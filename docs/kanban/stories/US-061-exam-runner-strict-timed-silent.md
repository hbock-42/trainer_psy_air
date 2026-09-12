---
id: US-061
issue: 46
title: "Exam runner (strict, timed, silent)"
type: story
epic: EPIC-06
status: review
priority: P0
size: L
lane: exam-ui
depends_on: [US-020,US-060,US-021,US-022]
labels: [ui,exam]
---

# US-061 — Exam runner (strict, timed, silent)

**As a** candidate **I want** a full-length timed simulation with no feedback **so that** I experience the real pressure.

## Acceptance criteria
- [x] Briefing screen per section (instructions, duration, item count) with "Start" — mimics the real flow
- [x] Section timer + optional per-item timer, auto-advance, no back, no pause; quitting = abort with confirmation
- [x] Between sections: optional short break with countdown
- [x] Screen stays awake; interruptions (call, background) handled: timer keeps running, state persisted every attempt
- [x] Ends on a "Computing results…" screen → US-062
- [x] Widget/integration test with a 2-section blueprint and fake generators

Implemented as `ExamRunController` (`features/exam/presentation/exam_run_controller.dart`),
a Riverpod Notifier that plans the blueprint's available sections
(`features/exam/domain/exam_section_planner.dart`), opens one `TrainingSession`
(storing every section's `ActivitySessionConfig` for later review) and runs
each through `SessionHost` in exam mode (`ActivitySessionConfig.mode = exam`,
`ownsSession: false`, `sectionIndex`/`positionOffset`); the runtime already
enforces no-back/no-pause/no-feedback for exam mode outside `liveFeedback`.
The per-section briefing (instructions/example/item count/Start) is
`SessionHost`'s own, extended with duration and a keyboard-only warning baked
into the section's `briefing` text. Quitting asks for confirmation
(`ExamRunScreen`) then aborts the whole exam (`SessionStatus.abandoned`); a
section whose engine isn't registered is skipped by the planner. Breaks use
`EngineClock.schedule` (testable with `ManualClock`), ending on
"Calcul des résultats…" → `/exam/report/:sessionId` (US-062). Tests:
`test/features/exam/presentation/exam_run_controller_test.dart` (2-section
sequencing with a break, abort, an unavailable middle section skipped, and a
fully-unavailable blueprint).
