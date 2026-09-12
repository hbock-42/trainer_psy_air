---
id: US-051
issue: 41
title: "Practice session with instant feedback"
type: story
epic: EPIC-05
status: done
priority: P0
size: M
lane: train-ui
depends_on: [US-050,US-021,US-022]
labels: [ui,practice]
---

# US-051 — Practice session with instant feedback

**As a** candidate **I want** immediate correction and explanation after each item **so that** I learn from mistakes right away.

## Acceptance criteria
- [x] Runs `TestSession` in `practice` mode; progress dots, optional per-item timer
- [x] Correct/wrong feedback, explanation, "Next"; pause and quit (session saved as aborted)
- [x] Attempts persisted as they happen; restarting the app after a crash offers to resume
- [x] Widget test of a full 3-item session with a fake generator
