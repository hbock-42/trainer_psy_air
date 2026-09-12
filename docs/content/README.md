# Content docs

Non-code documentation for the PSY trainer content: research, authoring rules, schemas.

| File | What it is | Owner story |
|---|---|---|
| [psy0-spec.md](psy0-spec.md) | Research on the real Air France Cadets selection and the PSY0 online pre-selection: stages, modality, the ~14 activities with formats/timings, proposed `psy0_full` / `psy0_short` blueprints, mapping to EPIC-03 families, open questions, sources, legal note and FR/EN app disclaimer. Every claim is tagged **[confirmed]** / **[reported]** / **[assumed]**. | US-080 |
| [psy2-spec.md](psy2-spec.md) | Research on the PSY2 final selection stage (Roissy-CDG): personality inventories, group exercise (type and CRM criteria only — no NDA content reproduced), individual interview themes, commission de recrutement / ajournement rules, app scope for US-111 (interview question bank by theme + self-recording) and US-112 (CRM behaviour rubric + group-exercise self-assessment), open questions, sources, legal/ethics note. Same confidence-tag convention as psy0-spec.md. | US-110 |
| [AUTHORING.md](AUTHORING.md) | How to write an item, naming, difficulty scale, explanation rules, how to run the validator. | US-010 |
| [CONTRACT.md](CONTRACT.md) | The content data model (v2) shared by engines, UI, database and authors: the 14 PSY0 activity families, typed generator params, cadence / scoring policy, lexical fields; Dart types; v1 → v2 diff. | US-010 / US-015 |
| [`../../packages/psy_content/schema/*.schema.json`](../../packages/psy_content/schema/) | JSON Schemas (draft 2020-12) for the manifest, modules, families, item banks, generators (typed params), lexical fields, lessons, decks, flashcards and blueprints. Moved from `docs/content/schema/` to `packages/psy_content/schema/` in US-007; see the pointer in [`schema/README.md`](schema/README.md). `psy_content:validate_content` validates every content file against them. | US-010 / US-014 / US-015 / US-007 |

Conventions
- Dates are ISO (`2026-09-11`). Sources are listed with URL and access date.
- Anything that describes the real selection must carry a confidence tag (see the top of `psy0-spec.md`).
- Never paste real test items or third-party trainers' item sets into these docs; describe formats, not content.
