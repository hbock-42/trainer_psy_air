# Content review & QA pass (US-087)

Second-person review of every authored bank and lesson in the PSY0 bundle, plus a
mechanical QA script (`tools/content_qa/check_content.py`) covering duplicates,
answer-position balance, French typography and lexical-field consistency.
`make content-check` passes with 0 errors / 0 warnings after the fixes below.

Reviewer: Hugo Bock — 2026-09-12.

## Sign-off table

| File(s) | Items | Issues found | Issues fixed | Notes |
|---|---|---|---|---|
| `psy0/english/items/*.json` (grammar-001/002, reading-001/002, vocab-001) | 270 items, 26 passages | Missing NBSP before `;:!?` and a straight `"` in genuinely-French `explanation` text (stems/options are English stimuli and correctly use straight quotes) | Fixed (NBSP inserted; no straight-quote fix needed once explanation text was isolated) | Grammar/tense keys, reading-comprehension keys and vocab keys spot-checked and confirmed correct; explanations teach the method, not just the answer; no duplicate ids or near-duplicate stems; difficulty distribution (1:18 2:58 3:101 4:65 5:28) is close to the documented 10/25/35/20/10 target |
| `psy0/culture_aero/items/*.json` (14 files) | 324 items | (1) Missing NBSP before French sentence-final `?`/`:`/`!` in several stems/explanations. (2) A 15th, undocumented tag `culture.instruments` (18 items) alongside the 14 documented topics. (3) Perishable facts (`validAsOf`) needed fact-checking. | (1) Fixed via typography pass. (2) Reconciled by merging `culture.instruments` / `culture.instruments.*` into `culture.flight_mechanics` / `culture.flight_mechanics.instrument_*` (third-level tags are free) — matches the existing lesson's "14 domaines" and domain-1 grouping ("mécanique du vol et instruments"); `docs/content/AUTHORING.md` §7 annotated to record the decision. (3) WebSearch-verified: AF fleet 268 aircraft (HOP! incl.) at 31 Dec 2025, 4 275 pilots / 37 000+ staff, 42.3M AF passengers / 102.8M group in 2025, group operating result €2.0bn (6.1% margin, a first), 35% new-generation fleet, ~3% SAF, Anne Rigail still DG Air France, Ben Smith group CEO/chair, SAS joined SkyTeam 1 Sept 2024 — all confirmed accurate against current sources, no changes needed to the facts themselves | No item version bumps needed: no correct answer changed, only punctuation/tags |
| `psy0/*/decks/*.json` (6 decks: `attention_rules`, `logic_dominos`, `memory_nback`, `arithmetic_grid`, `culture_aero`, `english`) | 213 flashcards | Straight double quotes used for quoted French phrases instead of `« »` guillemets (14 cards); one missing NBSP before `?` | Fixed: converted to `« … »` with NBSP, left `en` sides on straight quotes (correct for English) | Cards are atomic and reversible; backs checked against the corresponding lesson/bank for consistency |
| `psy0/verbal_boxes/lexical_fields/core.json` | 45 fields | None (validated with a dedicated script check: word ownership, `traps`/`incompatibleWith` symmetry, 15–25 words/field, no in-field duplicates) | — | All genuine word overlaps (e.g. `fruits`↔`couleurs`, `formes`↔`mathematiques`, `ecole`↔`bureau`) are already covered by reciprocal `incompatibleWith`; traps are real distractors, not contradicting the field they're filed under |
| `psy0/lessons/**/*.fr.md` (16 lessons) | 16 | None found: no Pilotest/EPLtest wording anywhere in the bundle; every lesson's `meta.source` correctly cites its `psy0-spec.md` section; the culture_aero lesson's "48 questions / 18 s / 14 domaines" format and domain list is consistent with the reconciled 14-topic tag vocabulary | — | Structure is consistent across lessons (format table with confidence tags where the spec source itself is `[reported]`/`[estimé]`, `[!METHOD]`/`[!TRAP]`/`[!EXAMPLE]` callouts, numbered worked examples with a verification step) |

## Mechanical QA script

`tools/content_qa/check_content.py` (Python 3, stdlib only, read-only — it reports,
it does not fix). Run from the repo root:

```sh
python3 tools/content_qa/check_content.py
```

It checks, across `apps/psy_trainer/assets/content/psy0`:

- duplicate ids and near-duplicate stems (same `familyId` + identical `stem.fr`) across bank files;
- `correctIndex` skew per bank file (flags any file where one position exceeds 45 % of its mcq items);
- French typography — NBSP before `;:!?` and straight `"` instead of `« »` — in `explanation` (always) and
  `stem`/`options` (for every family except `english`, whose stems/options are the English stimulus);
  time (`14:00`) and ratio (`10:1`) colons and the `HOP!` brand name are correctly excluded;
- lexical-field consistency: a word owned by two fields must have those fields mutually `incompatibleWith`,
  `incompatibleWith` must be reciprocal, and each field must have 15–25 words;
- the `culture_aero` tag vocabulary against the 14 topics documented in `docs/content/AUTHORING.md` §7.

Current run: clean (no output under any check).

## Items flagged `status: draft` / unverifiable

None. Every perishable fact (`validAsOf`) carries `meta.sources[]`, and the sampled
high-risk facts (fleet size, headcount, financial results, leadership, alliance
membership) were independently verified via web search and matched the bank's
figures exactly. No item needed to be pulled to `draft` or rewritten for
correctness.

## Not done in this pass

- On-device/emulator spot-check of long stems and media on a phone screen
  (tracked as a follow-up on the US-087 card — no device/emulator was available
  in this review environment).
