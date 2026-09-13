---
id: US-105
issue: 165
title: "PSY1: mental arithmetic engine with 4 answer modes"
type: story
epic: EPIC-10
status: done
priority: P2
size: M
lane: engines
depends_on: [US-101]
labels: [engine,generator,psy1]
---

# US-105 — PSY1: mental arithmetic engine with 4 answer modes

Spec §2.3-12: 4 series × 10 calculations; modes: free numeric, solve-for-x, smallest interval containing the value, all intervals containing it.
- [x] Generator shares the arithmetic core with `arithmetic_grid`; each mode is a params value; interval options generated with plausible overlaps
- [x] Renderers: keypad (free/x), single-select for smallest interval, multi-select for all intervals (reuse renderers)
- [x] Scorer per mode; tests per mode + SessionHost run
