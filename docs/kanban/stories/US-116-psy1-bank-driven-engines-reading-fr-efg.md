---
id: US-116
issue: 173
title: "PSY1: bank-driven engines (reading FR, EFG)"
type: story
epic: EPIC-10
status: done
priority: P2
size: S
lane: engines
depends_on: [US-101,US-103]
labels: [engine,content-driven,psy1]
---

# US-116 — PSY1: bank-driven engines (reading FR, EFG)

Spec §2.3-4/6: French reading comprehension (10 texts / 20 min) and EFG mixed reasoning (35 q / 30 min), both MCQ banks.
- [x] `p1_reading_fr`: `McqRenderer` with the passage resolver (reuse US-027's passage plumbing and passage-aware sampler)
- [x] `p1_general_efficiency`: `McqRenderer`, tag-balanced sampling
- [x] Tests: registration, sampling, SessionHost runs

**Deviation, flagged not fixed (non-negotiable #8):** both families' `family.json`
(`assets/content/psy1/p1_reading_fr/`, `.../p1_general_efficiency/`) still set
`generatorId` to their own id, and `blueprints/psy1_full.json`'s `s04-reading`/
`s06-efg` sections still use `itemSelection.mode: "generated"` — a leftover from
before this story descoped both to bank-only. As authored, `TestFamily
.generatorId != null` makes the practice launcher build an `ItemSource.adaptive`
for `GeneratorId.p1ReadingFr`/`p1GeneralEfficiency`, which no engine registers
(these two deliberately don't, being bank-only like `english`/`culture_aero`), so
`EngineRegistry.byGenerator` throws `EngineNotFoundError` the moment either
family runs through the standard launcher or the full PSY1 exam blueprint. Content
fix needed: null out `generatorId` in both `family.json` files and switch both
blueprint sections' `itemSelection.mode` to `bank` (see `culture_aero`/`english`
for the shape) — left untouched here per the "never edit the content contract to
fix a default" rule; see the engine files' doc comments and the PR description.

`p1_math_word_problems` was checked per the brief: its `family.json` also sets
`generatorId: "p1_math_word_problems"` and its own blueprint section is
`"generated"` too, so it is (as far as this story's checks can tell)
generated-only by the content contract, same as `p1_reading_fr`/
`p1_general_efficiency` above — its US-103 bank items are not wired as a
practice source here; no engine work for it was in this story's scope beyond
that check.
