---
name: progress-analytics
description: Change or extend readiness/level/trend/streak formulas or the dashboard, charts and their caching — use for any progress/analytics/stats work under features/progress.
---

# Progress / analytics

One tested service backs everything the app shows or decides on (dashboard, charts, adaptive
difficulty, recommendations) so they never disagree.

```
features/progress/
  domain/
    stats_config.dart        StatsConfig, ReadinessWeights — every tunable number lives here
    stats_service.dart       StatsService: pure functions of repository rows, injectable clock
    progress_analytics.dart  ProgressAnalytics: fetches rows from the repositories, calls the service
    family_progress.dart | time_series.dart | exam_summary.dart | readiness_score.dart | weak_area.dart
    progress_snapshot.dart   everything the dashboard needs, in one pass
  presentation/providers/
    stats_service_provider.dart | progress_analytics_provider.dart
    progress_version_provider.dart   cache key; bump() after a session write
    progress_snapshot_provider.dart | exam_history_provider.dart | family_time_series_provider.dart
```

`domain/` is pure Dart — enforced by `test/architecture/no_flutter_in_domain_test.dart` (no
Flutter/Riverpod/Drift under any `features/*/domain/`).

## Inputs (never load raw attempts)

The service is generic over activities: correct-or-not, `responseMs`, answered-or-not
(`answer == null` = timeout = wrong). Engine-specific metrics (restarts, precision/recall)
stay in the attempt's `answer` json for the engine's own summary screen, not the stats
service. Every input is an SQL aggregate:

| Input | Query |
|---|---|
| lifetime per family | `ProgressRepository.familyStats()` |
| series/sections | `ProgressRepository.sessionFamilyStats(from, to, mode, familyId)` |
| exam sessions | `ProgressRepository.sessions(mode: exam)` |
| lesson progress | `lessonsRead().length` / `ContentRepository.lessons().length` |
| tags | `itemStats()` joined to `itemsByIds(...).tags` |

## Formulas (change constants in `StatsConfig`, not inline)

- **Accuracy** = `correct / attempts` in scope; timeouts count as wrong.
- **Median response time**: SQL average of the two middle values; merging several rows uses
  the attempt-weighted mean of the row medians (an approximation, see
  `StatsService.timeSeries` doc comment).
- **Level 1..5**: level 1 below the first threshold *or* fewer than `minAttemptsForLevel` (10)
  attempts, else one level per `levelThresholds = [0.50, 0.65, 0.80, 0.90]`.
  `levelFraction = (level-1)/4`.
- **Trend (7/30 day)**: least-squares `slope` of session accuracy vs. time over the window
  points; `delta` = last minus first session accuracy. `up` when `delta >= 0.05 && slope > 0`,
  `down` when `delta <= -0.05 && slope < 0`, else `flat` (also flat with < 2 sessions).
- **Readiness 0..100** = `100 * (0.6*F + 0.15*L + 0.25*E) / 1.0` (`ReadinessWeights`):
  - `F` = weighted mean of `levelFraction` over every family (MVP families weigh 2, others 1,
    `StatsConfig.familyWeights`/`defaultFamilyWeight`); a never-practised family is level 1
    (contributes 0).
  - `L` = `min(lessonsRead, lessonsTotal) / lessonsTotal`.
  - `E` = mean `score` of the latest `recentExamCount` (3) completed simulations (0 without
    any). Without an exam, readiness tops out at 75 — a simulation is part of being ready.
- **Weak areas**: a family with `attempts >= 10` and lifetime accuracy `< 0.6` is
  `lowAccuracy`; a family with a `down` 30-day trend is `negativeTrend` (both can apply). Item
  tags flagged the same way. Families first, then tags, weakest first.
- **Exam summary**: one `SectionScore` per blueprint section, weighted by `ExamSection.weight`;
  `score = sum(weight_i * accuracy_i) / sum(weight_i)`. `deltaVsPrevious` vs. the latest
  earlier *completed* simulation of the same blueprint.

## Dashboard / charts

`ProgressScreen` renders the snapshot; bands: readiness `<40` error / `<70` warning / else
success (same thresholds for a session score), level `1-2`/`3`/`4-5`. Overall trend arrow =
majority 30-day direction across families with data. Radar chart once >=3 families have data,
else `HorizontalBarChart`. `LineChart` (`shared/widgets/`, see `design-system` skill) draws
accuracy/median-RT-over-time and exam score history; the feature only maps `TrendPoint`s /
`ExamSummary`s to `LineChartPoint`s and writes tooltips/semantics summaries.

## Caching

`progressSnapshotProvider`, `examHistoryProvider`, `familyTimeSeriesProvider` are
`FutureProvider`s that `watch(progressVersionProvider)` — cached until the version bumps:

```dart
await ref.read(progressRepositoryProvider).finishSession(id, status: SessionStatus.completed);
ref.read(progressVersionProvider.notifier).bump();
```

Bump after every session/lesson write that should invalidate the dashboard (the practice
runner, exam runner and lesson-progress feature already do). `familyTimeSeriesProvider` is
keyed by `(familyId, from, to, mode)` (`autoDispose`, shares results across equal queries).
Tests override `statsServiceProvider` with a fixed clock and the two repositories with the
in-memory fakes.

## Streaks and daily goal (US-073)

`StreakService` (pure Dart, injectable clock) takes a flat `ActivityEvent` list (`at`,
`itemCount`, `responseMs`) + a `DailyGoal` and returns a `StreakSummary` (current/best streak,
today's progress, goal-met flag, a heatmap of `DailyActivity`). `streakSummaryProvider` builds
events from `allAttempts()` + `allFlashcardReviews()` (only the latest review per card counts —
a card reviewed twice same day is undercounted by design). Day boundaries are **local
midnight**, not UTC. The streak counts any activity that day regardless of the goal;
goal-met is a separate flag on today's cell only.

## Adding a new metric or formula

1. Add the constant to `StatsConfig` (never hard-code it in the service).
2. Implement it in `StatsService` as a pure function of the rows it already receives, or add a
   new `ProgressRepository` aggregate query if it needs new rows (SQL aggregate, not a raw-row
   loop — see `data-layer` skill, "Aggregates in SQL").
3. Thread it through `ProgressSnapshot` (or a dedicated provider if it's chart-only) and the
   presentation widget.
4. Update `docs/ARCHITECTURE.md` "Progress / analytics" §Formulas with the new rule — that
   section is the single source of truth other stories read before touching this feature.
5. Unit-test the formula in isolation (fixed clock, hand-built rows) before wiring providers.
