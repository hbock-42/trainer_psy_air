# Architecture

Conventions for the PSY Trainer Flutter app. Established in US-001; amend this file when a
decision changes (and say why in the PR).

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
                             validator (see "Content model" and "Content validator" below);
                             `resolution: workspace`; no Flutter dependency
tools/                       repo-wide scripts with no package dependencies of their own:
                             coverage_gate.dart, list_content_assets.dart (+ tools/test/)
docs/                        unchanged (this file, TESTING.md, content/, kanban/)
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
    db/                      # Drift: AppDatabase, tables/, daos/, repositories/ (local impls),
                             # seed/ (content seeder, US-013); content models come from
                             # package:psy_content (see packages/psy_content/, US-007)
    repositories/            # ContentRepository / ProgressRepository interfaces, domain
                             # models, Riverpod providers, in_memory/ fakes (US-012)
    errors/                  # logError + global error hooks
    l10n/                    # ARB-based i18n (US-091): app_fr.arb (source)/app_en.arb,
                             # gen/ (generated AppLocalizations, `flutter gen-l10n`),
                             # l10n_extensions.dart (context.l10n + composed strings),
                             # strings.dart (AppStrings: two domain-only FR exceptions)
    router/                  # go_router config, AppPage, AppRoutes, redirect, shell,
                             # error screen + startup gate (the only UI allowed in core/)
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
    train/domain/engine/     # US-020 activity runtime (pure Dart), see "Engine"
    train/presentation/engine/ # its widget half: renderer contract, controller, SessionHost
    engines/<family_id>/     # one activity engine per EPIC-03 story (domain + presentation)
assets/content/               # the content bundle (US-013), see packages/psy_content/ for
                             # its models/validator and docs/content/AUTHORING.md
test/                        # see docs/TESTING.md
  architecture/              # rules about the codebase itself (e.g. no Material)
  features/<feature>/...     # mirrors lib/features; unit + widget tests
  helpers/                   # pumpApp, golden config, shared fakes
  goldens/                   # committed golden PNGs
  app_test.dart              # smoke test of the root widget
                             # (US-007 moved test/tool/ to tools/test/ and test/core/content/
                             # to packages/psy_content/test/; nothing under this app's test/
                             # tests a script or the content models any more)
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
| Local database | `drift` on `package:sqlite3` 3.x | `sqlite3` bundles the native library through Dart hooks, so `sqlite3_flutter_libs` (now discontinued) is not needed. Schema: see "Data layer" |
| IDs / paths    | `uuid`, `path`, `path_provider` | |
| Charts         | our own `CustomPainter`s        | `fl_chart` builds on Material, so US-070 draws with `CustomPaint`: `ArcGauge`, `RadarChart`, `HorizontalBarChart` in `shared/widgets/` (see `docs/DESIGN_SYSTEM.md`) |
| Sharing        | `share_plus`                    | Material-free (checked before adding it); US-074's backup export, `XFile.fromData` + `downloadFallbackEnabled` so the same call is the native share sheet on mobile/desktop and a browser download on web |
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
  yellow "missing style" underline. The root `builder` in `lib/app.dart` installs an
  `AppThemeScope` (which carries the `DefaultTextStyle`) and a background `ColoredBox`. Any new
  route or overlay you push must sit under that builder (it does when you use the app's
  navigator). Selection and cursor colors are
  set the same way with `DefaultSelectionStyle` when we add text fields.
- **Theme.** There is no `Theme.of(context)`. The design system exposes its own
  `InheritedWidget` (`AppThemeScope`, read with `AppTheme.of(context)`) carrying colors, text
  styles, spacing, radii and durations (`lib/core/theme/`).
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
- **Localization (US-091).** `WidgetsApp` already installs `DefaultWidgetsLocalizations`;
  `lib/app.dart` adds `AppLocalizations.localizationsDelegates`/`.supportedLocales` (our ARB
  strings only, never the Material/Cupertino ones) and passes `ref.watch(localeProvider)` as
  `WidgetsApp.router`'s `locale` (`null` follows the system locale). Source-of-truth copy lives
  in `lib/core/l10n/app_fr.arb` (FR) with `app_en.arb` (EN translations); `flutter gen-l10n`
  (run automatically before build/analyze/test, `generate: true` in `pubspec.yaml`, config in
  `l10n.yaml`) generates `AppLocalizations` under `lib/core/l10n/gen/`. Every widget reads its
  copy through `context.l10n` (the `L10nX` extension in `lib/core/l10n/l10n_extensions.dart`);
  the same file's `L10nComposed` extension holds the handful of strings built from real Dart
  logic (pluralisation across parts, locale-aware date/number formatting) rather than a single
  ICU message. `AppStrings` (`core/l10n/strings.dart`, the pre-US-091 FR-only constants) is kept
  only for two pure-Dart `domain/` files with no `BuildContext`
  (`logic_dominos/domain/domino_explanation.dart`,
  `spatial_viewpoint/domain/viewpoint_explanation.dart`); everywhere else is enforced by
  `test/architecture/no_app_strings_in_features_test.dart`. No literal strings in screens or
  widgets. Content language (`LocalizedText.resolve`) is a separate axis from the UI language:
  screens pass `context.l10n.localeName`, not a hard-coded code.
- **Tests.** `tester.pumpWidget` must wrap the widget under test in the same root context the app
  uses (a `WidgetsApp` or at least `Directionality` + `DefaultTextStyle`); use the `pumpApp`
  helper in `test/helpers/pump_app.dart` (see `docs/TESTING.md`).
- **Design system.** Tokens, widget catalogue and conventions are in `docs/DESIGN_SYSTEM.md`.

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

Notes for engine authors (EPIC-03; the runtime and the 5-step recipe are in "Engine" below):

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

## Data layer (US-011, US-012)

```
features/*  ->  core/repositories/  (interfaces + models + providers)  <-  core/db/  (Drift)
```

Features read `contentRepositoryProvider` / `progressRepositoryProvider`
(`core/repositories/repository_providers.dart`) and only ever see the `ContentRepository` and
`ProgressRepository` interfaces plus the pure-Dart models next to them (`TrainingSession`,
`Attempt`, `ItemStat`, `FamilyStats`, `SessionFamilyStats`, `FlashcardReview`, `LessonRead`,
`UserProfile`, `ContentInfo`) and the US-010 content models. **No file under `lib/features/` may import
`package:drift`, `package:sqlite3` or `lib/core/db/`**; `test/architecture/no_drift_in_features_test.dart`
enforces it. Widget tests override the two providers with `InMemoryContentRepository` /
`InMemoryProgressRepository` (`core/repositories/in_memory/`), which pass the same contract
tests as the Drift implementations (`test/core/repositories/*_contract.dart`).

The interfaces live in `core/repositories/` rather than a feature's `domain/` because every
feature (learn, train, exam, progress, settings) reads them; a repository owned by a single
feature would still go in that feature's `domain/`.

### Database (`core/db/`)

| File | Role |
|------|------|
| `app_database.dart` | `AppDatabase` (`@DriftDatabase`), `schemaVersion`, migration strategy |
| `open_database.dart` | `openAppDatabaseExecutor()`: `NativeDatabase.createInBackground` on a file in the app support dir (via `path_provider`); `openInMemoryExecutor()` for tests. Conditional import: `open_database_native.dart` when `dart:io` exists, `open_database_unsupported.dart` on web (throws on first use, see below) |
| `app_database_provider.dart` | `appDatabaseProvider` (opens lazily, closes with the container) |
| `tables/` | `AuditedTable` mixin (id + createdAt/updatedAt), content mirrors, user tables |
| `daos/` | One DAO per concern, typed queries; the only place SQL is written |
| `content_rows.dart` | `ContentRows`: US-010 models -> table companions (used by the seeder) |
| `seed/` | US-013: `AssetReader` (+ `RootBundleAssetReader`), `ContentBundleLoader`, `ContentSeeder`, `contentReadyProvider`; see "Content seeding" |
| `repositories/` | `LocalContentRepository`, `LocalProgressRepository` |
| `converters.dart` | `JsonMapConverter` for `TEXT` JSON blobs |

