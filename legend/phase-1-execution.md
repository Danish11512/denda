# Phase 1 execution plan

Execution detail for Phase 1 (Foundation). Reference: [task-list.md](./task-list.md), [general-technical-overview.md](./general-technical-overview.md).

**Decisions for 1.1:** Monorepo (`frontend/`, `backend/`). Root README only. Frontend: Bun; Next.js includes shadcn/ui in scaffold. Backend: Django runs with SQLite for 1.1 so both apps are runnable without PostgreSQL (1.2 adds PostgreSQL). README updated in place.

---

## Stack version policy

**Python and Bun/Node:** Use current stable versions compatible with Django and Next.js respectively. Document actual versions in the root README when the scaffold exists (1.1). This file and [general-technical-overview.md](./general-technical-overview.md) state the policy; README lists concrete versions after implementation.

---

## Stack versions (document in README when implementing)

- **Python:** Use current stable compatible with Django (e.g. 3.12+). Document in README.
- **Frontend runtime / package manager:** Bun (current stable). Next.js runs under Bun; document Bun and Node version (Bun embeds Node) in README.
- **Django:** Current stable (e.g. 5.x). Backend dependency only.
- **Next.js:** Current stable App Router. Frontend scaffold in 1.1; GraphQL client and health page in 1.4.

---

## Task 1.1 — Create project structure (plan)

**Acceptance:** Two runnable apps; README states how to run each and that frontend talks to backend.

### Sub-tasks (todos)

1. **Document stack versions**  
   Record in this file and in general-technical-overview: Python and Bun/Node version policy (current stable, compatible with Django and Next.js). README will list actual versions when scaffold exists.

2. **Create backend (Django)**  
   - Create `backend/` with Django project (e.g. `config/` or `denda/` for settings, `manage.py` at `backend/`).
   - One app for finance domain (e.g. `core` or `finance`).
   - Use SQLite for 1.1 so `python manage.py runserver` starts without DB setup; 1.2 will add PostgreSQL and connection docs.
   - Verify: from repo root, `cd backend && python manage.py runserver` runs and server responds.

3. **Backend dev environment script**  
   - Create a script (e.g. `backend/scripts/ensure-venv.sh` or `scripts/backend-venv.sh`) that is run **before any backend work**. On each run it: creates a fresh venv (or uses existing), installs all dependencies from `backend/requirements.txt`, and loads/sources env so all required keys (e.g. `DATABASE_URL`, `SECRET_KEY`) are set and ready. Document in README: run this script first when working on the backend.
   - **On cancel (SIGINT / script exit on failure / explicit cleanup):** destroy the venv and any other temporary artifacts created by the script (e.g. temp dirs, generated env files if any). No persistent venv or temp state left behind after cancel.
   - Verify: running the script leaves backend ready to use (`python manage.py runserver` or `migrate` works with env in place); cancel or cleanup removes venv and temp files.

4. **Create frontend (Next.js + Bun + shadcn)**  
   - Create `frontend/` with Next.js App Router via Bun (e.g. `bunx create-next-app` with App Router, TypeScript, Tailwind).
   - Install and configure shadcn/ui (init + at least one component so the setup is in place for 1.4).
   - Verify: from repo root, `cd frontend && bun run dev` runs and app loads in browser.

5. **Update root README**  
   - Add "Repo structure" entry: `frontend/` (Next.js), `backend/` (Django).
   - Add "Getting started" (or equivalent): how to run backend, how to run frontend, required env (if any for 1.1). Include: run the backend dev environment script before backend work so venv and env are ready.
   - State explicitly that the frontend talks to the backend (HTTP/GraphQL once 1.3 is done).
   - Keep existing stack and legend references; update in place.

6. **Update legend docs**  
   - general-technical-overview: Monorepo (`frontend/`, `backend/`); frontend uses Bun; document Node/Bun and Python versions in README. Note that backend work requires running the dev environment script first (venv + deps + env); on cancel, script cleans up venv and temp artifacts.
   - task-list: Note under Phase 1 or 1.1 that structure is monorepo and frontend uses Bun; link to this execution plan if useful.

