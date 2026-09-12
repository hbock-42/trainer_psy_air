---
id: US-075
issue: 55
title: "Stats computation service"
type: story
epic: EPIC-07
status: done
priority: P0
size: M
lane: analytics
depends_on: [US-011,US-012]
labels: [analytics,domain]
---

# US-075 — Stats computation service

**As a** developer **I want** all aggregates computed in one tested service **so that** dashboard, adaptive difficulty and recommendations agree.

## Metrics
- Per family: accuracy, median response time, level (1–5), trend over last 7/30 days, items done, last practised
- Per exam sim: global + per-section score, delta vs previous
- Readiness score 0–100 = weighted mix of family levels, lesson progress (US-044) and exam-sim results; weights in a config file
- Weak areas: families/tags with accuracy below threshold or negative trend

## Acceptance criteria
- [x] Pure Dart, unit tests with fixture sessions covering edge cases (no data, single session, timeouts)
- [x] Efficient SQL aggregates in DAOs (no loading all attempts in memory) for time series
- [x] Exposed via providers with caching invalidated when a session finishes

## Implementation notes
- `lib/features/progress/domain/` (`StatsService`, `ProgressAnalytics`, value objects,
  `StatsConfig`), providers in `presentation/providers/`; formulas and weights documented in
  `docs/ARCHITECTURE.md`, "Progress / analytics".
- New SQL aggregate `ProgressRepository.sessionFamilyStats` (one row per session/family/section,
  with an unanswered count) feeds the charts (US-071) and exam summaries.
- Consumers invalidate with `ref.read(progressVersionProvider.notifier).bump()` after finishing
  a session (US-051, US-061) or marking a lesson read (US-044).

## Parallel
Can be built right after US-011, before any engine exists.
