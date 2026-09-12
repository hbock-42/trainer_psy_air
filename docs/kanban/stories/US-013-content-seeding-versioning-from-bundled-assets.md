---
id: US-013
issue: 22
title: "Content seeding & versioning from bundled assets"
type: story
epic: EPIC-02
status: done
priority: P0
size: M
lane: core
depends_on: [US-010,US-011]
labels: [db,content]
---

# US-013 — Content seeding & versioning from bundled assets

**As a** user **I want** the app to ship with all content **so that** it works fully offline from first launch.

## Acceptance criteria
- [x] Content lives in `assets/content/<module>/<family>/*.json` + `lessons/*.md` + images
- [x] On first launch or when bundled `contentVersion` > stored one, content is (re)seeded in a transaction; user data untouched
- [x] Seeding runs off the UI thread with a splash/progress indicator; < 2 s for ~1 000 items on a mid-range phone (measured: ~0.35 s for the 594-item bundle on a laptop test VM, `content_seeder_test.dart` asserts < 2 s)
- [x] Integration test: seed → query → bump version → re-seed keeps `attempts`

## Implementation notes (PR)

- `lib/core/db/seed/`: `AssetReader` (`RootBundleAssetReader`; `FileAssetReader` in
  `test/helpers/`), `ContentBundleLoader` (read on the main isolate, `parse` in `compute`),
  `ContentSeeder.seedIfNeeded()` (one `ContentDao.replaceAll` transaction), `contentReadyProvider`.
- `StartupGate` (`lib/core/router/startup_gate.dart`) holds the router behind a splash until
  content and onboarding flag are ready; errors go to `ErrorScreen` with a retry.
- Lessons store their markdown in `body` at seeding time; lexical fields have no table yet.
- `pubspec.yaml` assets list generated/checked by `tool/list_content_assets.dart`.
- Details: `docs/ARCHITECTURE.md` "Content seeding", `docs/content/AUTHORING.md` §1 and §8.

