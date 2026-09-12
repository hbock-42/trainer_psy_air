---
id: US-037
issue: 124
title: "Runtime: run-scoped generation (run seed + item index)"
type: story
epic: EPIC-03
status: review
priority: P0
size: S
lane: engines
depends_on: [US-020,US-026]
labels: [engine,runtime,blocking]
---

# US-037 — Runtime: run-scoped generation (run seed + item index)

**As an** engine author **I want** `generate()` to receive the run seed and the item index **so that** activities whose items depend on each other (N-back, rule sets shared across a run) are faithful and reproducible.

## Problem
`ItemSource.generator` draws an independent seed per item and never passes the position, so an N-back item cannot reference the stimulus actually shown n steps earlier (US-026 shipped with a per-item simulated history — not faithful), and US-029 had to derive its rule set from `params` instead of the run seed.

## Acceptance criteria
- [x] `ActivityEngine.generate({params, seed, difficulty, index, runSeed})` (or a `GenerationContext` object): `runSeed` identical for every item of a run, `index` = position; per-item `seed` kept for backward compatibility (derived from runSeed + index)
- [x] `ItemOrigin` carries `runSeed` + `index` so attempts replay identically (contract additive change, `schemaVersion` untouched if fields optional — check with `packages/psy_content` schema + parser + validator)
- [x] `ActivitySession.resume` still rebuilds the same items
- [x] US-026 N-back reworked to a true continuous stream (item k's target = value shown at k−n); US-029 rule set derived from `runSeed`, shown in `buildExample` (pass a run context to `buildExample`)
- [x] Existing engines (US-023, US-024, US-031) unaffected or trivially adapted; all tests green
