---
id: US-090
issue: 64
title: "Onboarding: exam date, target stage, disclaimer"
type: story
epic: EPIC-09
status: review
priority: P1
size: S
lane: misc
depends_on: [US-005,US-011]
labels: [ui,onboarding]
---

# US-090 — Onboarding: exam date, target stage, disclaimer

- [x] 3 screens: welcome + disclaimer (must accept), exam date (optional), target stage (PSY0 default)
- [x] Stored in `user_profile`; route guard (US-002) sends new users here
- [x] Skippable, editable later in Settings

## Notes (implementation)

- `lib/features/onboarding/`: `domain/` (`TargetStage`, `OnboardingAnswers` <-> `UserProfile`
  mapping, `exam_date_rules.dart`: next first-Saturday-of-September suggestion, no past date),
  `presentation/widgets/` (`OnboardingFlow` with the three steps, `AcceptToggle`,
  `DateStepperField` built from design-system primitives, no platform date picker).
- Persistence: `examDate` / `targetStage` in the typed profile columns; `onboardingCompleted`
  and `disclaimerAcceptedAt` in the profile's free-form `settings` JSON, so no schema migration.
- `onboardingCompletedProvider` is hydrated from the repository (`null` -> `bool`); the router
  awaits it on the first redirect (no onboarding flash for returning users).
- Skip (from step 2 on) saves the defaults with the disclaimer accepted. Settings has
  "Modifier mon profil" -> `/settings/profile`, which replays the flow prefilled.
