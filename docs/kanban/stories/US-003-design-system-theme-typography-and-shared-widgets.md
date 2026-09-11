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

## UI constraint (project-wide)
**No Material, no Cupertino.** The app uses `WidgetsApp` (not `MaterialApp`/`CupertinoApp`) and
builds its own widgets on top of the `widgets` layer only (`package:flutter/widgets.dart`).
`package:flutter/material.dart` and `package:flutter/cupertino.dart` must not be imported anywhere
in `lib/` (enforced by a lint/architecture test). Third-party packages that require a Material
ancestor are out; prefer widget-layer-only packages or write it ourselves.

## Acceptance criteria
- [ ] Own `AppTheme` (InheritedWidget) with light + dark palettes — no `ThemeData`, color tokens, spacing scale, text styles
- [ ] Shared widgets in `lib/shared/widgets`: `CountdownTimerBar`, `ProgressDots`, `AnswerOptionTile` (idle/selected/correct/wrong states), `ScoreCard`, `PrimaryButton`, `SectionHeader`
- [ ] Widget tests + a hand-made gallery screen (debug only) to preview them
- [ ] Minimum touch target 48dp, respects system text scaling up to 1.3

## Parallel
Can start right after US-001, independently from US-002.