Schema v1 (every table has `id TEXT PRIMARY KEY`, `created_at`, `updated_at`):

| Table | Key columns | Notes |
|-------|-------------|-------|
| `content_meta` | schemaVersion, contentVersion, seededAt | single row (`id = 'content'`) |
| `modules`, `families`, `items`, `lessons`, `decks`, `flashcards`, `blueprints` | indexed columns + `version` + `json` blob | mirrors of the seeded bundle, keyed by the content id; `items(family_id, difficulty)`, `flashcards(deck_id, difficulty)`, `lessons(module_id, family_id)`, `decks(family_id, sort_order)` indexed. Decks are stored without cards; cards are rows of `flashcards`. Lesson rows carry the markdown inline in `body` (the seeder reads the `.md` files; `file` is always null in the database) |
| `sessions` | mode, familyId?, blueprintId?, startedAt, endedAt?, status, score?, config json | indexes `(started_at)`, `(family_id, started_at)` |
| `attempts` | sessionId (FK), familyId, itemId? or origin json, answer json?, isCorrect, responseMs, position, sectionIndex?, answeredAt | indexes `(session_id, position)`, `(family_id, answered_at)`, `(item_id)` |
| `item_stats` | itemId (unique), familyId, seen, correct, totalResponseMs, lastCorrect, lastSeenAt | maintained by `INSERT ... ON CONFLICT DO UPDATE` |
| `flashcard_reviews` | flashcardId (unique), deckId, box, reviews, lapses, lastReviewedAt?, nextReviewAt | index `(deck_id, next_review_at)` |
| `lesson_progress` | lessonId (unique), readAt | |
| `user_profile` | examDate?, targetStage?, locale, settings json | single row (`id = 'me'`). Onboarding (US-090) keeps its two flags in `settings`: `onboardingCompleted` (bool) and `disclaimerAcceptedAt` (ISO-8601 UTC); the mapping lives in `features/onboarding/domain/onboarding_answers.dart`. Settings (US-091) use `locale` for the UI language (`'system' \| 'fr' \| 'en'`, see `LanguagePreference`) and three more `settings` keys: `themeMode` (`'system' \| 'light' \| 'dark'`), `soundEnabled` (bool) and `keypadLayout` (`'phone' \| 'calculator'`) — mapping in `features/settings/domain/app_settings.dart` (`AppSettings`), read through `appSettingsProvider` (`features/settings/presentation/providers/`). Exam realism options (US-063) are one more nested `settings` key, `exam.realism`, holding a JSON object of seven booleans (`negativeMarkingCulture`, `hideRemainingTime`, `hideTimerEnglish`, `randomizeGenerated`, `allowPauseBetweenSections`, `immersiveFullScreen`, `soundCuesEnabled`) — mapping in `features/exam/domain/exam_realism_options.dart` (`ExamRealismOptions`), read through `examRealismOptionsProvider` (`features/exam/presentation/providers/`); see "Exam realism options (US-063)" below. Local reminders (US-092) are one more nested `settings` key, `reminder`, holding `{enabled: bool, hour: int, minute: int}` — mapping in `features/settings/domain/reminder_settings.dart` (`ReminderSettings`), read through `reminderSettingsProvider` (`features/settings/presentation/providers/`); see "Local reminders (US-092)" below. US-073 adds a `goal` key: `{'target': int, 'unit': 'items' \| 'minutes'}` (default `{target: 20, unit: 'items'}`) — mapping in `features/progress/domain/daily_goal.dart` (`DailyGoal`), read through `dailyGoalProvider` (`features/progress/presentation/providers/`) |

Design decisions:

- **Ids.** User rows get a uuid v4 from the repository layer (never `AUTOINCREMENT`), content
  mirrors keep the bundle's content id. Both are strings, so rows can be merged with a remote
  store later (EPIC-13) and `updated_at` is the sync watermark.
- **Dates** are stored as ISO-8601 text in UTC with millisecond precision
  (`DriftDatabaseOptions(storeDateTimeAsText: true)`), not unix seconds: cadence-driven
  activities (n-back, rules S-R) record several attempts per second. Repositories normalise
  every input with `toUtc()`; ordering within a session is by `attempts.position`, never by time.
- **Generated items** are not in `items`. An attempt on one stores `origin = {generatorId, seed,
  params}` instead of `item_id`, and `attempts.family_id` is denormalised so per-family
  aggregates never join `items`. Only bank items get `item_stats`.
- **JSON blobs** carry the full entity (`toJson()`), and free-form `config`/`answer`/`settings`,
  so a content contract change (US-015) or a new engine answer shape never needs a migration.
- **Aggregates in SQL.** `AttemptsDao.familyAggregates` computes count, correct, mean and median
  RT per family with window functions (`ROW_NUMBER`/`COUNT ... OVER`), optionally filtered by
  date range and session mode. `AttemptsDao.sessionFamilyAggregates` does the same partitioned
  by `(session, family, section_index)` plus an `unanswered` count (`answer IS NULL`, i.e.
  timeouts), filtered by session start date, mode and family: one row per chart point / exam
  section, so the stats service (US-075) never loads attempts. `ItemStatsDao.recordOutcome`
  increments in the `DO UPDATE` clause, so concurrent writers never lose an update.
- **Background isolate.** The app executor is `NativeDatabase.createInBackground`, so queries
  never block the UI thread; tests use `NativeDatabase.memory()`.
- **Web is not persisted yet.** `drift/native.dart` needs `dart:ffi`, so `open_database.dart`
  selects a stub on web that keeps `flutter build web` compiling and throws `UnsupportedError`
  on the first query. Wiring drift's `WasmDatabase` (`sqlite3.wasm` + `drift_worker.js` served
  from `web/`) is a follow-up card; until then the web target cannot record sessions.

### Schema migrations

`AppDatabase.schemaVersion` is the version of the *database* schema; the content bundle's
`schemaVersion`/`contentVersion` are separate (recorded in `content_meta`). To change a table:

1. Edit the table class, bump `schemaVersion`.
2. On the first bump, export the v1 snapshot and enable step-by-step migrations:
   `dart run drift_dev schema dump lib/core/db/app_database.dart drift_schemas/` then
   `dart run drift_dev schema steps drift_schemas/ lib/core/db/schema_versions.dart`, and set
   `onUpgrade: stepByStep(from1To2: ...)` in `AppDatabase.migration`.
3. Add a migration test with `drift_dev schema generate` fixtures.
4. Regenerate (`make gen`) and document the change here.

Content mirrors need no migration: the seeder (US-013) re-seeds them from assets whenever
`content_meta` does not match the bundled manifest; only the user tables need a real upgrade path.

### Content seeding (US-013)

The app ships its whole content in the asset bundle and mirrors it into the content tables on
first launch and after every `contentVersion` bump, so it works offline from the first screen.

```
assets/content/**  --rootBundle-->  AssetReader  -->  ContentBundleLoader  -->  ContentSeeder  -->  ContentDao.replaceAll
                                    (core/db/seed/)   read + parse           version check        one transaction
```

