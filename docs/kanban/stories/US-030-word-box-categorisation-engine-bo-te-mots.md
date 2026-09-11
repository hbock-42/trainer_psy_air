---
id: US-030
issue: 34
title: "Word-box categorisation engine (Boîte à mots)"
type: story
epic: EPIC-03
status: backlog
priority: P1
size: M
lane: engines
depends_on: [US-020,US-003]
labels: [engine,content-driven]
---

# US-030 — Word-box categorisation engine (Boîte à mots)

**As a** candidate **I want** to drill *Boîte à mots* **so that** I sort words into lexical fields fast.

Real test (spec §2.4-I): 4–6 empty boxes; words appear one at a time; click the box whose lexical field matches — the first word of a field claims a free box; timed per word; 4–5 series.

## Acceptance criteria
- [ ] Series builder: picks k lexical fields from the bank (US-085), interleaves ~20 words with deliberate near-miss traps; deterministic per seed
- [ ] Renderer: boxes that get labelled by their first word, word stream with per-word timer, tap/keyboard 1–6 input
- [ ] Scorer: errors, mean RT; practice mode explains the field of a missed word
- [ ] Unit tests on series building (no ambiguous word across the chosen fields)
Content: US-085.
