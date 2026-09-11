---
id: US-003
issue: 16
title: "Design system: theme, typography and shared widgets"
type: story
epic: EPIC-01
status: backlog
priority: P0
size: M
lane: design
depends_on: [US-001]
labels: [ui]
---

# US-003 — Design system: theme, typography and shared widgets

**As a** user **I want** a consistent, calm, high-contrast UI **so that** training feels like a serious tool and stays readable under time pressure.

## Acceptance criteria
- [ ] Light + dark `ThemeData`, color tokens, spacing scale, text styles
- [ ] Shared widgets in `lib/shared/widgets`: `CountdownTimerBar`, `ProgressDots`, `AnswerOptionTile` (idle/selected/correct/wrong states), `ScoreCard`, `PrimaryButton`, `SectionHeader`
- [ ] Widget tests + a `widgetbook`/gallery screen (debug only) to preview them
- [ ] Minimum touch target 48dp, respects system text scaling up to 1.3

## Parallel
Can start right after US-001, independently from US-002.
