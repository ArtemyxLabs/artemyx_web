# Artemyx Labs — Website (artemyxlabs.com)

## Project Overview

The public marketing site for Artemyx Labs, LLC. Deployed via **Cloudflare Pages**, source managed in **GitHub**. The site is a **single-file React + Babel in-browser app** — no build step, no bundler, no `npm install`. Just one `index.html`.

**Live URL:** https://artemyxlabs.com  
**Stack:** Vanilla HTML + inline React 18 (via CDN UMD builds) + Babel Standalone (JSX transpiled in-browser)  
**Deploy:** GitHub Actions → `wrangler pages deploy` on push/tag. See README for environment URLs and the full Release Train.

---

## File Structure

```
/
├── index.html          ← The entire site lives here
├── CLAUDE.md           ← This file
└── (any future assets) ← images, PDFs, etc.
```

Everything — components, styles, data, logic — is inside `index.html`. Do not create separate `.js` or `.css` files unless specifically asked.

---

## Tech Stack Details

### React Pattern
- React 18 loaded via CDN (`react.production.min.js` + `react-dom.production.min.js`)
- JSX transpiled in-browser via Babel Standalone (`babel.min.js`)
- Script tag uses `type="text/babel"` — this is required, not `type="module"`
- All hooks destructured from global `React`: `const { useState, useEffect, useRef } = React;`
- Components are plain functions, no imports/exports

### CSS Pattern
- Global resets and keyframe animations in a `<style>` block in `<head>`
- All component styles are **inline style objects** using the `T` theme object
- No Tailwind, no CSS modules, no external stylesheet

---

## Brand System

### Theme Object (`T`)
All colors and gradients are defined in a single `T` object at the top of the script block. Always reference `T.*` — never hardcode colors inline.

```js
const T = {
  // Backgrounds
  bg: "#F5F5F7",           // Page background (light gray)
  bgSoft: "#EDEDF0",       // Slightly darker surface
  darkBg: "#0B1120",       // Section banners, nav, footer

  // Text
  ink: "#1A1A2E",          // Primary text
  inkSoft: "#2D2D44",      // Slightly lighter primary
  muted: "#6B7280",        // Secondary/caption text
  mutedLight: "#9CA3AF",   // Tertiary text
  lightText: "#E2E8F0",    // Text on dark backgrounds

  // Brand colors
  teal: "#00D4AA",         // Primary accent
  midTeal: "#00B8CC",      // Secondary accent
  blue: "#0077FF",         // Tertiary accent

  // Borders
  rule: "#E5E7EB",
  ruleSoft: "#F0F1F3",

  // Gradients (CSS string values)
  gradient: "linear-gradient(135deg, #00D4AA 0%, #0077FF 100%)",
  gradientSubtle: "linear-gradient(135deg, rgba(0,212,170,0.08) 0%, rgba(0,119,255,0.06) 100%)",
  gradientCard: "linear-gradient(135deg, rgba(0,212,170,0.04) 0%, rgba(0,119,255,0.03) 100%)",
};
```

### Typography
- **Headings:** `'Orbitron', sans-serif` — loaded via Google Fonts. Use for brand wordmark, section titles, large display text.
- **Labels / mono:** `'JetBrains Mono', monospace` — use for tags, badges, code-style labels.
- **Body:** `system-ui, -apple-system, 'Segoe UI', sans-serif`

### Gradient Text (standard pattern)
```js
style={{
  background: T.gradient,
  WebkitBackgroundClip: "text",
  WebkitTextFillColor: "transparent"
}}
```

### Logo
Two built-in components — always use these, never recreate the logo as an image:

- `<ArtemyxIcon size={40} id="iconG" />` — the hexagonal neural network SVG mark
- `<ArtemyxWordmark dark={false} size="md" />` — the ARTEMYX / LABS stacked wordmark

---

## Key Reusable Components

### `<Reveal>` — scroll-triggered fade/slide-up
```jsx
<Reveal delay={0.1}>
  <SomeSection />
</Reveal>
```
Wraps any section to animate it in when scrolled into view. Uses `IntersectionObserver`.

### `<Section>` — standard page section wrapper
Standard full-width section with consistent `maxWidth: 1100` centered content.

### Standard card pattern
White background, `borderRadius: 16`, `border: \`1px solid ${T.rule}\``, `boxShadow: "0 2px 12px rgba(0,0,0,0.04)"`.

---

## Site Sections (Current)

1. **Nav** — fixed top bar with logo, nav links, CTA button
2. **Hero** — headline, sub-headline, two CTA buttons, animated grid background
3. **Model** — Build · Run · Venture three-column explainer
4. **Services** — capability cards (Custom Platforms, Managed Run, Equity Ventures)
5. **Case Studies** — HypeTix, Nyx AI, Creator Connections cards (link to PDFs)
6. **CTA Banner** — dark section with contact prompt
7. **Footer** — logo, tagline, contact info, nav links

---

## Business Context (for copy/content decisions)

- **Company:** Artemyx Labs, LLC — Colorado LLC, Frederick CO
- **Founders:** Chris Johnson (MD, Lead Dev) + Joel Wood (Co-Founder, Biz Dev)
- **Model:** Build · Run · Venture — custom software platforms, managed retainers, equity stakes
- **Key differentiator:** Clients own their IP (vs. SaaS lock-in like Salesforce)
- **Stage:** Early — actively pitching proposals, not yet publicly announcing clients by name without approval
- **Tagline territory:** "AI-native software development, managed services, and venture partnerships."
- **Contact:** ops.artemyxlabs.com (internal ops), standard email for public

---

## Editing Guidelines

1. **All edits go in `index.html`** — one file, full stop.
2. **Never hardcode hex colors** — always use `T.*` properties.
3. **Never break the `<script type="text/babel">` tag** — all JSX must be inside it.
4. **No `import` or `export` statements** — this is not an ES module environment.
5. **Add new Google Fonts** by appending to the existing `<link>` href query string.
6. **New sections** should follow the Reveal + Section wrapper pattern for consistency.
7. **Mobile responsiveness** — use `window.innerWidth` checks via state or CSS media queries in the `<style>` block. Avoid inline media queries.
8. **Test locally** by opening `index.html` directly in a browser — no server needed.

---

## Deploy Process

```bash
# Dev (immediate — push to main)
git add index.html
git commit -m "update: what changed"
git push origin main

# Staging + Prod (Release Train)
git checkout -b release/x.y.z && git push origin release/x.y.z  # → staging
git tag vx.y.z && git push origin vx.y.z                        # → prod
```

No build step. No `npm run build`. Cloudflare Pages serves `index.html` directly from the root.

---

## Common Tasks

**Add a new section:**
Create a new component function, wrap content in `<Reveal>`, insert into the main `App` return JSX in the correct position.

**Change hero copy:**
Find the Hero component function, update the heading/subheading string literals.

**Add a new case study card:**
Find the `caseStudies` array (or equivalent data structure), add a new object following the existing schema.

**Update nav links:**
Find the `navLinks` array near the top of the Nav component.

**Add a new page/route:**
The site is currently single-page with no router. If routing is needed, add `react-router-dom` via CDN or implement a simple `useState`-based view switcher.
