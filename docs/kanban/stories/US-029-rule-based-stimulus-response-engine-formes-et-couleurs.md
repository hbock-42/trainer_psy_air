---
id: US-029
issue: 33
title: "Rule-based stimulus–response engine (Formes et couleurs)"
type: story
epic: EPIC-03
status: done
priority: P0
size: M
lane: engines
depends_on: [US-020,US-003]
labels: [engine,generator,mvp,keyboard]
---

# US-029 — Rule-based stimulus–response engine (Formes et couleurs)

**As a** candidate **I want** to drill *Formes et couleurs* **so that** I apply conditional rules under time pressure without freezing.

Real test (spec §2.4-C): rules given at start (e.g. *filled → N for square / X for triangle; empty → N for blue / X for orange*); a shape flashes 0.5 s every 3 s; press the key; live right/wrong feedback; 20–41 stimuli (~2 min); shapes/colours/keys vary per session.

## Acceptance criteria
- [x] Generator: random rule set (2 conditions × 2 outcomes, 2 keys) + stimulus sequence balanced across rule branches; difficulty = rule complexity / cadence; deterministic per seed
- [x] Renderer on fixed cadence: rule reminder only on the briefing screen, stimulus flash, keyboard input (physical keys) with on-screen buttons as touch fallback labelled "non-representative"; live feedback shown even in exam mode (`liveFeedbackInExam`)
- [x] Scorer: accuracy, reaction time, timeouts
- [x] Unit tests: sequence balance, cadence with `fake_async`
