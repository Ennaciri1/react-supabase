# CLAUDE.md — Project Rules

This file defines the rules that Claude Code (and any contributor) must follow when working on this project.

## Stack

- **Frontend**: React + Vite
- **Backend / DB / Auth / Storage**: Supabase Cloud (PostgreSQL)
- **Deploy frontend**: Vercel
- **CI/CD**: GitHub Actions
- **Collaboration**: GitHub branches + Pull Requests
- **AI assistant**: Claude Code with sub-agents (see `.claude/agents/`)

## Hard rules

1. **Always use React + Vite** for the frontend. No CRA, no Next.js in this starter.
2. **Always use Supabase Cloud** as the backend (database, auth, storage).
3. **Never expose the `service_role` key in the frontend.** It must only live in GitHub Secrets / Vercel server-side env / Supabase Edge Functions.
4. **Only use the `anon` key on the frontend** (`VITE_SUPABASE_ANON_KEY`).
5. **All database changes go through SQL migrations** in `supabase/migrations/`. No manual edits in the Supabase dashboard for schema.
6. **RLS (Row Level Security) is mandatory** on every table that contains user data. No table goes live without policies.
7. **Plan before coding.** For any non-trivial feature, write the plan first (use the architect agent), then implement.
8. **Run build + tests after modification.** `npm run build` (and `npm run test` if present) must pass before opening a PR.
9. **Keep code simple and readable.** Prefer clarity over cleverness. No premature abstractions.
10. **Respect the project structure** described below. Do not invent parallel structures.

## Project structure

```
.claude/agents/      → sub-agents used by Claude Code
.github/workflows/   → GitHub Actions (CI + deploys)
docs/                → architecture, workflow, DB plan, security
supabase/migrations/ → SQL migrations
src/lib/             → shared clients (Supabase, etc.)
src/features/        → feature folders (auth, dashboard, products...)
src/components/      → reusable UI components
src/pages/           → page components
src/routes/          → route definitions
src/hooks/           → reusable React hooks
```

## Secrets

- Local dev: `.env` (never committed). Use `.env.example` as a template.
- CI/CD: GitHub Secrets.
- Vercel: Environment Variables (separate sets for Preview / Production).
- Service-role-only operations must run on the server (Edge Functions / CI), never in the browser bundle.

## Working with Claude Code

When delegating a task, prefer the right sub-agent:

- `architect-agent` → planning, decomposition, file impact.
- `frontend-agent` → React pages, components, routing, Supabase wiring (client side).
- `supabase-agent` → SQL migrations, RLS, auth config, storage buckets.
- `cicd-agent` → GitHub Actions, deploy pipelines, secrets management.
- `reviewer-agent` → code review, security checks, build/test verification.
