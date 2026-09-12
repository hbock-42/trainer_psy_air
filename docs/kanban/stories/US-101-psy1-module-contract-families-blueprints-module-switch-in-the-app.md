---
id: US-101
issue: 69
title: "PSY1 module: contract, families, blueprints, module switch in the app"
type: story
epic: EPIC-10
status: backlog
priority: P1
size: M
lane: core
depends_on: [US-100,US-015]
labels: [domain,blocking,psy1]
---

# US-101 — PSY1 module: contract, families, blueprints, module switch in the app

**As a** team **we want** the app to know about a second module **so that** PSY1 engines, content and blueprints plug into the same runtime and UI.

## Acceptance criteria
- [ ] `packages/psy_content`: `EngineType`/`GeneratorId` gain the 13 PSY1 family ids and generator ids of `docs/content/psy1-spec.md` §4 (`p1_*`), typed `GeneratorParams` with real-test defaults; `schemaVersion` bump if needed; validator updated
- [ ] `assets/content/psy1/module.json`, 13 `family.json`, `blueprints/psy1_full.json` + `psy1_short.json` transcribed from spec §4 with `confidence`; `manifest.json` lists both modules; seeder handles them
- [ ] Module switch: the profile's target stage (onboarding, Settings → profile) selects the active module; Learn/Train/Exam homes filter by module and show a segmented PSY0/PSY1 switch at the top; dashboard readiness is per module (weights config gains PSY1 families)
- [ ] Learn home for PSY1 uses the spec's activity descriptions; families without an engine show "Bientôt" (same as PSY0 did)
- [ ] Tests: content parses/seeds, module switch filters, blueprint validity
