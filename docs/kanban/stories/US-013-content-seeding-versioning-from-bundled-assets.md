---
id: US-013
title: "Content seeding & versioning from bundled assets"
type: story
epic: EPIC-02
status: backlog
priority: P0
size: M
lane: core
depends_on: [US-010,US-011]
labels: [db,content]
---

# US-013 — Content seeding & versioning from bundled assets

**As a** user **I want** the app to ship with all content **so that** it works fully offline from first launch.

## Acceptance criteria
- [ ] Content lives in `assets/content/<module>/<family>/*.json` + `lessons/*.md` + images
- [ ] On first launch or when bundled `contentVersion` > stored one, content is (re)seeded in a transaction; user data untouched
- [ ] Seeding runs off the UI thread with a splash/progress indicator; < 2 s for ~1 000 items on a mid-range phone
- [ ] Integration test: seed → query → bump version → re-seed keeps `attempts`
