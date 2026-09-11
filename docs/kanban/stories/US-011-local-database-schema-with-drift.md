---
id: US-011
issue: 20
title: "Local database schema with Drift"
type: story
epic: EPIC-02
status: backlog
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
- [ ] Drift tables + DAOs, migrations strategy from schema v1, `schemaVersion` bump documented
- [ ] All rows have uuid ids + `createdAt/updatedAt` (future remote sync, EPIC-13)
- [ ] DAO tests with in-memory database
- [ ] Indexes on (`sessions.startedAt`), (`attempts.sessionId`), (`items.familyId, difficulty`)
