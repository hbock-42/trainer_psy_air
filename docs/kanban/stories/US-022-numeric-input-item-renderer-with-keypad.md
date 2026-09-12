---
id: US-022
issue: 26
title: "Numeric input item renderer with keypad"
type: story
epic: EPIC-03
status: done
priority: P0
size: S
lane: engines
depends_on: [US-020,US-003]
labels: [engine,ui]
---

# US-022 — Numeric input item renderer with keypad

**As a** user **I want** to type numeric answers fast on a custom keypad **so that** mental arithmetic feels like the real test.

## Acceptance criteria
- [x] On-screen keypad (0–9, `.`, `-`, backspace, validate), no system keyboard
- [x] Tolerance and unit support from `NumericItem`
- [x] Response time measured from item display to validate
- [x] Widget tests
