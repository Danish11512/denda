# Denda

Fullstack finance app.

## Stack

- **Frontend**: Next.js
- **Backend**: Django
- **Database**: PostgreSQL
- **Deployment**: Self-hosted

**Versions (documented at scaffold; see also legend/phase-1-execution.md):**

- **Python:** 3.12+ (backend). See `backend/requirements.txt` for Django.
- **Bun / Node:** Bun current stable (frontend; Bun embeds Node). See `frontend/package.json` for Next.js and dependencies.

## Repo structure

- `frontend/` — Next.js (App Router, TypeScript, Tailwind, shadcn/ui). Run with Bun.
- `backend/` — Django. PostgreSQL (see Database below).
- `legend/` — Plans, technical overviews, and high-level documentation. Start with [legend/general-technical-overview.md](legend/general-technical-overview.md) for architecture and stack; [legend/features.md](legend/features.md) for target features and scope; [legend/task-list.md](legend/task-list.md) for phased tasks.

## Getting started

**Database (PostgreSQL)**

The backend requires PostgreSQL. Install it locally (e.g. [PostgreSQL downloads](https://www.postgresql.org/download/) or your package manager). Create the app database and set `DATABASE_URL`:

```bash
createdb denda
```

Set the connection URL (e.g. in `backend/.env` or your environment):

```bash
export DATABASE_URL=postgres://your_user:your_password@localhost:5432/denda
```

Then run migrations:

```bash
cd backend && python manage.py migrate
```

**Backend (Django)**

Before working on the backend, run the dev environment script so the venv, dependencies, and env (e.g. `DATABASE_URL`) are ready:

```bash
./backend/scripts/ensure-venv.sh
```

Inside the spawned shell you can run `python manage.py runserver` or `python manage.py migrate`. Exiting that shell removes the venv and any temp artifacts.

To run the server without the script (e.g. you already have a venv and env set):

```bash
cd backend && python manage.py runserver
```

Server runs at http://127.0.0.1:8000/ (or the port shown). Requires `DATABASE_URL` to be set.

**Frontend (Next.js)**

```bash
cd frontend && bun run dev
```

App runs at http://localhost:3000/ (or the port shown).

The frontend talks to the backend over HTTP; once 1.3 is done, it will use GraphQL for health and other queries.

See `legend/` for plans and the [general technical overview](legend/general-technical-overview.md).
