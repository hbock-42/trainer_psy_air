---
id: US-026
issue: 30
title: "Memory N-back engine"
type: story
epic: EPIC-03
status: backlog
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
- [ ] Generator: sequence of 42 stimuli from a palette (3 of 7 colours by default; digits option), n = 2 or 3, controlled proportion of targets (~30 %) and of lures (n±1 matches) by difficulty; deterministic per seed
- [ ] Renderer driven by the runtime's fixed cadence: big colour patch / digit, Yes/No buttons **and** keyboard keys; no per-item feedback in exam mode
- [ ] Scorer: hits, misses, false alarms, timeouts → accuracy and d′-like sensitivity for analytics
- [ ] Practice options: slower cadence, show the n-back history strip as a learning aid
- [ ] Colour-blind-safe palette option (spec open question 10)
- [ ] Unit tests: target proportion, cadence timing with `fake_async`, scoring
