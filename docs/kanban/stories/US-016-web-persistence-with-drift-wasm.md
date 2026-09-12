---
id: US-016
issue: 157
title: "Web persistence with drift WASM"
type: story
epic: EPIC-02
status: backlog
priority: P1
size: M
lane: core
depends_on: [US-011,US-006]
labels: [db,web]
---

# US-016 — Web persistence with drift WASM

**As a** web user **I want** my progress kept between visits **so that** the web build is usable for real, not just a demo.

## Context
`lib/core/db/open_database.dart` uses a conditional import: native SQLite on mobile/desktop, a stub that throws `UnsupportedError` on web (US-011). Drift supports web through `WasmDatabase.open` with `sqlite3.wasm` + `drift_worker.js` served from `web/`; it picks the best available storage (OPFS in a shared worker when cross-origin isolated, otherwise IndexedDB) and reports which one it chose.

## Acceptance criteria
- [ ] `web/sqlite3.wasm` and `web/drift_worker.js` added (versions matching the `sqlite3`/`drift` packages; a `tools/` script or documented command to refresh them)
- [ ] Web implementation of `openDatabase` via `WasmDatabase.open(databaseName: 'psy_trainer', sqlite3Uri: …, driftWorkerUri: …)`; the chosen storage (`result.chosenImplementation`) and any `missingFeatures` logged once; a visible notice in Settings → About when storage is not persistent (e.g. in-memory fallback in private browsing)
- [ ] Seeding, sessions, attempts, backup export/import all work on web (a `flutter test --platform chrome` smoke test for open + seed + one attempt round-trip, or a documented manual check if Chrome tests aren't feasible in CI)
- [ ] `flutter build web --release` still green in CI; bundle size impact noted in `docs/ARCHITECTURE.md` Platforms section
- [ ] `docs/ARCHITECTURE.md` Data layer: web storage matrix (OPFS / IndexedDB / memory) and the GitHub Pages implication (no COOP/COEP headers ⇒ IndexedDB)
