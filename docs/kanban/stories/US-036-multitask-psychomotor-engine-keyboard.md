---
id: US-036
issue: 95
title: "Multitask psychomotor engine (keyboard)"
type: story
epic: EPIC-03
status: done
priority: P1
size: L
lane: engines
depends_on: [US-020,US-003,US-006]
labels: [engine,generator,keyboard,desktop]
---

# US-036 — Multitask psychomotor engine (keyboard)

**As a** candidate **I want** to rehearse the 5-minute multitask activity **so that** I can divide attention like on the real desktop app.

Real test (spec §2.4-M): hold the arrow key in the direction a circle moves (tracking); press SPACE when the shape inside the circle equals the reference shape; press F when the framed calculation is wrong; ~5 min continuous; erratic target.

## Acceptance criteria
- [x] Deterministic tick simulation: target trajectory (seeded noise), shape stream, calculation stream; difficulty = speed / event rates
- [x] Renderer with `Ticker` + `CustomPainter`, physical keyboard input via `Focus`/`KeyboardListener` on the widgets layer; **desktop/web only** in exam mode; touch adaptation (on-screen arrows/buttons) allowed in practice, labelled "non-representative"
- [x] Scorer: tracking error (RMS), hit/miss/false alarm for shapes and calculations
- [x] Unit tests on the simulation and scorer
