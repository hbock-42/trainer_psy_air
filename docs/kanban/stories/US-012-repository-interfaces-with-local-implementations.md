---
id: US-012
issue: 21
title: "Repository interfaces with local implementations"
type: story
epic: EPIC-02
status: done
priority: P0
size: S
lane: core
depends_on: [US-011]
labels: [domain]
---

# US-012 — Repository interfaces with local implementations

**As a** developer **I want** features to depend on `ContentRepository` / `ProgressRepository` interfaces **so that** a remote backend can be added later without touching features.

## Acceptance criteria
- [x] `ContentRepository`: families, items by family/difficulty/count, lessons, flashcards, blueprints
- [x] `ProgressRepository`: start/finish session, record attempt, list sessions, item stats, flashcard reviews
- [x] Local implementations backed by Drift, exposed through Riverpod providers
- [x] In-memory fake implementations for widget tests
- [x] No feature imports Drift directly (lint rule or architecture test)

## Implementation notes
- Interfaces, domain models (`TrainingSession`, `Attempt`, `NewAttempt`, `ItemStat`,
  `FamilyStats`, `FlashcardReview`, `LessonRead`, `UserProfile`, `ContentInfo`), providers
  and fakes in `lib/core/repositories/` (every feature reads them, so not a single feature's
  `domain/`); barrel file `repositories.dart`.
- Local implementations in `lib/core/db/repositories/`; `contentRepositoryProvider` /
  `progressRepositoryProvider` bind them, widget tests override with the `InMemory*` fakes.
- Both implementations pass the same contract tests
  (`test/core/repositories/*_contract.dart`).
- `test/architecture/no_drift_in_features_test.dart` forbids `package:drift`,
  `package:sqlite3` and `core/db/` imports under `lib/features/`.
