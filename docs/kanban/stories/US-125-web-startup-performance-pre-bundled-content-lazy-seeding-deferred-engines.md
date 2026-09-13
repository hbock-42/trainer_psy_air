---
id: US-125
issue: 193
title: "Web startup performance: pre-bundled content, lazy seeding, deferred engines"
type: story
epic: EPIC-12
status: review
priority: P1
size: L
lane: core
depends_on: [US-016,US-124]
labels: [web,performance]
---

# US-125 — Web startup performance: pre-bundled content, lazy seeding, deferred engines

**As a** web user **I want** the app to show its first screen quickly **so that** the GitHub Pages build feels usable on the first visit.

## Suspected causes (measure first)
1. First-launch seeding fetches ~130 content files individually and writes ~1,200 items into IndexedDB through the drift worker before the first screen.
2. `main.dart.js` (~3.5 MB) carries all 27 activity engines up front.

## Acceptance criteria
- [x] Measurement first: a `tools/web_startup_profile.md` with numbers from a Chrome trace of the deployed build (cold: JS + renderer download, seeding; warm: cached) — before/after
- [x] Content pre-bundling: a build step (`tools/bundle_content.dart`, run by `make content-assets`/CI before `flutter build`) that emits one JSON per module (`assets/content/bundles/<module>.json`, gzip handled by the host) from the authored tree; the seeder reads the bundle (fallback to the tree in tests); the validator still runs on the tree; the authored tree stays the source of truth (bundles are generated, gitignored or committed — decide and document)
- [x] Lazy seeding: on first launch seed only the active module; other modules seed in the background after the first frame or on first module switch (UI shows "Chargement du module…" only when needed); `contentVersion` gate per module
- [~] Deferred engines: engines/renderers loaded with `deferred as` imports through a lazy registry (`EngineRegistry.load(familyId)` awaited by the launcher/exam runner before starting a session); a loading state in the launcher; native platforms unaffected (deferred imports are no-ops there); `flutter build web` output shows `*.part.js` files — **scoped down**: only the 13 PSY1 engines are split out (not all 27), loaded eagerly in the background right after the first frame rather than gated behind the launcher/exam runner/retry-mistakes builder. `*.part.js` output and the native no-op are both verified. See `docs/ARCHITECTURE.md` "Startup performance" and `deferred/psy1_engines.dart`'s doc comment for why (touching ~15 session-start call sites and ~50 tests that assume the registries are synchronously, fully populated was judged too high-risk for the time available).
- [x] Startup budget test: an integration/widget test asserting the first frame is not blocked by seeding (e.g. `contentReadyProvider` for the inactive modules completes after the router shows the shell)
- [~] Deployed and re-measured; numbers in `docs/ARCHITECTURE.md` Platforms section; `data-layer` and `add-activity-engine` skills updated (bundles, lazy registry step) — docs and skills updated; **not yet re-measured against a live redeploy** (this PR hasn't merged/deployed yet — `tools/web_startup_profile.md` has local-build "after" numbers and flags the live re-measurement as a follow-up once `main` redeploys via `.github/workflows/pages.yml`).
