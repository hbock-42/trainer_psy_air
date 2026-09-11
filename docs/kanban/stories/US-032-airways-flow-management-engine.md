---
id: US-032
issue: 91
title: "Airways flow-management engine"
type: story
epic: EPIC-03
status: backlog
priority: P1
size: L
lane: engines
depends_on: [US-020,US-003]
labels: [engine,generator,simulation]
---

# US-032 — Airways flow-management engine

**As a** candidate **I want** to drill *Airways* **so that** I manage a dynamic scene with capacity rules.

Real test (spec §2.4-H): triangles ("aircraft") move along lines; colour buttons re-route aircraft; keep ≤ 4 aircraft and ≤ 2 blue in each grey zone while re-routing as few as possible; a violation = crash; 10 series (~5 min).

## Acceptance criteria
- [ ] Small deterministic simulation (tick-based, seeded): graph of routes, zones with capacity rules, aircraft spawn schedule; difficulty = spawn rate / graph complexity
- [ ] Renderer with `CustomPainter` + `Ticker`, route buttons, crash/violation feedback (live, as in the real test)
- [ ] Scorer: violations, re-routes used, series survived
- [ ] Unit tests on the simulation (rule violation detection, determinism)
