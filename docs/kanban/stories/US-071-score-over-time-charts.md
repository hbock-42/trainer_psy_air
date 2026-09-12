---
id: US-071
issue: 51
title: "Score-over-time charts"
type: story
epic: EPIC-07
status: review
priority: P0
size: M
lane: analytics
depends_on: [US-070]
labels: [ui,analytics,chart]
---

# US-071 — Score-over-time charts

**As a** candidate **I want** to see my scores over time per family and for exam simulations **so that** I can see my improvement.

## Acceptance criteria
- [x] Line chart per family: accuracy and speed over sessions, 7d/30d/all range selector
- [x] Exam-sim chart: global score per attempt with per-section breakdown on tap
- [x] Tooltips, readable in dark mode, follows the dataviz guidelines of the design system
- [x] Widget tests with fixture data

## Notes
- No `fl_chart` (needs Material): `LineChart` is a `CustomPaint` primitive in
  `lib/shared/widgets/line_chart.dart` (multi-series, ticks, hover / press tooltip, persistent
  selection, semantics summary), documented in `docs/DESIGN_SYSTEM.md`.
- Family charts live on `/progress/family/:familyId` (`FamilyTrendScreen`): accuracy and median
  response time as two stacked charts, `7 j / 30 j / Tout` range and `Tous / Exercices /
  Simulations` mode filters, tooltips with date, kind, `correct/attempts (%)` and time. Opened
  from the chips under the family levels chart of the dashboard (the painted radar labels are
  not tappable).
- `ExamScoreChartCard` on the dashboard plots the global score of completed simulations, oldest
  first; tapping a point expands the per-section bars (readiness bands) under the chart. Hidden,
  header included, until a simulation is completed.
- `x` is the session index (evenly spaced), not time: sessions of one day would overlap. The
  date ticks under the baseline keep the time reading.
