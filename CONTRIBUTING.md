# Contributing

Thanks for contributing! Please follow this workflow.

## 1. Branch from `develop`

Never work directly on `main` or `develop`.

```bash
git checkout develop
git pull
git checkout -b feature/<short-descriptive-name>
```

Branch naming:

- `feature/<name>` — new features.
- `fix/<name>` — bug fixes.
- `chore/<name>` — tooling, deps, docs.

## 2. Commit cleanly

- Small, focused commits.
- Imperative present tense ("add product list", not "added product list").
- Reference issues when relevant (`#123`).

## 3. Open a Pull Request

- Target branch: **`develop`** (not `main`).
- Fill in the PR description: what, why, how to test.
- Link any related issue.

## 4. Wait for CI

The `ci.yml` workflow runs on every PR:

- install dependencies
- `npm run lint` (if configured)
- `npm run test` (if configured)
- `npm run build`

**CI must be green before merge.**

## 5. Request a review

- At least **one approving review** is required.
- Reviewer checks: correctness, security (RLS, exposed secrets), readability, tests.
- The `reviewer-agent` (Claude Code) can do a first pass, but a human review is still required.

## 6. Merge

- Use **Squash and merge** (preferred) to keep history clean on `develop`.
- Delete the feature branch after merge.

## 7. Promote to production

- A separate PR from `develop` → `main` triggers `deploy-production.yml`.
- The `main` branch is protected: no direct pushes, no force-pushes.

## Rules

- ❌ Never push directly to `main`.
- ❌ Never commit `.env`, secrets, or `service_role` keys.
- ❌ Never disable RLS on a user-data table.
- ✅ Always update migrations in `supabase/migrations/` for schema changes.
- ✅ Always update `docs/` when you change architecture or DB plan.
