---
id: US-082
issue: 58
title: "Author English item bank (reading passages first)"
type: story
epic: EPIC-08
status: done
priority: P0
size: L
lane: content
depends_on: [US-010,US-014]
labels: [content,english]
---

# US-082 — Author English item bank (reading passages first)

- [x] ≥ 25 reading sets: passage (text, or an image/graph described in the model) × 3–5 MCQ, TOEIC-like, aviation and general topics, B2–C1
- [x] ≥ 150 grammar gap-fill MCQ (4 options incl. ∅) for the secondary drill
- [ ] Stretch: 10 listening scripts (text + audio asset if produced) and 20 speaking prompts with model answers
- [x] Each item: difficulty, tags (`english.reading|grammar|listening|speaking`), explanation in FR; passes the validator; reviewed (US-087)

## Delivered

Files under `assets/content/psy0/english/items/` (bank files, ≤ 100 items each, validated
against `bank.schema.json` + `item.schema.json` + `common.schema.json`):

- `reading-001.json` — 13 aviation / airline-workplace passages (emails, notices, NOTAM-style
  bulletins, safety cards, timetables, graphs and tables described in text, memos, articles…).
- `reading-002.json` — 13 general-workplace passages (TOEIC-like: office, HR, logistics,
  hotel, conference, customer service…).
- `grammar-001.json`, `grammar-002.json` — gap-fill MCQ (tenses, modals, conditionals, passive,
  questions/inversion, gerund vs infinitive, prepositions, articles, phrasal verbs, relative
  clauses, reported speech, comparatives/quantifiers), `∅ (no word needed)` used where relevant.
- `vocab-001.json` — aviation-flavoured vocabulary gap-fill.

Conventions: ids follow AUTHORING §2 (`english.reading.0001`, passages
`english.reading.p001`, `english.grammar.0001`, `english.vocab.0001`); English stems are stored
under `fr` per CONTRACT §4; every item has `lang: en`, `difficulty`, tags (root + sub-skill,
reading items also carry a passage-genre tag such as `english.reading.email`) and a French
`explanation`. Correct-answer positions are balanced across each file.

Stretch (listening scripts, speaking prompts) not done: no audio pipeline yet and the
content model has no free-response item type for speaking prompts (see US-010 / US-027).
