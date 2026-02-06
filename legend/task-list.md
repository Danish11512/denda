# Phased task list

High-level phases and tasks. Format: phase goal, then tasks with brief acceptance. For human: track progress and scope. For AI: execute in order; complete all tasks in a phase before moving on; verify acceptance before marking done.

Reference: [general-technical-overview.md](./general-technical-overview.md), [features.md](./features.md).

**Build strategy:** Basics and schema always come first (Phases 1–3). Then build features by complexity and dependency; each phase states which features become possible after it (see features.md).

**Feature numbering** in "Features possible" refers to the 12 target features in [features.md](./features.md) (e.g. 1 = View all financial data, 2 = Income/expense, … 12 = Recurring custom expenses).

**When each feature is possible to create:**

| Feature | First possible (partial) | Full/complete |
|---------|---------------------------|---------------|
| 1 View all financial data | Phase 4 | Phase 8 |
| 2 Income/expense | Phase 4 | Phase 7 |
| 3 Categories + custom expenses | Phase 4 | Phase 7 |
| 4 Splits (tracking) | Phase 10 | Phase 10 |
| 5 Balance per account | Phase 4 | Phase 8 |
| 6 Budget chart | Phase 11 | Phase 11 |
| 7 Charts MoM/YoY | Phase 12 | Phase 12 |
| 8 Triggers/automations | Phase 15 | Phase 17 (with live events) |
| 9 Descriptions | Phase 4 | Phase 9 |
| 10 Zelle/Venmo assignment | Phase 14 | Phase 14 |
| 11 IOU (two-way) | Phase 14 | Phase 14 |
| 12 Recurring custom expenses | Phase 13 | Phase 13 |

Basics and schema (Phases 1–3) always come first; Phase 3 makes all features implementable.

---

## Phase 1: Foundation (repo, DB, Django, GraphQL skeleton)

**Features possible after this phase:** None (infrastructure only).

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

**Features possible after this phase:** None (auth only; required for all later features).

**Goal:** Users can register (username, password, email) and log in. Django manages sessions; Next.js has login/register and uses session (cookie) for authenticated requests.

- [ ] **2.1** Django: User model (or extend built-in). Registration and login endpoints or GraphQL mutations; session created on login. CORS and cookie settings so Next.js same-origin or configured origin can send credentials.
  - *Acceptance:* Register and login mutations work; response sets session cookie; authenticated query works when cookie sent.
- [ ] **2.2** Next.js: Login and register pages (form + validation). Call Django auth mutations; store session via cookie. Protected layout or route that requires auth and redirects if not logged in.
  - *Acceptance:* User can register and log in; after login, protected page loads; without login, redirect to login.

---

## Phase 3: Schema and data foundation (full schema for all features)

**Features possible after this phase:** Schema and API types exist for all 12 features; no user-facing feature is complete until later phases. This phase makes every feature *implementable* (data model and types in place).

**Goal:** DB schema and Django models exist for every entity required by the full feature set (features.md). One set of migrations; no redoing schema later. GraphQL exposes types (read-only or minimal) so API can return all shapes.

- [ ] **3.1** Document full schema: list all entities and relationships required by legend/features.md. Add schema overview to legend (e.g. in general-technical-overview or schema-overview.md): User, Account, Connection, Transaction (type, category_id, description), Category, TransactionSplit, Budget, IOU, Biller, RecurringRule, ScheduledTransaction, Trigger, TriggerAction. Document FKs and row-level visibility (user_id).
  - *Acceptance:* Schema doc exists; implementer can create models without guessing.
- [ ] **3.2** Django: Implement all models per schema doc. Migrations. Enforce integrity (FKs, no redundant user_id on Transaction where inferable from Account).
  - *Acceptance:* All migrations run; ORM can create/query all entities.
- [ ] **3.3** GraphQL: Expose all entity types (read-only or minimal CRUD for User/Account/Transaction/Category only). Enforce users only see their own data.
  - *Acceptance:* GraphQL schema includes all types; auth enforced; core entities create/list where implemented.

---

## Phase 4: Core data CRUD and basic UI

**Features possible after this phase:** 1 (partial: list all accounts/transactions), 2 (partial: transaction type), 3 (categories + custom expenses via Category), 5 (partial: balance per account if stored/derived), 9 (descriptions on Transaction; ensure editable and visible in UI).

**Goal:** Account, Transaction, and Category have full CRUD via GraphQL. Basic Next.js UI to list/create accounts, transactions, and categories.

- [ ] **4.1** Django: GraphQL mutations for create/update/delete Account, Transaction, Category. Queries for list/detail. Enforce users only see their own data.
  - *Acceptance:* Create and list accounts, transactions, categories via GraphQL.
