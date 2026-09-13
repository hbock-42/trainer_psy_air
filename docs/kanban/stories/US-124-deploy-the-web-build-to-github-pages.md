---
id: US-124
issue: 158
title: "Deploy the web build to GitHub Pages"
type: story
epic: EPIC-12
status: done
priority: P1
size: S
lane: core
depends_on: [US-006,US-016]
labels: [release,web,ci]
---

# US-124 — Deploy the web build to GitHub Pages

**As a** candidate **I want** to open the trainer in a browser at a public URL **so that** I can rehearse keyboard-native activities on my computer without installing anything.

## Acceptance criteria
- [x] `.github/workflows/pages.yml`: on push to `main` (after CI) and manual dispatch, `flutter build web --release --base-href /trainer_psy_air/` (repo name from `github.event.repository.name`), upload with `actions/upload-pages-artifact`, deploy with `actions/deploy-pages` (`pages: write`, `id-token: write`), environment `github-pages`
- [x] Deep links work: a `404.html` that redirects to `index.html` preserving the path (SPA fallback) or hash-based URL strategy — pick one, document why (chose the hash URL strategy — see `docs/RELEASE.md`)
- [x] `web/index.html`/`manifest.json` correct under the sub-path; service worker / caching headers considered (`flutter build web` default PWA settings; `--pwa-strategy` documented)
- [x] Repo setting: Pages source = GitHub Actions (document the one-time click in `docs/RELEASE.md` if it cannot be set via `gh api`; try `gh api -X POST repos/{repo}/pages -f build_type=workflow`)
- [x] `README.md` gets the live URL badge/link; `docs/RELEASE.md` gets a "Web (GitHub Pages)" section
- [ ] Verified: the deployed site loads, onboarding → a practice session → progress persists after reload (with US-016), keyboard activities work in Chrome (pending: the workflow deploys on merge to `main`, not from this branch — verify at https://hbock-42.github.io/trainer_psy_air/ after merge)
