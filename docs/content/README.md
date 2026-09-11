# Content docs

Non-code documentation for the PSY trainer content: research, authoring rules, schemas.

| File | What it is | Owner story |
|---|---|---|
| [psy0-spec.md](psy0-spec.md) | Research on the real Air France Cadets selection and the PSY0 online pre-selection: stages, modality, the ~14 activities with formats/timings, proposed `psy0_full` / `psy0_short` blueprints, mapping to EPIC-03 families, open questions, sources, legal note and FR/EN app disclaimer. Every claim is tagged **[confirmed]** / **[reported]** / **[assumed]**. | US-080 |
| [AUTHORING.md](AUTHORING.md) | How to write an item, naming, difficulty scale, explanation rules, how to run the validator. | US-010 |
| [CONTRACT.md](CONTRACT.md) | The content data model shared by engines, UI, database and authors; Dart types. | US-010 |
| [`schema/*.schema.json`](schema/) | JSON Schemas (draft 2020-12) for the manifest, modules, families, item banks, lessons, decks, flashcards and blueprints. `tool/validate_content.dart` validates every content file against them. | US-010 / US-014 |

Conventions
- Dates are ISO (`2026-09-11`). Sources are listed with URL and access date.
- Anything that describes the real selection must carry a confidence tag (see the top of `psy0-spec.md`).
- Never paste real test items or third-party trainers' item sets into these docs; describe formats, not content.
