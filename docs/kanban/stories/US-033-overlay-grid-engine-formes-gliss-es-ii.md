---
id: US-033
issue: 92
title: "Overlay-grid engine (Formes glissées II)"
type: story
epic: EPIC-03
status: done
priority: P1
size: L
lane: engines
depends_on: [US-020,US-003]
labels: [engine,generator]
---

# US-033 — Overlay-grid engine (Formes glissées II)

**As a** candidate **I want** to drill *Formes glissées* **so that** I predict the result of overlay rules on a grid.

Real test (spec §2.4-E): drag 3–4 tile-shapes onto a central grid so that, under the overlay rules (navy+navy=navy, navy+grey=grey, grey+grey=navy), it reproduces the target grid; auto-advance when solved; 5 boards (~60–90 s); version II has heavily overlapping shapes and black cells.

## Acceptance criteria
- [x] Core: grid model, tile shapes, overlay algebra, solver proving a unique placement; deterministic generator with difficulty = tiles count / overlap / black cells
- [x] Renderer: drag & drop tiles onto the grid with snapping, live overlay preview, auto-advance on match
- [x] Scorer: boards solved, time per board, moves
- [x] Unit tests on the overlay algebra and solver
