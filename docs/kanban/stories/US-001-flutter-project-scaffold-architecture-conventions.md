---
id: US-001
title: "Flutter project scaffold & architecture conventions"
type: story
epic: EPIC-01
status: backlog
priority: P0
size: S
lane: core
depends_on: []
labels: [setup]
---

# US-001 — Flutter project scaffold & architecture conventions

**As a** developer **I want** a Flutter project with an agreed structure and toolchain **so that** several people can work in parallel without stepping on each other.

## Acceptance criteria
- [ ] `flutter create` done with org id, app name `psy_trainer` (working title), Android + iOS targets (web optional)
- [ ] Feature-first layout documented in `docs/ARCHITECTURE.md`: `lib/core`, `lib/features/<feature>/{data,domain,presentation}`, `lib/shared`
- [ ] Stack decisions recorded (Riverpod, go_router, freezed, Drift, fl_chart) — or alternatives chosen and justified
- [ ] `analysis_options.yaml` with `flutter_lints` + stricter rules (`prefer_const`, `always_declare_return_types`, …)
- [ ] `build_runner` configured, `make gen` / script for codegen
- [ ] README with setup steps; `flutter run` works on a fresh clone

## Notes
Keep it small — this story unblocks everyone, do not gold-plate.
