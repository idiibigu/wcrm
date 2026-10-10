# WCRM by Idiibi

WCRM by Idiibi is a Node.js CRM and messaging automation application.

For full deployment steps, see [`DEPLOY-VPS-AR.md`](../DEPLOY-VPS-AR.md).

The server uses Node.js 20 or newer (Node.js 22 recommended) and MariaDB/MySQL.
Install the exact locked dependencies using `npm ci --omit=dev`, set the
environment variables shown in `.env.example`, import the included clean
database schema, and start the application with `npm start`.