| File (`core/db/seed/`) | Role |
|------|------|
| `asset_reader.dart` | `AssetReader` interface (`listAssets(prefix)`, `readString(path)`); `RootBundleAssetReader` lists the generated `AssetManifest` and reads through `rootBundle`. Tests use `FileAssetReader` (`test/helpers/`) over the repository's `assets/content/` or a temp copy of it |
| `content_bundle_loader.dart` | `ContentBundleLoader.read()` loads `manifest.json` then every `.json` / `.md` under the declared module folders into a `RawContentBundle` (a map of strings); the static `parse()` decodes it with `ContentBundleParser` into a `LoadedContentBundle`. Files are dispatched on their `kind` field; media is never read. Drafts (`status: draft`) are dropped |
| `content_seeder.dart` | `ContentSeeder.seedIfNeeded()`: reads the manifest, compares `contentVersion` with `content_meta`, and when the bundle is newer (or nothing is stored) reads, parses and calls `ContentDao.replaceAll` (delete + batch insert of every content table and the new meta in **one transaction**). Returns a `SeedResult` (seeded or not, versions, elapsed, counts) |
| `content_ready_provider.dart` | `assetReaderProvider`, `contentSeederProvider`, `contentReadyProvider` (`FutureProvider<SeedResult>`, Riverpod auto-retry disabled) |

The seeder lives under `core/db/` rather than in `package:psy_content` because it depends on
Drift (`ContentDao`, `ContentRows`); `packages/psy_content/` stays pure Dart (US-007).

Decisions:

- **Versioning.** Only `manifest.contentVersion` matters: bundle newer than `content_meta` (or no
  row) -> re-seed; equal -> no-op (a few milliseconds: one asset read and one row); older (a
  downgraded build) -> left alone. `seedIfNeeded(force: true)` exists for tooling. Entity
  `version`s are stored but never compared.
- **User data is never touched.** `replaceAll` only deletes and inserts the content tables;
  `sessions`, `attempts`, `item_stats`, `flashcard_reviews`, `lesson_progress` and
  `user_profile` keep referencing content by id (ids are permanent, AUTHORING.md §2). Verified
  by `test/core/db/seed/content_seeder_test.dart` ("a version bump re-seeds and keeps sessions
  and attempts").
- **Lessons store their markdown.** The seeder reads the `.fr.md` / `.en.md` files a lesson's
  `file` points to and stores them in `body` (`file` becomes null). The lesson viewer (US-041)
  therefore reads `Lesson.body` from the repository like any other field and never touches the
  asset bundle, and a remote content source (EPIC-13) needs no asset access either. Images
  referenced from the markdown stay module-relative asset paths (`english/media/x.svg`),
  loaded by the viewer from `assets/content/<module>/`.
- **Lexical fields** (`verbal_boxes/lexical_fields/*.json`) are parsed and validated at seeding
  time but not stored: there is no table until the `word_boxes` generator (US-085) needs one.
- **Off the UI thread.** Asset reads are asynchronous on the main isolate (they need the
  platform channel); parsing runs in a short-lived isolate through `compute`
  (`ContentBundleLoader.parse` is static and works on plain strings; parse errors are re-thrown
  without their `cause` so they cross the isolate boundary); the SQL runs on the database
  isolate (`NativeDatabase.createInBackground`). Tests inject an inline parse function.
- **Performance.** `content_seeder_test.dart` seeds the real bundle into an in-memory database
  and asserts `elapsed < 2 s`, printing the measurement (about 0.35 s for 594 items and 16
  lessons on a laptop, isolate spawn included).
- **Errors.** A corrupt file surfaces as the parser's `ContentParseException` (file and entity
  named); nothing is written (the transaction never starts). The startup gate shows it on
  `ErrorScreen` with a retry button that re-runs the seeder.

**Startup sequence.** `lib/app.dart` wraps the `Router` in `StartupGate`
(`core/router/startup_gate.dart`; with `ErrorScreen`, the only UI in `core/`), which watches
`contentReadyProvider` and `onboardingCompletedProvider` and renders:

- the seeding error -> `ErrorScreen` with retry (`ref.invalidate(contentReadyProvider)`);
- content ready **and** onboarding flag hydrated -> the router (first location resolved with
  the guard already synchronous, so nothing flashes);
- otherwise `SplashScreen`: page background only, then after `StartupGate.splashDelay`
  (250 ms) the app name and "Chargement du contenu…" fade in. A warm launch never shows the
  text; a first launch or a content update shows it for the seeding time.

Watching the onboarding provider from the gate starts its hydration in parallel with the
seeding instead of after it. Tests that pump the whole app add `contentReadyOverride()`
(`test/helpers/content_ready_fakes.dart`) next to `progressRepositoryOverride()`.

**Registering assets.** Flutter lists asset *directories* non-recursively, so every folder under
`assets/content/` (except `examples/`) is listed in `pubspec.yaml` between the
`# BEGIN content assets` / `# END content assets` markers. After adding a family folder, a
`lessons/<family>/` folder or an `items/`, `decks/`, `lexical_fields/`, `media/` subfolder, run
`dart run tools/list_content_assets.dart --write` from the repo root (`--check` verifies;
`tools/test/list_content_assets_test.dart` fails when the list is stale, and
`test/core/db/seed/content_ready_provider_test.dart` checks through `rootBundle` that every
file on disk is actually bundled).

## Progress / analytics (US-075)

All aggregates the app shows or decides on come from one tested service so the dashboard
(US-070), charts (US-071), adaptive difficulty (US-053) and recommendations (US-073) agree.

```
features/progress/
  domain/
    stats_config.dart        StatsConfig, ReadinessWeights: every tunable number
    stats_service.dart       StatsService: pure functions of repository rows, injectable clock
    progress_analytics.dart  ProgressAnalytics: fetches rows from the repositories, calls the service
    family_progress.dart     FamilyProgress, Trend, TrendDirection
    time_series.dart         TrendPoint, TimeSeries (chart data)
    exam_summary.dart        ExamSummary, SectionScore
    readiness_score.dart     ReadinessScore
    weak_area.dart           WeakArea, WeakAreaKind, WeakAreaReason
    progress_snapshot.dart   ProgressSnapshot: everything the dashboard needs, in one pass
    progress_domain.dart     barrel
  presentation/providers/
    stats_service_provider.dart        statsConfigProvider, statsServiceProvider
    progress_analytics_provider.dart   progressAnalyticsProvider (over the two repositories)
    progress_version_provider.dart     progressVersionProvider: cache key, bump() after a session
    progress_snapshot_provider.dart    progressSnapshotProvider  (FutureProvider, cached)
    exam_history_provider.dart         examHistoryProvider       (FutureProvider, cached)
    family_time_series_provider.dart   familyTimeSeriesProvider  (autoDispose family, cached)
```

`domain/` is pure Dart (enforced by `test/architecture/no_flutter_in_domain_test.dart`: no
Flutter, Riverpod or Drift under any `features/*/domain/`). The providers live in
`presentation/providers/` like every other feature's; there is no `application/` layer because
`ProgressAnalytics` is plain Dart and only needs the repository interfaces.

### Inputs

The service is generic over activities: an attempt is correct or not, took `responseMs`, and
was answered or not (`answer == null` = timeout, counted as wrong). Engine-specific metrics
(restarts, rule violations, tracking error) stay in the attempt's `answer` json and are read by
the engine's own summary screen, not by the stats service. The only rows it consumes are SQL
aggregates:

| Input | Query | Grain |
|---|---|---|
| lifetime per family | `ProgressRepository.familyStats()` | one row per family |
| series / sections | `ProgressRepository.sessionFamilyStats(from, to, mode, familyId)` | one row per (session, family, section) |
| exam sessions | `ProgressRepository.sessions(mode: exam)` | one row per session |
| lesson progress | `lessonsRead().length` / `ContentRepository.lessons().length` | counts |
| tags | `itemStats()` joined to `ContentRepository.itemsByIds(...).tags` | one row per bank item seen |

`snapshot()` loads the per-session rows once (all time; one row per session and family, so it
grows with sessions, not attempts) and derives every family from them.

### Formulas

- **Accuracy** = `correct / attempts` over the rows in scope (lifetime for the family card,
  per session for chart points, per section for exams). Timeouts are wrong answers.
- **Median response time**: computed in SQL (average of the two middle values). When several
  rows of one session are merged (an exam with two sections of the same family, or a family
  card built without the lifetime row), the merged median is the attempt-weighted mean of the
  row medians (an approximation, documented on `StatsService.timeSeries`).
