---
id: US-104
issue: 164
title: "PSY1: maths word-problem engine"
type: story
epic: EPIC-10
status: review
priority: P2
size: M
lane: engines
depends_on: [US-101]
labels: [engine,generator,psy1]
---

# US-104 — PSY1: maths word-problem engine

Spec §2.3-1: 30 multi-step arithmetic word problems in 35 min, MCQ or free numeric, scratch paper allowed.
- [x] Generator of templated FR word problems (speed/time/distance, fuel, proportions, percentages, unit conversions, averages, time zones) with numeric answers, difficulty 1–5 by steps/magnitudes; deterministic per seed
- [x] Renderer: stem + `NumericRenderer` keypad (reuse), optional MCQ mode; negative-marking policy from the blueprint
- [x] Tests: generator determinism/answer correctness by solving templates independently, SessionHost run
