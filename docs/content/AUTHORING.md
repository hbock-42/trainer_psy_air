# Content authoring guide

How to write items, lessons, flashcards and exam blueprints for the PSY trainer.
You do not need Flutter or Dart: content is JSON + Markdown validated by a script.
The data model itself is described in [CONTRACT.md](CONTRACT.md); the machine-readable
rules are the JSON Schemas in [`packages/psy_content/schema/`](../../packages/psy_content/schema/)
(US-007 moved them out of `docs/`). Valid examples of every file type live in
[`apps/psy_trainer/assets/content/examples/`](../../apps/psy_trainer/assets/content/examples/) — copy one to start.

Legal reminder: the app is an unofficial trainer. **Never reproduce copyrighted test
material** (real Air France / ENAC / publisher items). Write your own items in the same
spirit; note your source in `meta.source`.

This is human-facing reference. The condensed procedure an agent needs while authoring content
is the `author-content` skill (`.agents/skills/author-content/SKILL.md`).

## 1. Where files go (content bundle layout)

The bundle lives inside the app package (`apps/psy_trainer/`, US-007: Flutter needs its
assets in the declaring package). Paths below are relative to `apps/psy_trainer/`.

```
assets/content/
  manifest.json                     # contentVersion, schemaVersion (2)  (manifest.schema.json)
  psy0/
    module.json                     # the stage, ordered familyIds   (family.schema.json#/$defs/Module)
    lessons/                        # lessons grouped by family or theme (US-081 layout)
      selection_process/
        01-comment-fonctionne-la-selection.json
        01-comment-fonctionne-la-selection.fr.md
      memory_nback/
        01-n-back.json              # familyId memory_nback, id lesson.memory_nback.01
        01-n-back.fr.md
    blueprints/
      psy0_full.json                # (blueprint.schema.json) — spec §3.1
      psy0_short.json               # spec §3.2
    english/                        # one folder per family, folder name == family id
      family.json                   # (family.schema.json) — engineType english_reading
      items/
        reading-001.json            # ≤ 100 items per file           (bank.schema.json)
        reading-002.json            # bank files may hold passages
        grammar-001.json
      decks/
        aviation-vocab.json         # deck + its cards               (deck.schema.json)
      media/
        runway-signs.svg
    culture_aero/
      family.json
      items/
        flight_mechanics-001.json
        …
    verbal_boxes/
      family.json
      lexical_fields/
        everyday-001.json           # French lexical fields          (lexical_fields.schema.json)
    memory_nback/
      family.json
      items/
        worked-examples.json        # generated recipes pinned by seed
    attention_rules/ … spatial_cubes/ … multitask_psychomotor/ …   # one folder per family (16 in PSY0)
  psy1/ …
```

Rules:

- Folder name = family `id` = `familyId` inside every file of the folder; `family.json` is
  mandatory in every family folder listed in `module.json` (the validator checks both
  directions). PSY0 families: the 14 activities of EPIC-03 — with the English test as one
  `english` family (engineType `english_reading`; grammar/vocab drills live in the same bank)
  — plus `english_listening` and `english_speaking` (2026 format, still empty).
- Lessons may live inside their family folder (`<family>/lessons/`) or under the module's
  `lessons/<family>/` folder; in both cases they carry `familyId`.
- Media paths in JSON are **relative to the module folder**: `english/media/runway-signs.svg`.
- Bank files: at most **100 items**, all of the same family. Name them
  `<subtag>-<nnn>.json` and start a new file when one is full. Files are seeded in
  alphabetical order, which only matters for items sharing a `passageId` (kept in file order).
- Every JSON file starts with `"kind"` so the validator and the seeder know what it is.
- **New folder = pubspec entry.** Flutter bundles assets per folder, so after creating a family
  folder, a `lessons/<family>/` folder or an `items/`, `decks/`, `lexical_fields/` or `media/`
  subfolder, run `make content-assets` (`dart run tools/list_content_assets.dart --write`,
  from the repo root) to update the list in `apps/psy_trainer/pubspec.yaml`
  (`tools/test/list_content_assets_test.dart` fails otherwise; the seeder reports
  a declared module or a lesson `.md` file it cannot find with a hint to that command).