- **Level 1..5** from lifetime accuracy: level 1 below the first threshold *or* with fewer than
  `minAttemptsForLevel` (10) attempts, then one level per threshold reached:
  `levelThresholds = [0.50, 0.65, 0.80, 0.90]`. `levelFraction = (level - 1) / 4`.
- **Trend over 7 / 30 days** (`StatsService.shortWindow` / `longWindow`, from the injected
  clock): over the session points started in the window, `slope` = least-squares slope of
  session accuracy against time (accuracy points per day), `delta` = last minus first session
  accuracy. `direction` is `up` when `delta >= trendDeltaThreshold` (0.05) and `slope > 0`,
  `down` when `delta <= -0.05` and `slope < 0`, `flat` otherwise (including fewer than two
  sessions).
- **Items done** = lifetime attempts; **last practised** = start of the latest session with
  attempts of the family (any mode).
- **Exam summary**: with the blueprint, one `SectionScore` per blueprint section (0 when never
  reached) weighted by `ExamSection.weight`; without it, the sections seen, weight 1.
  `score = sum(weight_i * accuracy_i) / sum(weight_i)` in 0..1 (`percent` rounds to 0..100).
  `deltaVsPrevious = score - previous.score` where *previous* is the latest earlier **completed**
  simulation of the same blueprint (abandoned ones get a delta but are never a reference).
- **Readiness 0..100** = `100 * (w_f * F + w_l * L + w_e * E) / (w_f + w_l + w_e)` with
  `ReadinessWeights(families: 0.6, lessons: 0.15, exams: 0.25)` and
  - `F` = weighted mean of `levelFraction` over every content family (plus families only seen
    in attempts), weights from `StatsConfig.familyWeights` (MVP families of EPIC-03 weigh 2:
    `memory_nback`, `attention_rules`, `attention_parity`, `logic_dominos`, `arithmetic_grid`,
    `culture_aero`, `english` / `english_reading`; the others 1; unknown ids
    `defaultFamilyWeight` = 1). A family never practised is level 1, i.e. contributes 0.
  - `L` = `min(lessonsRead, lessonsTotal) / lessonsTotal` (0 without lessons).
  - `E` = mean `score` of the latest `recentExamCount` (3) completed simulations (0 without).
  Without any exam the score tops out at 75, by design: a simulation is part of being ready.
- **Weak areas**: a family with `attempts >= minAttemptsForWeakArea` (10) and lifetime accuracy
  `< weakAccuracyThreshold` (0.6) is flagged `lowAccuracy`; a family whose 30-day trend is
  `down` is flagged `negativeTrend` (a family can carry both). Item tags (from `ItemStat`s of
  bank items and the items' `tags`) are flagged `lowAccuracy` with the same thresholds.
  Families first, then tags, each weakest first.

Every constant lives in `StatsConfig` (`statsConfigProvider`); change it there, not in the
service, and update this section.

### Dashboard (US-070)

`features/progress/presentation/` renders the snapshot:

```
progress_screen.dart                 ProgressScreen: loading / error / empty state / dashboard
providers/
  exam_date_provider.dart            examDateProvider (UserProfile.examDate), daysUntil()
  dashboard_labels_provider.dart     dashboardLabelsProvider: family / blueprint names by id
  recent_activity_provider.dart      recentActivityProvider: last 10 finished sessions + score
widgets/
  readiness_card.dart                ArcGauge of the readiness, trend arrow, ExamCountdownChip
  family_levels_chart.dart           RadarChart (>= 3 practised families) or HorizontalBarChart
  weak_areas_preview.dart            top 3 WeakAreas with a "train" action (-> /train until US-072)
  recent_activity_list.dart          sessions and sims, newest first
  progress_empty_state.dart          no data yet -> first drill
  progress_bands.dart                success / warning / error thresholds, overallTrend()
```

Presentation-only rules (the formulas above stay in the service):

- **Bands**: readiness `< 40` error, `< 70` warning, else success; level `1..2` error, `3`
  warning, `4..5` success; a session score uses the readiness thresholds (`ProgressBands`).
- **Overall trend arrow** = majority of the 30-day `TrendDirection` over families with data
  (`up` when more families improve than decline, `down` in the opposite case, else `flat`).
- **Recent activity score** = the `ExamSummary.score` for a simulation, else
  `TrainingSession.score` when the runner stored one, else `correct / attempts` over the
  session's `sessionFamilyStats` rows; null (shown as `—`) when nothing was answered.
- **Chart choice**: the radar shows every content family in `order` (level 1 = centre) once at
  least three have data; below that, horizontal bars of the practised families only.
- **Days until exam** are whole local calendar days (`daysUntil`), computed against the
  snapshot's `computedAt` so tests with a fixed clock are deterministic.

### Score-over-time charts (US-071)

```
family_trend_screen.dart             FamilyTrendScreen (/progress/family/:familyId), TrendRange
widgets/
  family_trend_charts.dart           FamilyTrendCharts: accuracy + median RT LineCharts, TrendTooltip
  exam_score_chart_card.dart         ExamScoreChartCard / ExamScoreChart / ExamSectionBreakdown
  segmented_choice.dart              SegmentedChoice: the range and mode pills
  family_levels_chart.dart           + FamilyChip row (onFamilySelected) opening the family page
```

- The chart primitive is `LineChart` (`shared/widgets/line_chart.dart`, see
  `docs/DESIGN_SYSTEM.md`); the feature only maps `TrendPoint`s / `ExamSummary`s to
  `LineChartPoint`s and writes the tooltips and semantics summaries.
- **Family page**: `familyTimeSeriesProvider((familyId, from, to, mode))` with
  `from = now - TrendRange.window` (`StatsService.shortWindow` / `longWindow`, null for `Tout`)
  and `mode` null / practice / exam. `now` is read once per screen (`statsServiceProvider`,
  fixed in tests) so the query record, and the cached provider instance, stay stable across
  rebuilds. `x` = session index (oldest first), `y` = accuracy (0..1, fixed axis) or median
  response time in seconds (0..ceil(max)); ticks under the baseline carry `dd/MM` dates.
- **Exam chart**: `examHistoryProvider` filtered to `completed`, oldest first; `y` = `score`.
  The selected attempt is kept by session id so a refresh keeps the breakdown open. Sections are
  `HorizontalBarChart` entries in `sectionIndex` order, painted in the readiness bands
  (`ProgressBands.score`), "non atteinte" when `attempts == 0`.

### Caching and invalidation

`progressSnapshotProvider`, `examHistoryProvider` and `familyTimeSeriesProvider` are
`FutureProvider`s that `watch(progressVersionProvider)`. Results are cached until the version
is bumped, which recomputes them once:

```dart
await ref.read(progressRepositoryProvider).finishSession(id, status: SessionStatus.completed);
ref.read(progressVersionProvider.notifier).bump();
```

The practice runner (US-051), the exam runner (US-061) and lesson progress (US-044) bump after
their writes. `familyTimeSeriesProvider` takes a record `(familyId, from, to, mode)` so equal
chart queries share one result and is `autoDispose` so ranges nobody watches are dropped.
Tests override `statsServiceProvider` with a fixed clock and the two repository providers with
the in-memory fakes.

### Streaks and daily goal (US-073)

```
features/progress/
  domain/
    daily_goal.dart           GoalUnit, DailyGoal (target, unit; UserProfile.settings['goal'])
    streak_service.dart       ActivityEvent, DailyActivity, StreakSummary, StreakService
  presentation/
    providers/
      daily_goal_provider.dart    dailyGoalProvider (hydrate-once Notifier, same shape as
                                  appSettingsProvider); settings screen writes it
      streak_provider.dart        streakServiceProvider, streakSummaryProvider
    widgets/
      streak_card.dart            StreakCard: streak counter, an ArcGauge progress ring, the
                                  heat-map
      activity_heatmap.dart       ActivityHeatmap: CustomPainter calendar heat-map
```

`StreakService` is pure Dart (an injectable clock, no repository access): it takes a flat list of
`ActivityEvent` (`at`, `itemCount`, `responseMs`) and a `DailyGoal`, and returns a `StreakSummary`
(current/best streak, today's progress and goal-met flag, and a `heatmap` of `DailyActivity` for
the requested window, default the last 12 weeks). `streakSummaryProvider` builds the events from
`ProgressRepository.allAttempts()` (every practice attempt and exam-section attempt counts as one
item) and `allFlashcardReviews()` (each card's `lastReviewedAt`, when set, counts as one item —
only the latest review per card is stored, not a full history, so a card reviewed several times
the same day is undercounted by design). Both repository methods return the raw rows (no SQL
aggregation) so the service buckets them into days itself.

Day boundaries are **local midnight** (`DateTime.toLocal()`), not UTC, so a session just after
midnight streaks as a new day even though the stored timestamp is UTC. The streak counts *any*
activity that day, independent of the goal; goal-met is a separate flag on today's cell only, so
editing the goal never rewrites history. `streakSummaryProvider` watches `progressVersionProvider`
(recomputes after a finished session, same as the rest of the dashboard) and `dailyGoalProvider`
(recomputes when the goal changes, no version bump needed).

`ActivityHeatmap` chunks its `days` (oldest first) into columns of 7 — a rolling window ending
today, not calendar weeks starting Monday — and paints one cell per day with `CustomPaint`,
coloured by a fixed 0..4 intensity bucket (`ActivityHeatmap.level`) blended between
`accentSubtle` and `accent`; one `Semantics` node summarises it (`activityHeatmapSemanticsValue`),
the cells themselves excluded. `StreakCard` reuses the shared `ArcGauge` (`shared/widgets/`) for
the progress ring rather than a new primitive, since it is already exactly "a 0..1 value with a
label in the middle".

### Backup export / import (US-074)

`BackupService` (`features/settings/domain/backup_service.dart`, pure Dart) shapes and validates
a single versioned JSON document that is the whole of a user's data:

```json
{
  "format": "psy-trainer-backup",
  "version": 1,
  "exportedAt": "2026-09-12T10:00:00.000Z",
  "app": { "name": "psy_trainer", "version": "1.2.3" },
  "data": {
    "sessions": [ { "id": "...", "updatedAt": "...", "fields": { /* every column */ } } ],
    "attempts": [ ... ],
    "itemStats": [ ... ],
    "flashcardReviews": [ ... ],
    "lessonProgress": [ ... ],
    "profile": { "id": "me", "updatedAt": "...", "fields": { ... } } | null
  }
}
```

Each row of `data` is a `BackupRow` (`core/repositories/model/backup.dart`): its id, its
`updatedAt` (the merge watermark) and `fields` — every column of the row, JSON-encoded exactly as
Drift's generated `toJson()`/`fromJson()` already do it (`row.toJson()` on the way out,
`XxxRow.fromJson(row.fields)` on the way in), so `BackupService` never needs its own per-table
mapping. This is deliberately **not** the feature-facing domain models (`TrainingSession`,
`Attempt`...): those do not carry `updatedAt` (a Drift-row-only concern until now), and a raw row
dump is exactly the shape a future remote sync (EPIC-13) needs to diff against a server — this
format *is* that contract, expressed a version early.

