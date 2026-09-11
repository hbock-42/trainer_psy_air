# Content authoring guide

How to write items, lessons, flashcards and exam blueprints for the PSY trainer.
You do not need Flutter or Dart: content is JSON + Markdown validated by a script.
The data model itself is described in [CONTRACT.md](CONTRACT.md); the machine-readable
rules are the JSON Schemas in [`schema/`](schema/). Valid examples of every file type live in
[`assets/content/examples/`](../../assets/content/examples/) — copy one to start.

Legal reminder: the app is an unofficial trainer. **Never reproduce copyrighted test
material** (real Air France / ENAC / publisher items). Write your own items in the same
spirit; note your source in `meta.source`.

## 1. Where files go (content bundle layout)

```
assets/content/
  manifest.json                     # contentVersion, schemaVersion  (manifest.schema.json)
  psy0/
    module.json                     # the stage                      (family.schema.json#/$defs/Module)
    lessons/                        # module-level lessons (selection overview, exam-day tips)
      01-how-the-selection-works.json
      01-how-the-selection-works.fr.md
    blueprints/
      psy0_full.json                # (blueprint.schema.json)
      psy0_short.json
    english/                        # one folder per family, folder name == family id
      family.json                   # (family.schema.json)
      items/
        grammar-001.json            # ≤ 100 items per file           (bank.schema.json)
        grammar-002.json
        vocab-001.json
        reading-001.json            # bank files may hold passages
      lessons/
        01-tenses.json              # (lesson.schema.json)
        01-tenses.fr.md             # body referenced by the json
        01-tenses.en.md             # optional
      decks/
        aviation-vocab.json         # deck + its cards               (deck.schema.json)
      media/
        runway-signs.svg
    mental_arithmetic/
      …
  psy1/ …
```

Rules:

- Folder name = family `id` = `familyId` inside every file of the folder.
- Media paths in JSON are **relative to the module folder**: `english/media/runway-signs.svg`.
- Bank files: at most **100 items**, all of the same family. Name them
  `<subtag>-<nnn>.json` and start a new file when one is full. Files are seeded in
  alphabetical order, which only matters for items sharing a `passageId` (kept in file order).
- Every JSON file starts with `"kind"` so the validator and the seeder know what it is.
- Add `"$schema": "../../../../docs/content/schema/<kind>.schema.json"` at the top to get
  editor autocompletion (VS Code understands it). It is ignored by the app.

## 2. Ids

Pattern `^[a-z0-9_.-]+$`, 3–120 chars, **globally unique across every kind of entity**.
Ids are permanent: renaming an id orphans user statistics (`item_stats`, `attempts`).

