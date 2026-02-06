# General technical overview

## Purpose

Finance app for **individual customers** (end users). Users register, log in, and manage their own accounts and transactions. Full feature set and clarified scope are in [legend/features.md](legend/features.md).

**Planned scope:** View all financial data; income/expense; categories and custom expenses (including recurring with placeholders); split tracking between friends; balance per account; budget and charts (MoM, YoY); triggers/automations (including live events); descriptions; Zelle/Venmo manual assignment; two-way IOUs; pay internal accounts and bills; bank/card connections. Build order: DB/schema foundation for all features first, then features by complexity and dependency.

**MVP scope:** No real money; mock data only. A seed script generates relational mock data. Audit logging is required. Staging and production are planned; for now everything runs locally.

---

## Architecture

- **Frontend**: Next.js (App Router) — UI and client-side logic; consumes the Django GraphQL API over HTTP.
- **Backend**: Django — GraphQL API, business logic, validation, and persistence via PostgreSQL.
- **Database**: PostgreSQL — primary datastore. Single-tenant; normalized relational model. All persistent data lives in PostgreSQL.

**Layers:** Next.js talks to Django over HTTP (single GraphQL endpoint). Django talks to PostgreSQL. No shared codebase between frontend and backend. **Repo structure:** Monorepo with `frontend/` (Next.js) and `backend/` (Django). See [task-list.md](task-list.md) Phase 1 and [phase-1-execution.md](phase-1-execution.md) for execution details.

**Stack version policy:** Python and Bun/Node — use current stable versions compatible with Django and Next.js. Concrete versions are listed in the root README. Policy is recorded in [phase-1-execution.md](phase-1-execution.md).

---

## Frontend (Next.js)

### Stack and tooling

- **Framework:** Next.js, App Router. **Package manager / runtime:** Bun. Document Bun and Node version (Bun embeds Node) in README; use current stable compatible with Next.js.
- **UI:** shadcn/ui (React components, Tailwind). Target desktop and mobile; responsive from the start.
- **GraphQL client:** Use a client that supports cookies (e.g. Apollo Client, urql, or `fetch` with `credentials: 'include'`) so Django session cookies are sent. Single GraphQL endpoint (e.g. `NEXT_PUBLIC_GRAPHQL_URL` or `NEXT_PUBLIC_API_URL`).

### Role and behavior

- Renders the app UI and calls the Django GraphQL API for all data and actions (no direct DB access).
- **Auth flow:** Login and register pages submit to Django; Django sets a session cookie. Subsequent requests include the cookie; Django session middleware identifies the user. No JWT; no roles — every logged-in user is the same type.
- **Protected routes:** Layout or middleware that checks auth (e.g. via a “me” or “currentUser” query); redirect to login if unauthenticated.
- **State:** Server state from GraphQL; local UI state as needed. Prefer server-driven data; avoid duplicating business logic in the frontend.

### Structure

- App Router: `app/` for routes, layouts, and page components. Shared components and hooks outside `app/` or under a clear convention. Env: `.env.local`; prefix public URL with `NEXT_PUBLIC_`.

---

## Backend (Django)

### Stack and tooling

- **Framework:** Django. Use a supported Python version; document in README. Prefer a single Django app (e.g. `core` or `finance`) for the finance domain; add more apps if the codebase grows.
- **API:** GraphQL only (no REST). Use Graphene-Django or Strawberry; document which. Single endpoint (e.g. `/graphql/`). Queries for reads; mutations for writes and auth (register, login).
- **Auth:** Django’s built-in User model (or minimal extension). Username + password; email stored. Session-based auth: on login, create a session and set session cookie (httpOnly, sameSite, secure in production). No JWT; no role-based permissions — if you’re logged in, you’re “a user.”

### Role and behavior

- GraphQL layer: parse requests, resolve queries/mutations, enforce auth (reject unauthenticated requests for protected fields).
- Business rules and validation in service layer or in resolvers; persist via Django ORM.
- **CORS:** Allow the Next.js origin (and optionally localhost for dev). Credentials (cookies) must be allowed.
- **CSRF:** For session cookies, CSRF may be required for state-changing requests; document how GraphQL mutations are protected (e.g. CSRF token in header or cookie).

### Structure

- Project root: `manage.py`, `config/` or `<project_name>/` for settings, URLs, ASGI/WSGI. One app for finance domain. Migrations in the app. Env: `DATABASE_URL`, `SECRET_KEY`, `ALLOWED_HOSTS`, `CORS_ALLOWED_ORIGINS` (or equivalent). Document all required env vars.
- **Local development:** Before any backend work, run the dev environment script (`backend/scripts/ensure-venv.sh`). It creates a venv, installs dependencies, and loads env; the script spawns a shell with venv and env ready. On cancel or exit of that shell, the script removes the venv and any temporary artifacts.

