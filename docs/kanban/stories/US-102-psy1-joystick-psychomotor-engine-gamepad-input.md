---
id: US-102
issue: 70
title: "PSY1: joystick psychomotor engine (gamepad input)"
type: story
epic: EPIC-10
status: done
priority: P2
size: L
lane: engines
depends_on: [US-101,US-036]
labels: [engine,psychomotor,gamepad,psy1]
---

# US-102 — PSY1: joystick psychomotor engine (gamepad input)

Spec §2.3-13: 18 min = 6 × 3 min phases; left stick + 2 buttons re-centre 4 drifting gauges, right stick tracks a crosshair (2-axis proportional), F1–F9 cancel target letters, numpad answers an addition every 12 s; tasks layer in over phases 1–3; **any sub-task entering its red zone zeroes the test**.
- [x] Gamepad abstraction `lib/core/input/gamepad/`: `GamepadService` interface (per-device stick/button state, dead zone, devices, `calibrate()`), a real implementation on the `gamepads` pub package (pinned `0.1.11`, desktop native + web Gamepad API), a `KeyboardGamepadService` fallback (WASD/arrows + digits 1/2, flagged non-representative), a `FakeGamepadService` for tests; Settings → "Manettes" section (detected devices, live axis view, dead zone, gauge-button mapping) persisted at `UserProfile.settings['gamepad']`
- [x] Simulation (pure Dart, deterministic from `runSeed`): 4 gauges drifting with seeded noise (nulled by left-stick Y after selection), a crosshair trajectory (right stick, documented proportional control law), a 9-letter panel with 3 rotating targets, an arithmetic stream every 12 s; a 6-phase schedule layering the 4 channels in over phases 1-3 with per-phase attention-weighting guidance; per-channel live scores (0-100, smoothed) with the red-zone zeroing rule (first trigger recorded and permanent for the run)
- [x] Renderer: `CustomPainter` cockpit scene (gauges, crosshair circle, letter grid, arithmetic box, per-channel score bars with a red-zone line), driven by a `Ticker` + `GamepadService`/keyboard; desktop/web (and Android/iOS, via the same package) in exam mode, touch-only devices with no keyboard get a notice + `SkipAnswer`; practice mode shows a per-channel score-history summary (`LineChart`s) once the run ends
- [x] Scorer: per-channel metrics + the zeroing rule as the pass/fail criterion; summary explanation surfaced in practice mode
- [x] Tests: simulation determinism/control-law/phase-schedule/red-zone-permanence unit tests, gamepad abstraction unit tests (`FakeGamepadService`, dead zone, calibration), a `SessionHost` run with a fake gamepad stream + physical key events (exam completion, exam no-device skip, practice per-channel summary)

**Notes (implementation, for the reviewer):**
- The published `gamepads` 0.1.11 package has no connect/disconnect event stream (only in an unreleased newer version); `GamepadsPackageService` polls `Gamepads.list()` every second instead. Fine for a settings-page/pre-run device list; flagging in case a future story wants to bump the pin once a version with connection events ships.
- `family.json`/both blueprints model this family as `phaseCount` (6) generated items, one per 3-minute phase, rather than a single item the way `multitask_psychomotor` (US-036) does. The engine honours that literally: one continuous autonomous timeline (`P1PsychomotorSimulation`) spans the whole run, but the live, user-driven half (gauge displacement, cursor position, hit/miss counts) is kept in a `P1PsychomotorRunState` cached by `runSeed` (`P1PsychomotorRunCache`) so it survives the fresh `State` each phase-item gets (`ActivityRenderer`'s `ValueKey(item.id)` convention). This works but is more complex than the single-item pattern; worth reconsidering `itemCount: 1` (with the engine looping its own 6 phases internally, as `multitask_psychomotor` does for its one 5-minute run) in a follow-up if this proves fragile in practice — not changed here per the "never edit the content contract to fix a default you disagree with" rule.
- The exact per-phase channel/weight composition (§2.3 row 13 gives only "tasks layer in over phases 1-3" and one example, "phase 5 emphasises letters+calcs at 40%") is this engine's own reasonable reading (`P1PsychomotorPhaseSchedule`), matching `family.json`'s own `confidence: reported` (structure) vs the schedule's finer detail being closer to `[estimated]`. Per-phase weighting is HUD-only guidance in this MVP — it does not change event rates/difficulty, a scope cut documented in the class doc.
- No touch fallback is offered in practice mode (unlike `multitask_psychomotor`'s on-screen D-pad): two of the four channels need continuous proportional dual-stick input a touch surface cannot approximate at all, so a degraded touch rehearsal would teach the wrong reflexes. Touch always sees the "device required" notice + skip.
- The gauge-nulling control law (`correction = -stickY * gaugeCorrectionRate`) and the crosshair's proportional law (`velocity = stick * maxSpeed`) are this engine's own documented choices — the spec names the paradigms ("select and re-centre", "direct, continuous, 2-axis proportional control") but not a formula.
