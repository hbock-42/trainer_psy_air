---
id: US-114
issue: 171
title: "PSY1: angle estimation engine (Angles à saisir)"
type: story
epic: EPIC-10
status: review
priority: P2
size: S
lane: engines
depends_on: [US-101]
labels: [engine,generator,psy1]
---

# US-114 — PSY1: angle estimation engine (Angles à saisir)

Spec §2.3-5: among ~9 candidate angle values, select up to 4 correct ones (multi-select).
- [x] Generator: a drawn angle (or several) and 9 candidate values with ≤ 4 correct within tolerance; difficulty = tolerance/closeness of distractors
- [x] Renderer: `CustomPainter` angle + multi-select option tiles (reuse `arithmetic_grid`'s multi-select pattern)
- [x] Tests: correctness set, determinism, SessionHost run
