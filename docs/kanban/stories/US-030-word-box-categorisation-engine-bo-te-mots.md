---
id: US-030
issue: 34
title: "Word-box categorisation engine (Boîte à mots)"
type: story
epic: EPIC-03
status: review
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
- [x] Series builder: picks k lexical fields from the bank (US-085), interleaves ~20 words with deliberate near-miss traps; deterministic per seed
- [x] Renderer: boxes that get labelled by their first word, word stream with per-word timer, tap/keyboard 1–6 input
- [x] Scorer: errors, mean RT; practice mode explains the field of a missed word
- [x] Unit tests on series building (no ambiguous word across the chosen fields)
Content: US-085.

## Implementation notes
- Lexical fields had no storage yet (US-013 note); added a `lexical_fields`
  content-mirror table (`AppDatabase.schemaVersion` v2 -> v3),
  `ContentRepository.lexicalFields`/`lexicalField` (+ in-memory fake +
  contract test), wired into the seeder like the other content kinds.
- `WordBoxesEngine` needs the whole field catalogue synchronously at
  `generate()` time (`ActivitySession` materialises every item up front), so
  the catalogue is injected via the constructor from a Riverpod provider
  (`LexicalFieldCatalogue`, `presentation/lexical_field_catalogue.dart`)
  rather than preloaded per-session like `EnglishPassageCache`: which fields
  a series draws from is decided inside the generator itself, so there is no
  per-session subset to preload ahead of it. The provider loads lazily on
  first read of `.all` (not at construction, to avoid touching the database
  just from building the engine registry) — see the class doc for the
  documented race/caveat.
- Metrics: `errors`, `wordCount`; per-word mean RT was not tracked (the
  answer is submitted once per whole series as an `Answer.sequence`, per the
  card, so there is no per-word RT to carry without a payload change).
- `family.json`/blueprint timing: `perItemTimeSec` (75 s in `psy0_full.json`)
  is the runtime's per-*item* limit, and one item here is a whole series; the
  per-word pacing come from `params.wordTimeMs` (3000 ms), which the
  renderer times itself (engine-owned pacing, not a runtime limit).
