---
id: US-115
issue: 172
title: "PSY1: sustained attention engine"
type: story
epic: EPIC-10
status: backlog
priority: P2
size: M
lane: engines
depends_on: [US-101]
labels: [engine,generator,psy1]
---

# US-115 — PSY1: sustained attention engine

Spec §2.3-3: series-based vigilance task, 3 series of ~3 min; exact format is an open question — build on the closest PSY0 paradigm (cadence-driven target detection) and keep the params flexible.
- [ ] Generator: stimulus stream with rare targets (e.g. specific symbol/colour combination), cadence from params, difficulty = target rarity / similarity
- [ ] Renderer: cadence-driven stimulus + key/tap response; scorer hits/misses/false alarms + RT
- [ ] Tests: cadence with `ManualClock`, SessionHost run; flagged `confidence: assumed` in the family file
