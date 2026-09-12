---
id: EPIC-01
issue: 1
title: "Foundation & architecture"
type: epic
status: done
priority: P0
lane: core
---

# EPIC-01 — Foundation & architecture

Flutter project skeleton, architecture conventions, design system, navigation shell and CI.
Everything else builds on this; it must be done first and fast (target: a few days).

## Goal
A running app with 5 tabs (Learn / Train / Exam / Progress / Settings), a documented
folder structure, theming, state management and routing wired, CI green on every PR.

## Proposed stack (to confirm in US-001)
- Flutter stable, Dart 3, feature-first folder layout (`lib/features/<feature>/{data,domain,presentation}`)
- Riverpod (state + DI), go_router (navigation), freezed + json_serializable (models)
- Drift (SQLite) for the local database — see EPIC-02
- fl_chart for progress charts
- flutter_localizations + ARB for FR/EN

## UI constraint (project-wide)
**No Material, no Cupertino.** The app uses `WidgetsApp` (not `MaterialApp`/`CupertinoApp`) and
builds its own widgets on top of the `widgets` layer only (`package:flutter/widgets.dart`).
`package:flutter/material.dart` and `package:flutter/cupertino.dart` must not be imported anywhere
in `lib/` (enforced by a lint/architecture test). Third-party packages that require a Material
ancestor are out; prefer widget-layer-only packages or write it ourselves.

## Stories
US-001, US-002, US-003, US-004, US-005

## Done when
All P0 stories done, `flutter analyze` and `flutter test` pass in CI, app runs on Android + iOS.
