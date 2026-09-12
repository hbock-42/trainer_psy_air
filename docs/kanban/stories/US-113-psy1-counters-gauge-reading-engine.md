---
id: US-113
issue: 170
title: "PSY1: counters / gauge reading engine"
type: story
epic: EPIC-10
status: backlog
priority: P2
size: M
lane: engines
depends_on: [US-101]
labels: [engine,generator,psy1]
---

# US-113 — PSY1: counters / gauge reading engine

Spec §2.3-7: fast, accurate reading of analog dials/counters (closest analogue to an instrument scan); timing undocumented (assumed 10 items / 10 min).
- [ ] Generator: dial types (linear scale, circular gauge with sub-divisions, multi-needle, drum counter), random needle positions, questions "value?", "which gauge shows X?", "sum/difference of two gauges"; difficulty = sub-division density / needle count
- [ ] Renderer: `CustomPainter` gauges + keypad or MCQ
- [ ] Tests: value derivation from needle angle, determinism, SessionHost run