- Add `"$schema": "../../../../../../packages/psy_content/schema/<kind>.schema.json"` at the top to get
  editor autocompletion (VS Code understands it). It is ignored by the app.

## 2. Ids

Pattern `^[a-z0-9_.-]+$`, 3–120 chars, **globally unique across every kind of entity**.
Ids are permanent: renaming an id orphans user statistics (`item_stats`, `attempts`).

| Entity | Convention | Example |
|---|---|---|
| Module | fixed | `psy0`, `psy1`, `psy2` |
| Family | the activity id of EPIC-03, `_` allowed, no dot | `memory_nback`, `planning_tubes`, `attention_rules`, `attention_parity`, `spatial_overlay`, `logic_dominos`, `attention_airways`, `verbal_boxes`, `arithmetic_grid`, `spatial_viewpoint`, `spatial_cubes`, `culture_aero`, `multitask_psychomotor`, `english`, `english_listening`, `english_speaking` |
| Item (bank) | `<family>.<subskill>.<nnnn>` (4-digit, zero-padded, never reused) | `culture_aero.meteorology.0042` |
| Item (generated recipe) | `<family>.<subskill>.gen.<nnnn>` | `memory_nback.colour.gen.0001` |
| Passage | `<family>.reading.p<nnn>` | `english.reading.p001` |
| Lexical field | `verbal_boxes.field.<slug>` | `verbal_boxes.field.cuisine` |
| Lesson | `<family>.lesson.<nn>-<slug>` (module-level: `<module>.lesson.<nn>-<slug>`) | `arithmetic_grid.lesson.03-speed-time-distance` |
| Deck | `<family>.deck.<slug>` | `arithmetic_grid.deck.aviation-conversions` |
| Flashcard | `<deckId>.<nnnn>` | `arithmetic_grid.deck.aviation-conversions.0001` |
| Blueprint | `<module>.blueprint.<slug>` | `psy0.blueprint.full` |
| Blueprint section | unique inside its blueprint: `s<nn>-<slug>` | `s12-culture` |

Items materialised by a generator at runtime get `gen.<generatorId>.<seed>` ids; you never
write those.

## 3. Writing an item

One item = one JSON object inside a bank file's `items` array. Common fields:

```jsonc
{
  "id": "english.grammar.0001",
  "type": "mcq",                 // mcq | numeric | sequence | generated
  "version": 1,                  // bump when the meaning changes (see §8)
  "familyId": "english",
  "difficulty": 2,               // 1–5, see §4
  "tags": ["english.grammar", "english.grammar.tenses"],   // see §7
  "lang": "en",                  // language of the stimulus, optional (defaults to the family's)
  "status": "published",         // optional; "draft" = validated but not shipped
  "meta": {                      // optional, never shown
    "author": "…",
    "source": "own",
    "sources": [{ "title": "…", "url": "https://…", "accessedOn": "2026-09-11" }]   // v2, dated references
  }
  // + type-specific fields below
}
```

### `mcq` — multiple choice

- `stem` (LocalizedText), `options` (2–6, each with `text` and/or `media`), `correctIndex`
  (0-based), `explanation` (mandatory), optional `media`, `passageId`, `shuffleOptions`,
  `allowSkip`, `validAsOf`.
- Exactly **one** option is right and it must be *unambiguously* right. Distractors must be
  plausible (a common mistake each), never silly.
- Keep options homogeneous (same grammatical form, same length order of magnitude).
- Set `shuffleOptions: false` only when order carries meaning ("none of the above",
  sorted numbers).
- Reading comprehension: put the text in the bank file's `passages` array and reference it
  from 3–5 items via `passageId`. Passage 80–250 words for PSY0 English.