`ProgressRepository.exportSnapshot()` / `.importSnapshot(BackupSnapshot)` (both implementations:
`LocalProgressRepository` reads/writes the tables directly, `InMemoryProgressRepository` tracks a
parallel `updatedAt` per row purely for this) do the actual merge, one table at a time:

- **`sessions` / `attempts`**: the row `id` is the only identity a row has, so an imported row
  wins over an existing one at the same `id` when its `updatedAt` is strictly newer; sessions are
  merged before attempts (attempts reference `sessionId`).
- **`itemStats` / `flashcardReviews` / `lessonProgress` / `profile`**: merged by their *natural*
  unique key (`itemId`, `flashcardId`, `lessonId`, the single profile row) instead, since two
  independent exports can assign different row ids to what is the same item; the existing row's
  id/`createdAt` are kept, only its fields and `updatedAt` change.
- A tie or an older `updatedAt` is left alone (`BackupImportSummary.skipped`).
- Content tables (`items`, `lessons`...) are never part of a backup or touched by it — they are
  re-derived from the bundled assets (US-013), never user-authored.

`BackupService.parseSnapshot` validates the envelope before anything is written — wrong
`format`, missing/non-object `data`, a `version` newer than this app understands, or a row missing
`id`/`updatedAt`/`fields` — and throws `BackupFormatException(BackupErrorReason)`; the settings
screen maps each reason to a localized message (`context.l10n`, never a literal string in
`domain/`).

**Export**: `share_plus` (Material-free — checked before adding it) with `XFile.fromData` (no
`dart:io`/`path_provider` file write needed) and `ShareParams.downloadFallbackEnabled` (its
default), so the same call opens the native share sheet on mobile/desktop and triggers a browser
download on web without any platform branching in this app's code.

**Import**: no Material file picker exists on this widgets-only stack, and `file_picker` was not
added (unverified Material-freedom, and native file-picking entitlements per platform were out of
scope for this story); instead the settings screen's backup section has a paste-JSON field
(`features/settings/presentation/widgets/plain_text_area.dart`, `PlainTextArea`) built directly on
`EditableText` (see "No Material, no Cupertino" above) — paste the exported file's content,
"Importer" parses, validates and merges it, and reports `BackupImportSummary` (inserted/updated/
skipped) or the validation error.

## Engine

The generic activity runtime (US-020) runs every PSY0 activity of EPIC-03 in practice and
exam mode. An activity engine only implements **a generator, a scorer and a renderer**; the
runtime sequences the items, runs the timers and the cadence, records the attempts, scores the
section and exposes the state to the screens.

```
features/train/
  domain/engine/                      pure Dart (no Flutter), barrel engine.dart
    activity_engine.dart              ActivityEngine (familyId, generatorId, generate(params, seed, difficulty,
                                      index, runSeed), score, materialise), EngineRegistry, EngineNotFoundError,
                                      GeneratorId.jsonName
    activity_session.dart             ActivitySession: the state machine (start/answer/next/pause/resume/abort,
                                      resume from attempts), persistence through ProgressRepository
    activity_session_config.dart      ActivitySessionConfig (family, mode, source, timing, scoring, liveFeedback,
                                      sessionId/ownsSession/sectionIndex/positionOffset for the exam runner), JSON
    activity_session_state.dart       ActivitySessionState = briefing | running | paused | finished; ItemPhase
    answer.dart                       Answer = choice | numeric | multiSelect | key | sequence | skip | timeout | raw
    item_result.dart                  ItemResult (correct, timedOut, skipped, metrics), ItemOutcome (+ responseMs)
    item_source.dart                  ItemSource = bank(items) | generator(generatorId, seed, params, count, difficulty)
                                      | adaptive(generatorId, runSeed, params, count, initialDifficulty,
                                      fastThresholdMs, policy) (US-053) | replay(origins),
                                      SessionItem (item + itemId | AttemptOrigin). `seed` doubles as the run's
                                      `runSeed` (US-037): identical for every item, handed to `generate` alongside
                                      each item's own position (`index`) and its per-item `seed` (still derived
                                      from `runSeed`, kept for id/backward-compat)
    adaptive/                         domain/adaptive/ (US-053), pure Dart, imported by domain/engine/
      adaptive_difficulty_policy.dart AdaptiveDifficultyPolicy (streak thresholds, clamps, fastCutoffMs),
                                      AdaptiveDifficultyState (level + both streaks), LevelChange
    timing_policy.dart                TimingPolicy (perItemMs, sectionMs, cadence; fromSection, forPractice)
    scorer.dart                       Scorer.scoreItem (mcq / numeric / sequence defaults), Scorer.section
    session_result.dart               SectionResult (accuracy, RT, timeouts, points), SessionResult, FinishReason
    engine_clock.dart                 EngineClock, SystemClock, ManualClock (tests)
  presentation/engine/                widgets + Riverpod, barrel engine_ui.dart (re-exports the domain barrel)
    activity_renderer.dart            ActivityRenderer (build, buildExample(context, [run])), ActivityRenderContext,
                                      ActivityWidgetBuilder, FunctionRenderer, RendererRegistry, RunExampleContext
                                      (runSeed + params of the run about to play, from a generator source; US-037)
    engine_registry_provider.dart     engineRegistryProvider, rendererRegistryProvider, engineClockProvider
                                      = the composition root where engines are registered
    activity_session_controller.dart  activitySessionControllerProvider (autoDispose family Notifier),
                                      ActivitySessionRequest = fresh(config) | resume(session, attempts)
    session_host.dart                 SessionHost: briefing -> renderer + countdown bars -> onFinished
```

