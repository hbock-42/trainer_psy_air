---
id: US-005
title: "App shell with bottom navigation"
type: story
epic: EPIC-01
status: backlog
priority: P0
size: S
lane: core
depends_on: [US-002,US-003]
labels: [ui]
---

# US-005 — App shell with bottom navigation

**As a** user **I want** five tabs — Learn, Train, Exam, Progress, Settings — **so that** I always know where I am.

## Acceptance criteria
- [ ] `StatefulShellRoute` with 5 branches, state preserved per tab
- [ ] Placeholder screens with the tab name; each feature later replaces its own placeholder
- [ ] Home/Learn tab shows the "unofficial trainer, not affiliated with Air France" disclaimer (see US-080)
- [ ] Widget test: tapping each tab shows its screen
