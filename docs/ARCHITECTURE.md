# Architecture

Conventions for the PSY Trainer Flutter app. Established in US-001; amend this file when a
decision changes (and say why in the PR). Task-shaped procedures (adding an engine, authoring
content, shipping a story, the data layer, the design system, progress/analytics) live in
`.agents/skills/` — see "Skills" below. This file stays the layout, module map and the rules
that cut across every feature.

## Repository layout (pub workspace, US-007)

The repo is a [pub workspace](https://dart.dev/tools/pub/workspaces) (Dart 3.6+): one
`pubspec.lock` at the root resolves every member together, and `dart pub get` only ever
runs there.

```
pubspec.yaml                 workspace root: `workspace: [apps/psy_trainer, packages/psy_content]`,
                             publish_to: none, no app code of its own
melos.yaml                   Melos scripts (analyze, format, test, coverage, build:web,
                             content:check) — a thin wrapper around per-package commands;
                             see "Running the workspace" below
apps/psy_trainer/            the Flutter app: lib, test, assets/content, platform folders
                             (android, ios, macos, windows, web), its own pubspec.yaml
                             (`resolution: workspace`), build.yaml, analysis_options.yaml
packages/psy_content/        pure Dart: content models, ContentBundleParser and the content
                             validator (see docs/content/CONTRACT.md and the `author-content`
                             skill); `resolution: workspace`; no Flutter dependency
tools/                       repo-wide scripts with no package dependencies of their own:
                             coverage_gate.dart, list_content_assets.dart (+ tools/test/)
docs/                        this file, TESTING.md, RELEASE.md, content/, kanban/
.agents/skills/               canonical, agent-agnostic task skills (`.claude/skills` symlinks here)
AGENTS.md                    the agent entry point (non-negotiables + skills index); CLAUDE.md
                             symlinks to it
Makefile, .gitattributes,    unchanged, run from the repo root
.github/
```

**Adding a package.** Create `packages/<name>/` (or `apps/<name>/` for another app) with its
own `pubspec.yaml` (`resolution: workspace`, no `publish_to` needed beyond `'none'` for
private code), list it under the root `workspace:` key, and `dart pub get` at the root. A
member that depends on another declares a normal `path:` dependency
(`psy_content: {path: ../../packages/psy_content}`); pub workspaces still resolve
inter-package dependencies through the pubspec graph, they only share one lockfile and one
`.dart_tool/`. Add its commands to `melos.yaml` (or the root `Makefile`) and, if it ships
Dart code, an architecture test enforcing its layer rules (see `no_flutter_test.dart` in
`packages/psy_content/test/` for the "no Flutter dependency" pattern).

**Why pub workspaces over Melos-only or a single package.** A single package (the pre-US-007
layout) could not keep `psy_content` Flutter-free without a separate checkout; pub
workspaces give one lockfile and one `flutter pub get`/`dart pub get` for every member,
which is simpler than N independent lockfiles kept in sync by hand. Melos is layered on top
only for the convenience of naming a script once (`melos run test`) instead of a
per-package loop; if it ever adds friction the root `Makefile` already delegates to the same
per-package commands and is the fallback (see `melos.yaml`'s header comment).

**Running the workspace** (from the repo root):

```sh
dart pub global activate melos   # once per machine
dart pub get                     # resolves every member from the one lockfile
melos run analyze                # flutter analyze (app) + dart analyze (psy_content), --fatal-infos
melos run format                 # dart format --output=none --set-exit-if-changed, every member
melos run test                   # flutter test (app) + dart test (psy_content, tools/test)
melos run coverage                # flutter test --coverage (app) + tools/coverage_gate.dart
melos run build:web              # flutter build web --release, in apps/psy_trainer
melos run content:check          # the content validator over apps/psy_trainer/assets/content
```

Equivalent `make` targets exist at the root (`make test`, `make lint`, `make coverage`,
`make build-web`, `make content-check`) and delegate the same way; use whichever you have
installed. `make gen`, `make run*` and the platform builds still apply to `apps/psy_trainer`
specifically (the Makefile passes `-C apps/psy_trainer` or an app-scoped command).

## Folder layout (feature-first, `apps/psy_trainer/`)

```
lib/
  main.dart                  # entry point: error hooks + ProviderScope + runApp
  app.dart                   # root WidgetsApp.router
  core/                      # cross-cutting infrastructure: database, routing,
                             # error/logging, constants, extensions
    db/                      # Drift database — see the `data-layer` skill
    repositories/            # ContentRepository / ProgressRepository interfaces, domain
                             # models, Riverpod providers, in_memory/ fakes (US-012)
    errors/                  # logError + global error hooks
    l10n/                    # ARB-based i18n (US-091): app_fr.arb (source)/app_en.arb,
                             # gen/ (generated AppLocalizations, `flutter gen-l10n`),
                             # l10n_extensions.dart (context.l10n + composed strings),
                             # strings.dart (AppStrings: two domain-only FR exceptions)
    router/                  # go_router config, AppPage, AppRoutes, redirect, shell,
                             # error screen + startup gate (the only UI allowed in core/)
  shared/                    # design system (see the `design-system` skill) + generic
                             # widgets and helpers used by several features
  features/
    <feature>/
      data/                  # repositories impl, data sources (Drift DAOs, JSON loaders),
                             # DTOs and mappers
      domain/                # entities/value objects (freezed), repository interfaces,
                             # pure logic (test generators, scoring)
      presentation/          # screens, widgets, Riverpod providers/notifiers, routes
    train/domain/engine/     # activity runtime (pure Dart) — see the `add-activity-engine` skill
    train/presentation/engine/ # its widget half: renderer contract, controller, SessionHost
    engines/<family_id>/     # one activity engine per EPIC-03 story (domain + presentation)
    progress/                # readiness/stats — see the `progress-analytics` skill
assets/content/               # the content bundle (US-013) — see the `author-content` skill
test/                        # see docs/TESTING.md
docs/kanban/                 # epics/stories/board — see the `ship-a-story` skill
```

Initial features: `learn`, `train`, `exam`, `progress`, `settings`, `onboarding`. Add a feature
by creating `lib/features/<name>/{data,domain,presentation}`; do not add new top-level folders
without a kanban card.

**Dependency direction:** `presentation -> domain <- data`. `domain` never imports Flutter
widgets, Drift, or anything from `presentation`. Features may depend on `core` and `shared`;
`core` and `shared` never import from `features`, with one deliberate exception:
`core/router/app_router.dart` is the composition root that maps paths to feature screens (and
reads the providers its guards need), so it imports from `features/*/presentation`. Nothing
else in `core` may. Cross-feature imports go through a `domain` interface, not into another
feature's `presentation` or `data`.

## Stack

| Concern        | Choice                          | Notes |
|----------------|---------------------------------|-------|
| UI toolkit     | `package:flutter/widgets.dart` only | **No Material, no Cupertino** (see below and the `design-system` skill) |
| State + DI     | `flutter_riverpod` 3.x          | Providers live next to the feature that owns them; see "State and DI" |
| Navigation     | `go_router`                     | `WidgetsApp.router` + our own `AppPage`; see "Routing" |
| Models         | `freezed` + `json_serializable` | Immutable entities, `copyWith`, JSON for content files |
| Local database | `drift` on `package:sqlite3` 3.x | See the `data-layer` skill |
| IDs / paths    | `uuid`, `path`, `path_provider` | |
| Charts         | our own `CustomPainter`s        | `fl_chart` builds on Material; see the `design-system` skill |
| Sharing        | `share_plus`                    | Material-free; backup export uses `XFile.fromData` (see the `data-layer` skill) |
| Lints          | `flutter_lints` + stricter rules in `analysis_options.yaml` | `custom_lint` was dropped: its analyzer pin conflicts with `drift_dev` |

Versions are pinned with caret constraints in `pubspec.yaml` and locked in `pubspec.lock`
(committed). Some packages have newer releases that require a newer Dart SDK than the one shipped
with Flutter 3.41.x; bump them together with the Flutter version.

## No Material, no Cupertino

The root widget is `WidgetsApp`, not `MaterialApp`/`CupertinoApp`, and nothing under `lib/` may
import `package:flutter/material.dart` or `package:flutter/cupertino.dart`. This is enforced by
`test/architecture/no_material_cupertino_test.dart`, which scans `lib/` and fails on any such
import (including `show`/`hide`/`as` forms). Third-party packages whose widgets require a
Material ancestor (`Theme.of`, `Scaffold`, `Material` for ink) are not allowed; prefer
widget-layer packages or write the widget ourselves. What this implies for theming, chrome,
text input, navigation, localization and testing — and the full widget catalogue — is the
`design-system` skill's job; this rule itself is the cross-cutting constraint every feature
must respect.

## Platforms

The real PSY0 session runs on a desktop app with keyboard and mouse, and several activities are
keyboard-native (Formes et couleurs keys, multitask arrows/space/F; see `docs/content/psy0-spec.md`
§4.4). A phone cannot rehearse those faithfully, so the app targets every Flutter platform with a
deliberate split by role (US-006):

| Target | Folder | Role |
|--------|--------|------|
| Android, iOS (phone) | `android/`, `ios/` | **Learn and practice**: lessons, flashcards, drills, progress. Touch-first layouts. |
| macOS, Windows | `macos/`, `windows/` | **Exam mode** for keyboard-native activities; the window opens at 1280×800 and cannot shrink below 1024×700 logical pixels (`macos/Runner/MainFlutterWindow.swift`, `windows/runner/win32_window.cpp`). |
| Web (Chrome) | `web/` | Same as desktop for people without a build; also the cheapest platform to build in CI (`flutter build web --release` in the `check` job). Deployed continuously to GitHub Pages (US-124, see `docs/RELEASE.md` "Web (GitHub Pages)") at `https://hbock-42.github.io/trainer_psy_air/`, using the hash URL strategy (`core/router/url_strategy.dart`) so deep links survive a reload from a project-site sub-path with no server-side SPA rewrite. Persists through drift `WasmDatabase` (US-016; see the `data-layer` skill) — `web/sqlite3.wasm` (732 KB) + `web/drift_worker.js` (348 KB) add about 1.1 MB to `build/web`; both are fetched lazily by the worker once the database first opens, not part of the initial `main.dart.js` payload. |
| Tablet + physical keyboard | `android/`, `ios/` | Treated as desktop when a hardware keyboard is present. |

One codebase, one `WidgetsApp`: nothing in `lib/app.dart` or the router is platform-specific.
Screens adapt to the viewport and to the input available, not to `Platform.isX`. Windows is
configured and committed but only built on demand (`flutter build windows` on a Windows machine);
macOS is run locally with `make run-macos`, web with `make run-web` / `make build-web`.

**Verification is headless** — use `flutter build <target>` (`make build-macos`, `make build-web`)
and `flutter test`; never `flutter run` in automation (CI, scripts, agents). `make run-*` targets
are for a person at the keyboard. See the `ship-a-story` skill for the full verification command
list before opening a PR.

Keyboard input, timing and the "non-representative" touch-fallback rule for a new engine are
covered in the `add-activity-engine` skill, not here.

## Data layer

```
features/*  ->  core/repositories/  (interfaces + models + providers)  <-  core/db/  (Drift)
```

Features only ever see the `ContentRepository`/`ProgressRepository` interfaces and their
pure-Dart models; `lib/features/` never imports `package:drift`, `package:sqlite3` or
`lib/core/db/` (`test/architecture/no_drift_in_features_test.dart`). Tables, DAOs, seeding,
migrations, web persistence and the backup format are the `data-layer` skill. Add a new
`UserProfile.settings` key only alongside a doc update there.

## Progress / analytics

All aggregates the app shows or decides on (dashboard, charts, adaptive difficulty,
recommendations) come from one tested service, `features/progress/domain/stats_service.dart`
(pure Dart, no Flutter/Riverpod/Drift — `test/architecture/no_flutter_in_domain_test.dart`),
fed by SQL aggregate queries so raw attempts are never loaded into Dart. Formulas (readiness,
level, trend, weak areas, streaks) and how to extend them: the `progress-analytics` skill.

## Engine

The generic activity runtime (US-020, `features/train/domain/engine/` +
`features/train/presentation/engine/`) sequences every PSY0/PSY1 activity's items, runs
timers/cadence, records attempts and scores a section; an activity engine only supplies **a
generator, a scorer and a renderer** under `features/engines/<family_id>/`. The runtime's
public surface (`ActivityEngine.generate({params, seed, difficulty, index, runSeed})`,
`Answer`, `ActivityRenderer.build`/`buildExample`, `SessionHost`, the two registries in
`engine_registry_provider.dart`) and the 5-step recipe for adding an engine are the
`add-activity-engine` skill.

Three features are built on top of this runtime and are pure reference material once landed
(no active procedure moved to a skill for them, since no other story touches them the way
engines are added repeatedly):

- **Exam realism options (US-063)** — `features/exam/domain/exam_realism_options.dart`
  (`ExamRealismOptions`, 7 booleans, `UserProfile.settings['exam.realism']`) let a candidate
  dial the simulation toward or away from the real conditions (negative marking on culture
  aéro, randomising generated seeds, hiding the timer, pausing between sections, immersive
  full-screen, sound cues); applied by `exam_section_planner.dart` and `ExamRunScreen`/
  `ExamRunController`. See the file doc comments for exactly where each toggle is read.
- **Local reminders (US-092)** — `core/notifications/` picks a platform scheduler
  (`PluginReminderScheduler` on Android/iOS, `UnsupportedReminderScheduler` elsewhere) and
  recomputes the notification's content (due flashcards, weakest family, exam countdown) every
  time it reschedules, via `reminderCoordinatorProvider` watched once from `lib/app.dart`.
- **Module switch (US-101)** — `features/home/domain/active_module.dart` (`ActiveModule`,
  `UserProfile.settings['module']`) lets Learn/Train/Exam/the dashboard show PSY1 instead of
  PSY0 without a second set of screens; `ModuleSwitch` (`shared/widgets/`) is the toggle, and
  every family/blueprint provider filters by `activeModuleProvider`'s `moduleId`.

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
| `app_shell.dart` | `AppShell`: `AppScaffold` + `AppTabBar` around the `StatefulNavigationShell`; bottom bar under 900 dp, left rail above; re-tapping the active tab resets it to its root. Tab labels/glyphs live in `AppShell.tabs`, in `AppRoutes.tabs` order. |
| `error_screen.dart` | `ErrorScreen`: go_router `errorBuilder` target (unknown route, route error) and the startup gate's failure screen; optional `onRetry`, "back to home" only when a router is in scope. |
| `startup_gate.dart` | `StartupGate` + `SplashScreen`: holds the `Router` until the content is seeded and the onboarding flag is hydrated (see the `data-layer` skill, "Content seeding"). |

Route table:

```
/onboarding                          root navigator, outside the shell
StatefulShellRoute.indexedStack      AppShell; one branch (own Navigator) per tab, state kept
  /learn                             branch 0  (initial location)
    family/:familyId                 nested -> /learn/family/:familyId (US-040 family page)
      lesson/:lessonId               nested -> /learn/family/:familyId/lesson/:lessonId (US-041 lesson viewer)
    how-it-works                     nested -> /learn/how-it-works (selection stages)
  /train                             branch 1
    session/:sessionId               nested -> /train/session/:sessionId (pushed inside the tab)
  /exam                              branch 2
  /progress                          branch 3
    family/:familyId                 nested -> /progress/family/:familyId (US-071 family charts)
  /settings                          branch 4
    profile                          nested -> /settings/profile (edit the onboarding answers)
    about                            nested -> /settings/about (US-091: version, disclaimer, sources)
```

- **Adding a tab route:** add the constant to `AppRoutes` (and `AppRoutes.tabs`, whose order is
  the branch/bottom-bar order), a `StatefulShellBranch` in `createAppRouter`, an `AppTabItem` in
  `AppShell.tabs`, and a screen in `features/<f>/presentation/<f>_screen.dart`.
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
  `/learn` once completed). `onboardingCompletedProvider` (US-090) is hydrated from the profile
  at startup: its state is `null` until the first read, and the router's `redirect` awaits
  `OnboardingCompletedNotifier.whenHydrated()` (a `FutureOr<bool>`, synchronous once known)
  before resolving the first location, so go_router renders nothing rather than flashing the
  onboarding to a returning user. Tests that pump the whole app must override
  `progressRepositoryProvider` (see `test/helpers/onboarding_fakes.dart`).
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
  `XxxRepository`, implementations `LocalXxxRepository` (Drift) and `InMemoryXxxRepository`
  (fake). The two cross-cutting repositories live in `core/repositories/` (see "Data layer");
  a feature-specific one goes in `features/<f>/domain/` with its implementation in `data/`.
- Drift: everything under `core/db/` (`tables/`, `daos/`, `repositories/`); generated files
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

`make lint` (analyze + format check, app and `psy_content`) and `make test` (every member's
tests) must pass before a PR is opened. CI (US-004, US-007, `.github/workflows/ci.yml`) runs
the same commands from the repo root on every PR and on pushes to `main` (`check` job: `dart
pub get` once, codegen, format check, `flutter analyze --fatal-infos` / `dart analyze
--fatal-infos` for every member, content validation, tests with coverage, coverage gate, web
build), and `main` is protected so that `check`, `integration` and `build-android` must all be
green to merge. Coverage is gated with `make coverage` (see `docs/TESTING.md`). Format with
`dart format .` in each member (or `melos run format` / `make format` from the root). Full PR
checklist (branch/commit/PR rules, merge hotspots, the kanban card update): the `ship-a-story`
skill.

Release builds are a separate workflow (US-122, `.github/workflows/release.yml`) triggered by
pushing a `v*` tag rather than by `check` — see `docs/RELEASE.md` for the version bump script,
Android signing, and the manual Play/TestFlight steps.

## Skills

Task-shaped procedures for coding agents (and humans) live in `.agents/skills/<name>/SKILL.md`
(`.claude/skills` is a relative symlink to the same folder). Each is self-sufficient for its
task — read only the one you need instead of this whole file.

| Skill | Covers |
|---|---|
| `ship-a-story` | branch/commit/PR rules (incl. the no-AI-attribution rule), headless verification commands, l10n ARB rule, required CI jobs, merge hotspots, kanban card/board update |
| `add-activity-engine` | the runtime API, the 5-step recipe, `runSeed`/`index`, answer types, renderer rules, registry conventions, the test template |
| `author-content` | bundle layout, item/lesson/deck/lexical-field rules, the validator, `contentVersion` |
| `data-layer` | Drift tables, repositories, seeding, web persistence, backup format |
| `design-system` | tokens, the widget catalogue, the no-Material rule's practical implications, the gallery, a11y |
| `progress-analytics` | the stats service, providers, the readiness/level/trend formulas, cache invalidation |
