const router = require("express").Router();
const { query } = require("../database/dbpromise.js");
const validateUser = require("../middlewares/user.js");
const logger = require("../utils/logger.js");

const FIELDS = new Set([
  "name",
  "mobile",
  "phonebook_name",
  "var1",
  "var2",
  "var3",
  "var4",
  "var5",
  "var6",
]);
const VALUE_OPERATORS = new Set([
  "equals",
  "not_equals",
  "contains",
  "not_contains",
  "starts_with",
  "ends_with",
]);
const EMPTY_OPERATORS = new Set(["is_empty", "is_not_empty"]);
const MAX_RULES = 10;
const PAGE_SIZE_MAX = 100;

let schemaReady;

function ensureSchema(req, res, next) {
  if (!schemaReady) {
    schemaReady = query(`
      CREATE TABLE IF NOT EXISTS customer_segments (
        id INT NOT NULL AUTO_INCREMENT,
        uid VARCHAR(999) NOT NULL,
        name VARCHAR(150) NOT NULL,
        match_type ENUM('all', 'any') NOT NULL DEFAULT 'all',
        rules LONGTEXT NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        KEY idx_customer_segments_uid (uid(150))
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `).catch((error) => {
      schemaReady = null;
      throw error;
    });
  }

  schemaReady.then(() => next()).catch((error) => {
    logger.error(error);
    return res.status(500).json({
      success: false,
      msg: "Unable to initialize customer segments",
    });
  });
}

function normalizeDefinition(body) {
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return { error: "Provide a valid customer segment" };
  }

  const name = typeof body.name === "string" ? body.name.trim() : "";
  const matchType = body.matchType === "any" ? "any" : body.matchType === "all" ? "all" : null;
  const rules = body.rules;

  if (!name || name.length > 150) {
    return { error: "Enter a segment name between 1 and 150 characters" };
  }
  if (!matchType) {
    return { error: "Choose whether all or any rules should match" };
  }
  if (!Array.isArray(rules) || rules.length < 1 || rules.length > MAX_RULES) {
    return { error: `Add between 1 and ${MAX_RULES} rules` };
  }

  const normalizedRules = [];
  for (const rule of rules) {
    if (!rule || !FIELDS.has(rule.field)) {
      return { error: "Choose a valid contact field for every rule" };
    }
    if (!VALUE_OPERATORS.has(rule.operator) && !EMPTY_OPERATORS.has(rule.operator)) {
      return { error: "Choose a valid comparison for every rule" };
    }

    const value = typeof rule.value === "string" ? rule.value.trim() : "";
    if (VALUE_OPERATORS.has(rule.operator) && (!value || value.length > 255)) {
      return { error: "Each comparison needs a value of 1 to 255 characters" };
    }
    normalizedRules.push({
      field: rule.field,
      operator: rule.operator,
      value: VALUE_OPERATORS.has(rule.operator) ? value : "",
    });
  }

  return { definition: { name, matchType, rules: normalizedRules } };
}

function buildPredicate(rules, matchType) {
  const conditions = [];
  const values = [];

  for (const rule of rules) {
    const field = `\`${rule.field}\``;

    if (rule.operator === "is_empty") {
      conditions.push(`(${field} IS NULL OR TRIM(${field}) = '')`);
    } else if (rule.operator === "is_not_empty") {
      conditions.push(`(${field} IS NOT NULL AND TRIM(${field}) <> '')`);
    } else if (rule.operator === "equals") {
      conditions.push(`COALESCE(${field}, '') = ?`);
      values.push(rule.value);
    } else if (rule.operator === "not_equals") {
      conditions.push(`COALESCE(${field}, '') <> ?`);
      values.push(rule.value);
    } else {
      const escaped = rule.value.replace(/[!%_]/g, "!$&");
      const pattern =
        rule.operator === "starts_with"
          ? `${escaped}%`
          : rule.operator === "ends_with"
            ? `%${escaped}`
            : `%${escaped}%`;
      const comparison = `LOWER(COALESCE(${field}, '')) LIKE LOWER(?) ESCAPE '!'`;
      conditions.push(
        rule.operator === "not_contains"
          ? `NOT (${comparison})`
          : comparison,
      );
      values.push(pattern);
    }
  }

  return {
    sql: conditions.join(matchType === "any" ? " OR " : " AND "),
    values,
  };
}

function readRules(segment) {
  try {
    const rules =
      typeof segment.rules === "string"
        ? JSON.parse(segment.rules)
        : segment.rules;
    const normalized = normalizeDefinition({
      name: segment.name,
      matchType: segment.match_type,
      rules,
    });
    return normalized.definition || null;
  } catch (error) {
    logger.error(error);
    return null;
  }
}

async function findSegment(id, uid) {
  const rows = await query(
    "SELECT id, name, match_type, rules, createdAt, updatedAt FROM customer_segments WHERE id = ? AND uid = ?",
    [id, uid],
  );
  return rows[0] || null;
}

async function countContacts(uid, definition) {
  const predicate = buildPredicate(definition.rules, definition.matchType);
  const [result] = await query(
    `SELECT COUNT(*) AS total FROM contact WHERE uid = ? AND (${predicate.sql})`,
    [uid, ...predicate.values],
  );
  return result.total;
}

router.use(validateUser, ensureSchema);

