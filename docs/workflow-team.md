# Team Workflow

## Branches

| Branch         | Purpose                          | Protected? |
|----------------|----------------------------------|------------|
| `main`         | Production. Auto-deploys live.   | Yes        |
| `develop`      | Staging. Auto-deploys to preview.| Yes        |
| `feature/<x>`  | Individual work.                 | No         |
| `fix/<x>`      | Bug fixes.                       | No         |
| `chore/<x>`    | Tooling, deps, docs.             | No         |

## Flow

```
feature/foo  ──PR──▶  develop  ──PR──▶  main
   (you)              (staging)         (production)
```

1. Branch from `develop`.
2. Commit, push, open a **Pull Request → `develop`**.
3. CI (`ci.yml`) runs automatically: lint + test + build. **Must be green.**
4. Request **at least one code review**. Reviewer checks correctness, security (RLS, secrets), readability.
5. Once approved and green, **Squash and merge**.
6. Merge to `develop` triggers `deploy-staging.yml` → preview URL on Vercel.
7. When ready to ship: open a PR `develop` → `main`.
8. Merge to `main` triggers `deploy-production.yml`. Production environment is protected and requires a reviewer approval before the deploy job runs.

## Rules

- ❌ **No direct push to `main` or `develop`.**
- ❌ **No force-push to protected branches.**
- ❌ **Do not merge with a failing CI check.**
- ✅ **PRs must include a description**: what, why, how to test.
- ✅ **Update docs** (`docs/`) when architecture or DB plan changes.
- ✅ **Update migrations** for any schema change; no dashboard-only changes.

## Branch protection (configure in GitHub repo settings)

For `main` and `develop`:

- Require pull request before merging.
- Require status checks to pass (`CI / Lint / Test / Build`).
- Require at least 1 approving review.
- Block force pushes and deletions.

For the **production environment** (Settings → Environments → `production`):

- Required reviewers.
- Restrict deploys to the `main` branch.
