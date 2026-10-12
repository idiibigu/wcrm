(() => {
  const fields = [
    ["name", "الاسم"],
    ["mobile", "رقم الجوال"],
    ["phonebook_name", "دفتر الهاتف"],
    ["var1", "الحقل المخصص 1"],
    ["var2", "الحقل المخصص 2"],
    ["var3", "الحقل المخصص 3"],
    ["var4", "الحقل المخصص 4"],
    ["var5", "الحقل المخصص 5"],
    ["var6", "الحقل المخصص 6"],
  ];
  const operators = [
    ["contains", "يحتوي على"],
    ["equals", "يساوي"],
    ["not_equals", "لا يساوي"],
    ["not_contains", "لا يحتوي على"],
    ["starts_with", "يبدأ بـ"],
    ["ends_with", "ينتهي بـ"],
    ["is_empty", "فارغ"],
    ["is_not_empty", "غير فارغ"],
  ];
  const valueOperators = new Set(operators.slice(0, 6).map(([value]) => value));
  const state = { segments: [], editingId: null, page: 1, editingRules: [] };
  const elements = {
    alert: document.getElementById("segments-alert"),
    create: document.getElementById("segments-create"),
    editor: document.getElementById("segments-editor"),
    editorHeading: document.getElementById("editor-heading"),
    form: document.getElementById("segments-form"),
    name: document.getElementById("segment-name"),
    matchType: document.getElementById("match-type"),
    rules: document.getElementById("segment-rules"),
    addRule: document.getElementById("add-rule"),
    preview: document.getElementById("preview-segment"),
    previewCount: document.getElementById("preview-count"),
    previewResults: document.getElementById("preview-results"),
    save: document.getElementById("save-segment"),
    cancel: document.getElementById("segments-cancel"),
    cancelBottom: document.getElementById("segments-cancel-bottom"),
    list: document.getElementById("segments-list"),
  };

  function escapeText(value) {
    return String(value ?? "");
  }

  function showAlert(message, kind = "error") {
    elements.alert.textContent = message;
    elements.alert.dataset.kind = kind;
    elements.alert.hidden = false;
  }

  function clearAlert() {
    elements.alert.hidden = true;
    elements.alert.textContent = "";
  }

  async function api(path, options = {}) {
    const token = localStorage.getItem("wacrm_user");
    if (!token) {
      window.location.assign("/user/login");
      throw new Error("يرجى تسجيل الدخول أولًا");
    }

    const response = await fetch(`/api/segments${path}`, {
      ...options,
      headers: {
        Authorization: `Bearer ${token}`,
        ...(options.body ? { "Content-Type": "application/json" } : {}),
        ...options.headers,
      },
    });
    let result;
    try {
      result = await response.json();
    } catch {
      throw new Error("تعذر قراءة استجابة الخادم");
    }
    if (!response.ok || !result.success) {
      if (response.status === 401) {
        window.location.assign("/user/login");
      }
      throw new Error(result.msg || `فشل الطلب (${response.status})`);
    }
    return result;
  }

  function addOption(select, items, selected) {
    for (const [value, label] of items) {
      const option = document.createElement("option");
      option.value = value;
      option.textContent = label;
      option.selected = value === selected;
      select.append(option);
    }
  }

  function renderRule(rule = { field: "name", operator: "contains", value: "" }) {
    const row = document.createElement("div");
    row.className = "segments-rule";

    const field = document.createElement("select");
    field.setAttribute("aria-label", "حقل جهة الاتصال");
    addOption(field, fields, rule.field);

    const operator = document.createElement("select");
    operator.setAttribute("aria-label", "طريقة المطابقة");
    addOption(operator, operators, rule.operator);

    const value = document.createElement("input");
    value.className = "segments-rule-value";
    value.setAttribute("aria-label", "قيمة المطابقة");
    value.maxLength = 255;
    value.value = rule.value || "";
    value.placeholder = "قيمة المطابقة";
    value.hidden = !valueOperators.has(operator.value);
    value.required = !value.hidden;

    operator.addEventListener("change", () => {
      value.hidden = !valueOperators.has(operator.value);
      value.required = !value.hidden;
      if (value.hidden) value.value = "";
    });

    const remove = document.createElement("button");
    remove.type = "button";
    remove.className = "segments-rule-delete";
    remove.textContent = "×";
    remove.setAttribute("aria-label", "حذف الشرط");
    remove.addEventListener("click", () => {
      if (elements.rules.children.length === 1) {
        showAlert("يجب أن تحتوي الشريحة على شرط واحد على الأقل");
        return;
      }
      row.remove();
    });

    row.append(field, operator, value, remove);
    elements.rules.append(row);
  }

  function currentDefinition() {
    return {
      name: elements.name.value.trim(),
      matchType: elements.matchType.value,
      rules: [...elements.rules.children].map((row) => ({
        field: row.children[0].value,
        operator: row.children[1].value,
        value: row.children[2].value.trim(),
      })),
    };
  }

  function renderContacts(container, contacts) {
    container.replaceChildren();
    if (!contacts.length) {
      const empty = document.createElement("p");
      empty.className = "segments-empty";
      empty.textContent = "لا توجد جهات اتصال تطابق هذه الشروط حتى الآن.";
      container.append(empty);
      return;
    }

    const table = document.createElement("table");
    table.className = "segments-table";
    const head = document.createElement("thead");
    const headRow = document.createElement("tr");
    for (const label of ["الاسم", "رقم الجوال", "دفتر الهاتف"]) {
      const cell = document.createElement("th");
      cell.textContent = label;
      headRow.append(cell);
    }
    head.append(headRow);
    const body = document.createElement("tbody");
    for (const contact of contacts) {
      const row = document.createElement("tr");
      for (const value of [contact.name, contact.mobile, contact.phonebook_name]) {
        const cell = document.createElement("td");
        cell.textContent = escapeText(value) || "—";
        row.append(cell);
      }
      body.append(row);
    }
    table.append(head, body);
    container.append(table);
  }

  function openEditor(segment = null) {
    clearAlert();
    state.editingId = segment?.id ?? null;
    elements.editorHeading.textContent = segment ? "تعديل شريحة" : "إنشاء شريحة";
    elements.name.value = segment?.name ?? "";
    elements.matchType.value = segment?.matchType ?? "all";
    elements.rules.replaceChildren();
    const rules = segment?.rules ?? [{ field: "name", operator: "contains", value: "" }];
    for (const rule of rules) renderRule(rule);
    elements.previewCount.textContent = "—";
    elements.previewResults.hidden = true;
    elements.previewResults.replaceChildren();
    elements.editor.hidden = false;
    elements.name.focus();
  }

  function closeEditor() {
    elements.editor.hidden = true;
    state.editingId = null;
    clearAlert();
  }

  function createButton(label, className, onClick) {
    const button = document.createElement("button");
    button.type = "button";
    button.className = className;
    button.textContent = label;
    button.addEventListener("click", onClick);
    return button;
  }

  function renderSegments() {
    elements.list.replaceChildren();
    if (!state.segments.length) {
      const empty = document.createElement("div");
      empty.className = "segments-empty";
      const title = document.createElement("strong");
      title.textContent = "لا توجد شرائح محفوظة";
      const detail = document.createElement("span");
      detail.textContent = "أنشئ شريحة بقواعد لمعاينة جمهورها الديناميكي وحفظه.";
      empty.append(title, detail);
      elements.list.append(empty);
      return;
    }

    for (const segment of state.segments) {
      const card = document.createElement("article");
      card.className = "segments-row";
      const main = document.createElement("div");
      main.className = "segments-row-main";
      const title = document.createElement("h2");
      title.textContent = segment.name;
      const meta = document.createElement("div");
      meta.className = "segments-row-meta";
      meta.textContent = `${segment.contactCount} جهة اتصال · ${segment.rules.length} شرط · ${segment.matchType === "all" ? "مطابقة كل الشروط" : "مطابقة أي شرط"}`;
      main.append(title, meta);

      const actions = document.createElement("div");
      actions.className = "segments-row-actions";
      actions.append(
        createButton("عرض الجمهور", "segments-secondary", () => viewSegment(segment)),
        createButton("تعديل", "segments-secondary", () => openEditor(segment)),
        createButton("حذف", "segments-secondary", () => deleteSegment(segment)),
      );
      card.append(main, actions);
      elements.list.append(card);
    }
  }

  async function loadSegments() {
    elements.list.replaceChildren();
    const loading = document.createElement("div");
    loading.className = "segments-empty";
    loading.textContent = "جارٍ تحميل الشرائح…";
    elements.list.append(loading);
    const result = await api("");
    state.segments = result.data;
    renderSegments();
  }

  async function previewDefinition() {
    const definition = currentDefinition();
    const result = await api("/preview", {
      method: "POST",
      body: JSON.stringify(definition),
    });
    elements.previewCount.textContent = String(result.count);
    elements.previewResults.hidden = false;
    renderContacts(elements.previewResults, result.data);
  }

  async function viewSegment(segment) {
    clearAlert();
    try {
      const result = await api(`/${encodeURIComponent(segment.id)}/contacts?page=1&limit=25`);
      elements.previewResults.hidden = false;
      elements.previewResults.replaceChildren();
      const heading = document.createElement("p");
      heading.textContent = `${segment.name}: ${result.pagination.total} جهة اتصال مطابقة`;
      elements.previewResults.append(heading);
      renderContacts(elements.previewResults, result.data);
      elements.previewResults.scrollIntoView({ behavior: "smooth", block: "center" });
    } catch (error) {
      showAlert(error.message);
    }
  }

  async function deleteSegment(segment) {
    if (!window.confirm(`هل تريد حذف الشريحة "${segment.name}"؟ لن تُحذف جهات الاتصال.`)) {
      return;
    }
    clearAlert();
    try {
      await api(`/${encodeURIComponent(segment.id)}`, { method: "DELETE" });
      await loadSegments();
      showAlert("تم حذف الشريحة. لم تتأثر جهات الاتصال.", "success");
    } catch (error) {
      showAlert(error.message);
    }
  }

  elements.create.addEventListener("click", () => openEditor());
  elements.addRule.addEventListener("click", () => {
    if (elements.rules.children.length >= 10) {
      showAlert("الحد الأقصى هو 10 شروط لكل شريحة");
      return;
    }
    renderRule();
    clearAlert();
  });
  elements.preview.addEventListener("click", async () => {
    clearAlert();
    elements.preview.disabled = true;
    try {
      await previewDefinition();
    } catch (error) {
      showAlert(error.message);
    } finally {
      elements.preview.disabled = false;
    }
  });
  elements.cancel.addEventListener("click", closeEditor);
  elements.cancelBottom.addEventListener("click", closeEditor);
  elements.form.addEventListener("submit", async (event) => {
    event.preventDefault();
    clearAlert();
    elements.save.disabled = true;
    try {
      const definition = currentDefinition();
      await api(state.editingId ? `/${encodeURIComponent(state.editingId)}` : "", {
        method: state.editingId ? "PUT" : "POST",
        body: JSON.stringify(definition),
      });
      closeEditor();
      await loadSegments();
      showAlert("تم حفظ الشريحة بنجاح.", "success");
    } catch (error) {
      showAlert(error.message);
    } finally {
      elements.save.disabled = false;
    }
  });

  loadSegments().catch((error) => showAlert(error.message));
})();
