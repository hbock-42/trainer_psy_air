---
id: US-028
issue: 32
title: "Aeronautical culture engine (Culture générale aéronautique)"
type: story
epic: EPIC-03
status: done
priority: P0
size: S
lane: engines
depends_on: [US-021]
labels: [engine,content-driven,mvp]
---

# US-028 — Aeronautical culture engine (Culture générale aéronautique)

**As a** candidate **I want** to drill the culture MCQ **so that** I am not caught out by the activity candidates fear most.

Real test (spec §2.4-N): 48 single-answer MCQ (4 options), one per screen, no back, ~18 s each (Sept 2026); topics = BIA/PPL theory + aviation history + airports/codes + geography + Air France/Transavia facts + the cadet path. Historically +3/−1/0 with "je ne sais pas"; 2026 instruction silent on negative marking.

## Acceptance criteria
- [x] Uses `BankSource` of `McqItem`s tagged `culture.<topic>` (14 topic areas from the spec) with balanced sampling across topics
- [x] Per-item timer 18 s default, no back, auto-advance; optional scoring policy `{+3, −1, 0}` with a "Je ne sais pas" option (realism toggle, US-063)
- [x] Items carry `validAsOf`; perishable items (fleet counts, CEOs, routes) show their date in the explanation
- [x] Topic-level stats fed to analytics (weak topics)
Content: US-083.

## Implementation notes (US-028)
- `CultureAeroEngine` (`lib/features/engines/culture_aero/domain/culture_aero_engine.dart`)
  is bank-only (`generatorId == null`); the default `ActivityEngine.score` /
  `Scorer.scoreItem` already handles an `McqItem` choice or a `SkipAnswer`
  ("je ne sais pas") as a skip, so no scorer override was needed.
- Reuses `McqRenderer` (US-021) rather than forking it: extended it with an
  optional generic `explanationFooter` builder, used here for
  `culture_aero`'s "Donnée valable au `<date>`" line
  (`lib/features/engines/culture_aero/presentation/culture_aero_explanation.dart`)
  when `McqItem.validAsOf` is set.
- Registered `CultureAeroEngine()` + `McqRenderer(familyId: 'culture_aero',
  explanationFooter: cultureAeroExplanationFooter)` in
  `engine_registry_provider.dart`, alphabetically.
- Balanced sampling across topics is the existing generic round-robin-by-
  first-tag in `practice_session_builder.dart` (`_balancedByTag`); added a
  culture_aero-specific test proving it spreads across all 15
  `culture.<topic>` tags instead of adding a new sampler.
- Per-item timing (18 s) and the exam `scoringPolicy` come from
  `family.json` / `blueprints/psy0_full.json` through the existing
  `TimingPolicy`/`ScoringPolicy` plumbing — nothing engine-specific to add,
  see the PR description for a content mismatch found while verifying this.
- Topic-level stats: `StatsService.tagAccuracy` (US-075) already aggregates
  by item tag for every family, so `culture.<topic>` weak-area analytics
  need no engine-specific code.
