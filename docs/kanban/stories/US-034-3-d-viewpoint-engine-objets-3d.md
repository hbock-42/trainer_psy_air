---
id: US-034
issue: 93
title: "3-D viewpoint engine (Objets 3D)"
type: story
epic: EPIC-03
status: done
priority: P1
size: M
lane: engines
depends_on: [US-021,US-003]
labels: [engine,generator]
---

# US-034 — 3-D viewpoint engine (Objets 3D)

**As a** candidate **I want** to drill *Objets 3D* **so that** I identify from which of 8 viewpoints a scene is seen.

Real test (spec §2.4-K): a 3-D scene + 8 numbered viewpoints around a circle; click the right one; 10 items, ~10–15 s each.

## Acceptance criteria
- [x] Scene generator: 3–6 simple coloured solids (cubes, cylinders, cones) on a grid; deterministic per seed
- [x] Renderer: minimal 2.5-D / isometric projection with `CustomPainter` from any of the 8 azimuths (no 3D engine, no assets); MCQ of 8 numbered positions on a circle
- [x] Difficulty: object count, symmetric arrangements
- [x] Unit tests on the projection (left/right ordering from each azimuth)