router.get("/", async (req, res) => {
  try {
    const segments = await query(
      "SELECT id, name, match_type, rules, createdAt, updatedAt FROM customer_segments WHERE uid = ? ORDER BY updatedAt DESC, id DESC",
      [req.decode.uid],
    );
    const data = await Promise.all(
      segments.map(async (segment) => {
        const definition = readRules(segment);
        if (!definition) {
          throw new Error(`Invalid rules stored for customer segment ${segment.id}`);
        }
        return {
          id: segment.id,
          ...definition,
          createdAt: segment.createdAt,
          updatedAt: segment.updatedAt,
          contactCount: await countContacts(req.decode.uid, definition),
        };
      }),
    );
    return res.json({ success: true, data });
  } catch (error) {
    logger.error(error);
    return res.status(500).json({ success: false, msg: "Unable to load customer segments" });
  }
});

router.post("/preview", async (req, res) => {
  const { definition, error } = normalizeDefinition(req.body);
  if (error) {
    return res.status(400).json({ success: false, msg: error });
  }

  try {
    const predicate = buildPredicate(definition.rules, definition.matchType);
    const [count] = await query(
      `SELECT COUNT(*) AS total FROM contact WHERE uid = ? AND (${predicate.sql})`,
      [req.decode.uid, ...predicate.values],
    );
    const data = await query(
      `SELECT id, name, mobile, phonebook_name, var1, var2, var3, var4, var5, var6
       FROM contact WHERE uid = ? AND (${predicate.sql}) ORDER BY id DESC LIMIT 10`,
      [req.decode.uid, ...predicate.values],
    );
    return res.json({ success: true, count: count.total, data });
  } catch (error) {
    logger.error(error);
    return res.status(500).json({ success: false, msg: "Unable to preview this segment" });
  }
});

router.post("/", async (req, res) => {
  const { definition, error } = normalizeDefinition(req.body);
  if (error) {
    return res.status(400).json({ success: false, msg: error });
  }

  try {
    const [duplicate] = await query(
      "SELECT id FROM customer_segments WHERE uid = ? AND name = ? LIMIT 1",
      [req.decode.uid, definition.name],
    );
    if (duplicate) {
      return res.status(409).json({ success: false, msg: "A segment with this name already exists" });
    }

    const result = await query(
      "INSERT INTO customer_segments (uid, name, match_type, rules) VALUES (?, ?, ?, ?)",
      [
        req.decode.uid,
        definition.name,
        definition.matchType,
        JSON.stringify(definition.rules),
      ],
    );
    return res.status(201).json({ success: true, id: result.insertId });
  } catch (error) {
    logger.error(error);
    return res.status(500).json({ success: false, msg: "Unable to create this segment" });
  }
});

router.put("/:id", async (req, res) => {
  const { definition, error } = normalizeDefinition(req.body);
  if (error) {
    return res.status(400).json({ success: false, msg: error });
  }

  try {
    const [duplicate] = await query(
      "SELECT id FROM customer_segments WHERE uid = ? AND name = ? AND id <> ? LIMIT 1",
      [req.decode.uid, definition.name, req.params.id],
    );
    if (duplicate) {
      return res.status(409).json({ success: false, msg: "A segment with this name already exists" });
    }

    const result = await query(
      "UPDATE customer_segments SET name = ?, match_type = ?, rules = ? WHERE id = ? AND uid = ?",
      [
        definition.name,
        definition.matchType,
        JSON.stringify(definition.rules),
        req.params.id,
        req.decode.uid,
      ],
    );
    if (!result.affectedRows) {
      return res.status(404).json({ success: false, msg: "Segment not found" });
    }
    return res.json({ success: true });
  } catch (error) {
    logger.error(error);
    return res.status(500).json({ success: false, msg: "Unable to update this segment" });
  }
});

router.delete("/:id", async (req, res) => {
  try {
    const result = await query(
      "DELETE FROM customer_segments WHERE id = ? AND uid = ?",
      [req.params.id, req.decode.uid],
    );
    if (!result.affectedRows) {
      return res.status(404).json({ success: false, msg: "Segment not found" });
    }
    return res.json({ success: true });
  } catch (error) {
    logger.error(error);
    return res.status(500).json({ success: false, msg: "Unable to delete this segment" });
  }
});

router.get("/:id/contacts", async (req, res) => {
  try {
    const segment = await findSegment(req.params.id, req.decode.uid);
    if (!segment) {
      return res.status(404).json({ success: false, msg: "Segment not found" });
    }
    const definition = readRules(segment);
    if (!definition) {
      return res.status(500).json({ success: false, msg: "The saved segment rules are invalid" });
    }

    const page = Math.max(1, Number.parseInt(req.query.page, 10) || 1);
    const limit = Math.min(
      PAGE_SIZE_MAX,
      Math.max(1, Number.parseInt(req.query.limit, 10) || 25),
    );
    const predicate = buildPredicate(definition.rules, definition.matchType);
    const [count] = await query(
      `SELECT COUNT(*) AS total FROM contact WHERE uid = ? AND (${predicate.sql})`,
      [req.decode.uid, ...predicate.values],
    );
    const data = await query(
      `SELECT id, name, mobile, phonebook_name, var1, var2, var3, var4, var5, var6
       FROM contact WHERE uid = ? AND (${predicate.sql})
       ORDER BY id DESC LIMIT ? OFFSET ?`,
      [req.decode.uid, ...predicate.values, limit, (page - 1) * limit],
    );
    return res.json({
      success: true,
      data,
      pagination: {
        total: count.total,
        page,
        limit,
        totalPages: Math.ceil(count.total / limit),
      },
    });
  } catch (error) {
    logger.error(error);
    return res.status(500).json({ success: false, msg: "Unable to load segment contacts" });
  }
});

module.exports = router;
