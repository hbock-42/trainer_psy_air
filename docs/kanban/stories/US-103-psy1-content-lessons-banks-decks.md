---
id: US-103
issue: 71
title: "PSY1 content: lessons, banks, decks"
type: story
epic: EPIC-10
status: done
priority: P2
size: L
lane: content
depends_on: [US-101]
labels: [content,psy1]
---

# US-103 — PSY1 content: lessons, banks, decks

- [x] Lessons (FR) per PSY1 activity + "how PSY1 day works" (schedule, hardware, scoring, red-zone rule), same structure as PSY0 lessons
- [x] Banks: ≥ 15 French reading passages × 3–5 MCQ; ≥ 150 EFG mixed reasoning MCQ (numeric/verbal/spatial/logic); ≥ 60 math word problems as bank items (complementing the generator)
- [x] Decks: mental-math shortcuts for word problems, gauge-reading reminders
- [x] Validator 0 errors; `contentVersion` bump

Delivered (also: p1_psychomotor deck for the red-zone rule/key layout, beyond the two decks named above):
- 14 lessons under `psy1/lessons/` (13 `p1_*` families + module-level `selection_day`).
- `p1_reading_fr/items/`: 16 passages, 64 MCQ. `p1_general_efficiency/items/`: 160 MCQ across `efg-001.json`/`efg-002.json` (tags `efg.numeric|verbal|spatial|logic`). `p1_math_word_problems/items/`: 65 numeric items.
- Decks: `p1_math_word_problems/decks/mental-shortcuts.json`, `p1_counters/decks/gauge-reading.json`, `p1_psychomotor/decks/red-zone-and-keys.json`.
- Two engine-author-flagged fixes: `psy1_full.json` gains a cube rotation-matching section (`p1_cube_nets`, `includeRotationMatching`, -0.25/wrong); `P1RavenMatricesParams.optionCount` default corrected 6 -> 8 to match the engine (schema + generated code + tests updated).
- `make content-check` 0 errors/0 warnings (115 files); `contentVersion` bumped 6 -> 7; `make lint`, `make test`, `make coverage`, `make build-web` all green.