---

## Data (PostgreSQL)

**PostgreSQL (local):** App DB name `denda`. Connection via `DATABASE_URL`. Step-by-step (create DB, set env, run migrations) is in the root README.

### Stack and hosting

- **Engine:** PostgreSQL (psql). Self-hosted; single instance under your control. Document version and how to create the DB (e.g. `createdb denda` or script).
- **Connection:** Django connects via `DATABASE_URL` (e.g. `postgres://user:pass@localhost:5432/denda`). No SQLite fallback; backend requires PostgreSQL. No direct frontend access.
- **Local run:** App database name is `denda`. Install PostgreSQL, create the DB with `createdb denda`, set `DATABASE_URL` in env or `backend/.env`, then run `python manage.py migrate`. Step-by-step is in the root README.

### Model (relational)

- **Single-tenant:** All users share one database; row-level visibility by `user_id` (or equivalent). No multi-tenant schema separation in MVP.
- **Core entities (foundation):** Full schema for all features is designed in Phase 3 (task list). Entities include:
  - **User:** Django’s User (username, email, password hash). One-to-many to Account.
  - **Account:** Belongs to one User. Optional link to Connection (bank/card). Name, type, currency, balance or derived. One-to-many to Transaction.
  - **Connection:** Bank/card connection (provider, external_id, status). One-to-many to Account.
  - **Transaction:** Belongs to one Account. Amount, date, description, type (income/expense), optional category. May have TransactionSplits.
  - **Category:** System or user-defined; type income/expense. Transactions and Budgets reference Category.
  - **TransactionSplit:** Per-transaction split (participant label, share amount, paid amount). Tracking only; no multi-user accounts.
  - **Budget:** Per user; optional category; amount, period (e.g. monthly).
  - **IOU:** Two-way (I owe you / you owe me); counterparty, amount, direction, status, due date.
  - **Biller:** Payee for “pay a bill” (internal transfer vs pay bill).
  - **RecurringRule / ScheduledTransaction:** Recurrence and placeholder/scheduled transactions for upcoming view and projections.
  - **Trigger / TriggerAction:** Automations on conditions (e.g. when/where money lands); actions (move between accounts, pay account). Support live events as well as manual/imported data.
- **Normalized:** Use FKs; avoid storing redundant user_id on Transaction if it can be inferred from Account. Enforce integrity with migrations and constraints.
- **Migrations:** Django migrations only; no manual schema changes without a migration. See [legend/features.md](legend/features.md) and [legend/task-list.md](legend/task-list.md) Phase 3 for full schema.

### Compliance and retention

- No specific compliance or retention requirements for MVP. Best-effort security; audit logging covers who did what and when.

---

## Hosting

- **Model:** Self-hosted. Application and database run on infrastructure you control (own server).
- **Environments:** Staging and production planned; exact topology (e.g. one server vs two, reverse proxy) to be decided later. For now, everything runs **locally** (Next.js dev server, Django runserver, local PostgreSQL).
- **Platform:** Not yet chosen (VPS, Docker, Docker Compose, reverse proxy). Document when decided; keep legend/ and README updated with run instructions and env vars.

---

## Security and compliance

- **Auth:** Username + password; email collected. Session cookie; no roles. Best-effort: strong password hashing (Django default), HTTPS in production, secure cookie flags.
- **Audit logging:** Required. Log at least: who (user), what (action, e.g. login, account create, transaction create), when (timestamp). Store in DB (dedicated table or append-only). Document schema and how to query.
- **Data:** No real money in MVP; mock data only. A **seed script** (e.g. Django management command) generates mock Users, Accounts, and Transactions with correct FKs and relationships. Document how to run it.
- **No PCI or other compliance** in scope for MVP; revisit if real payments are added.

---

## Documentation and process

- **Features:** Target features and clarified scope in `legend/features.md`. Build strategy: schema foundation first, then features by complexity and dependency.
- **Task list:** Phased, high-level tasks in `legend/task-list.md`. Execute in order; complete all tasks in a phase before the next. Acceptance criteria define “done.”
- **Audience:** Solo developer and AI (e.g. Cursor). Docs should let either resume work without guessing: README (run instructions, env vars, structure), legend/ (overview, features, task list), and inline comments where behavior is non-obvious.
- **Updates:** When adding env vars, commands, or structural changes, update README or legend/ so the next session has the full picture.

---

Last updated: 2025-02-06
