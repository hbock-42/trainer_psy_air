---
id: US-020
issue: 24
title: "Generic activity engine runtime"
type: story
epic: EPIC-03
status: backlog
priority: P0
size: M
lane: engines
depends_on: [US-010,US-015]
labels: [engine,blocking]
---

# US-020 — Generic activity engine runtime

**As a** developer **I want** one runtime that sequences items, runs timers/cadence, captures answers and scores **so that** every activity engine only implements its generator, its renderer and its scorer.

## Design
- `ActivitySession` state machine: `briefing(example) → running(itemIndex) → finished`; exam mode has no pause/back; practice mode allows pause and shows feedback.
- `SessionMode` = `practice` | `exam`; an activity may declare `liveFeedbackInExam: true` (rules S-R, parity restart) — see spec §2.4.
- Timing policies (all combinable, from the blueprint section): per-item limit, per-section limit, **fixed cadence** (stimulus every N ms, answer window M ms, missing answer = error), auto-advance on timeout.
- `ItemSource`: `BankSource(items)` | `GeneratorSource(generatorId, seed, params, count)`; seeded → an exam is reproducible.
- `ActivityEngine` interface: `generate(seed, params, difficulty)`, `build(item, mode, callbacks)` (widget), `score(item, answer)`; registry keyed by `familyId`/`generatorId`.
- `Scorer` outputs per-item correctness + response time; section score = accuracy, mean RT, timeouts; optional scoring policy `{correct, wrong, skip}` for negative marking (culture, dominos).
- Emits `Attempt`s to `ProgressRepository` as they happen (crash-safe, resume).

## Acceptance criteria
- [ ] Pure Dart in `lib/features/train/domain/` (no Flutter imports); state machine 100 % unit-tested (timeouts, cadence, pause, abort, finish, live-feedback flag)
- [ ] `ActivityEngine` + registry + a fake engine used in tests
- [ ] Clock injected (`fake_async` friendly)
- [ ] Documented in `docs/ARCHITECTURE.md#engine`
