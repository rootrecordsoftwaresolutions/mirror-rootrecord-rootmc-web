# RootMC website (`rootmc.net`)

Standalone export of the RootMC public site for UI/design work. Production deploy target is **Cloudflare Pages** (`rootmc-web` project) on custom domain **rootmc.net**.

## Stack

- **Static site** — HTML, CSS, vanilla JS under `public/`
- **Build** — copies `public/` → `build/` (`scripts/build.mjs`)
- **Pages Functions** — `functions/api/[[path]].ts` proxies `/api/*` to `api.rootmc.net` (and account API for auth routes)
- **No bundler framework** — no React/Vue; pages are hand-authored static files

## Local preview

```powershell
pnpm install
pnpm run build
npx wrangler pages dev build
```

Open the URL Wrangler prints (usually `http://localhost:8788`). Live data requires the upstream API (`https://api.rootmc.net`) to be reachable.

## Key pages

| Path | Source |
|------|--------|
| `/` | `public/index.html`, `public/home.js` |
| `/market/` | Stock market table + Chart.js |
| `/shops/` | Player shop listings |
| `/player/` | Player stats / net worth |
| `/verify/` | Minecraft ↔ account linking |
| `/wiki/` | Player + operator docs |
| `/servers/` | Server info |

Shared styles: `public/styles/rootmc.css`

## Deploy (RootRecord maintainers)

```powershell
pnpm install
pnpm run pages:deploy
```

Requires `.env` with `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` (see `.env.example`).

## Plugin JARs (`public/plugins/`)

The in-game auto-update manifest lives here. **JAR binaries are not in this repo** — they are produced by the MonoRepo Minecraft Gradle build (`publishPlugins generatePluginManifest`) and uploaded on deploy. Do not delete `manifest.json` if merging back to production.

## Upstream API (read-only for UI work)

- Site fetches: `/api/rootmc/...` (proxied to `https://api.rootmc.net/api/rootmc/...`)
- Market: `GET /api/rootmc/stock-market/items?server_id=rootmc`
- Shops: `GET /api/rootmc/server/rootmc/shops`

## Monorepo origin

Extracted from `MonoRepo/Web/apps/rootmc-web/` (RootRecord monorepo). After UI work, changes merge back into that path before `cloudflare-update-pages` / production deploy.

## Emergent / contractor notes

- Prefer editing `public/` and `public/styles/rootmc.css`; avoid breaking `/api/` proxy or `_redirects`
- Chart.js loaded from CDN on market page
- Theme: dark green (`#0a140a`), Fraunces + Geist fonts (see `index.html` head)
- Mobile nav is in shared header markup on each page