---

## Task 1.2 — PostgreSQL (after 1.1)

**Decisions:** Assume PostgreSQL is already installed. Single `DATABASE_URL` (e.g. `postgres://user:pass@localhost:5432/denda`). Fixed app DB name: `denda`. Full cutover: no SQLite fallback. Connection + migrations in 1.2. Document in README and legend (this file and general-technical-overview). Minimal URL parsing in Django settings (no new dependency).

**Acceptance:** Django connects to PostgreSQL; doc shows how to create the DB and connect; migrations run on PostgreSQL.

### Sub-tasks (todos)

1. **Document PostgreSQL in legend**  
   Add a short "PostgreSQL (local)" note in general-technical-overview (or under Data): app DB name `denda`, connection via `DATABASE_URL`, doc in README. This file already records the decisions above.

2. **Backend: PostgreSQL connection**  
   - Add `psycopg2-binary` to `backend/requirements.txt`.
   - In `backend/config/settings.py`: require `DATABASE_URL`; parse it with `urllib.parse` (no new lib); set `DATABASES['default']` to PostgreSQL (ENGINE, NAME, USER, PASSWORD, HOST, PORT). No SQLite fallback; if `DATABASE_URL` is unset, raise `ImproperlyConfigured`.
   - Verify: with PostgreSQL running and `DATABASE_URL` set, `cd backend && python manage.py runserver` starts without error (migrations applied in next sub-task).

3. **Create app DB and run migrations**  
   - Document in README: install PostgreSQL (or link), create DB with `createdb denda` (or equivalent), set `DATABASE_URL` in `.env` or env (e.g. `postgres://user:pass@localhost:5432/denda`), then `cd backend && python manage.py migrate`.
   - Verify: after creating `denda` and setting `DATABASE_URL`, `python manage.py migrate` runs; `python manage.py runserver` connects and serves.

4. **Update root README**  
   - Add a "Database" (or "Getting started" subsection): PostgreSQL required; how to install (or link); create DB `denda`; set `DATABASE_URL`; run backend migrations. Remove or update any "no env required for 1.1" to note that 1.2 requires `DATABASE_URL`.
   - Keep existing stack and legend references.

5. **Update legend docs**  
   - general-technical-overview: Under Data (PostgreSQL) or Backend, note that local run uses `DATABASE_URL` and DB name `denda`; README has step-by-step. task-list: No change needed (acceptance already states "Django can connect; doc shows how to create DB and connect").

---

## Task 1.3 — GraphQL skeleton (after 1.2)

Django: one app, GraphQL lib, single query (e.g. `ping`/`health`). Acceptance: `runserver` and GraphQL query return success.

---

## Task 1.4 — Next.js calls Django (after 1.3)

Next.js: env for backend URL; one page that calls Django GraphQL (e.g. health) and displays result. shadcn already in place from 1.1.

---

## Completion verification (1.1 and 1.2)

Verified 2025-02-06. All sub-tasks through 1.2.5 are implemented and documented.

- **1.1:** Stack versions in this file, general-technical-overview, README. Backend: `backend/` with `config/`, `core/`, `manage.py`. Dev script: `backend/scripts/ensure-venv.sh` (venv + deps + env; cleanup on exit). Frontend: `frontend/` with Next.js, shadcn/ui. README: repo structure, Getting started (Database, Backend with script, Frontend), frontend talks to backend. Legend: general-technical-overview has dev script note; task-list has 1.1 decisions and link.
- **1.2:** general-technical-overview has PostgreSQL (local) note. requirements.txt has psycopg2-binary; settings.py requires DATABASE_URL, urllib.parse, ImproperlyConfigured. README: Database subsection (install, createdb denda, DATABASE_URL, migrate). Legend: Data (PostgreSQL) and README step-by-step. No SQLite; `backend/db.sqlite3` removed.

Last updated: 2025-02-06
