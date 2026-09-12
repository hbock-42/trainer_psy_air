---
id: US-102
issue: 70
title: "PSY1: joystick psychomotor engine (gamepad input)"
type: story
epic: EPIC-10
status: backlog
priority: P2
size: L
lane: engines
depends_on: [US-101,US-036]
labels: [engine,psychomotor,gamepad,psy1]
---

# US-102 — PSY1: joystick psychomotor engine (gamepad input)

Spec §2.3-13: 18 min = 6 × 3 min phases; left stick + 2 buttons re-centre 4 drifting gauges, right stick tracks a crosshair (2-axis proportional), F1–F9 cancel target letters, numpad answers an addition every 12 s; tasks layer in over phases 1–3; **any sub-task entering its red zone zeroes the test**.
- [ ] Gamepad abstraction `lib/core/input/gamepad.dart`: `gamepads` package (desktop native + web Gamepad API), stream of axes/buttons for up to 2 sticks, calibration/dead-zone, keyboard fallback flagged non-representative; a settings page to map sticks/buttons
- [ ] Simulation (pure Dart, ticks): gauge drift, crosshair trajectory, letter and arithmetic streams, per-channel live scores with red zones, phase schedule from params
- [ ] Renderer: `CustomPainter` scene driven by a `Ticker` + gamepad stream; desktop/web only; touch shows a notice + skip
- [ ] Scorer: per-channel metrics + the zeroing rule; practice mode shows per-channel timelines
- [ ] Tests: simulation determinism, red-zone rule, input mapping, SessionHost run with a fake gamepad stream
