---
id: US-054
issue: 44
title: "Retry my mistakes"
type: story
epic: EPIC-05
status: done
priority: P1
size: S
lane: train-ui
depends_on: [US-052,US-011]
labels: [practice]
---

# US-054 — Retry my mistakes

**As a** candidate **I want** to re-drill the items I failed **so that** weaknesses get fixed.

## Acceptance criteria
- [x] From a summary: session-scoped retry; from the family card: all items failed in the last 30 days (bank items) or regenerated with the same params (generated items)
- [x] Item leaves the "mistakes" pool after 2 consecutive correct answers
