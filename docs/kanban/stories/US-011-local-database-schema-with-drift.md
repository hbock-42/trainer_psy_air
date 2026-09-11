---
id: US-011
issue: 20
title: "Local database schema with Drift"
type: story
epic: EPIC-02
status: review
priority: P0
size: M
lane: core
depends_on: [US-010]
labels: [db]
---

# US-011 — Local database schema with Drift

**As a** user **I want** my sessions and answers stored on device **so that** progress survives restarts and works offline.

## Tables (proposal)
- `content_meta` (contentVersion, seededAt)
- `items`, `lessons`, `flashcards`, `blueprints` (mirrors of the seeded JSON, indexed by family/difficulty)
- `sessions` (id uuid, mode practice|exam, familyId?, blueprintId?, startedAt, endedAt, status, score, config json)
- `attempts` (sessionId, itemId or generator+seed, answer json, isCorrect, responseMs, order)
- `item_stats` (itemId, seen, correct, lastSeenAt) — for "retry mistakes" and adaptive difficulty
- `flashcard_reviews` (flashcardId, box, nextReviewAt)
- `lesson_progress` (lessonId, readAt)
- `user_profile` (examDate, targetStage, locale, settings json)

## Acceptance criteria
- [x] Drift tables + DAOs, migrations strategy from schema v1, `schemaVersion` bump documented
- [x] All rows have uuid ids + `createdAt/updatedAt` (future remote sync, EPIC-13)
- [x] DAO tests with in-memory database
- [x] Indexes on (`sessions.startedAt`), (`attempts.sessionId`), (`items.familyId, difficulty`)

## Implementation notes
- Code in `lib/core/db/` (`app_database.dart`, `tables/`, `daos/`, `repositories/`,
  `content_rows.dart`); design and the full schema table in `docs/ARCHITECTURE.md` ("Data layer").
- Added `modules`, `families` and `decks` mirrors on top of the proposal so `ContentRepository`
  can serve families/decks without touching assets; decks are stored without cards.
- `attempts` carries `familyId` (denormalised), `position` (the `order` of the card, renamed
  to avoid the SQL keyword), `sectionIndex` and `answeredAt`; generated items store
  `origin = {generatorId, seed, params}` instead of an `itemId`.
- Content mirrors are keyed by the content id, not a uuid: it is the stable identity of the
  bundle and re-seeding replaces the rows wholesale.
- Dates are ISO-8601 UTC text with millisecond precision (several attempts per second).
- Aggregates (per-family accuracy, mean and median RT) run in SQL with window functions.
