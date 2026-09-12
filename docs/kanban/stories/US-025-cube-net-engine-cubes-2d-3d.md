---
id: US-025
issue: 29
title: "Cube-net engine (Cubes 2D/3D)"
type: story
epic: EPIC-03
status: done
priority: P1
size: L
lane: engines
depends_on: [US-020,US-003]
labels: [engine,generator]
---

# US-025 — Cube-net engine (Cubes 2D/3D)

**As a** candidate **I want** to drill *Cubes / dés* **so that** I fold nets in my head faster.

Real test (spec §2.4-L): a reference cube net on the left; a second net with missing faces; drag the given faces (flippable by tapping) to rebuild the same cube; 4–10 items, ~60 s each.

## Acceptance criteria
- [x] Geometry core: cube model with 6 faces carrying oriented symbols/letters, the 11 net shapes, folding validity, face orientation after folding; unit-tested
- [x] Generator: reference net + target net with k missing faces, distractor faces (mirrored / rotated symbols); difficulty = number of missing faces + symbol asymmetry
- [x] Renderer: drag & drop faces into slots, tap to flip/rotate, "Valider"; vector rendering only
- [x] Practice mode shows the folded cube (isometric drawing) as explanation
- [x] Widget test for drag/drop with `WidgetTester.drag`
