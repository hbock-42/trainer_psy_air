---
id: US-015
issue: 89
title: "Content contract v2: interactive activities, cadence, scoring policy"
type: story
epic: EPIC-02
status: review
priority: P0
size: S
lane: core
depends_on: [US-010,US-080]
labels: [domain,blocking]
---

# US-015 — Content contract v2: interactive activities, cadence, scoring policy

**As a** team **we want** the JSON contract to express the real PSY0 activities **so that** engines and blueprints are reproducible and faithful.

From spec §4.3:
- [x] `GeneratedItem.generatorId` enum extended: `nback`, `stimulus_response`, `parity_sequence`, `overlay_grid`, `airways`, `word_boxes`, `arithmetic_grid`, `cube_net`, `viewpoint`, `tubes`, `dominos`, `multitask`; `params` documented per generator (JSON schema `$defs` per id)
- [x] `ExamSection`: `perItemTimeSec`, `sectionTimeSec`, `cadence {stimulusMs, answerWindowMs}`, `scoringPolicy {correct, wrong, skip}`, `liveFeedback`, `inputRequirement: touch|keyboard`, `confidence`
- [x] `TestFamily.engineType` aligned with the 14 family ids of EPIC-03; `Module psy0` family list updated
- [x] `McqItem.validAsOf` (date) and `meta.sources` for culture items; `LexicalField` entity for US-085
- [x] Schemas, examples, Dart models (freezed) and `docs/content/CONTRACT.md` updated together; `schemaVersion` bumped; all examples validate
