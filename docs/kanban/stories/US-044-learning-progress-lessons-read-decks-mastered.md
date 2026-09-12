---
id: US-044
issue: 39
title: "Learning progress (lessons read, decks mastered)"
type: story
epic: EPIC-04
status: done
priority: P1
size: S
lane: learn-ui
depends_on: [US-041,US-011]
labels: [learn,analytics]
---

# US-044 — Learning progress (lessons read, decks mastered)

**As a** candidate **I want** to see which lessons I have read **so that** I know what is left.

## Acceptance criteria
- [x] Lesson marked read when scrolled to the end (or after 20 s for a lesson short enough that it
  never needs scrolling); manual toggle in the lesson screen's top bar. Deviation:
  `ProgressRepository.markLessonRead` is idempotent and one-way (no `unmarkLessonRead`); the manual
  toggle can mark a lesson read but not back to unread — adding an unmark method touches
  `core/repositories/**`, out of this card's scope (touches only `lib/features/learn/**` etc.)
- [x] Family progress ring = read lessons / total (`ArcGauge` on the family page's "Leçons" section);
  the learn-home card's mastery slot shows the same ratio while `familyMasteryProvider` is still null
  (no stats yet, US-075). Feeding the readiness score (US-070) is a separate follow-up: `StatsService`
  already reads `lessonsRead()` there and is unaffected by this card.
