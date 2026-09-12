---
id: US-021
issue: 25
title: "MCQ item renderer"
type: story
epic: EPIC-03
status: review
priority: P0
size: S
lane: engines
depends_on: [US-020,US-003]
labels: [engine,ui]
---

# US-021 — MCQ item renderer

**As a** user **I want** multiple-choice questions with text or image options **so that** English, knowledge, logic and verbal items can be displayed.

## Acceptance criteria
- [x] Stem (text/markdown + optional image), 2–6 options in a grid or list, single-select
- [x] Practice mode: shows correct/wrong state + explanation panel + "Next"
- [x] Exam mode: select then "Validate" (or auto-validate on timeout), no feedback
- [x] Keyboard/number-key support on desktop/web (1–6)
- [x] Widget tests for both modes
