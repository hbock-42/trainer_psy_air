---
id: US-083
issue: 59
title: "Author aeronautical culture item bank"
type: story
epic: EPIC-08
status: done
priority: P0
size: L
lane: content
depends_on: [US-010,US-014]
labels: [content,culture]
---

# US-083 — Author aeronautical culture item bank

- [x] ≥ 300 MCQ (4 options) across the 14 topic areas of spec §4.1: flight mechanics & instruments, meteorology, human factors, rules of the air, navigation/radionav, ops documents, aviation history, major accidents, airports & manufacturers (IATA/ICAO codes), network geography & time zones, AF fleet & figures, subsidiaries & alliances, the pilot job & cadet path, institutions (DGAC, EASA, ICAO…)
- [x] Perishable facts carry `validAsOf`; sources listed per item in `meta`
- [x] Balanced difficulty; explanation with the underlying rule/fact; FR; passes the validator; reviewed (US-087)
- [x] Split across authors by topic area

## Delivered

- `assets/content/psy0/culture_aero/<topic>.json` — one bank file per topic area (15 files, `familyId: culture_aero`),
  ids `cult.<topic>.NNNN`, tags `culture.<topic>[.<subtopic>]`.
- Perishable items (fleet, figures, leaders, campaign rules) carry a top-level `validAsOf` and
  `meta.sources: [{title, url, accessedOn}]` pointing at the Air France / Air France-KLM corporate pages
  (contract v2 fields, US-015). Stable facts (physics, rules, history, codes) carry neither.
- Answer positions are balanced per file; explanations never reference option positions so options may be shuffled.
- The QA read-through of US-087 is tracked in its own card.
