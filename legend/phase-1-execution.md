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

3. **Create frontend (Next.js + Bun + shadcn)**  
   - Create `frontend/` with Next.js App Router via Bun (e.g. `bunx create-next-app` with App Router, TypeScript, Tailwind).
   - Install and configure shadcn/ui (init + at least one component so the setup is in place for 1.4).
   - Verify: from repo root, `cd frontend && bun run dev` runs and app loads in browser.

4. **Update root README**  
   - Add "Repo structure" entry: `frontend/` (Next.js), `backend/` (Django).
   - Add "Getting started" (or equivalent): how to run backend, how to run frontend, required env (if any for 1.1).
   - State explicitly that the frontend talks to the backend (HTTP/GraphQL once 1.3 is done).
   - Keep existing stack and legend references; update in place.

5. **Update legend docs**  
   - general-technical-overview: Monorepo (`frontend/`, `backend/`); frontend uses Bun; document Node/Bun and Python versions in README.
   - task-list: Note under Phase 1 or 1.1 that structure is monorepo and frontend uses Bun; link to this execution plan if useful.

---

## Task 1.2 — PostgreSQL (after 1.1)

Stand up PostgreSQL locally; document connection; create app DB. Django switches from SQLite to PostgreSQL (e.g. `DATABASE_URL`).

---

## Task 1.3 — GraphQL skeleton (after 1.2)

Django: one app, GraphQL lib, single query (e.g. `ping`/`health`). Acceptance: `runserver` and GraphQL query return success.

---

## Task 1.4 — Next.js calls Django (after 1.3)

Next.js: env for backend URL; one page that calls Django GraphQL (e.g. health) and displays result. shadcn already in place from 1.1.

---

Last updated: 2025-02-05