- [ ] **4.2** Next.js: Basic UI — list accounts, list transactions (e.g. per account or user), list categories. Create account, create transaction, create category forms calling GraphQL.
  - *Acceptance:* User can create and view accounts, transactions, and categories in the UI.

---

## Phase 5: Audit logging and mock data

**Features possible after this phase:** No new features; supports development, testing, and compliance for all features.

**Goal:** Significant actions are audit-logged. A script generates mock User, Account, Transaction, Category (and other entities as needed) data that is fully relational (linked correctly).

- [ ] **5.1** Django: Audit logging for defined actions (e.g. login, account create, transaction create). Store who, what, when (and any needed context). Schema and storage (table or append-only) documented.
  - *Acceptance:* Trigger actions; verify audit records created and queryable.
- [ ] **5.2** Script (e.g. Django management command or standalone) to create mock data for all core entities with correct FKs and relationships. Document how to run it.
  - *Acceptance:* Running script produces consistent relational data; doc in README or `legend/`.

---

## Phase 6: Docs and environment

**Features possible after this phase:** No new features; enables onboarding and continuation for all features.

**Goal:** Staging vs prod and local run are documented. Task list and overview are up to date so a solo dev or AI can continue work.

- [ ] **6.1** Document local run (frontend, backend, DB) and env vars. Note that staging/prod will be decided later; placeholder for future hosting.
  - *Acceptance:* New contributor or AI can run app locally from docs.
- [ ] **6.2** Update this task list and `general-technical-overview.md` with any decisions or structure changes from implementation.
  - *Acceptance:* Legend reflects current state and next steps.

---

## Phase 7: Income/expense + categories in UI

**Features possible after this phase:** 2 (income/expense differentiation complete in UI), 3 (categories and custom expenses fully usable in lists/filters).

**Goal:** Transaction type (income/expense) and category in lists and filters; category CRUD already in Phase 4; complete UI and classification behavior.

- [ ] **7.1** Django: Ensure Transaction has type (income/expense) and category_id; queries support filter by type and category.
  - *Acceptance:* GraphQL supports filter by type and category; classification consistent.
- [ ] **7.2** Next.js: Lists and filters for transactions by type and category; category picker on transaction form.
  - *Acceptance:* User can filter and create transactions with type and category; custom expenses via Category.

---

## Phase 8: Balance per account + view all accounts

**Features possible after this phase:** 1 (view all financial data from all accounts), 5 (balance per account/card).

**Goal:** Balance (stored or derived) per account; dashboard or “all accounts” view with aggregation and filters.

- [ ] **8.1** Django: Balance per account (stored or derived from transactions). Query for all accounts and aggregated view; filter by account, date range.
  - *Acceptance:* GraphQL returns balance per account and supports “all accounts” view.
- [ ] **8.2** Next.js: Dashboard or “all accounts” view; balance per account; filter by account, date range, category, type.
  - *Acceptance:* User sees all accounts and balances; can filter as in feature 1.

---

## Phase 9: Descriptions (searchable, visible)

**Features possible after this phase:** 9 (descriptions on payments; editable, searchable, visible).

**Goal:** Transaction description editable, searchable, and visible in lists and detail views.

- [ ] **9.1** Django: Transaction description in queries; search/filter by description if not already in Phase 4.
  - *Acceptance:* GraphQL supports description and search by description.
- [ ] **9.2** Next.js: Description field on transaction form and detail; search/filter by description in lists.
  - *Acceptance:* User can edit, search, and see descriptions everywhere relevant.

---

## Phase 10: Splits (tracking only)

**Features possible after this phase:** 4 (split transactions between friends; show share and paid per person).

**Goal:** TransactionSplit CRUD and UI; show share and amount paid per person; tracking only (no multi-user accounts).

- [ ] **10.1** Django: TransactionSplit model CRUD via GraphQL; link to Transaction; participant label, share amount, paid amount.
  - *Acceptance:* Create/list/update splits per transaction; enforce sum of shares and paid amounts.
- [ ] **10.2** Next.js: Split editor on transaction (add/remove participants, share, paid); list view shows total, per-person share, and paid.
  - *Acceptance:* User can split a transaction and see who owes what and how much has been paid.

---

## Phase 11: Budgets + budget chart

**Features possible after this phase:** 6 (chart: budget breakdown — budget vs actual and spending by category).

**Goal:** Budget CRUD; chart showing budget vs actual and spending by category.

- [ ] **11.1** Django: Budget CRUD via GraphQL; query for budget vs actual (aggregate transactions by category/period).
  - *Acceptance:* GraphQL supports budgets and budget-vs-actual and spending-by-category data.
- [ ] **11.2** Next.js: Budget create/edit; chart: budget vs actual (bar) and spending by category (e.g. pie).
  - *Acceptance:* User can set budgets and see both chart types.

---

## Phase 12: Charts — month-to-month, year-on-year

