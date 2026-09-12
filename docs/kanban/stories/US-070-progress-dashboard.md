---
id: US-070
issue: 50
title: "Progress dashboard"
type: story
epic: EPIC-07
status: review
priority: P0
size: M
lane: analytics
depends_on: [US-075,US-003,US-005]
labels: [ui,analytics]
---

# US-070 — Progress dashboard

**As a** candidate **I want** one screen that tells me how ready I am **so that** I can steer my training.

## Acceptance criteria
- [x] Readiness score gauge + trend arrow, days until exam (US-090)
- [x] Radar/bar chart of family levels
- [x] Recent activity list (sessions & sims)
- [x] Empty state guiding to the first drill

## Notes
- Charts are `CustomPaint` primitives in `lib/shared/widgets/` (`ArcGauge`, `RadarChart`,
  `HorizontalBarChart`), no chart package (see `docs/DESIGN_SYSTEM.md`).
- `examDateProvider` reads `UserProfile.examDate`; re-point it at the profile provider US-090
  introduces so an edited date refreshes without a `progressVersionProvider` bump.
- "S'entraîner" on a weak area opens the Train tab; US-072 targets the family directly.
- Radar when at least 3 families have data, horizontal bars below that (`progress_bands.dart`
  and `docs/ARCHITECTURE.md` "Dashboard (US-070)" for the presentation rules).
