# WCRM by Idiibi

WhatsApp CRM, shared inbox, messaging automations, and team tools in one Node.js application.

## Deployment

See the step-by-step Arabic [Ubuntu VPS deployment guide](DEPLOY-VPS-AR.md).

The application uses Node.js 20 or newer (Node.js 22 recommended) and
MariaDB/MySQL. Uploading these source files does not itself provision a server,
database, domain, TLS certificate, or third-party API credentials.

## Application source

The Node.js application and compiled React frontend are in [`server/`](server/).
The clean database schema and a one-time administrator seed are in
[`database/import.sql`](database/import.sql).

The SQL seed contains no demonstration customer or agent accounts. Generate a
strong application database password and JWT secret for the server, and store
production settings outside Git in `/etc/whatscrm/whatscrm.env`.

The deployment folder intentionally excludes `.env` files other than
`.env.example`, installed dependencies, WhatsApp sessions, uploaded customer
media, and bundled Google service-account key files.

## Customer segments

Open **Phonebook** and choose **Customer Segments · شرائح العملاء** to save
dynamic contact segments. Rules can match contact name, mobile number,
phonebook, or custom fields, using either all rules or any rule. Segment
membership is recalculated from the user's current contacts whenever it is
previewed; rules are stored per user and do not copy or delete contacts.

## First login

- Admin page: `/admin`
- Initial account email: `admin@admin.com`
- Initial account password is supplied separately by the installer; change it
  immediately after the first login.

## Persistent data

Back up the MariaDB database and these application data directories on the VPS:

- `server/sessions`
- `server/client/public/media`
- `server/client/public/meta-media`
- `server/middlewares/license.json`

Do not expose the MySQL/MariaDB port to the public internet.
