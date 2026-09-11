---
id: US-010
issue: 19
title: "Content domain model & JSON contract (sync point)"
type: story
epic: EPIC-02
status: review
priority: P0
size: M
lane: core
depends_on: [US-001]
labels: [domain,blocking]
---

# US-010 — Content domain model & JSON contract (sync point)

**As a** team **we want** one shared contract for content **so that** engines, learn UI and content authors can work in parallel.

This is the **synchronisation point** of the project: get it reviewed by everyone and merged early. Changes after that go through versioning.

## Model (proposal)
- `Module` (`psy0`, `psy1`, `psy2`) → `TestFamily` (id, name, description, defaultDuration, itemCount, engineType) → `Item`
- `Item` sealed class: `McqItem` (stem, options, correctIndex, explanation, media?), `NumericItem` (stem, expected, tolerance, unit?), `SequenceItem` (stimulus sequence, recall mode), `GeneratedItem` (generator id + seed + params — reproducible)
- `Lesson` (familyId, title, markdown body, order), `Flashcard` (front, back, deckId)
- `ExamBlueprint` (ordered `ExamSection`s: familyId, durationSec, itemCount, itemSelection: bank|generated)
- All entities carry `id` (uuid/slug), `version`, `difficulty` (1–5), `tags`
- `Locale`-aware text fields (`{ "fr": …, "en": … }`), FR mandatory

## Acceptance criteria
- [x] Dart models with freezed + json_serializable, round-trip tests
- [x] `docs/content/schema/*.schema.json` (JSON Schema) for items, lessons, flashcards, blueprints
- [x] `docs/content/AUTHORING.md`: how to write an item, naming, difficulty scale, explanation rules
- [x] Example content file per item type in `assets/content/examples/`
- [ ] Reviewed and approved by whoever takes EPIC-03, EPIC-04 and EPIC-08

## Progress
- Part 1 (JSON contract): `docs/content/CONTRACT.md`, `docs/content/schema/`, `docs/content/AUTHORING.md`, `assets/content/examples/` — examples validated with ajv (draft 2020-12).
- Part 2 (Dart models): `lib/core/content/` (freezed + json_serializable models, `ContentBundleParser`), `test/core/content/` round-trip tests over every example file plus negative cases — second PR on #19.