**Features possible after this phase:** 7 (charts MoM and YoY; configurable time range).

**Goal:** Charts comparing month-to-month and year-on-year by category, expenses, income; configurable time range.

- [ ] **12.1** Django: Queries for MoM and YoY aggregates (by category, type, configurable date range).
  - *Acceptance:* GraphQL returns data for MoM and YoY charts; time range parameter.
- [ ] **12.2** Next.js: Charts (MoM, YoY); time range selector (e.g. last 6/12 months, custom range, year vs year).
  - *Acceptance:* User can view MoM and YoY with configurable range.

---

## Phase 13: Recurring + placeholders/scheduled

**Features possible after this phase:** 12 (custom expenses: recurring, future start, duration; placeholder/scheduled transactions).

**Goal:** RecurringRule and ScheduledTransaction; “upcoming” view and balance projections.

- [ ] **13.1** Django: RecurringRule and ScheduledTransaction CRUD; generate placeholders (start in future, duration/count); queries for upcoming and projections.
  - *Acceptance:* Recurring rules and scheduled transactions stored and queryable; placeholders generated as specified.
- [ ] **13.2** Next.js: Recurring rule editor (frequency, start, end/count); upcoming view; balance projection using scheduled items.
  - *Acceptance:* User can create recurring custom expenses with future start and duration; see upcoming and projections.

---

## Phase 14: IOU (two-way) + Zelle/Venmo assignment

**Features possible after this phase:** 10 (manual assign payment to transaction/IOU/custom expense), 11 (IOU two-way; link payments to IOUs).

**Goal:** IOU CRUD and UI (two-way); manual link transaction to IOU (or transaction/custom expense) for Zelle/Venmo-style assignment.

- [ ] **14.1** Django: IOU CRUD; direction (I owe / they owe); status; link Transaction to IOU (assignment). Query for unassigned or assignable transactions.
  - *Acceptance:* GraphQL supports IOU and assignment of a transaction to an IOU (or transaction/custom expense).
- [ ] **14.2** Next.js: IOU list and form (counterparty, amount, direction, due date); “assign to IOU” (or transaction/custom expense) on transaction.
  - *Acceptance:* User can manage IOUs and manually assign payments to IOUs or other targets.

---

## Phase 15: Automations/triggers (live events)

**Features possible after this phase:** 8 (triggers/automations on when/where to move money; live events supported).

**Goal:** Trigger and TriggerAction; conditions (e.g. when deposit hits account, balance threshold); actions (transfer between accounts, pay account); support live events (webhooks or polling).

- [ ] **15.1** Django: Trigger and TriggerAction models; condition evaluation; action execution (internal transfer); job or webhook entry point for live events.
  - *Acceptance:* Triggers can be evaluated on transaction or balance events; actions run (transfer); live events can invoke evaluation.
- [ ] **15.2** Next.js: Trigger/automation editor (condition, actions); list and enable/disable.
  - *Acceptance:* User can create and manage automations; they run on manual and live events.

---

## Phase 16: Pay a bill (Biller)

**Features possible after this phase:** 8 (pay an account: internal transfer and pay biller).

**Goal:** Biller CRUD; “pay an account” = internal transfer (already) or pay Biller; wire into automations.

- [ ] **16.1** Django: Biller CRUD; “pay bill” action (transfer to Biller or external payee); link to TriggerAction for automations.
  - *Acceptance:* GraphQL supports Biller; pay-bill action and automation action type.
- [ ] **16.2** Next.js: Biller list and form; “pay bill” from account; optional automation action “pay Biller”.
  - *Acceptance:* User can define billers and pay them (and automate paying a bill).

---

## Phase 17: Bank/card connections

**Features possible after this phase:** 1 (full: data from connected accounts), 8 (live events from connections feed triggers).

**Goal:** Connection model and sync (e.g. Plaid or similar); link accounts to connections; feed transactions and events into app and triggers.

- [ ] **17.1** Django: Connection sync (link, refresh); map external accounts/transactions to Account/Transaction; emit or store events for triggers.
  - *Acceptance:* Connected accounts and transactions sync; triggers can run on connection events.
- [ ] **17.2** Next.js: Connect bank/card (provider flow); list connected accounts; optional “refresh” and status.
  - *Acceptance:* User can connect accounts and see synced data; triggers can use live connection data.

---

## How to use this (human and AI)

- **Order:** Do phases in order; finish all tasks in a phase before starting the next.
- **Acceptance:** Each task is done when its acceptance criteria are met. If a task is too big, split it in the list and keep acceptance concrete.
- **Docs:** When you add env vars, commands, or structure, update README or `legend/` so the next session (human or AI) can resume without guessing.
- **Checklist:** Uncheck tasks only when they are fully done and verified.

---

Last updated: 2025-02-05
