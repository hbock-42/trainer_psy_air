---
id: US-108
issue: 168
title: "PSY1: cube nets with rune alphabet + cube rotation matching"
type: story
epic: EPIC-10
status: backlog
priority: P2
size: M
lane: engines
depends_on: [US-101,US-025]
labels: [engine,generator,psy1]
---

# US-108 — PSY1: cube nets with rune alphabet + cube rotation matching

Spec §2.3-8: (a) net folding as PSY0 but with Latin or invented rune-like symbols; (b) rotation matching: reference cube, judge each candidate as same-object-rotated vs altered; ~25 items / 8–10 min, −0.25 per wrong.
- [ ] Extend the `spatial_cubes` geometry core with a symbol-set param (`latin` | `runes`, runes drawn as asymmetric glyphs) and register `p1_cube_nets`
- [ ] New `p1_cube_rotation` engine: candidates rendered isometrically from rotations/mirrors; yes/no answers; scoring policy from the blueprint
- [ ] Tests: rotation/mirror invariants, determinism, SessionHost runs
