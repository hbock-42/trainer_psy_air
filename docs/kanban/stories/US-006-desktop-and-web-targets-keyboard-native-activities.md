---
id: US-006
issue: 88
title: "Desktop and web targets (keyboard-native activities)"
type: story
epic: EPIC-01
status: review
priority: P0
size: S
lane: core
depends_on: [US-001]
labels: [setup,platform]
---

# US-006 — Desktop and web targets (keyboard-native activities)

**As a** candidate **I want** to run the trainer on my computer **so that** keyboard-native activities (Formes et couleurs, multitask) rehearse like the real desktop app (spec §4.4).

## Acceptance criteria
- [x] `flutter create --platforms=macos,windows,web .` added; app runs on macOS and web (Chrome); Windows config committed even if not built locally
- [x] Window defaults for desktop (min size ~1024×700), `WidgetsApp` unchanged
- [x] CI: `flutter build web` in the `check` job (fast) — desktop builds not required in CI
- [x] `docs/ARCHITECTURE.md` platform section: phone = learn/practice, desktop/web/tablet+keyboard = exam mode; keyboard input abstraction note for engines