`presentation/engine/` is the one presentation folder other features may import: the exam
runner (US-061) and every engine's renderer depend on it, exactly as they depend on
`domain/engine/`. Engines live in `lib/features/engines/<family_id>/{domain,presentation}/`
(one folder per EPIC-03 story) and never import each other.

### Runtime behaviour

- **State machine.** `briefing -> running(itemIndex) -> finished`, with `paused` reachable from
  `running` in practice only. Items are built in the constructor (a generator source with a
  seed always yields the same run); `start()` opens the `TrainingSession` (unless the config
  attaches to one) and shows item 0. `answer()` scores through the engine and records the
  attempt at once; `next()` moves on after feedback; `abort()` ends as `aborted`. Commands
  that do not apply to the current state are ignored (a second answer on the same item,
  `next()` without feedback), except `pause()` in exam mode and a `TimeoutAnswer`, which are
  programming errors and throw.
- **Feedback policy.** `config.showsFeedback` = practice, or exam with `liveFeedback` (from
  `TestFamily.liveFeedback` / `ExamSection.liveFeedback`: rules S-R, parity restart). When
  shown, `ActivityRunning.feedback` carries the verdict and the item waits for `next()`
  (`awaitsNext`); when hidden, `feedback` stays null and the session advances at once. The
  renderer never decides this.
- **Timing** (`TimingPolicy`, from `ExamSection` or the family defaults): a per-item limit
  records a `TimeoutAnswer` (stored as `answer = null`, which the stats service counts as a
  timeout) and advances (or shows the timeout feedback in practice); a section limit ends the
  session as `sectionTimeout`, recording the open item as a timeout and leaving the rest
  unplayed; a **cadence** (`stimulusMs` + `answerWindowMs`) shows `ItemPhase.stimulus` then
  `answer`, accepts an answer during both, and advances at the end of the window whether or
  not an answer came, so the rhythm never slips. Cadence wins over the per-item limit. Pause
  freezes every timer and is excluded from response times.
- **Persistence.** `startSession` when the first item appears, `recordAttempt` per item (bank
  `itemId` or `AttemptOrigin{generatorId, seed, params}`, `position = positionOffset + index`,
  `sectionIndex`), `finishSession(completed | abandoned, score = accuracy)` at the end when
  the config `ownsSession`. Writes are chained and never block the state machine; `idle`
  completes when they settled; failures go to `onPersistenceError` (the controller logs them).
  The exam runner creates one `TrainingSession`, runs each section with
  `sessionId`, `ownsSession: false`, `sectionIndex` and `positionOffset`, then finishes it.
