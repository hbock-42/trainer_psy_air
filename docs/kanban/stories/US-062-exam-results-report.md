---
id: US-062
issue: 47
title: "Exam results report"
type: story
epic: EPIC-06
status: review
priority: P0
size: M
lane: exam-ui
depends_on: [US-061,US-075]
labels: [ui,exam,analytics]
---

# US-062 — Exam results report

**As a** candidate **I want** a detailed report after a simulation **so that** I know where I stand.

## Acceptance criteria
- [x] Global score + per-section score, accuracy, speed, timeouts count
- [x] Comparison with my previous simulations (delta per section) and with the estimated pass threshold (configurable, from US-080, shown as "estimated")
- [x] Review of all items with my answers and explanations (available only after the exam)
- [x] Report stored; reachable from exam history (US-064) and Progress tab

`ExamReportScreen` (`/exam/report/:sessionId`) reads only persisted rows
(`examReportProvider`): the global/per-section score, accuracy, median
response time and timeouts come from `StatsService.examSummary` (US-075) via
`ProgressAnalytics`; the delta vs. the previous completed simulation of the
same blueprint is global (`ExamSummary.deltaVsPrevious`) and per-section
(diffed here against the previous summary's sections, matched by
`sectionIndex` — `StatsService` only computes the global one); the estimated
pass threshold is `ExamPassThresholds` (`features/exam/domain/
exam_pass_thresholds.dart`), a configurable constant per blueprint id, always
shown as "estimation". The item review reconstructs every played item from
the session's stored per-section `ActivitySessionConfig`s and its `Attempt`s
(`features/exam/domain/exam_review.dart`, `buildExamReview`) and reuses
`ItemReviewText` from the practice summary (US-052) rather than duplicating
it. Reachable from `/exam/history` (US-064) and, unchanged, from the
Progress tab's `ExamScoreChartCard`. Tests:
`test/features/exam/domain/exam_review_test.dart`,
`test/features/exam/presentation/exam_report_provider_test.dart`.
