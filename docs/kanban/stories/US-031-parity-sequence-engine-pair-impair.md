---
id: US-031
issue: 90
title: "Parity-sequence engine (Pair / impair)"
type: story
epic: EPIC-03
status: done
priority: P0
size: M
lane: engines
depends_on: [US-020,US-003]
labels: [engine,generator,mvp]
---

# US-031 — Parity-sequence engine (Pair / impair)

**As a** candidate **I want** to drill *Pair / impair* **so that** I follow an alternating rule under time pressure and recover from errors.

Real test (spec §2.4-D): a cloud of numbers; from START, click alternately an even then an odd number, each category in ascending order; an error restarts the series; START and END labelled; 5 series (~60 s each).

## Acceptance criteria
- [x] Generator: 12–20 numbers scattered without overlap, unique valid path; difficulty = count, number range, visual density; deterministic per seed
- [x] Renderer: tappable number bubbles, restart-on-error behaviour (kept in exam mode — it is how the real test works), series timer
- [x] Scorer: series completed, restarts, total time
- [x] Unit tests: path uniqueness, layout non-overlap
