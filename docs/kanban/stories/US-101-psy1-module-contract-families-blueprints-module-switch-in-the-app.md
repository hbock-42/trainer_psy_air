---
id: US-101
issue: 69
title: "PSY1 module: contract, families, blueprints, module switch in the app"
type: story
epic: EPIC-10
status: done
priority: P1
size: M
lane: core
depends_on: [US-100,US-015]
labels: [domain,blocking,psy1]
---

# US-101 — PSY1 module: contract, families, blueprints, module switch in the app

**As a** team **we want** the app to know about a second module **so that** PSY1 engines, content and blueprints plug into the same runtime and UI.

## Acceptance criteria
- [x] `packages/psy_content`: `EngineType`/`GeneratorId` gain the 13 PSY1 family ids and generator ids of `docs/content/psy1-spec.md` §4 (`p1_*`), typed `GeneratorParams` with real-test defaults; `schemaVersion` bump if needed; validator updated
- [x] `assets/content/psy1/module.json`, 13 `family.json`, `blueprints/psy1_full.json` + `psy1_short.json` transcribed from spec §4 with `confidence`; `manifest.json` lists both modules; seeder handles them
- [x] Module switch: the profile's target stage (onboarding, Settings → profile) selects the active module; Learn/Train/Exam homes filter by module and show a segmented PSY0/PSY1 switch at the top; dashboard readiness is per module (weights config gains PSY1 families)
- [x] Learn home for PSY1 uses the spec's activity descriptions; families without an engine show "Bientôt" (same as PSY0 did)
- [x] Tests: content parses/seeds, module switch filters, blueprint validity

## Notes (implementation)
- `schemaVersion` was **not** bumped: the 13 new `EngineType`/`GeneratorId` enum
  members are purely additive and only ever consumed by content shipped in
  this same PR (no older app build needs to parse them), so per
  `docs/content/CONTRACT.md` §5 this does not qualify as a breaking change.
- All 13 PSY1 families are modelled as **generated** (no bank items needed
  yet); real item/passage authoring is US-103+. No engine is registered for
  any of them, so Train/Exam show "Bientôt" for the whole module today —
  expected until US-102/104-116 land.
- PSY2 module.json was **not** added (left to US-111 per the spec's own
  recommendation, §4.4): PSY2 has no engines/content of its own yet and an
  empty module would add nothing testable.
- MVP PSY1 family weights (`StatsConfig.defaultFamilyWeights`): `p1_psychomotor`,
  `p1_cube_nets`, `p1_mental_arithmetic`, `p1_raven_matrices` weigh 2 (the
  spec's highest-stakes families), the other 9 weigh 1.
