---
id: US-050
issue: 40
title: "Practice launcher"
type: story
epic: EPIC-05
status: review
priority: P0
size: S
lane: train-ui
depends_on: [US-005,US-020]
labels: [ui,practice]
---

# US-050 — Practice launcher

**As a** candidate **I want** to configure a drill **so that** I train exactly what I need.

## Acceptance criteria
- [x] Choose family, number of items (5/10/20/50), difficulty (auto / 1–5), timed per item on/off
- [x] Last configuration remembered per family
- [x] "Quick 5" shortcut (Train home's family row and the launcher itself); the
      Learn home / family card wiring stays out of this story's file scope
      (`lib/features/learn/**`) — its "S'entraîner" action already lands on
      the launcher via `AppRoutes.trainFamily`, where Quick 5 is one tap away

## Notes
- Train home (`/train`): the 14 PSY0 families in real-test order from
  `ContentRepository`, each flagged via `engineRegistryProvider.hasFamily` —
  unavailable ones show "Bientôt" and are disabled.
- `/train/family/:familyId` launcher builds a `PracticeConfig` (item count,
  difficulty, timed) and turns it into an `ActivitySessionConfig` via
  `buildActivitySessionConfig`: `ItemSource.generator` (fresh seed each run)
  for families with a `generatorId`, `ItemSource.bank` (tag-balanced
  round-robin sample) otherwise. The config is handed to `/train/session`
  through `context.push`'s `extra`; `TrainSessionScreen` shows a French
  summary until US-051 replaces it.
- Last configuration is stored in
  `UserProfile.settings['practice.<familyId>']`.
- US-054 hook: a disabled "Reprendre mes erreurs (bientôt)" entry sits on the
  launcher as the stub the retry-mistakes story will wire up.
