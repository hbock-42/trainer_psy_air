---
id: US-060
issue: 45
title: "Exam blueprint model & PSY0 default blueprint"
type: story
epic: EPIC-06
status: backlog
priority: P0
size: S
lane: exam-ui
depends_on: [US-010,US-080]
labels: [exam,content]
---

# US-060 — Exam blueprint model & PSY0 default blueprint

**As a** candidate **I want** the simulation to follow the real PSY0 structure **so that** the rehearsal is realistic.

## Acceptance criteria
- [ ] `assets/content/psy0/blueprints/psy0_full.json`: ordered sections with family, duration, item count, item source, break between sections
- [ ] Additional "short" blueprint (~20 min) for a quick rehearsal
- [ ] Blueprint values reference the research doc (US-080) and are marked "estimated" where unconfirmed
- [ ] Validated by US-014
