---
name: author-content
description: Write or edit content bundle files (items, lessons, decks, lexical fields, blueprints) under apps/psy_trainer/assets/content — use for any content-authoring task.
---

# Author content

Content is JSON + Markdown validated by a script; no Flutter/Dart needed. Full data model:
`docs/content/CONTRACT.md`. Machine-readable rules: `packages/psy_content/schema/*.schema.json`.
Valid examples of every file kind: `apps/psy_trainer/assets/content/examples/` — copy one to
start.

**Legal**: never reproduce copyrighted test material (real Air France/ENAC/publisher items).
Write your own items in the same spirit; note the source in `meta.source`.

## Bundle layout

Paths below are relative to `apps/psy_trainer/`:

```
assets/content/
  manifest.json                 contentVersion, schemaVersion (2)
  psy0/
    module.json                 the stage, ordered familyIds
    lessons/<family or theme>/  module-level lessons (.json + .fr.md/.en.md)
    <family>/
      family.json                mandatory in every family folder listed in module.json
      items/<subtag>-<nnn>.json  <=100 items, all one family
      decks/<slug>.json          deck + its cards inline
      lessons/                   family-level lessons (alternative to module-level)
      media/                     SVG/PNG/audio, referenced module-relative
    verbal_boxes/lexical_fields/<slug>.json   French lexical fields (not items)
  psy1/ …
```

Rules: folder name = family `id` = `familyId` in every file of that folder. Every JSON file
starts with `"kind"`. New folder (family, `lessons/<family>/`, `items/`, `decks/`,
`lexical_fields/`, `media/`) -> run `make content-assets`
(`dart run tools/list_content_assets.dart --write`) to update the asset list in
`apps/psy_trainer/pubspec.yaml`, or `list_content_assets_test.dart` fails. Add
`"$schema": "../../../../../../packages/psy_content/schema/<kind>.schema.json"` at the top of
a new file for editor autocompletion.

## Ids

Pattern `^[a-z0-9_.-]+$`, 3-120 chars, globally unique, **permanent** (renaming orphans user
stats). Conventions: item `<family>.<subskill>.<nnnn>` (4-digit zero-padded); generated recipe
`<family>.<subskill>.gen.<nnnn>`; passage `<family>.reading.p<nnn>`; lexical field
`verbal_boxes.field.<slug>`; lesson `<family>.lesson.<nn>-<slug>`; deck `<family>.deck.<slug>`;
flashcard `<deckId>.<nnnn>`; blueprint `<module>.blueprint.<slug>`; blueprint section unique
inside its blueprint, `s<nn>-<slug>`.

## Writing an item

One item = one object in a bank file's `items[]`. Common fields: `id`, `type` (`mcq` |
`numeric` | `sequence` | `generated`), `version` (starts 1), `familyId`, `difficulty` (1-5),
`tags`, optional `lang`, `status` (`published` default, or `draft`), optional `meta`
(`author`, `source`, `sources[]` with `url`+`accessedOn`).

- **`mcq`**: `stem`, `options` (2-6), `correctIndex` (0-based), mandatory `explanation`.
  Exactly one unambiguously right option; distractors plausible, not silly. Reading
  comprehension: put text in the bank's `passages[]`, reference via `passageId` from 3-5
  items. Culture items with a perishable fact need `validAsOf` + `meta.sources[]`; `culture_aero`
  items may set `allowSkip: true`.
- **`numeric`**: `stem`, `expected`, `explanation`; optional `unit`, `inputFormat`
  (`integer`|`decimal`|`time`), `decimals`, `tolerance`. `inputFormat: time` -> `expected` in
  minutes. No tolerance = exact match after rounding.
- **`sequence`**: memory stimulus (`stimulusKind`, `stimulus[]`, `recallMode`,
  `presentationMs`, `gapMs`, optional `grid` for `gridCells`). Practice-only at PSY0.
- **`generated`**: `generatorId` + `seed` + optional typed `params`
  (`packages/psy_content/schema/generators.schema.json` — only that generator's keys are
  allowed; every omitted key takes the real-test default; `(generatorId, seed, params)` is
  always the same item; never put the answer in `params`). Use only to pin a specific item
  (worked examples, regression cases); everyday items come from the blueprint at runtime, not
  bank files. See `docs/content/AUTHORING.md` §3 for the full generator/param table.
- **`lexical_fields`**: separate file kind under `<module>/verbal_boxes/lexical_fields/`: `id`,
  `name`, `difficulty`, `tags`, 15-25 lowercase singular `words`, optional `traps` and
  `incompatibleWith` (fields that must never share a series).

## Difficulty (1-5)

Calibrate against the **real test**. 1 = warm-up (never in the full exam blueprint), 2 = easy
real-test (>90% correct), 3 = typical (needs the lesson's method), 4 = hard (two steps or a
trap), 5 = hardest expected (<=10% of the bank). Target bank distribution 10/25/35/20/10%.
See `docs/content/AUTHORING.md` §4 for the per-family calibration table.

## Explanations

Mandatory for `mcq`/`numeric`, optional for `sequence`, absent for `generated`. French
mandatory, English optional (app falls back to `fr`). Teach the method, not just the answer;
1-4 sentences; end with the shortcut to remember; never reveal generator internals or
reference item ids.

## Media

Relative to the module folder, in the family's `media/`: SVG preferred; PNG/JPEG only for
photos (<=1200px, <=200kB); audio `.m4a` mono <=60s. Every informative image needs `alt` (FR
mandatory). Prefer procedural generation by the engine over media for logic/spatial figures.

## Tags

Dotted, lowercase, hierarchical: first segment = family root, second = sub-skill (mandatory on
every item), third level optional/free. New second-level tags need a PR first — see the full
vocabulary table in `docs/content/AUTHORING.md` §7.

## Versions

- Entity `version` (item/lesson/deck/card/family/blueprint): bump when the entity's *meaning*
  changes (correct answer, option added/removed, a stem rewording); not for typos.
- `manifest.json`'s `contentVersion`: bump by 1 on **every** change under `assets/content/`
  that should reach users, set `updatedAt`, add a one-line `changelog` entry. Without the
  bump the app never re-seeds an installed device. One bump per PR; on a rebase conflict take
  the higher number + 1.
- `schemaVersion`: only when the Dart models change incompatibly (bump together with
  `CONTRACT.md` and the schemas, a separate kind of PR from ordinary authoring).

## Blueprints

Sections in real-test order; each names `familyId`, `itemCount`, `itemSelection` (`bank` with
filters, or `generated` with `generatorId` + difficulty range + typed `params`). Timing is any
combination of `sectionTimeSec`, `perItemTimeSec`, `cadence` (at least one required).
`scoringPolicy` defaults `{1,0,0}`; `liveFeedback`/`inputRequirement: keyboard` mirror the real
activity; `weight: 0` for practice-only sections. Every section carries `confidence`
(`confirmed`|`reported`|`assumed`).

## Validating

```sh
make content-check                      # whole assets/content bundle
make content-check PATHS=<file-or-dir>  # narrow to one folder/file
```

Runs JSON Schema, Dart-model parsing and semantic rules (unique ids, `correctIndex` range,
explanation presence, `fr` non-blank, grid cells inside bounds, blueprint sections naming real
families, changelog/`contentVersion` consistency...) and exits 1 on any error. CI runs it on
every PR. `--json` for a machine-readable report (add `--verbosity=error` to `dart run` first).
Full option list and sample output: `docs/content/AUTHORING.md` §9.
