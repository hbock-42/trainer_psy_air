---
id: US-108
issue: 168
title: "PSY1: cube nets with rune alphabet + cube rotation matching"
type: story
epic: EPIC-10
status: done
priority: P2
size: M
lane: engines
depends_on: [US-101,US-025]
labels: [engine,generator,psy1]
---

# US-108 — PSY1: cube nets with rune alphabet + cube rotation matching

Spec §2.3-8: (a) net folding as PSY0 but with Latin or invented rune-like symbols; (b) rotation matching: reference cube, judge each candidate as same-object-rotated vs altered; ~25 items / 8–10 min, −0.25 per wrong.
- [x] Extend the `spatial_cubes` geometry core with a symbol-set param (`latin` | `runes`, runes drawn as asymmetric glyphs) and register `p1_cube_nets`
- [x] Rotation matching implemented as a `p1_cube_nets` mode (no separate `p1_cube_rotation` generator/family exists in the contract -- `P1CubeNetsParams.includeRotationMatching` already models it; see PR description): candidates rendered isometrically from rotations/mirrors; yes/no answers per candidate; scoring policy (`-0.25`/wrong) applied by the runtime from the blueprint, not by the engine
- [x] Tests: rotation/mirror invariants (24 orientations, mirror ≠ rotation), rune glyph orientation/mirror distinctness, determinism, SessionHost runs for both modes; PSY0 `spatial_cubes` tests untouched and green
