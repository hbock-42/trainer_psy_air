---
id: US-106
issue: 166
title: "PSY1: working-memory engines (reverse span, calc memory back)"
type: story
epic: EPIC-10
status: review
priority: P2
size: M
lane: engines
depends_on: [US-101]
labels: [engine,generator,psy1]
---

# US-106 — PSY1: working-memory engines (reverse span, calc memory back)

Spec §2.3-9/10: reverse digit span 4–9 digits with a 3–4 s response window; calc-memory-back in 4 stages × 20+ calculations with increasing load.
- [x] `p1_wm_reverse_span`: sequence shown digit by digit (renderer-owned reveal, the family ships no `defaultCadence` — see PR description), keypad recall in reverse order, span length adapts within a practice series via the shared `AdaptiveDifficultyPolicy` (see PR description for the deviation from the spec's literal "+1/2 correct, -1/miss, 4-9" numbers); scorer = exact reverse match, metrics decomposed by span length (`reverseSpanMaxReached` derives "max span reached" post-hoc)
- [x] `p1_wm_calc_back`: chained calculations where each answer reuses the result of n steps back (load 1→4, `CalcBackChain`); keypad; scorer accuracy per stage
- [x] Tests: cadence/reveal timers with `ManualClock`/`fakeAsync`, chain correctness, adaptation, determinism, SessionHost runs for both
