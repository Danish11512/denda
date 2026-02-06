# Phased task list

High-level phases and tasks. Format: phase goal, then tasks with brief acceptance. For human: track progress and scope. For AI: execute in order; complete all tasks in a phase before moving on; verify acceptance before marking done.

Reference: [general-technical-overview.md](./general-technical-overview.md).

---

## Phase 1: Foundation (repo, DB, Django, GraphQL skeleton)

**Goal:** Django project runs locally, connects to PostgreSQL, exposes a minimal GraphQL endpoint. Next.js app exists and can call it.

- [ ] **1.1** Create project structure: monorepo or separate repos for `frontend/` (Next.js) and `backend/` (Django). Document in README.
  - *Acceptance:* Two runnable apps; README states how to run each and that frontend talks to backend.
- [ ] **1.2** Stand up PostgreSQL locally; document connection (e.g. `DATABASE_URL` or individual vars). Create app DB.
  - *Acceptance:* Django can connect; doc shows how to create DB and connect.
- [ ] **1.3** Django project with one app (e.g. `core` or `finance`). Install GraphQL lib (e.g. Graphene-Django or Strawberry). Single query (e.g. `ping` or `health`) exposed.
  - *Acceptance:* `python manage.py runserver` and GraphQL query return success.
- [ ] **1.4** Next.js App Router app with shadcn/ui. Env/config for backend URL. One page that calls Django GraphQL (e.g. health) and displays result.
  - *Acceptance:* Next.js runs; page shows successful response from Django GraphQL.

---

## Phase 2: Auth (Django sessions, login UI)

**Goal:** Users can register (username, password, email) and log in. Django manages sessions; Next.js has login/register and uses session (cookie) for authenticated requests.

- [ ] **2.1** Django: User model (or extend built-in). Registration and login endpoints or GraphQL mutations; session created on login. CORS and cookie settings so Next.js same-origin or configured origin can send credentials.
  - *Acceptance:* Register and login mutations work; response sets session cookie; authenticated query works when cookie sent.
- [ ] **2.2** Next.js: Login and register pages (form + validation). Call Django auth mutations; store session via cookie. Protected layout or route that requires auth and redirects if not logged in.
  - *Acceptance:* User can register and log in; after login, protected page loads; without login, redirect to login.

---

## Phase 3: Core data (User, Account, Transaction + GraphQL + basic UI)

**Goal:** Account and Transaction models exist and are related to User. GraphQL exposes CRUD (or minimal read/write). Basic Next.js UI to list/create accounts and transactions.

- [ ] **3.1** Django: Define Account and Transaction models (FKs to User and Account as appropriate). Migrations. Expose via GraphQL (queries and mutations). Enforce that users only see their own data.
  - *Acceptance:* Schema is relational; GraphQL allows creating and listing accounts and transactions per user.
- [ ] **3.2** Next.js: Basic UI — list accounts, list transactions (e.g. per account or user). Create account and create transaction forms calling GraphQL.
  - *Acceptance:* User can create and view accounts and transactions in the UI.

---

## Phase 4: Audit logging and mock data

**Goal:** Significant actions are audit-logged. A script generates mock User, Account, and Transaction data that is fully relational (linked correctly).

- [ ] **4.1** Django: Audit logging for defined actions (e.g. login, account create, transaction create). Store who, what, when (and any needed context). Schema and storage (table or append-only) documented.
  - *Acceptance:* Trigger actions; verify audit records created and queryable.
- [ ] **4.2** Script (e.g. Django management command or standalone) to create mock Users, Accounts, and Transactions with correct FKs and relationships. Document how to run it.
  - *Acceptance:* Running script produces consistent relational data; doc in README or `legend/`.

---

## Phase 5: Docs and environment

**Goal:** Staging vs prod and local run are documented. Task list and overview are up to date so a solo dev or AI can continue work.

- [ ] **5.1** Document local run (frontend, backend, DB) and env vars. Note that staging/prod will be decided later; placeholder for future hosting.
  - *Acceptance:* New contributor or AI can run app locally from docs.
- [ ] **5.2** Update this task list and `general-technical-overview.md` with any decisions or structure changes from implementation.
  - *Acceptance:* Legend reflects current state and next steps.

---

## How to use this (human and AI)

- **Order:** Do phases in order; finish all tasks in a phase before starting the next.
- **Acceptance:** Each task is done when its acceptance criteria are met. If a task is too big, split it in the list and keep acceptance concrete.
- **Docs:** When you add env vars, commands, or structure, update README or `legend/` so the next session (human or AI) can resume without guessing.
- **Checklist:** Uncheck tasks only when they are fully done and verified.

---

Last updated: 2025-02-05
