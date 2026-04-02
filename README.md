# artemyx_web

Public marketing site for [Artemyx Labs](https://artemyxlabs.com) — a single `index.html` using CDN React + Babel Standalone. No build step, no bundler, no npm.

---

## Environments

| Environment | URL | Deploy Trigger |
|-------------|-----|----------------|
| **Dev** | https://artemyx-web-dev.pages.dev | Push to `main` |
| **Staging** | https://artemyx-web-staging.pages.dev | Push to `release/*` |
| **Production** | https://artemyxlabs.com | Tag `v*.*.*` |

All environments are hosted on **Cloudflare Pages** using Direct Upload (wrangler). DNS for `artemyxlabs.com` is managed in Cloudflare — the apex and `www` records point to `artemyx-web-prod.pages.dev`.

---

## Stack

- **Frontend:** Vanilla HTML + React 18 (CDN UMD) + Babel Standalone — everything in `index.html`
- **Hosting:** Cloudflare Pages (Direct Upload via wrangler)
- **CI/CD:** GitHub Actions (OIDC auth to AWS 336090301433)
- **Infra:** Terraform lives in the [ArcaHq](https://github.com/ArtemyxLabs/ArcaHq) repo (`infra/shared/` and `infra/envs/*/`)

No Supabase. No backend. No build step.

---

## Release Train

```
feature branch → PR → main (auto-deploys to dev)
                       ↓
              release/x.y.z (auto-deploys to staging)
                       ↓
                  tag vx.y.z (deploys to prod)
```

**Feature work:**
```bash
git checkout -b TICKET-my-feature
# make changes to index.html
git push && gh pr create
# merge PR → dev auto-deploys
```

**Releasing to staging + prod:**
```bash
git checkout -b release/1.1.0
git push origin release/1.1.0        # triggers staging deploy
# verify at artemyx-web-staging.pages.dev
git tag v1.1.0
git push origin v1.1.0               # triggers prod deploy
```

---

## Local Development

No server needed — open `index.html` directly in a browser:

```bash
open index.html
```

All edits go in `index.html`. Never create separate `.js` or `.css` files.

---

## Make Targets

```bash
make install        # Install Terraform + wrangler
make github-setup   # Create GitHub environments, set secrets/vars
make credentials    # View/rotate stored credentials
make update-platform # Pull latest Artemyx platform scripts
```

---

## GitHub Secrets & Vars

| Name | Type | Value |
|------|------|-------|
| `CLOUDFLARE_API_TOKEN` | Secret | Pages deploy token |
| `CLOUDFLARE_ACCOUNT_ID` | Secret | `6b40cb2e667312e61f1b0ab520babd1d` |
| `AWS_ACCOUNT_ID` | Var | `336090301433` |
| `DEV_CF_PAGES_PROJECT` | Var | `artemyx-web-dev` |
| `STAGING_CF_PAGES_PROJECT` | Var | `artemyx-web-staging` |
| `PROD_CF_PAGES_PROJECT` | Var | `artemyx-web-prod` |

---

## Infrastructure

Managed in the **ArcaHq repo** — artemyx_web piggybacks on ArcaHQ's AWS account (336090301433) and Cloudflare account.

| Resource | Location in ArcaHq repo |
|----------|--------------------------|
| IAM deployer roles (`artemyx-web-*`) | `infra/shared/main.tf` |
| CF Pages project (dev) | `infra/envs/dev/main.tf` |
| CF Pages project (staging) | `infra/envs/staging/main.tf` |
| CF Pages project (prod) + custom domain | `infra/envs/prod/main.tf` |

To apply infra changes, run from the ArcaHq repo:
```bash
make infra ENV=shared
make infra ENV=dev
make infra ENV=staging
make infra ENV=prod
```

---

## AWS IAM Roles (account 336090301433)

| Role | Used by |
|------|---------|
| `artemyx-web-dev-developer` | Engineers (dev resources) |
| `artemyx-web-dev-deployer` | GitHub Actions → dev |
| `artemyx-web-staging-deployer` | Release managers |
| `artemyx-web-staging-deployer-ci` | GitHub Actions → staging |
| `artemyx-web-prod-readonly` | On-call / PMs |
| `artemyx-web-prod-deployer` | GitHub Actions → prod |
