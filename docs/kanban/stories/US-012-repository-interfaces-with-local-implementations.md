---
id: US-012
issue: 21
title: "Repository interfaces with local implementations"
type: story
epic: EPIC-02
status: backlog
priority: P0
size: S
lane: core
depends_on: [US-011]
labels: [domain]
---

# US-012 — Repository interfaces with local implementations

**As a** developer **I want** features to depend on `ContentRepository` / `ProgressRepository` interfaces **so that** a remote backend can be added later without touching features.

## Acceptance criteria
- [ ] `ContentRepository`: families, items by family/difficulty/count, lessons, flashcards, blueprints
- [ ] `ProgressRepository`: start/finish session, record attempt, list sessions, item stats, flashcard reviews
- [ ] Local implementations backed by Drift, exposed through Riverpod providers
- [ ] In-memory fake implementations for widget tests
- [ ] No feature imports Drift directly (lint rule or architecture test)
