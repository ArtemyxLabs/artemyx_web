# artemyx_web — Claude Rules

This project follows the **Artemyx Generic App archetype** with the deviations noted below. Check all code and infrastructure changes against these rules before responding or suggesting changes.

---

## Archetype: Generic App (Static Variant)

This is a Generic App archetype project **without a backend**. It is a static brochure site with no Supabase, no Edge Functions, no database, and no auth. Do not suggest adding any of these unless explicitly asked.

**Documented deviations from the full Generic App standard:**
- No Supabase (no backend, no auth, no DB) — static site only
- No AWS AppConfig — no runtime config required
- No AWS Secrets Manager — no secrets required
- No observability stack (no Grafana Alloy, no CloudWatch log groups)
- Infrastructure lives in the **ArcaHq repo**, not in this repo
- Shared AWS account 336090301433 with ArcaHq (intentional, documented in README)

These are approved deviations, not oversights. Do not flag them.

---

## The One Rule: Everything in `index.html`

The entire site — components, styles, data, logic — lives in a single `index.html`. Do not create separate `.js`, `.css`, or component files. Do not suggest splitting into multiple files unless explicitly asked.

**React pattern:** CDN UMD builds loaded via `<script>` tags. JSX transpiled in-browser by Babel Standalone (`<script type="text/babel">`). No `import`/`export`. All hooks destructured from global `React`.

---

## Styling Rules

- All colors reference the `T` theme object — **never hardcode hex values**.
- All component styles are inline style objects using `T.*`.
- Global resets and `@keyframe` animations go in the `<style>` block in `<head>`.
- No Tailwind. No CSS modules. No styled-components. No external UI libraries.

---

## Deployment and Environments

| Environment | URL | Trigger |
|-------------|-----|---------|
| Dev | https://artemyx-web-dev.pages.dev | Merge to `main` |
| Staging | https://artemyx-web-staging.pages.dev | Push to `release/*` |
| Production | https://artemyxlabs.com | Tag `v*.*.*` |

All three environments are Cloudflare Pages projects (Direct Upload via wrangler). No build step — wrangler deploys the root directory directly.

---

## Release Train

```
{ticket}-{feature} branch → PR → main (auto-deploys dev)
                                    ↓
                          release/x.y.z (auto-deploys staging)
                                    ↓
                              tag vx.y.z (deploys prod)
```

- Feature branches must be cut from `main` with a ticket prefix.
- Bug fixes found in staging must be cut from the release branch, not from `main`.
- Never push directly to `main` or a `release/*` branch.

---

## Infrastructure

Infrastructure for this project lives in the **ArcaHq repo** (`infra/shared/` and `infra/envs/*/`). Do not create or modify Terraform files in this repo. When infra changes are needed, direct the user to the ArcaHq repo.

GitHub Actions authenticate to AWS account 336090301433 via OIDC. No long-lived credentials are stored in GitHub. Do not suggest adding AWS credentials as GitHub secrets.

---

## Configuration and Secrets

This site has no runtime config and no secrets. Do not suggest adding AppConfig, Secrets Manager, or environment variables unless the site gains a backend.

---

## What Not to Do

- Do not add a router — navigation is state-based via `setPage()`
- Do not add a build step, bundler, or package manager
- Do not add `import`/`export` statements
- Do not add external UI libraries (no shadcn, MUI, Ant Design, etc.)
- Do not change the color scheme or fonts without being asked
- Do not create Terraform files in this repo — infra is in ArcaHq
