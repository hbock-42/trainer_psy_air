# Architecture

Conventions for the PSY Trainer Flutter app. Established in US-001; amend this file when a
decision changes (and say why in the PR).

## Folder layout (feature-first)

```
lib/
  main.dart                  # entry point: runApp(PsyTrainerApp())
  app.dart                   # root WidgetsApp
  core/                      # cross-cutting infrastructure, no UI: database, routing
                             # setup, DI wiring, error/logging, constants, extensions
  shared/                    # reusable UI + small helpers used by several features:
                             # design system (theme, buttons, text styles, scaffold),
                             # generic widgets, formatters
  features/
    <feature>/
      data/                  # repositories impl, data sources (Drift DAOs, JSON loaders),
                             # DTOs and mappers
      domain/                # entities/value objects (freezed), repository interfaces,
                             # pure logic (test generators, scoring)
      presentation/          # screens, widgets, Riverpod providers/notifiers, routes
test/
  architecture/              # rules about the codebase itself (e.g. no Material)
  features/<feature>/...     # mirrors lib/features; unit + widget tests
  app_test.dart              # smoke test of the root widget
docs/
  ARCHITECTURE.md            # this file
  kanban/                    # epics, stories, board (see docs/kanban/README.md)
```

Initial features: `learn`, `train`, `exam`, `progress`, `settings`. Add a feature by creating
`lib/features/<name>/{data,domain,presentation}`; do not add new top-level folders without a
kanban card.

Dependency direction: `presentation -> domain <- data`. `domain` never imports Flutter widgets,
Drift, or anything from `presentation`. Features may depend on `core` and `shared`; `core` and
`shared` never import from `features`. Cross-feature imports go through a `domain` interface, not
into another feature's `presentation` or `data`.

## Stack

| Concern        | Choice                          | Notes |
|----------------|---------------------------------|-------|
| UI toolkit     | `package:flutter/widgets.dart` only | **No Material, no Cupertino** (see below) |
| State + DI     | `flutter_riverpod`              | Providers live next to the feature that owns them; wired in US-002 |
| Navigation     | `go_router`                     | Works with `WidgetsApp.router`; wired in US-002 |
| Models         | `freezed` + `json_serializable` | Immutable entities, `copyWith`, JSON for content files |
| Local database | `drift` on `package:sqlite3` 3.x | `sqlite3` bundles the native library through Dart hooks, so `sqlite3_flutter_libs` (now discontinued) is not needed. Schema in EPIC-02 |
| IDs / paths    | `uuid`, `path`, `path_provider` | |
| Charts         | not decided                     | `fl_chart` was proposed but its widgets build on Material; to be checked in US-07x (either confirm it works without a Material ancestor or draw with `CustomPainter`) |
| Lints          | `flutter_lints` + stricter rules in `analysis_options.yaml` | `custom_lint` was dropped: its analyzer pin conflicts with `drift_dev` |

Versions are pinned with caret constraints in `pubspec.yaml` and locked in `pubspec.lock`
(committed). Some packages have newer releases that require a newer Dart SDK than the one shipped
with Flutter 3.41.x; bump them together with the Flutter version.

## No Material, no Cupertino

The root widget is `WidgetsApp`, not `MaterialApp`/`CupertinoApp`, and nothing under `lib/` may
import `package:flutter/material.dart` or `package:flutter/cupertino.dart`. This is enforced by
`test/architecture/no_material_cupertino_test.dart`, which scans `lib/` and fails on any such
import (including `show`/`hide`/`as` forms). Third-party packages whose widgets require a Material
ancestor (`Theme.of`, `Scaffold`, `Material` for ink) are not allowed; prefer widget-layer packages
or write the widget ourselves.

What this implies in practice:

