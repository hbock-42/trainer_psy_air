---
id: US-053
issue: 43
title: "Adaptive difficulty"
type: story
epic: EPIC-05
status: review
priority: P2
size: M
lane: train-ui
depends_on: [US-051,US-075]
labels: [practice,analytics]
---

# US-053 — Adaptive difficulty

**As a** candidate **I want** difficulty to follow my level **so that** drills stay challenging but doable.

## Acceptance criteria
- [x] "Auto" difficulty = per-family level derived from recent accuracy & speed (US-075)
- [x] Within a session: +1 after 3 consecutive correct & fast, −1 after 2 consecutive wrong
- [x] Level changes are shown discreetly and logged in the session config

## Implementation notes

- Generated families now build an `ItemSource.adaptive` (`domain/engine/item_source.dart`)
  instead of `ItemSource.generator`: items are materialised lazily, one at a time, as
  `ActivitySession` shows them, since the difficulty of item *k* depends on how items
  `0..k-1` were answered. New `domain/adaptive/adaptive_difficulty_policy.dart`
  (`AdaptiveDifficultyPolicy`/`AdaptiveDifficultyState`/`LevelChange`) is the pure policy:
  3 correct-and-fast in a row -> +1, 2 wrong in a row -> -1, clamped 1..5. "Fast" is under the
  family's median response time (`StatsService`) or 60% of the per-item limit as a fallback.
- The launcher (`practice_launcher_screen.dart`) resolves "Auto" via
  `ProgressAnalytics.familyProgress(familyId).level` (1 with no history) and passes it, plus
  the family's median RT, into `buildActivitySessionConfig` as the adaptive source's starting
  level and fast threshold. A manually fixed level is still just the *starting* level — the
  session still adapts from there.
- `SessionHost` shows a small pill next to the progress dots that pulses when the level
  changes (no popups); the summary screen shows "niveau X -> Y" discreetly when
  `SessionResult.levelChanges` is non-empty.
- Deviations (documented in `ActivitySessionConfig`'s doc comment and `docs/ARCHITECTURE.md`):
  level changes ride on `SessionResult` (read by the summary straight after the run), not on
  the persisted `TrainingSession.config` — `ProgressRepository.finishSession` has no config
  update, and the config is written once, before start, before any change could have happened.
  Every attempt still durably records the difficulty it was actually shown at
  (`AttemptOrigin.difficulty`, pre-existing). Bank families do not adapt in-session (their
  sample is drawn once, up front) and "Auto" still samples their whole pool rather than
  narrowing to one level, to avoid an empty/starved session where a family's bank content
  is not yet calibrated across all 5 levels.
