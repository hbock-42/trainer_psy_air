---
id: US-053
issue: 43
title: "Adaptive difficulty"
type: story
epic: EPIC-05
status: backlog
priority: P2
size: M
lane: train-ui
depends_on: [US-051,US-075]
labels: [practice,analytics]
---

# US-053 — Adaptive difficulty

**As a** candidate **I want** difficulty to follow my level **so that** drills stay challenging but doable.

## Acceptance criteria
- [ ] "Auto" difficulty = per-family level derived from recent accuracy & speed (US-075)
- [ ] Within a session: +1 after 3 consecutive correct & fast, −1 after 2 consecutive wrong
- [ ] Level changes are shown discreetly and logged in the session config
