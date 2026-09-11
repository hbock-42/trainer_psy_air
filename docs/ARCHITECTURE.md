# Architecture

Conventions for the PSY Trainer Flutter app. Established in US-001; amend this file when a
decision changes (and say why in the PR).

## Folder layout (feature-first)

```
lib/
  main.dart                  # entry point: error hooks + ProviderScope + runApp
  app.dart                   # root WidgetsApp.router
  core/                      # cross-cutting infrastructure: database, routing,
                             # error/logging, constants, extensions
    errors/                  # logError + global error hooks
    router/                  # go_router config, AppPage, AppRoutes, redirect, shell,
                             # error screen (the only UI allowed in core/)
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

Initial features: `learn`, `train`, `exam`, `progress`, `settings`, `onboarding`. Add a feature by creating
`lib/features/<name>/{data,domain,presentation}`; do not add new top-level folders without a
kanban card.

Dependency direction: `presentation -> domain <- data`. `domain` never imports Flutter widgets,
Drift, or anything from `presentation`. Features may depend on `core` and `shared`; `core` and
`shared` never import from `features`, with one deliberate exception: `core/router/app_router.dart`
is the composition root that maps paths to feature screens (and reads the providers its guards
need), so it imports from `features/*/presentation`. Nothing else in `core` may. Cross-feature
imports go through a `domain` interface, not into another feature's `presentation` or `data`.

## Stack

| Concern        | Choice                          | Notes |
|----------------|---------------------------------|-------|
| UI toolkit     | `package:flutter/widgets.dart` only | **No Material, no Cupertino** (see below) |
| State + DI     | `flutter_riverpod` 3.x          | Providers live next to the feature that owns them; see "State and DI" |
| Navigation     | `go_router`                     | `WidgetsApp.router` + our own `AppPage`; see "Routing" |
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
- **Navigation.** The root is `WidgetsApp.router` with go_router. There is no `MaterialPage`, so
  every route is wrapped in `core/router/app_page.dart` (`AppPage`), a `Page` whose route is a
  small `PageRoute` subclass with a fade + slide transition. Never use `GoRoute.builder` (go_router
  would pick a platform page type); always `pageBuilder` returning an `AppPage`.
- **Localization.** `WidgetsApp` already installs `DefaultWidgetsLocalizations`; add
  `flutter_localizations` delegates for our ARB strings only (not the Material/Cupertino ones).
- **Tests.** `tester.pumpWidget` must wrap the widget under test in the same root context the app
  uses (a `WidgetsApp` or at least `Directionality` + `DefaultTextStyle`); a `pumpApp` helper will
  live in `test/helpers/` once the design system exists.

## Platforms

The real PSY0 session runs on a desktop app with keyboard and mouse, and several activities are
keyboard-native (Formes et couleurs keys, multitask arrows/space/F; see `docs/content/psy0-spec.md`
§4.4). A phone cannot rehearse those faithfully, so the app targets every Flutter platform with a
deliberate split by role (US-006):

| Target | Folder | Role |
|--------|--------|------|
| Android, iOS (phone) | `android/`, `ios/` | **Learn and practice**: lessons, flashcards, drills, progress. Touch-first layouts. |
| macOS, Windows | `macos/`, `windows/` | **Exam mode** for keyboard-native activities; the window opens at 1280×800 and cannot shrink below 1024×700 logical pixels (`macos/Runner/MainFlutterWindow.swift`, `windows/runner/win32_window.cpp`). |
| Web (Chrome) | `web/` | Same as desktop for people without a build; also the cheapest platform to build in CI (`flutter build web --release` in the `check` job). |
| Tablet + physical keyboard | `android/`, `ios/` | Treated as desktop when a hardware keyboard is present. |

One codebase, one `WidgetsApp`: nothing in `lib/app.dart` or the router is platform-specific.
Screens adapt to the viewport and to the input available, not to `Platform.isX`. Windows is
configured and committed but only built on demand (`flutter build windows` on a Windows machine);
macOS is run locally with `make run-macos`, web with `make run-web` / `make build-web`.

**Verification is headless** — use `flutter build <target>` (`make build-macos`, `make build-web`)
and `flutter test`; never `flutter run` in automation (CI, scripts, agents). `make run-*` targets
are for a person at the keyboard.

Notes for engine authors (EPIC-03):

- **Keyboard input comes from the widgets layer.** Wrap the activity in a `Focus` (or
  `FocusableActionDetector`) node that requests focus when the item appears, and read keys with
  `KeyboardListener` (`onKeyEvent`, `KeyDownEvent` / `LogicalKeyboardKey`) or declare
  `Shortcuts` + `Actions` for the activity's key map. Never use `RawKeyboardListener` (deprecated)
  and never depend on a `TextField`/`EditableText` just to receive key presses. Keep the key map in
  the engine's `domain/` as data (e.g. `{LogicalKeyboardKey.arrowLeft: Answer.left}`) so the
  same engine is testable with `tester.sendKeyEvent` and reusable by the practice and exam
  runners.
- **Touch fallbacks are labelled "non-representative".** A keyboard-native activity may offer
  on-screen buttons so it stays usable on a phone, but the practice UI must label that mode as
  non-representative of the real test, and the exam runner (US-061) must not count a touch run of
  such an activity as a representative rehearsal. Detect the mode by whether a hardware key event
  has been received (or by the platform being desktop/web), not by screen size alone.
- **Timing is the same everywhere.** Reaction-time and per-item timers live in `domain/` and are
  driven by the engine, not by platform APIs, so results are comparable across targets.

## State and DI (Riverpod)

- `main.dart` wraps the app in a `ProviderScope`; `PsyTrainerApp` is a `ConsumerWidget`.
- Riverpod 3 idioms only: `Provider`, `NotifierProvider`/`Notifier`, `AsyncNotifierProvider`,
  `FutureProvider`, `StreamProvider`. `StateProvider`, `StateNotifierProvider` and
  `ChangeNotifierProvider` are legacy in 3.x (`flutter_riverpod/legacy.dart`) and are not used.
- Providers live in the feature that owns the state (`features/<f>/presentation/providers/`), one
  file per provider. Reference example: `onboardingCompletedProvider`
  (`features/onboarding/presentation/providers/onboarding_completed_provider.dart`).
- Services and repositories are exposed as providers too; `data/` implementations are bound to
  `domain/` interfaces by a provider in the feature, overridden in tests.
- Tests: `ProviderContainer.test(overrides: [...])` for pure provider tests (auto-disposed); for
  widget tests, create a `ProviderContainer` and pump `UncontrolledProviderScope(container: ...)`
  so the test can both override and read providers. Override a notifier with
  `xxxProvider.overrideWith(FakeNotifier.new)`. See
  `test/features/onboarding/presentation/providers/onboarding_completed_provider_test.dart` and
  `test/core/router/app_router_test.dart`.

## Routing (go_router)

Everything lives in `lib/core/router/`:

| File | Role |
|------|------|
| `app_routes.dart` | `AppRoutes`: path constants and location helpers. No string paths anywhere else. |
| `app_router.dart` | `appRouterProvider` (a `Provider<GoRouter>`) and `createAppRouter(...)` building the route table. |
| `app_page.dart` | `AppPage`, the page type used by every route. |
| `app_redirect.dart` | `computeRedirect(...)`: the top-level guard as a pure function. |
| `app_shell.dart` | `AppShell`: wraps the `StatefulNavigationShell` (bottom bar arrives in US-005). |
| `error_screen.dart` | `ErrorScreen`: go_router `errorBuilder` target (unknown route, route error). |

Route table:

```
/onboarding                          root navigator, outside the shell
StatefulShellRoute.indexedStack      AppShell; one branch (own Navigator) per tab, state kept
  /learn                             branch 0  (initial location)
  /train                             branch 1
    session/:sessionId               nested -> /train/session/:sessionId (pushed inside the tab)
  /exam                              branch 2
  /progress                          branch 3
  /settings                          branch 4
```

- **Adding a tab route:** add the constant to `AppRoutes` (and `AppRoutes.tabs`, whose order is
  the branch/bottom-bar order), a `StatefulShellBranch` in `createAppRouter`, and a screen in
  `features/<f>/presentation/<f>_screen.dart`.
- **Adding a nested route** (a screen pushed on top of a tab, tab stays selected): declare a
  `GoRoute` with a *relative* path (`'session/:sessionId'`) in the parent `GoRoute.routes`, add a
  helper in `AppRoutes` returning the full location (`AppRoutes.trainSession(id)`), and read path
  parameters with `state.pathParameters[AppRoutes.sessionIdParam]`. Navigate with
  `context.go(...)` (replace stack) or `context.push(...)` (stack on top). A screen that must cover
  the shell (no tab bar, e.g. the exam runner) sets `parentNavigatorKey` to the root navigator
  key instead of living in a branch.
- **Guards:** the router calls `computeRedirect(onboardingDone:, location:)` on every navigation
  with `state.matchedLocation`. Keep guards pure functions of provider values so they are unit
  tested without widgets; `appRouterProvider` listens to the providers a guard reads and calls
  `router.refresh()` when they change, so the router itself is created once and navigation state
  survives. Today's only rule: onboarding not completed -> `/onboarding` (and `/onboarding` ->
  `/learn` once completed). `onboardingCompletedProvider` defaults to `true` until US-090.
- **Errors:** unknown locations and route-time exceptions render `ErrorScreen`. Uncaught errors go
  to `core/errors/error_logger.dart`: `installGlobalErrorHandlers()` hooks `FlutterError.onError`
  (chaining the default so debug builds keep the red box) and `PlatformDispatcher.onError`;
  `main.dart` runs everything under `runZonedGuarded`. All three call `logError`, which uses
  `dart:developer` `log` (structured, visible in DevTools, no `print`). Swap the backend there when
  crash reporting is added.

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
