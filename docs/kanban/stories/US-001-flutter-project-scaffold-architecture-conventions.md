---
id: US-001
issue: 14
title: "Flutter project scaffold & architecture conventions"
type: story
epic: EPIC-01
status: review
priority: P0
size: S
lane: core
depends_on: []
labels: [setup]
---

# US-001 — Flutter project scaffold & architecture conventions

**As a** developer **I want** a Flutter project with an agreed structure and toolchain **so that** several people can work in parallel without stepping on each other.

## UI constraint (project-wide)
**No Material, no Cupertino.** The app uses `WidgetsApp` (not `MaterialApp`/`CupertinoApp`) and
builds its own widgets on top of the `widgets` layer only (`package:flutter/widgets.dart`).
`package:flutter/material.dart` and `package:flutter/cupertino.dart` must not be imported anywhere
in `lib/` (enforced by a lint/architecture test). Third-party packages that require a Material
ancestor are out; prefer widget-layer-only packages or write it ourselves.

## Acceptance criteria
- [x] `flutter create` done with org id, app name `psy_trainer` (working title), Android + iOS targets (web optional)
- [x] Feature-first layout documented in `docs/ARCHITECTURE.md`: `lib/core`, `lib/features/<feature>/{data,domain,presentation}`, `lib/shared`
- [x] Stack decisions recorded (Riverpod, go_router, freezed, Drift, fl_chart) — or alternatives chosen and justified (fl_chart deferred: to be checked for Material dependency before adoption; `sqlite3` 3.x replaces the discontinued `sqlite3_flutter_libs`)
- [x] Root is a `WidgetsApp`; a test fails if `material.dart` or `cupertino.dart` is imported under `lib/`
- [x] `analysis_options.yaml` with `flutter_lints` + stricter rules (`prefer_const`, `always_declare_return_types`, …)
- [x] `build_runner` configured, `make gen` / script for codegen
- [x] README with setup steps; `flutter run` works on a fresh clone

## Notes
Keep it small — this story unblocks everyone, do not gold-plate.
