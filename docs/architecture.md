# Architecture

## High-level

```
┌────────────────┐      HTTPS       ┌─────────────────────┐      SQL       ┌──────────────┐
│  React + Vite  │  ─────────────▶  │   Supabase Cloud    │  ────────────▶ │  PostgreSQL  │
│   (browser)    │   anon key only  │  (Auth + REST/RT +  │                │  (managed)   │
│                │                  │   Storage)          │                │              │
└────────────────┘                  └─────────────────────┘                └──────────────┘
```

- The browser holds only the **anon (public) key**.
- All sensitive logic is protected by **RLS** at the PostgreSQL level.
- Anything that needs the `service_role` key runs server-side (Supabase Edge Functions or CI), never in the browser.

## Delivery pipeline

```
┌─────────┐  push   ┌────────────────┐  build+test  ┌────────┐   deploy   ┌─────────────────┐
│ GitHub  │ ──────▶ │ GitHub Actions │ ──────────▶  │ Vercel │ ─────────▶ │  React app live │
└─────────┘  PR     └────────────────┘              └────────┘            └────────┬────────┘
                                                                                    │ runtime calls
                                                                                    ▼
                                                                          ┌────────────────────┐
                                                                          │  Supabase Cloud    │
                                                                          └────────────────────┘
```

- **GitHub** = source of truth.
- **GitHub Actions** = CI (lint/test/build) + CD (deploy staging/production).
- **Vercel** = hosts the React build (Preview env for `develop`, Production env for `main`).
- **Supabase** = backend services (DB, Auth, Storage). One Supabase project for staging, one for production is the recommended setup.

## Environments

| Env        | Git branch | Vercel env  | Supabase project        |
|------------|------------|-------------|-------------------------|
| Local      | any        | —           | dev project (shared or per-dev) |
| Staging    | `develop`  | Preview     | staging project         |
| Production | `main`     | Production  | production project (protected) |

## Frontend layout

- `src/lib/` — shared clients (Supabase).
- `src/features/<feature>/` — UI + hooks + logic for one bounded feature.
- `src/components/` — reusable, presentation-only components.
- `src/pages/` — route-level page components.
- `src/routes/` — router setup and guards (e.g. `RequireAuth`).
- `src/hooks/` — generic hooks reused across features.

## Data flow (typical read)

1. User opens a page.
2. A hook (e.g. `useProducts`) calls `supabase.from('products').select(...)`.
3. Supabase JS sends the request with the user's JWT (if logged in) + anon key.
4. PostgreSQL evaluates **RLS policies** for the current `auth.uid()`.
5. Only authorized rows are returned.

## Data flow (typical write)

Same path, but `insert` / `update` / `delete` policies decide whether the row may be written. The frontend never bypasses these — it cannot.