- **Text styling.** `WidgetsApp` provides no `DefaultTextStyle`; text without one renders with the
  yellow "missing style" underline. The root `builder` in `lib/app.dart` installs a
  `DefaultTextStyle` and a background `ColoredBox`. Any new route or overlay you push must sit
  under that builder (it does when you use the app's navigator). Selection and cursor colors are
  set the same way with `DefaultSelectionStyle` when we add text fields.
- **Theme.** There is no `Theme.of(context)`. The design system (US-003) exposes its own
  `InheritedWidget` (e.g. `AppTheme.of(context)`) carrying colors, text styles, spacing and radii.
- **Chrome.** No `Scaffold`, `AppBar`, `BottomNavigationBar`, `ElevatedButton`, `Icon`s from the
  Material font, `Dialog`, `SnackBar`. `shared/` provides our own equivalents built from
  `Container`, `Row`/`Column`, `GestureDetector`, `Listener`, `FocusableActionDetector`,
  `Overlay`, `Navigator`, `SafeArea`, `CustomPaint`. `pubspec.yaml` has
  `uses-material-design: false`, so the Material icon font is not bundled; use SVG/PNG assets or a
  custom icon font.
- **Text input.** Use `EditableText` directly (wrapped in our own field widget) rather than
  `TextField`/`CupertinoTextField`.
- **Scrolling and gestures.** `ListView`, `GridView`, `CustomScrollView`, `PageView`,
  `Draggable`, `InteractiveViewer` and friends are widget-layer and fine. Scroll physics come from
  `ScrollConfiguration`, which `WidgetsApp` already installs.
- **Navigation.** `WidgetsApp` needs a `pageRouteBuilder` (or a router config); we provide a plain
  `PageRouteBuilder` today and will move to `WidgetsApp.router` + `go_router` in US-002 with our
  own page transitions.
- **Localization.** `WidgetsApp` already installs `DefaultWidgetsLocalizations`; add
  `flutter_localizations` delegates for our ARB strings only (not the Material/Cupertino ones).
- **Tests.** `tester.pumpWidget` must wrap the widget under test in the same root context the app
  uses (a `WidgetsApp` or at least `Directionality` + `DefaultTextStyle`); a `pumpApp` helper will
  live in `test/helpers/` once the design system exists.

## Naming conventions

- Files: `snake_case.dart`; one public widget/class per file, file named after it
  (`mental_arithmetic_generator.dart` -> `MentalArithmeticGenerator`).
- Widgets: nouns, suffix by role when it helps: `*Screen` (route target), `*Page` (go_router page
  wrapper), `*Card`, `*Tile`, `*Button`.
- Riverpod: `xxxProvider` for providers, `XxxNotifier` for notifiers, one provider per file or
  grouped in `<feature>/presentation/providers/`.
- Domain: entities are `freezed` classes without an `Entity` suffix; repository interfaces are
  `XxxRepository` in `domain/`, implementations `XxxRepositoryImpl` (or `DriftXxxRepository`) in
  `data/`.
- Drift: tables in `core/database/tables/`, DAOs next to the feature's `data/`; generated files
  (`*.g.dart`, `*.freezed.dart`, `*.drift.dart`) are committed and excluded from analysis.
- Tests: `<file>_test.dart` mirroring the `lib/` path; test names are sentences describing the
  behaviour.
- Strings: prefer single quotes; no `print` (use the logger in `core/`).

## Code generation

`freezed`, `json_serializable` and `drift_dev` run through `build_runner`:

```
make gen        # one-shot build (deletes conflicting outputs)
make gen-watch  # rebuild on change
```

Commit generated files so a fresh clone builds and analyzes without running the generator.

## Quality gates

`make lint` (`flutter analyze` + format check) and `make test` (`flutter test`) must pass before a
PR is opened. CI (US-004, `.github/workflows/ci.yml`) runs the same commands on every PR and on
pushes to `main` (`check` job: pub get, codegen, format check, `flutter analyze --fatal-infos`,
`flutter test --coverage`), and `main` is protected so that `check` must be green to merge. A
debug APK is built and uploaded as an artifact on pushes to `main` and on PRs labelled `build`.
Format with `dart format .`.