- **Culture items** (`culture_aero`): `allowSkip: true` lets the realism option offer
  "Je ne sais pas" (scored with the section's `scoringPolicy.skip`). Any **perishable fact**
  (fleet size, CEO, routes, figures, "latest" anything) must carry `validAsOf` (the date you
  checked it) and at least one `meta.sources[]` entry with `url` and `accessedOn`; the app
  shows the date next to the explanation. Timeless facts (physics, history) need neither.

### `numeric` — typed answer on the keypad

- `stem`, `expected` (number), `explanation`; optional `unit` (`kt`, `NM`, `ft`, `m`,
  `km/h`, `kg`, `L`, `min`, `%`…), `inputFormat` (`integer` | `decimal` (default) | `time`),
  `decimals` (default 2), `tolerance` (`{"mode":"absolute"|"relative","value":…}`).
- No tolerance = exact match after rounding to `decimals`. Use a tolerance only when the
  question is an estimate by nature (unit conversions with rounded factors); say so in the stem
  ("≈") and in the explanation.
- `inputFormat: "time"`: `expected` is in **minutes** (17:25 → 1045); the keypad shows hh:mm.
- Prefer integer results for difficulty ≤ 3.

### `sequence` — memory stimulus

- `stimulusKind` (`digits` | `letters` | `symbols` | `colors` | `gridCells`), `stimulus`
  (array of strings), `recallMode` (`forward` | `backward` | `anyOrder`), optional
  `presentationMs` (default 1000), `gapMs` (default 250), `instructions`, `grid`
  (required for `gridCells`, cells written `"row,col"` zero-based), `explanation` (optional
  here: a chunking tip).
- Symbols: `circle square triangle star cross diamond`. Colors:
  `red blue green yellow orange purple`.
- Practice-only at PSY0 (the real memory activity is the N-back, see `generated`). Digit-span difficulty roughly follows length: 3–4 → 1, 5 → 2, 6 → 3, 7 → 4, 8+ → 5
  (backward: one level higher for the same length).

### `generated` — reproducible recipe

- `generatorId` (one of the 12 generators below), `seed` (integer), optional `params`.
- Use it to pin a **specific** generated item: worked examples in lessons, regression cases,
  calibration sets (US-086). Everyday practice/exam items are generated on the fly from the
  blueprint or the family defaults, not from bank files.
- `difficulty` is the level you *expect*; the validator (later) checks the generator agrees.
- `params` is **typed per generator** (`packages/psy_content/schema/generators.schema.json`): only the
  keys of that generator are allowed, and every key you omit takes the **real-test default**
  below, so `"params": {}` (or no `params` at all) is the real test. Same
  `(generatorId, seed, params)` ⇒ same item, always. Never put the answer in `params`.

| `generatorId` | Family | Params (real-test default) — see spec §2.4 |
|---|---|---|
| `nback` | `memory_nback` | `n` 2 · `stimulusKind` colour \| digit \| letter · `paletteSize` 3 · `count` 42 · `primers` 2 · `stimulusMs` 1000 · `answerWindowMs` 1500 · `targetRatio` 0.3 · `lureRatio` 0.1 |
| `tubes` | `planning_tubes` | `capacities` [3,2,3] · `colourCount` 3 · `ballCount` 5 · `minMoves` 2 · `maxMoves` 8 |
| `stimulus_response` | `attention_rules` | `count` 36 · `stimulusMs` 500 · `answerWindowMs` 3000 · `keys` ["n","x"] · `shapes` [square,triangle] · `colours` [blue,orange] · `ruleDepth` 2 |
| `parity_sequence` | `attention_parity` | `numberCount` 16 · `numberMin` 1 · `numberMax` 99 · `restartOnError` true · `labelEnds` true |
| `overlay_grid` | `spatial_overlay` | `grid` {5,5} · `tileCount` 3 · `overlapping` true · `blackCells` true |
| `dominos` | `logic_dominos` | `length` 6 · `layout` row \| grid \| spiral · `ruleCount` 1 · `answerMode` pick \| mcq |
| `airways` | `attention_airways` | `capacity` 4 · `blueCapacity` 2 · `zoneCount` 2 · `routeCount` 3 · `spawnIntervalMs` 2500 · `durationSec` 30 |
| `word_boxes` | `verbal_boxes` | `boxCount` 5 · `wordCount` 20 · `fieldIds` (optional pin) · `trapRatio` 0.1 · `wordTimeMs` 3000 |
| `arithmetic_grid` | `arithmetic_grid` | `grid` {3,3} · `wrongMin` 0 · `wrongMax` 4 · `operations` [add,sub,mul,div,square,priority] (+ percent) · `maxOperand` 100 |
| `viewpoint` | `spatial_viewpoint` | `viewpointCount` 8 · `objectCount` 4 · `objectKinds` [cube,cylinder,cone] (+ sphere, pyramid) · `allowSymmetric` false |
| `cube_net` | `spatial_cubes` | `missingFaces` 2 · `distractorFaces` 2 · `symbolKind` letters \| shapes \| mixed · `flippable` true |
| `multitask` | `multitask_psychomotor` | `durationSec` 300 · `trackingSpeed` 1 · `trackingNoise` 1 · `shapeIntervalMs` 2000 · `calcIntervalMs` 4000 · `shapeTargetRatio` 0.3 · `calcWrongRatio` 0.4 · `shapeKey` space · `calcKey` f |

Values tagged **[assumed]** in the spec (tube counts, domino counts, grid size of the overlay
board, airways spawn rate…) are our estimates — change them in the blueprint, not in the
generator, when the research is refined.

### `lexical_fields` — French lexical fields for *Boîte à mots* (US-085)

Not an item: a separate file kind under `verbal_boxes/lexical_fields/`. Each field has an
`id` (`verbal_boxes.field.<slug>`), `name` (shown only in explanations — in the real test a
box is labelled by its first word), `difficulty`, `tags`, 15–25 `words` (lowercase,
singular, no article, unambiguous), optional `traps` (`{ "word", "trapFor": "<fieldId>" }`:
words that *do* belong to this field but that a hurried candidate would file under
`trapFor`) and `incompatibleWith` (fields that must never share a series because some
words fit both). A word must belong to exactly one field among any set the generator may
mix; the validator (US-014) checks it. See `assets/content/examples/lexical_fields.example.json`.

The bank at `psy0/verbal_boxes/lexical_fields/core.json` (US-085, 45 fields) marks a pair
`incompatibleWith` whenever a word would genuinely fit both (e.g. `fruits` ↔ `legumes` over
`tomate`/`olive`/`pomme de terre`, `couleurs` ↔ `fruits`/`fleurs`/`animaux_marins` over
`orange`/`rose`/`corail`, `formes` ↔ `mathematiques` over `angle`/`axe`/`carré`). The schema
has no separate "hard pair" flag to *allow* two overlapping fields into the same series at
high difficulty, so every genuine overlap is blocked via `incompatibleWith` regardless of
difficulty; fields on the harder side of a pair (e.g. `mathematiques` at difficulty 5) carry
a `meta.notes` explaining the trade-off. If a future story wants a deliberately ambiguous
"hard series" mode, it should add a dedicated field (e.g. `hardPairWith`) rather than reuse
`incompatibleWith` for the opposite meaning.

## 4. Difficulty scale

Calibrate against the **real test**, not against a beginner. The app's adaptive mode (US-053)
moves users between levels, so the scale must be consistent across a family.

| Level | Meaning | Arithmetic grid | Culture aéro / English | Dominos | N-back |
|---|---|---|---|---|---|
| **1** | Warm-up. Anyone with a bac gets it in a few seconds. Never appears in the full exam blueprint. | one wrong cell, `48 + 27`, `6 × 7` | "What does ATC stand for?" / present simple, basic vocab (*runway*) | `+1` series | 1-back, 2 colours |
| **2** | Easy real-test item. Correct > 90 % of the time when not rushed. | 0–2 wrong cells, `340 × 3`, `12²` | BIA basics (four forces, ICAO codes of major hubs) / past simple vs present perfect | `+k` mod 7 on both halves | 2-back, 3 colours, no lures |
| **3** | Typical real-test item. Needs the method from the lesson; ~10–20 s. | 2–3 wrong cells, priorities `3 + 4 × 5`, simple divisions | PPL-level physics/nav (stall speed vs load factor, 240 kt for 15 min) / inference on a passage | alternating rules top/bottom | 2-back, 3 colours, 10 % lures |
| **4** | Hard real-test item. Two steps or a trap; a good candidate hesitates. | 3–4 wrong cells with ±1 / sign traps | dated company facts (fleet, leaders, routes) with `validAsOf` / dense passage, chart reading | two interleaved rules, spiral layout | 3-back digits |
| **5** | Hardest expected; discriminates the top. Rare in the bank (≤ 10 %). | 4 wrong cells, squares + priorities mixed | very specific trivia (a runway count, a quote) / subtle register, collocations | three rules, mirrored halves | 3-back, 4+ stimuli, lures |

Target distribution per family bank: 10 % / 25 % / 35 % / 20 % / 10 %.

## 5. Explanations

An explanation is **mandatory** for `mcq` and `numeric`, optional for `sequence` (a memory
tip) and absent for `generated` (the generator writes it).

1. **French is mandatory, English optional.** The `fr` text is what a French-UI user sees; add
   `en` when you can, the app falls back to `fr` otherwise.
2. **Teach the method, not just the answer.** Bad: « La réponse est C. » Good: « Deux actions
   passées, l'une avant l'autre → past perfect. Repère : *by the time* + prétérit. »
3. Start with the reasoning, end with the shortcut/reflex the candidate should remember.
4. For MCQ, say in one clause why the main distractor is wrong when it is a classic trap.
5. 1–4 sentences. Markdown allowed: `**bold**` for the key idea, `$…$` for inline formulas.
6. Never reveal generator internals or reference item ids in explanations.

## 6. Media

- Path relative to the module folder, in the family's `media/` folder:
  `spatial_cubes/media/net-0001.svg`.
- **Vector (SVG) preferred** for figures, diagrams, instruments. PNG/JPEG only for
  photographs, max 1 200 px on the long side, ≤ 200 kB. Audio: `.m4a` (AAC), mono, ≤ 60 s.
- Every informative image carries `alt` (FR mandatory).
- Logic/spatial figures should be **generated procedurally** by the engine whenever possible
  (US-024/025); use media only for hand-authored one-offs.
- File names: lowercase, `-` separator, same numbering as the item when tied to one item.

## 7. Tag vocabulary

Tags are dotted, lowercase, hierarchical. The **first segment is the family root**, the second
is the sub-skill, a third level is optional and free (keep it consistent within a family).
Every item carries at least its second-level tag. Add new second-level tags here (PR) before
using them; third-level tags are free.

| Family (`familyId`) | Root | Second level |
|---|---|---|
| `memory_nback` | `memory` | `memory.n_back` (`.colour`, `.digit`, `.letter`), `memory.span` (`.forward`, `.backward`, practice only), `memory.pattern` (practice only) |
| `planning_tubes` | `planning` | `planning.tubes` (`.two_colours`, `.three_colours`), `planning.hanoi` |
| `attention_rules` | `attention` | `attention.rules` (`.shape`, `.colour`, `.fill`, `.two_level`) |
| `attention_parity` | `attention` | `attention.parity` (`.dense`, `.wide_range`) |
| `attention_airways` | `attention` | `attention.airways` (`.capacity`, `.colour_rule`) |
| `spatial_overlay` | `spatial` | `spatial.overlay` (`.v1`, `.v2`, `.black_cells`) |
| `spatial_viewpoint` | `spatial` | `spatial.viewpoint` (`.azimuth`, `.symmetry`) |
| `spatial_cubes` | `spatial` | `spatial.cube_net` (`.letters`, `.shapes`, `.flip`), `spatial.cube_rotation` |
| `logic_dominos` | `logic` | `logic.dominos` (`.linear`, `.alternating`, `.mirror`, `.sum`, `.spiral`), `logic.series` (secondary drill: `.arithmetic`, `.alternating`, `.letters`) |
| `verbal_boxes` | `verbal` | `verbal.boxes` (`.everyday`, `.aviation`, `.abstract`, `.trap`) |
| `arithmetic_grid` | `arith` | `arith.grid` (`.priority`, `.squares`, `.division`, `.sign`), `arith.drill` (practice-only free input: `.add_sub`, `.mul`, `.div`, `.percent`, `.squares`, `.time`, `.aviation`) |
| `culture_aero` | `culture` | the 14 topic areas of spec §4.1: `culture.flight_mechanics`, `culture.meteorology`, `culture.human_factors`, `culture.rules_of_the_air`, `culture.navigation`, `culture.ops_documents`, `culture.history`, `culture.accidents`, `culture.airports_manufacturers`, `culture.network_geography`, `culture.af_fleet_figures`, `culture.subsidiaries_alliances`, `culture.pilot_job_cadet_path`, `culture.institutions`. Flight instruments (altimeter, PFD, transponder codes…) are a third-level tag under `culture.flight_mechanics` (e.g. `culture.flight_mechanics.instrument_altimeter`), not a 15th topic — a standalone `culture.instruments` second-level tag briefly existed and was folded back into `culture.flight_mechanics` during the US-087 review to keep exactly 14 topics. |
| `multitask_psychomotor` | `multitask` | `multitask.tracking`, `multitask.shapes`, `multitask.calc` |
| `english` (+ `english_listening`, `english_speaking`) | `english` | `english.reading` (`.detail`, `.inference`, `.main_idea`, `.vocab_in_context`, `.graph`), `english.grammar` (`.tenses`, `.modals`, `.conditionals`, `.prepositions`, `.articles`, `.questions`, `.passive`, `.reported_speech`), `english.vocab` (`.general`, `.aviation`, `.phrasal_verbs`, `.collocations`), `english.listening`, `english.speaking`, `english.strategy` |
| blueprints | `blueprint` | `blueprint.full`, `blueprint.short`, `blueprint.custom` |
| `p1_reading_fr` | `p1_reading_fr` | `p1_reading_fr.comprehension`, `p1_reading_fr.inference`, `p1_reading_fr.vocab_in_context` |
| `p1_math_word_problems` | `p1_math_word_problems` | `p1_math_word_problems.speed_time_distance`, `p1_math_word_problems.fuel`, `p1_math_word_problems.proportions`, `p1_math_word_problems.conversions`, `p1_math_word_problems.time_zones` |
| `p1_general_efficiency` | `efg` | `efg.numeric`, `efg.verbal`, `efg.spatial`, `efg.logic` (US-103: mixed-topic MCQ bank, spec §2.3 row 6) |
| `p1_tangram`, `p1_cube_nets`, `p1_raven_matrices`, `p1_angles`, `p1_attention_sustained`, `p1_counters`, `p1_mental_arithmetic`, `p1_wm_reverse_span`, `p1_wm_calc_back`, `p1_psychomotor` | own `familyId` | Lessons/decks only this story (US-103), no bank yet: the familyId itself is the tag until a bank needs a second level. |

Lessons and decks reuse the same tags so the "Try it" button and weak-area recommendations
(US-041, US-072) can link lessons ↔ items ↔ decks.

## 8. Versions: entity `version` vs bundle `contentVersion`

- **`version`** on an entity (item, lesson, deck, card, family, blueprint): starts at 1. Bump it
  when the entity's **meaning** changes: correct answer, an option added/removed, a stem
  rewording that changes what is asked, a lesson rewritten. Do **not** bump for typos or
  formatting. Analytics treat different versions of an item as different questions for
  accuracy purposes.
- **`contentVersion`** in `assets/content/manifest.json`: an integer that must increase on
  **every change under `assets/content/` that should reach users**. The app re-seeds its
  database when the bundled value is greater than the stored one, keeping user data. Procedure:
  1. Make your content changes and run the validator.
  2. Increment `contentVersion` by 1, set `updatedAt`, add a one-line entry at the top of
     `changelog`.
  3. One bump per PR is enough even if it touches many files. Two PRs bumping in parallel
     will conflict on the manifest — rebase and take the higher number + 1.

  **Did you bump `contentVersion`?** Without the bump an installed app keeps the previous
  content forever: the seeder (US-013) only re-reads the bundle when the manifest value is
  greater than the one stored in its `content_meta` row, and a fresh install is the only
  other trigger. During development, the fastest way to see a content change without bumping
  is to delete the app's database (`psy_trainer.sqlite` in the application support folder) or
  reinstall. Bumping while the number is *lower* than the installed one (a downgraded build)
  does nothing either; the app keeps the newer content.

  What the app stores from a bump: every published module, family, bank item, lesson (with the
  markdown of its `file` copied into the row), deck, flashcard and blueprint. Drafts
  (`"status": "draft"`) and lexical fields (no table yet, US-085) are validated but not stored.
  User progress (`attempts`, `item_stats`, lesson reads...) survives every re-seed because it
  references content by id — which is why ids are permanent.
- **`schemaVersion`** in the manifest changes only when the Dart models change incompatibly
  (a developer bumps it in the same PR as the models, CONTRACT.md and these schemas).

## 9. Validating

Run the validator from the repo root (Flutter SDK installed, no Node needed):

```sh
dart run psy_content:validate_content apps/psy_trainer/assets/content        # whole bundle
dart run psy_content:validate_content apps/psy_trainer/assets/content/psy0/english   # one folder or file
make content-check                             # same, via the Makefile (PATHS=... to narrow)
```

It runs three layers on every `*.json` file and exits with code 1 on any error (CI runs
it on every PR, see `.github/workflows/ci.yml`):

1. **JSON Schema** — the file is matched to its schema by its `kind` and checked against
   [`packages/psy_content/schema/`](../../packages/psy_content/schema/) (draft 2020-12,
   including `oneOf` / `unevaluatedProperties`).
2. **Dart models** — `ContentBundleParser` must accept the file, so the app's models and
   the schemas cannot drift apart.
3. **Semantic rules** — what schemas cannot say: ids unique across the whole bundle,
   `correctIndex < options.length`, explanation present and non-blank for `mcq` / `numeric`
   (and absent for `generated`), `fr` present and non-blank in every localized text,
   `difficulty` 1–5, `passageId` declared in the same file, grid cells inside the grid,
   `familyId` = folder = an existing `family.json`, `moduleId` = module folder, media and
   lesson `.md` files present under the module folder, `deckIds` resolving, blueprint
   sections naming existing families, `module.json` listing every family folder, the
   manifest listing every module folder, changelog newest-first and matching
   `contentVersion`, each kind of file in its expected folder (§1).

A *bundle* is a folder holding a `manifest.json` (`apps/psy_trainer/assets/content/`); the cross-file rules
apply inside it. Files outside a bundle — and everything under a folder named `examples/`
— are validated on their own (layers 1–3 minus the cross-file references).

Options: `--quiet` (errors and verdict only), `--json` (machine-readable report with the
same errors, warnings and family summary), `--schema-dir <dir>`, `--help`. When piping
`--json` into another tool, add `--verbosity=error` to `dart run` so its own
"Running build hooks..." banner does not precede the JSON:
`dart run --verbosity=error psy_content:validate_content --json`.

Sample output on a valid bundle:

```
Content validation: assets/content
14 JSON file(s), 1 bundle(s) (assets/content), 0 loose file(s)

family             module  items  d1  d2  d3  d4  d5  generated  mcq  numeric  sequence  passages  lessons  decks  cards
-----------------  ------  -----  --  --  --  --  --  ---------  ---  -------  --------  --------  -------  -----  -----
english            psy0        3   0   2   1   0   0          0    3        0         0         1        1      1      2
logic              psy0        1   0   1   0   0   0          1    0        0         0         0        0      0      0
memory             psy0        2   0   1   1   0   0          0    0        0         2         0        0      0      0
mental_arithmetic  psy0        2   0   1   0   1   0          0    0        2         0         0        0      0      0

OK: 0 error(s), 0 warning(s) in 14 file(s)
```

And when something is wrong (each line: file, `[entity id]`, JSON pointer, message, layer):

```
ERRORS (4)
  assets/content/psy0/english/items/grammar-001.json [english.vocab.0001] /items/1/difficulty: maximum exceeded (7 > 5)  (schema)
  assets/content/psy0/english/items/grammar-001.json [english.reading.0001] /items/2: missing required property "explanation"  (schema)
  assets/content/psy0/english/items/grammar-001.json [english.grammar.0001] /items/0/correctIndex: correctIndex 4 is out of range: the item has 4 options (indexes 0-3)  (rule)
  assets/content/psy0/logic/items/series-gen-001.json [english.grammar.0001] /items/0: duplicate id: this item id is already used in assets/content/psy0/english/items/grammar-001.json  (rule)

FAILED: 4 error(s), 0 warning(s) in 14 file(s)
```

Warnings (an unreferenced passage, an item without tags, a section whose
`perItemTimeSec × itemCount` exceeds `durationSec`) are printed but do not fail the run.

Editor autocompletion still works without the validator: keep the `$schema` line (§1).

## 10. Lessons

- One `.json` per lesson plus `.fr.md` (and optional `.en.md`) next to it; use inline `body`
  only for very short lessons.
- Markdown: headings from `#`, tables, images `![alt](english/media/x.svg)` (module-relative),
  inline formulas `$v = d / t$`, block formulas on their own `$$` lines.
- Callouts are GitHub-style blockquotes; the viewer renders them as coloured panels:
  `> [!METHOD]`, `> [!TIP]`, `> [!TRAP]`, `> [!EXAMPLE]`.
- A `> [!EXAMPLE]` whose content is a **numbered list** is a *worked example*: the viewer
  reveals the steps one by one (US-043). Provide at least 3 per family, the last step being a
  verification.
- Fill `practiceTags` so the "Try it" button drills what the lesson taught, and `deckIds` to
  link flashcards.

## 11. Flashcards

- One deck file per theme, ≤ 200 cards; `front` is a question or prompt, `back` the answer
  plus, when useful, a one-line memory hook.
- Cards must be atomic (one fact) and reversible in meaning ("1 NM = ? km", not "talk about
  the nautical mile").
- `difficulty` uses the same scale as items (1 = must-know, 5 = nice-to-know).

## 12. Blueprints

- Sections in the order of the real test; each section names its `familyId`, `itemCount`
  (stimuli, series, boards, grids or questions; `1` for the continuous multitask activity)
  and `itemSelection` (`bank` with filters or `generated` with a `generatorId`, a difficulty
  range and typed `params`, see §3).
- **Timing** (v2) is any combination of `sectionTimeSec` (hard limit for the section),
  `perItemTimeSec` (timeout advances with a null answer) and `cadence`
  (`{ "stimulusMs", "answerWindowMs" }`, fixed rhythm for `memory_nback` and
  `attention_rules`); at least one is required. A section `cadence` overrides the generator's
  `stimulusMs` / `answerWindowMs` params.
- `scoringPolicy` (`{ "correct", "wrong", "skip" }`, default `{1, 0, 0}`) sets the points;
  `{3, -1, 0}` reproduces the historical culture marking and is meant for the realism
  options (US-063), not for `psy0.blueprint.full`.
- `liveFeedback: true` on the sections whose real activity shows right/wrong live
  (`attention_rules`, `attention_parity` restart, `attention_airways` crash);
  `inputRequirement: "keyboard"` on keyboard-native ones (`attention_rules`,
  `multitask_psychomotor`); `weight: 0` for practice-only sections (`english_speaking`).
- Optional `title`, `briefing` (instruction screen with the worked example, markdown) and
  `breakAfterSec`.
- Every section and the blueprint itself carry `confidence`
  (`confirmed` | `reported` | `assumed`) tied to the research doc (US-080). The exam launcher
  shows "estimated" for anything not `confirmed`.
- Keep `psy0.blueprint.full` faithful (spec §3.1); `psy0.blueprint.short` (§3.2) and custom
  blueprints are for rehearsal. `assets/content/examples/blueprint.example.json` shows every
  field.
