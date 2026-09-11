---
id: US-020
title: "Generic test engine runtime"
type: story
epic: EPIC-03
status: backlog
priority: P0
size: M
lane: engines
depends_on: [US-010]
labels: [engine,blocking]
---

# US-020 — Generic test engine runtime

**As a** developer **I want** one runtime that sequences items, runs timers, captures answers and scores **so that** every family engine only implements item generation + rendering.

## Design
- `TestSession` state machine: `briefing → running(itemIndex) → paused? → finished`
- `SessionMode` = `practice` (feedback after each item, pause allowed) | `exam` (no feedback, no back, no pause)
- Timer policy per section: per-item time limit, per-section time limit, or both; auto-advance on timeout, timeout recorded as `answer = null`
- `ItemSource` abstraction: `BankSource(items)` or `GeneratorSource(generator, seed, count)` — a seed makes an exam reproducible
- `Scorer` per item type; section score = correct / total, plus mean response time
- Emits `Attempt`s to `ProgressRepository` as they happen (crash-safe)

## Acceptance criteria
- [ ] Pure Dart, no Flutter imports in `domain/`; 100 % unit-tested state machine (timeouts, pause, abort, finish)
- [ ] `ItemGenerator` interface + registry keyed by `engineType`
- [ ] Example fake generator used in tests
- [ ] Documented in `docs/ARCHITECTURE.md#engine`
