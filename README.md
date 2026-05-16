# react-supabase-starter-architecture

A starter architecture for building apps with **React + Vite** on the frontend, **Supabase Cloud** (PostgreSQL + Auth + Storage) on the backend, deployed to **Vercel**, with **GitHub Actions** for CI/CD and **Claude Code** sub-agents to assist development.

This repo is intentionally minimal — it gives you the structure, conventions, and tooling, not a full app.

---

## 1. Prerequisites

- Node.js >= 18
- npm (or pnpm / yarn — adjust commands accordingly)
- A Supabase Cloud project: https://supabase.com
- A Vercel account (for deploys): https://vercel.com
- A GitHub repository (for CI/CD and team workflow)

---

## 2. Install

```bash
git clone <your-repo-url>
cd react-supabase-starter-architecture
npm install
```

> Note: `package.json` is not bundled in this starter. Initialize it with:
> ```bash
> npm create vite@latest . -- --template react
> npm install @supabase/supabase-js
> ```

---

## 3. Configure environment variables

Copy `.env.example` to `.env` at the project root:

```bash
cp .env.example .env
```

Then fill in:

```
VITE_SUPABASE_URL=https://<your-project-ref>.supabase.co
VITE_SUPABASE_ANON_KEY=<your-anon-public-key>
```

**Never commit `.env`. Never put `service_role` in `.env` — it belongs only in server-side environments.**

---

## 4. Run locally

```bash
npm run dev
```

Vite will start the dev server (default `http://localhost:5173`).

Build for production:

```bash
npm run build
npm run preview
```

---

## 5. Database & migrations (Supabase)

All schema changes live in `supabase/migrations/` as SQL files, numbered in order:

- `001_create_profiles.sql`
- `002_create_example_tables.sql`
- `003_enable_rls.sql`

Apply them either:

- via the Supabase SQL Editor (paste and run, in order), or
- via the Supabase CLI:
  ```bash
  supabase link --project-ref <your-project-ref>
  supabase db push
  ```

See `docs/database-plan.md` and `docs/security-rules.md`.

---

## 6. Working with GitHub

- `main` → production branch (protected).
- `develop` → staging branch.
- `feature/<short-name>` → individual work branches.

Every change goes through a **Pull Request** with **CI green** and **at least one review**. See `CONTRIBUTING.md` and `docs/workflow-team.md`.

---

## 7. CI/CD

GitHub Actions are defined in `.github/workflows/`:

- `ci.yml` → runs lint / test / build on every PR.
- `deploy-staging.yml` → deploys `develop` to Vercel staging.
- `deploy-production.yml` → deploys `main` to Vercel production (protected env).

Required GitHub Secrets:

- `VERCEL_TOKEN`
- `VERCEL_ORG_ID`
- `VERCEL_PROJECT_ID`
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

---

## 8. Using Claude Code agents

This repo ships with sub-agents in `.claude/agents/`:

| Agent | When to use |
|---|---|
| `architect-agent` | Planning a feature, splitting tasks, identifying impacted files. |
| `frontend-agent` | Building React pages, components, forms, routes, Supabase calls. |
| `supabase-agent` | Writing SQL migrations, RLS policies, configuring Auth/Storage. |
| `cicd-agent` | Editing GitHub Actions, deploy pipelines, managing secrets. |
| `reviewer-agent` | Reviewing a diff for bugs, security, exposed secrets, build/test status. |

Invoke them via Claude Code's agent system, e.g. "Use the supabase-agent to add a `categories` table with RLS".

---

## 9. Project structure

See `CLAUDE.md` and `docs/architecture.md`.
