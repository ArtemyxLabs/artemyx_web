# Copilot Review Instructions — artemyx_web

This project follows the **Artemyx Generic App archetype** (static variant). Enforce the rules below in all review comments and suggestions.

---

## Archetype: Generic App (Static — No Backend)

This is a static brochure site. It has no Supabase, no Edge Functions, no database, no auth, no AppConfig, and no Secrets Manager. These are **approved deviations** from the full Generic App standard — do not flag them.

Do not suggest adding a backend, database, or auth layer unless explicitly requested.

---

## Single-File Rule

All code lives in `index.html`. Flag any PR that creates separate `.js`, `.css`, or component files.

**Correct React pattern:**
- React 18 loaded via CDN `<script>` tags (UMD builds)
- JSX transpiled in-browser: `<script type="text/babel">`
- No `import` or `export` statements
- No `npm`, no `package.json`, no build step
- All hooks destructured from global `React`

Flag any attempt to introduce a bundler, build tool, or module system.

---

## Styling

- Colors must use `T.*` theme object properties — flag any hardcoded hex values.
- Component styles are inline style objects only.
- No Tailwind, no CSS frameworks, no external UI libraries.

---

## GitHub Branching — Release Train

| Branch | Rule |
|--------|------|
| `main` | Always deployable; auto-deploys to Dev |
| `{ticket}-{feature}` | Feature work; cut from `main`; ticket prefix required |
| `release/{x.y.z}` | Cut from `main`; auto-deploys to Staging |
| `{ticket}-{bugfix}` | Staging fixes; cut from release branch, not `main` |

- Feature branches must rebase from `main`, not merge.
- Flag PRs targeting `main` from `release/*` branches — release branches merge back to `main` after tagging.
- Bug fixes in staging must be cut from the release branch, not from `main`.

---

## CI/CD — GitHub Actions

| Trigger | Expected action |
|---------|-----------------|
| PR → `main` | Security scan (Trivy) |
| Merge → `main` | `wrangler pages deploy .` → `artemyx-web-dev` |
| Push → `release/*` | `wrangler pages deploy .` → `artemyx-web-staging` |
| Tag `v*.*.*` | `wrangler pages deploy .` → `artemyx-web-prod` |

No build step before deploy. Flag any workflow that runs `npm install`, `npm run build`, or introduces a build artifact.

---

## IAM and Secrets

- GitHub Actions authenticates to AWS (account 336090301433) via **OIDC only**.
- No long-lived AWS credentials in GitHub secrets.
- This site has no secrets or environment config — flag any suggestion to add `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, or application secrets as GitHub secrets.

---

## Infrastructure

Terraform for this project lives in the **ArcaHq repo** (`infra/shared/` and `infra/envs/*/`). Flag any Terraform files added to this repo.

---

## PR Merge Requirements

Flag PRs targeting `main` that are missing:
- Passing security scan (Trivy)
- At least one peer review approval (not the author)
