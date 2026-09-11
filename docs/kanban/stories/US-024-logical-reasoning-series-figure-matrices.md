---
id: US-024
issue: 28
title: "Logical reasoning: series & figure matrices"
type: story
epic: EPIC-03
status: backlog
priority: P0
size: M
lane: engines
depends_on: [US-020,US-021]
labels: [engine,generator]
---

# US-024 — Logical reasoning: series & figure matrices

**As a** candidate **I want** number/letter series and figure-matrix puzzles **so that** I can train abstract reasoning.

## Acceptance criteria
- [ ] Series generator: arithmetic, geometric, alternating, two-step, Fibonacci-like, letter series; MCQ or numeric answer
- [ ] Figure matrices (3×3, "find the missing cell") rendered procedurally with `CustomPainter` from a rule set (shape, count, rotation, fill, position) — no image assets needed
- [ ] Distractor generation that is plausible (violates exactly one rule)
- [ ] Explanation names the rule(s)
- [ ] Unit tests on rule solvers (exactly one correct option)
