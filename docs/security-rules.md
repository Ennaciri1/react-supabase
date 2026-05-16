# Security Rules

These rules are non-negotiable.

## Keys

| Key                 | Where it lives                                    | Where it must NEVER appear |
|---------------------|---------------------------------------------------|----------------------------|
| `anon` (public)     | Frontend `.env`, Vercel env, GitHub Secrets       | —                          |
| `service_role`      | Server only: Supabase Edge Functions, CI jobs that strictly need it | Frontend `.env*`, `src/**`, committed files, browser bundle, public docs |

- The **anon key** is designed to be public; it is safe in the browser bundle. Security comes from **RLS**, not from key secrecy.
- The **service_role key bypasses RLS**. Treat it like a root password.

## Row Level Security (RLS)

- **Mandatory** on every table that contains user data.
- Enable per table: `alter table <name> enable row level security;`.
- Add explicit policies for `select`, `insert`, `update`, `delete`. Default-deny otherwise.
- Reference `auth.uid()` to scope by owner.
- Test as the anon role and as a logged-in non-owner before merging.

## Secrets management

| Place           | What goes there                                            |
|-----------------|------------------------------------------------------------|
| Local `.env`    | `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY` only         |
| GitHub Secrets  | `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID`, `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`. Server-only secrets (e.g. `SUPABASE_SERVICE_ROLE_KEY`) only if a workflow truly needs them. |
| Vercel env vars | Same as above, split into **Preview** (staging) and **Production** sets. |

- `.env` is in `.gitignore`. Never commit it.
- Never paste secrets into PR descriptions, issue comments, Slack, or AI prompts.
- Rotate any key suspected to have leaked. Audit usage in the Supabase dashboard.

## Frontend rules

- All Supabase calls go through `src/lib/supabase.js` (single client).
- No raw SQL strings interpolated with user input — use the supabase-js builder (`.from().select().eq(...)`).
- Sanitize / escape any user input rendered as HTML. Prefer text rendering by default.

## Storage

- Buckets are **private by default**.
- Public read should be a deliberate decision per bucket.
- Storage policies follow the same RLS principles: scope to `auth.uid()`.

## CI/CD

- Workflows reference secrets via `${{ secrets.NAME }}` — never literal values.
- Production deploys are gated by a **protected environment** with required reviewers.
- Logs must not echo secrets. Don't `cat .env`, don't `env`, don't `set -x` around secret-bearing commands.
