---
id: US-023
title: "Mental arithmetic generator"
type: story
epic: EPIC-03
status: backlog
priority: P0
size: M
lane: engines
depends_on: [US-020,US-022]
labels: [engine,generator]
---

# US-023 — Mental arithmetic generator

**As a** candidate **I want** unlimited mental-arithmetic drills **so that** I get faster and more accurate.

## Item types (parametrised by difficulty 1–5)
- Addition/subtraction (2–4 digits), multiplication (2×1, 2×2 digits), division with integer result
- Percentages, fractions → decimals, squares/roots of common values
- Aviation-flavoured: speed × time = distance, fuel burn, unit conversions (kt/km/h, ft/m, NM/km), time arithmetic (hh:mm)
- Rule-of-three / proportionality

## Acceptance criteria
- [ ] `MentalArithmeticGenerator implements ItemGenerator`, deterministic given a seed
- [ ] Difficulty controls operand size & operation mix; documented table
- [ ] Each item includes a short explanation (e.g. "27 × 4 = 27 × 2 × 2 = 108")
- [ ] Unit tests: distribution per difficulty, no division by zero, answers within `int`/2-decimals
