# Denda

Fullstack finance app.

## Stack

- **Frontend**: Next.js
- **Backend**: Django
- **Database**: PostgreSQL
- **Deployment**: Self-hosted

## Repo structure

- `frontend/` — Next.js (App Router, TypeScript, Tailwind, shadcn/ui). Run with Bun.
- `backend/` — Django. SQLite for 1.1; PostgreSQL in 1.2.
- `legend/` — Plans, technical overviews, and high-level documentation. Start with [legend/general-technical-overview.md](legend/general-technical-overview.md) for architecture and stack; [legend/features.md](legend/features.md) for target features and scope; [legend/task-list.md](legend/task-list.md) for phased tasks.

## Getting started

No environment variables are required for 1.1.

**Backend (Django)**

```bash
cd backend && python manage.py runserver
```

Server runs at http://127.0.0.1:8000/ (or the port shown).

**Frontend (Next.js)**

```bash
cd frontend && bun run dev
```

App runs at http://localhost:3000/ (or the port shown).

The frontend talks to the backend over HTTP; once 1.3 is done, it will use GraphQL for health and other queries.

See `legend/` for plans and the [general technical overview](legend/general-technical-overview.md).
