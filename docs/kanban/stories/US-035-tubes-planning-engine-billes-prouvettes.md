---
id: US-035
issue: 94
title: "Tubes / planning engine (Billes, éprouvettes)"
type: story
epic: EPIC-03
status: review
priority: P1
size: M
lane: engines
depends_on: [US-022,US-003]
labels: [engine,generator]
---

# US-035 — Tubes / planning engine (Billes, éprouvettes)

**As a** candidate **I want** to drill *Billes* **so that** I compute minimal move counts (Tower-of-Hanoi family) mentally.

Real test (spec §2.4-B): three U-tubes (capacities 3/2/3) with coloured balls; enter the **minimum number of moves** from the start to the target configuration; ~10 items, ~40 s each.

## Acceptance criteria
- [x] Core: state model + BFS solver giving the optimal move count and one optimal sequence; generator picks start/target pairs with a chosen optimal distance (difficulty = distance); deterministic per seed
- [x] Renderer: two tube diagrams (start / target) with `CustomPainter`, numeric keypad answer (US-022); practice mode can replay the optimal sequence step by step
- [x] Unit tests on the solver
