---
id: US-106
issue: 166
title: "PSY1: working-memory engines (reverse span, calc memory back)"
type: story
epic: EPIC-10
status: backlog
priority: P2
size: M
lane: engines
depends_on: [US-101]
labels: [engine,generator,psy1]
---

# US-106 — PSY1: working-memory engines (reverse span, calc memory back)

Spec §2.3-9/10: reverse digit span 4–9 digits with a 3–4 s response window; calc-memory-back in 4 stages × 20+ calculations with increasing load.
- [ ] `p1_wm_reverse_span`: sequence shown digit by digit (cadence), keypad recall in reverse order, adaptive length within a series; scorer = max span + accuracy
- [ ] `p1_wm_calc_back`: chained calculations where each answer reuses the result of n steps back (load 1→4); keypad; scorer accuracy per stage
- [ ] Tests: cadence with `ManualClock`, chain correctness, SessionHost runs