- **Resume.** `ActivitySession.resume(session:, attempts:)` rebuilds the config from
  `TrainingSession.config` (the runtime stored `ActivitySessionConfig.toJson()` there), replays
  the attempts of its section into outcomes, starts at the next item (`ActivityBriefing.startIndex`)
  and shortens a section limit by the response time already spent. Because a generator source's
  `seed` (the run's `runSeed`, US-037) is part of that stored config, re-materialising it
  (`ItemSource.materialise`) always yields the exact same items in the exact same order,
  whether or not any engine reads `runSeed`/`index` -- a resumed run-scoped generator (n-back,
  rules) picks up mid-stream identically to a fresh one. US-051/US-064 decide when to offer it
  (`sessions(status: inProgress)`).
- **Adaptive difficulty (US-053).** `ItemSource.adaptive` is the practice launcher's
  choice for a generated family: it starts at `initialDifficulty` (the launcher's fixed pick,
  or the family's `StatsService`/`FamilyProgress.level` on "Auto") and has no fixed item list
  up front -- the difficulty of item *k* depends on how items `0..k-1` were answered, so
  `ActivitySession` materialises each item lazily, right when it is shown
  (`ItemSource.materialiseAdaptive(engine, index, difficulty)`), keyed by `(runSeed, index)` so
  it stays reproducible whatever order indices are materialised in (a resumed session rebuilds
  earlier indices from their stored `AttemptOrigin`s, not by replaying from index 0).
  `AdaptiveDifficultyPolicy` (`domain/adaptive/`) folds each answered item into an
  `AdaptiveDifficultyState` (current level + both streaks): 3 consecutive correct-and-*fast*
  answers move the level up by 1, 2 consecutive wrong ones move it down by 1, both clamped
  1..5, both streaks resetting on a level change. "Fast" is at or under `fastThresholdMs` (the
  family's own median response time, resolved once by the launcher from `StatsService`) or,
  failing that, 60% of the per-item time limit; with neither known (untimed, no history) every
  correct answer counts as fast. Every `LevelChange` is recorded on `SessionResult.levelChanges`
  for the summary ("niveau 2 -> 4", `session_summary_screen.dart`) and `SessionHost` shows a
  small pill next to the progress dots (`ActivityRunning.level`) that only exists for this
  source. Deviations, both intentional and documented in code: (1) `TrainingSession.config` is
  written once by `startSession`, before any level change can have happened, and
  `ProgressRepository.finishSession` takes no config update, so level changes do not also ride
  along in the persisted config -- only on the in-memory `SessionResult` the summary screen
  already holds; the difficulty actually played on every item is still durable, via each
  attempt's own (pre-existing) `AttemptOrigin.difficulty`. (2) Bank families do not adapt
  in-session: their whole sample is drawn once, up front, and "Auto" still samples from the
  whole pool rather than narrowing to the resolved level, since a bank's item pool at exactly
  one level can be thin or empty for content not yet calibrated across all 5 levels.
- **Time.** Everything goes through `EngineClock`; `SystemClock` uses `Timer`s (fake-able with
  `fakeAsync`), `ManualClock.elapse()` steps time by hand in unit and widget tests.
- **Controller.** `activitySessionControllerProvider(request)` builds the session over
  `engineRegistryProvider`, `progressRepositoryProvider` and `engineClockProvider`, mirrors its
  states, forwards the commands and bumps `progressVersionProvider` once the finished session
  is persisted. Auto-dispose aborts a session still running (a screen that leaves = quit).

### Adding an activity engine in 5 steps

1. **Generator** (`lib/features/engines/<family>/domain/<family>_engine.dart`): subclass
   `ActivityEngine`, return `familyId` (= `TestFamily.engineType`, e.g. `memory_nback`) and
   `generatorId` (`GeneratorId.nback`), and implement
   `generate({params, seed, difficulty, index = 0, runSeed})` with `Random(seed)` (or
   `Random(runSeed)`, see below) only: same inputs, same item. Cast the typed params
   (`params as NbackParams`, or `switch`), give the item the id
   `ActivityEngine.generatedItemId(generatorId, seed)` and `origin: ItemOrigin(generatorId,
   seed, runSeed: runSeed ?? seed, index: index)`. Return an `McqItem` / `NumericItem` when
   the activity is one (dominos, viewpoint, tubes); for interactive activities return a
   `GeneratedItem` whose `params` carry what the renderer needs, or keep the stimulus in
   engine-owned data derived again from the seed. Bank-driven engines (culture, English) skip
   this step: `generatorId` stays null.

   **`runSeed`/`index` (US-037).** `ItemSource.generator`'s own `seed` is the run's `runSeed`:
   identical for every item of the run, unlike the per-item `seed` (still drawn one per item
   from `Random(runSeed)`, still what `generatedItemId` and `ItemOrigin` key replay on for
   simple generators). Most engines never read `runSeed`/`index` (arithmetic grid, dominos,
   parity: every item is independent). An engine whose items depend on the run's *other* items
   -- item k needs to know what item k-n actually showed (n-back), or every item of a run must
   share one property drawn once (the rules engine's rule set) -- reads `runSeed` (and, for a
   continuous stream, `index`) instead of deriving state from its own `seed` alone: recompute
   the whole run from `Random(runSeed)` (`NbackSequence.build` in `memory_nback`) or shuffle a
   `params` pool with `Random(runSeed)` (`StimulusRuleSet.fromRunSeed` in `attention_rules`),
   and store `runSeed`/`index` on `origin` so the renderer and the scorer can redo the same
   computation from the materialised item alone. A direct `generate()` call with no `runSeed`
   (a unit test) falls back to `runSeed = seed`, `index = 0` -- the first item of its own
   single-item run.
2. **Scorer**: override `score(Item, Answer)` when the default (`Scorer.scoreItem`: MCQ choice,
   numeric with tolerance, sequence recall) does not apply. Return `ItemResult(correct:,
   metrics: {...})`; the metrics are summed into `SectionResult.metricTotals` for the engine's
   summary and analytics (hits/misses, restarts, precision/recall). Never handle
   `TimeoutAnswer`, the runtime does. Pick the `Answer` case that fits (`key` for key presses,
   `multiSelect` for grids, `sequence` for click paths, `raw` for anything else).
3. **Renderer** (`lib/features/engines/<family>/presentation/<family>_renderer.dart`): subclass
   `ActivityRenderer` with the same `familyId`; `build(context, render)` draws
   `render.item` for `render.phase`, calls `render.onAnswer(answer)` once, and shows
   `render.feedback` when non-null (the runtime already applied the practice/exam policy).
   Widgets layer only (no Material); keyboard input through `Focus` + `KeyboardListener`, with
   the touch fallback labelled non-representative when `inputRequirement == keyboard`. Do not
   run your own timers for the runtime's limits: `SessionHost` draws the countdown bars from
   `render.itemDeadline`; the cadence phases arrive through `render.phase`. Optionally override
   `buildExample(context, [run])` for the briefing screen; when the session's source is a
   generator, `SessionHost` passes a `RunExampleContext` (`runSeed` + `params` of the run about
   to play, US-037) so a renderer whose activity derives run-specific state from the run seed
   (the rules engine's rule set) can show this run's actual briefing instead of a generic
   stand-in. Most renderers ignore `run` and show a fixed illustration.
4. **Register**: add the engine to `engineRegistryProvider` and the renderer to
   `rendererRegistryProvider` in `features/train/presentation/engine/engine_registry_provider.dart`
   (one line each). Tests override both providers with `FakeEngine` / `FakeRenderer`
   (`test/helpers/`).
5. **Blueprint family**: check `assets/content/psy0/<family>/family.json` (`engineType`,
   `generatorId`, `defaultCadence`, `defaultPerItemTimeSec`, `liveFeedback`) and the sections of
   `assets/content/psy0/blueprints/*.json` (`itemSelection.generated.params`, `cadence`,
   `scoringPolicy`) match what the generator expects; new params keys are a contract change
   (CONTRACT.md §3, US-015).

Tests: unit-test the generator (determinism per seed, announced counts, no ambiguous items)
and the scorer in `test/features/engines/<family>/domain/`; run a full session with
`ActivitySession` + `ManualClock` + `InMemoryProgressRepository` for cadence or timing
behaviour; widget-test the renderer through `SessionHost` with the engine registered
(`test/features/train/presentation/engine/session_host_test.dart` is the template).

### Exam realism options (US-063)

The real PSY0 session's exact conditions are only partly known
(`docs/content/psy0-spec.md` §2.1/§2.2: negative marking on culture aéro was removed at some
point but is documented as configurable; whether the app allows pausing between activities is
an open question); a panel on the exam launcher (`features/exam/presentation/exam_screen.dart`,
`_RealismOptionsPanel`, above the blueprint list) lets a candidate dial the simulation closer to
or further from those conditions instead of the app guessing:

```
features/exam/
  domain/exam_realism_options.dart          ExamRealismOptions (7 bools, see the `user_profile`
                                             table above), .defaults, .realConditions preset,
                                             fromProfile/applyTo (settings key 'exam.realism')
  presentation/
    providers/exam_realism_options_provider.dart  examRealismOptionsProvider
                                             (ExamRealismOptionsController): hydrates once from
                                             the profile then holds state synchronously, same
                                             shape as `AppSettingsController`
    exam_screen.dart                        _RealismOptionsPanel: seven toggles + "Conditions
                                             réelles" (applies every option's strictest value)
```

Applied where each condition actually lives:

- **Negative marking + "Je ne sais pas" on culture aéro** (`negativeMarkingCulture`):
  `exam_section_planner.dart`'s `planExamSections` overrides the culture aéro section's
  `scoringPolicy` to `+3`/`-1`/`0` (`negativeMarkingScoringPolicy`) and every one of its bank
  items' `McqItem.allowSkip` to `true` (already rendered as "Je ne sais pas" by `McqRenderer`).
  No other family is affected.
- **Randomise shapes/colours/keys of rule-based activities** (`randomizeGenerated`): generated
  sections already draw a fresh `runSeed` per run (US-037); off fixes every generated section's
  seed to `ExamRealismOptions.canonicalSeed` instead, so a run replays identically.
- **Hide remaining time** (`hideRemainingTime`) and **hide the timer in English**
  (`hideTimerEnglish`, family `english`): `SessionHost` takes a `timingDisplay:
  TimingDisplay` parameter (`visible` default, `hiddenUntilLastMinute`, `hidden`) that only
  changes what its countdown bars draw, never the timing itself (`ActivitySessionConfig.timing`
  keeps running underneath). `ExamRunScreen` computes it per section from the realism options
  and the running section's `familyId` (carried on `ExamRunState.running` for this reason).
- **Allow/deny pause between sections** (`allowPauseBetweenSections`): the break screen always
  auto-continues after `ExamSection.breakAfterSec` (`ExamRunController._startBreak`); on top of
  that, "Continuer" (`ExamRunController.skipBreak`) ends it early. Off,
  `ExamRunController.allowsSkippingBreak` is false, `ExamRunScreen` does not render the
  "Continuer" button, and `skipBreak()` is a no-op — only the timer can advance the exam.
- **Full-screen immersive + orientation lock on mobile** (`immersiveFullScreen`): `ExamRunScreen`
  calls `SystemChrome.setEnabledSystemUIMode`/`setPreferredOrientations`
  (`package:flutter/services.dart`, not Material) on Android/iOS only, and restores the defaults
  on dispose.
- **Sound cues** (`soundCuesEnabled`): a `SystemSound.play` click at the start/end of each
  section, gated on both this toggle and the existing `soundEnabledProvider` mute
  (`features/settings/`) — the widgets layer has no other audio API, so this is the whole cue.
- **"Conditions réelles" preset**: `ExamRealismOptionsController.applyRealConditionsPreset()`
  sets every option above to `ExamRealismOptions.realConditions` in one call.
- **Keyboard-native warning on touch devices** (already existed, US-061/062): unaffected by this
  panel — `exam_section_planner.dart`'s `_briefingText` appends it to the briefing whenever
  `ExamSection.inputRequirement == InputRequirement.keyboard`.

### Local reminders (US-092)

A single daily notification, on/off + time (Settings, `_ReminderSection`), whose *content* is
recomputed every time it is (re)scheduled rather than baked in once:

```
core/notifications/
  reminder_scheduler.dart               ReminderScheduler interface, ReminderContent,
                                         nextDailyFireTime (pure, unit-tested)
  reminder_content.dart                 ReminderContentInputs, ReminderLines,
                                         ReminderContentBuilder: which lines apply, pure Dart
  reminder_scheduler_plugin.dart        PluginReminderScheduler (Android/iOS,
                                         flutter_local_notifications + zonedSchedule)
  unsupported_reminder_scheduler.dart   UnsupportedReminderScheduler: no-op, isSupported=false
                                         (macOS, Windows, web — see "Platforms" above)
  in_memory_reminder_scheduler.dart     InMemoryReminderScheduler: fake for tests, records calls
  reminder_scheduler_provider.dart      reminderSchedulerProvider: picks the impl for this
                                         platform (kIsWeb / defaultTargetPlatform)
  reminder_coordinator_provider.dart    reminderCoordinatorProvider: composes the content
                                         (due flashcards, weakest family, exam countdown) and
                                         calls scheduler.scheduleDaily/.cancel
features/settings/
  domain/reminder_settings.dart         ReminderSettings (enabled, hour, minute; settings key
                                         'reminder', see the `user_profile` table above)
  presentation/
    providers/reminder_settings_provider.dart  reminderSettingsProvider
                                         (ReminderSettingsController): same hydration shape as
                                         AppSettingsController
    widgets/time_stepper_field.dart      TimeStepperField: hour/minute steppers, same pattern as
                                         `onboarding`'s `DateStepperField`
```

`reminderCoordinatorProvider` is watched once from `PsyTrainerApp` (`lib/app.dart`) purely for
its side effect, so it runs once at app start and again whenever any of its inputs changes
(`reminderSettingsProvider`, `examDateProvider`, `flashcardsDueTodayProvider`,
`recommendationsProvider` — the last three already react to `progressVersionProvider`, so a new
attempt reschedules the reminder with fresh content next time the provider rebuilds). It loads
`AppLocalizations` directly (`AppLocalizations.delegate.load`) instead of through a
`BuildContext`, since it runs outside the widget tree; the resolved language follows
`localeProvider` ('system' falls back to `PlatformDispatcher.instance.locale`, clamped to a
supported language, else French).

`nextDailyFireTime` (platform-free) picks today if the target hour:minute has not passed yet,
tomorrow otherwise; `PluginReminderScheduler.scheduleDaily` builds the `zonedSchedule` instant
from it with `matchDateTimeComponents: DateTimeComponents.time` so the OS re-fires it daily
without the app rescheduling every day by itself (the app still reschedules on every start /
settings change, which simply replaces the same notification id, `reminderNotificationId`).

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
| `startup_gate.dart` | `StartupGate` + `SplashScreen`: holds the `Router` until the content is seeded and the onboarding flag is hydrated (see "Content seeding"). |

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

## Performance notes (US-123)

Findings and fixes from the accessibility & performance pass. Add to this section rather than
starting a new one when the next perf pass finds something.

**Chart painters (`shared/widgets/`, `features/progress/presentation/widgets/activity_heatmap.dart`).**
`ArcGauge`, `RadarChart`, `HorizontalBarChart`, `LineChart` and `ActivityHeatmap` each own a
`CustomPainter` with a `shouldRepaint` that compares fields instead of defaulting to `true`.
Three of them were comparing a `List` field (`RadarChart`'s `axes`, `LineChart`'s
`series`/`colors`/`xTicks`/`yTicks`, `ActivityHeatmap`'s `days`) with `!=`, which is reference
equality on the list itself — every rebuild passes a freshly built `List` literal, so the
comparison was `true` (repaint) even when every element was unchanged. Fixed with `listEquals`
(and an `==`/`hashCode` override on `LineChartSeries`/`RadarChartAxis`/`DailyActivity`, whose own
equality `listEquals` needs). `ArcGauge` and `HorizontalBarChart` only ever compared scalar
fields and were already correct. Each chart's `CustomPaint` is now also wrapped in its own
`RepaintBoundary`, so a repaint (hover, a changed value) rasterises just that chart's layer
instead of the screen around it.

**Ticker-driven engine scenes.** `attention_airways` and `multitask_psychomotor` run a
widget-layer `Ticker` at 60 fps (`_onTick` -> `_sim.advance(...)` -> `setState(() {})`); the scene
genuinely changes every frame, so `AirwaysPainter.shouldRepaint` correctly always returns `true`
(a deep comparison would still be `true` almost every tick and cost more than it saves) — the
`_MultitaskPainter` one already compared its scalar fields. What was missing was a
`RepaintBoundary` around each `CustomPaint`: the `setState` per tick still rebuilds the whole
`_AirwaysView`/`_MultitaskView` subtree (counters, buttons) since the ticker lives in that
`State`, but without a boundary the *repaint* (rasterisation) wasn't isolated to the animated
canvas either, so every tick re-painted layers above it too. `memory_nback`'s stimulus runs on the
runtime's item/cadence timers, not a widget-layer ticker (see its class doc), so there is no
per-frame `setState` there; its `CustomPaint` (`NbackGlyphPainter`) got a `RepaintBoundary` anyway
for the same isolation, at negligible cost.

**`progress_analytics.dart`: one N+1 found and fixed.** `_examHistory` looped over every distinct
`blueprintId` seen in the exam history and called `ContentRepository.blueprintById(id)` once per
id — a query per blueprint, right next to `_tagAccuracy`'s correct batched `itemsByIds` call three
lines above. Replaced with one `_content.blueprints()` call filtered to the ids actually seen.
Every other query in `snapshot()`/`familyProgress()`/`examHistory()` is already a single aggregate
call per collection (the file's own doc comment: "every query is an SQL aggregate... attempts
themselves are never loaded"), so no other change was needed there.

**Dashboard/progress providers already cache correctly.** `progressSnapshotProvider`,
`familyTimeSeriesProvider`, `examHistoryProvider` and `recentActivityProvider`
(`features/progress/presentation/providers/`) are `FutureProvider`s keyed off
`progressVersionProvider` (bumped explicitly after a session/lesson changes something, see that
provider's doc comment) or `.autoDispose.family` on the query — Riverpod caches the result and
never re-runs the DB query on an unrelated rebuild or every frame. No change needed.

**`setState` outside painters.** Searched `lib/features/**/presentation` and
`lib/shared/widgets` for `setState` reachable from a `Timer`/`Ticker`/`AnimationController`
callback: only the two ticker-driven engines above call it per frame (addressed with
`RepaintBoundary`, not a `setState` change — the rebuild is legitimate, only the paint needed
isolating). `SessionHost`'s countdown (`_Countdowns`, `Timer.periodic` at 100 ms) and
`word_boxes_renderer.dart`/`exam_run_screen.dart`'s own periodic timers all run at ≤10 Hz, well
under the 60 fps threshold this pass was scoped to, and each is a small, dedicated `State` (not
the whole screen), so they were left alone.

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
build), and `main` is protected so that `check` must be green to merge. A debug APK is built
(`apps/psy_trainer`) and uploaded as an artifact on pushes to `main` and on PRs labelled
`build`. Coverage is gated with `make coverage` (see `docs/TESTING.md`). Format with `dart
format .` in each member (or `melos run format` / `make format` from the root).

Release builds are a separate workflow (US-122, `.github/workflows/release.yml`) triggered by
pushing a `v*` tag rather than by `check` — see `docs/RELEASE.md` for the version bump script,
Android signing, and the manual Play/TestFlight steps.
