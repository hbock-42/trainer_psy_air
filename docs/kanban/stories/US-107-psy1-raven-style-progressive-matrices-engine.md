---
id: US-107
issue: 167
title: "PSY1: Raven-style progressive matrices engine"
type: story
epic: EPIC-10
status: done
priority: P2
size: L
lane: engines
depends_on: [US-101]
labels: [engine,generator,psy1]
---

# US-107 — PSY1: Raven-style progressive matrices engine

Spec §2.3-11: 30 items / 30 min, classic 3×3 matrix with 6–8 candidate tiles.
- [x] Procedural matrix generator (rules on shape, count, rotation, fill, position, XOR/overlay across rows/columns; 1–3 rules by difficulty), distractors violating exactly one rule, solver proving uniqueness; drawn with `CustomPainter` (no assets)
- [x] Renderer: matrix + tile grid, tap/keyboard 1–8; practice explanation names the rules
- [x] Tests: uniqueness over many seeds, determinism, SessionHost run
