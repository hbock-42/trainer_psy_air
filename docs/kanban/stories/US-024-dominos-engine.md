---
id: US-024
issue: 28
title: "Dominos engine"
type: story
epic: EPIC-03
status: backlog
priority: P0
size: M
lane: engines
depends_on: [US-020,US-003]
labels: [engine,generator,mvp]
---

# US-024 — Dominos engine

**As a** candidate **I want** to drill *Dominos* **so that** I recognise modulo-7 series patterns quickly.

Real test (spec §2.4-G): find the missing domino (two halves 0–6) in a series/arrangement; ~16–20 items, ~30 s each; present since 2024.

## Acceptance criteria
- [ ] Generator: linear series (+k mod 7), alternating series on top/bottom halves, mirrored, sums constant, spiral/grid arrangements; difficulty controls number of interleaved rules; deterministic per seed; the answer must be unique (solver check)
- [ ] Renderer: dominoes drawn with `CustomPainter` (pips), answer by picking top and bottom values 0–6 (two selectors) or from 6 candidate dominoes (MCQ mode); per-item timer
- [ ] Explanation names the rule(s) for practice mode
- [ ] Secondary (P2): alphanumeric logic series MCQ (dropped from the real test after 2023 but cheap)
- [ ] Unit tests on rule solvers and uniqueness
