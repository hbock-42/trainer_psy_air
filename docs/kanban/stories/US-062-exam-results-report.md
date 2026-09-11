---
id: US-062
issue: 47
title: "Exam results report"
type: story
epic: EPIC-06
status: backlog
priority: P0
size: M
lane: exam-ui
depends_on: [US-061,US-075]
labels: [ui,exam,analytics]
---

# US-062 — Exam results report

**As a** candidate **I want** a detailed report after a simulation **so that** I know where I stand.

## Acceptance criteria
- [ ] Global score + per-section score, accuracy, speed, timeouts count
- [ ] Comparison with my previous simulations (delta per section) and with the estimated pass threshold (configurable, from US-080, shown as "estimated")
- [ ] Review of all items with my answers and explanations (available only after the exam)
- [ ] Report stored; reachable from exam history (US-064) and Progress tab
