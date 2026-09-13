---
id: US-115
issue: 172
title: "PSY1: sustained attention engine"
type: story
epic: EPIC-10
status: review
priority: P2
size: M
lane: engines
depends_on: [US-101]
labels: [engine,generator,psy1]
---

# US-115 — PSY1: sustained attention engine

Spec §2.3-3: series-based vigilance task, 3 series of ~3 min; exact format is an open question — build on the closest PSY0 paradigm (cadence-driven target detection) and keep the params flexible.
- [x] Generator: stimulus stream with rare targets (e.g. specific symbol/colour combination), cadence from params, difficulty = target rarity / similarity
- [x] Renderer: cadence-driven stimulus + key/tap response; scorer hits/misses/false alarms + RT
- [x] Tests: cadence with `ManualClock`, SessionHost run; flagged `confidence: assumed` in the family file

## Implementation notes

- `p1_attention_sustained` is a continuous stream of one `GeneratedItem` per
  stimulus (shape + colour, from `psy_content`'s existing `StimulusShape`/
  `StimulusColour`), same `runSeed`/`index` derivation pattern as
  `memory_nback`/`attention_rules`. Each series (`itemsPerSeries` items)
  draws one fixed target rule from the run seed — either a shape+colour
  conjunction (e.g. "red circle") or "same shape as the previous stimulus"
  — shown as a persistent header in the renderer (the runtime has no
  per-series briefing hook, so this is how the candidate learns a new
  series' rule as it starts, not only at the very first briefing).
- Params gained `targetRatio`/`lureRatio`/`shapes`/`colours` on
  `P1AttentionSustainedParams` (`packages/psy_content/lib/model/
  generator.dart` + `generators.schema.json`) to make target rarity, lure
  similarity and the stimulus palette tunable, per the card's "keep the
  params flexible" instruction.
- Metrics: `attentionHits`/`Misses`/`FalseAlarms`/`CorrectRejections`
  (signal-detection), plus `attentionFirstThirdTotal`/`Correct` and
  `attentionLastThirdTotal`/`Correct` (position within series) feeding
  `attentionVigilanceDecrement` — first-third accuracy minus last-third
  accuracy, the vigilance-decrement metric the card asked for.
- **Deviation from the card's `TimeoutAnswer` idea**: `ActivityEngine
  .score` is never called with a `TimeoutAnswer` (the runtime always
  records `ItemResult.timeout` itself), so a silent non-answer cannot be
  reinterpreted as a correct rejection. Non-targets require an explicit
  "not target" key/button (SPACE = target, N = not target) to score a
  correct rejection; a genuine timeout is recorded as a timeout regardless
  of whether the stimulus was a target — documented in
  `AttentionSustainedEngine`'s doc comment and covered by a session test.