| Entity | Convention | Example |
|---|---|---|
| Module | fixed | `psy0`, `psy1`, `psy2` |
| Family | one word, `_` allowed, no dot | `english`, `maths_physics`, `mental_arithmetic`, `logic`, `spatial`, `memory`, `verbal`, `attention` |
| Item (bank) | `<family>.<subskill>.<nnnn>` (4-digit, zero-padded, never reused) | `english.grammar.0042` |
| Item (generated recipe) | `<family>.<subskill>.gen.<nnnn>` | `logic.series.gen.0001` |
| Passage | `<family>.reading.p<nnn>` | `english.reading.p001` |
| Lesson | `<family>.lesson.<nn>-<slug>` (module-level: `<module>.lesson.<nn>-<slug>`) | `mental_arithmetic.lesson.03-speed-time-distance` |
| Deck | `<family>.deck.<slug>` | `mental_arithmetic.deck.aviation-conversions` |
| Flashcard | `<deckId>.<nnnn>` | `mental_arithmetic.deck.aviation-conversions.0001` |
| Blueprint | `<module>.blueprint.<slug>` | `psy0.blueprint.full` |
| Blueprint section | unique inside its blueprint: `s<nn>-<slug>` | `s03-english` |

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
  "meta": { "author": "…", "source": "own" }               // optional, never shown
  // + type-specific fields below
}
```

### `mcq` — multiple choice

- `stem` (LocalizedText), `options` (2–6, each with `text` and/or `media`), `correctIndex`
  (0-based), `explanation` (mandatory), optional `media`, `passageId`, `shuffleOptions`.
- Exactly **one** option is right and it must be *unambiguously* right. Distractors must be
  plausible (a common mistake each), never silly.
- Keep options homogeneous (same grammatical form, same length order of magnitude).
- Set `shuffleOptions: false` only when order carries meaning ("none of the above",
  sorted numbers).
- Reading comprehension: put the text in the bank file's `passages` array and reference it
  from 3–5 items via `passageId`. Passage 80–250 words for PSY0 English.

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
- Digit-span difficulty roughly follows length: 3–4 → 1, 5 → 2, 6 → 3, 7 → 4, 8+ → 5
  (backward: one level higher for the same length).

### `generated` — reproducible recipe

- `generatorId` (engine key, see CONTRACT.md), `seed` (integer), optional `params`.
- Use it to pin a **specific** generated item: worked examples in lessons, regression cases,
  calibration sets (US-086). Everyday practice/exam items are generated on the fly from the
  blueprint or the family defaults, not from bank files.
- `difficulty` is the level you *expect*; the validator (later) checks the generator agrees.
- `params` keys are defined by each engine story (US-023…US-029); unknown keys are ignored.

## 4. Difficulty scale

Calibrate against the **real test**, not against a beginner. The app's adaptive mode (US-053)
moves users between levels, so the scale must be consistent across a family.

| Level | Meaning | Mental arithmetic | English | Logic series | Memory (digit span) |
|---|---|---|---|---|---|
| **1** | Warm-up. Anyone with a bac gets it in a few seconds. Never appears in the full exam blueprint. | `48 + 27`, `6 × 7` | present simple / plural -s, basic vocab (*runway*) | `2 4 6 8 ?` | 3–4 digits forward |
| **2** | Easy real-test item. Correct > 90 % of the time when not rushed. | `340 × 3`, 10 min at 420 kt | past simple vs present perfect, common prepositions | `3 6 12 24 ?`, letters `A C E ?` | 5 digits forward |
| **3** | Typical real-test item. Needs the method from the lesson; ~10–20 s. | `5 600 kg ÷ 2 400 kg/h`, 15 % of 240 | past perfect, conditionals 1–2, phrasal verbs, aviation phraseology | alternating two-step series, 3×3 matrix with 2 rules | 6 forward / 5 backward |
| **4** | Hard real-test item. Two steps or a trap; a good candidate hesitates. | 11 000 ft in m ±2 %, 2 h 50 after 14:35 | inversion, mixed conditionals, inference questions on a passage | Fibonacci-like, matrix with 3 rules, plausible distractors | 7 forward / 6 backward |
| **5** | Hardest expected; discriminates the top. Rare in the bank (≤ 10 %). | 3-digit × 2-digit, chained conversions | subtle register/collocation, dense passage with inference | matrix with rotation + count + fill, two interleaved series | 8+ forward / 7 backward |

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
  `logic/media/matrix-0001.svg`.
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
| `english` | `english` | `english.grammar` (`.tenses`, `.modals`, `.conditionals`, `.prepositions`, `.articles`, `.questions`, `.passive`, `.reported_speech`), `english.vocab` (`.general`, `.aviation`, `.phrasal_verbs`, `.collocations`), `english.reading` (`.detail`, `.inference`, `.main_idea`, `.vocab_in_context`), `english.listening` |
| `mental_arithmetic` | `arith` | `arith.add_sub`, `arith.mul`, `arith.div`, `arith.percent`, `arith.fractions`, `arith.squares_roots`, `arith.rule_of_three`, `arith.time`, `arith.aviation` (`.speed_distance`, `.fuel`, `.conversion`, `.descent`) |
| `maths_physics` | `math` / `phys` | `math.algebra`, `math.functions`, `math.trigonometry`, `math.geometry`, `math.probabilities`, `math.statistics`, `math.vectors`, `phys.mechanics`, `phys.energy`, `phys.electricity`, `phys.optics`, `phys.waves`, `phys.thermo`, `phys.units` |
| `logic` | `logic` | `logic.series` (`.arithmetic`, `.geometric`, `.alternating`, `.two_step`, `.fibonacci`, `.letters`), `logic.matrix` (`.shape`, `.count`, `.rotation`, `.fill`, `.position`), `logic.odd_one_out` |
| `spatial` | `spatial` | `spatial.rotation_2d`, `spatial.mirror`, `spatial.cube_net`, `spatial.cube_rotation`, `spatial.paper_folding` |
| `memory` | `memory` | `memory.digit_span` (`.forward`, `.backward`), `memory.pattern`, `memory.sequence` (`.symbols`, `.colors`, `.positions`), `memory.n_back` |
| `verbal` | `verbal` | `verbal.analogy`, `verbal.odd_one_out`, `verbal.syllogism`, `verbal.comprehension`, `verbal.vocab` |
| `attention` | `attention` | `attention.symbol_count`, `attention.target_detection`, `attention.n_back`, `attention.stroop` |
| blueprints | `blueprint` | `blueprint.full`, `blueprint.short`, `blueprint.custom` |

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
- **`schemaVersion`** in the manifest changes only when the Dart models change incompatibly
  (a developer bumps it in the same PR as the models, CONTRACT.md and these schemas).

## 9. Validating

Until the Dart validator exists, validate with any JSON Schema draft 2020-12 tool, e.g.
from the repo root with Node installed:

```sh
npx --yes ajv-cli@5 validate --spec=draft2020 -c ajv-formats --strict-required=false \
  -r docs/content/schema/common.schema.json -r docs/content/schema/item.schema.json \
  -s docs/content/schema/bank.schema.json -d "assets/content/psy0/english/items/*.json"
```

(`-r` lists the referenced schemas; add `flashcard.schema.json` for decks.)

**Forthcoming (US-014):** `dart run tool/validate_content.dart` will run the schemas *and*
the semantic checks — unique ids across the bundle, `correctIndex < options.length`,
`familyId` matches the folder, `passageId` resolves in the same file, referenced media and
lesson files exist, FR present everywhere, `difficulty` 1–5, ≤ 100 items per file — and
print a per-family count by difficulty. CI runs it on every PR.

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

- Sections in the order of the real test; each section names its `familyId`, `durationSec`,
  `itemCount`, `itemSelection` (`bank` with filters or `generated` with a `generatorId` and a
  difficulty range), optional `perItemTimeSec` and `breakAfterSec`.
- Every section and the blueprint itself carry `confidence`
  (`confirmed` | `reported` | `assumed`) tied to the research doc (US-080). The exam launcher
  shows "estimated" for anything not `confirmed`.
- Keep `psy0.blueprint.full` faithful; make separate `short`/custom blueprints for rehearsal.
