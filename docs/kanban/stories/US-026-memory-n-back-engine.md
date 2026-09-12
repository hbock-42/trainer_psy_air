---
id: US-026
issue: 30
title: "Memory N-back engine"
type: story
epic: EPIC-03
status: done
priority: P0
size: M
lane: engines
depends_on: [US-020,US-003]
labels: [engine,generator,mvp]
---

# US-026 — Memory N-back engine

**As a** candidate **I want** to drill the *N-back* activity **so that** my working memory keeps up with the real cadence.

Real test (spec §2.4-A): stimulus (colour, previously digit) shown ~1 s; answer Yes/No whether it equals the one shown 2 (or 3) steps earlier; 1.5 s answer window; missing answer = error; 42 stimuli including 2 primers (~1 min 45 s).

## Acceptance criteria
- [x] Generator: sequence of 42 stimuli from a palette (3 of 7 colours by default; digits option), n = 2 or 3, controlled proportion of targets (~30 %) and of lures (n±1 matches) by difficulty; deterministic per seed (see PR report: `n`/ratios come from `NbackParams`, not from `difficulty` — the blueprint pins `difficulty` to a constant 3, so "by difficulty" isn't exercised today; a second blueprint section with `n: 3` would give the sometimes-3-back variant)
- [x] Renderer driven by the runtime's fixed cadence: big colour patch / digit, Yes/No buttons **and** keyboard keys; no per-item feedback in exam mode
- [x] Scorer: hits, misses, false alarms, timeouts → accuracy and d′-like sensitivity for analytics
- [x] Practice options: slower cadence (via `TimingPolicy.forPractice`/practice config, already supported by the runtime), show the n-back history strip as a learning aid
- [x] Colour-blind-safe palette option (spec open question 10)
- [x] Unit tests: target proportion, cadence timing with `ManualClock` (the runtime uses its own `EngineClock`, not `fake_async`, for this), scoring
