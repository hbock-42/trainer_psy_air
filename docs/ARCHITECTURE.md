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
    content/                 # US-010 content models (JSON contract), pure Dart
    db/                      # Drift: AppDatabase, tables/, daos/, repositories/ (local impls),
                             # seed/ (content seeder, US-013)
    repositories/            # ContentRepository / ProgressRepository interfaces, domain
                             # models, Riverpod providers, in_memory/ fakes (US-012)
    errors/                  # logError + global error hooks
    l10n/                    # AppStrings (FR constants until ARB i18n, US-091)
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
test/                        # see docs/TESTING.md
  architecture/              # rules about the codebase itself (e.g. no Material)
  features/<feature>/...     # mirrors lib/features; unit + widget tests
  helpers/                   # pumpApp, golden config, shared fakes
  goldens/                   # committed golden PNGs
  tool/                      # tests for scripts under tool/
  app_test.dart              # smoke test of the root widget
tool/
  coverage_gate.dart         # lcov parser + 70 % gate on domain/data/core (make coverage)
  validate_content.dart      # content validator (US-014, make content-check)
  list_content_assets.dart   # (re)generates the assets/content/ list in pubspec.yaml (US-013)
docs/
  ARCHITECTURE.md            # this file
  TESTING.md                 # test pyramid, conventions, coverage gate
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
| Local database | `drift` on `package:sqlite3` 3.x | `sqlite3` bundles the native library through Dart hooks, so `sqlite3_flutter_libs` (now discontinued) is not needed. Schema: see "Data layer" |
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
- **Localization.** `WidgetsApp` already installs `DefaultWidgetsLocalizations`; add
  `flutter_localizations` delegates for our ARB strings only (not the Material/Cupertino ones).
  Until US-091, user-facing copy is French constants in `core/l10n/strings.dart` (`AppStrings`);
  no literal strings in screens or widgets.
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
| `user_profile` | examDate?, targetStage?, locale, settings json | single row (`id = 'me'`). Onboarding (US-090) keeps its two flags in `settings`: `onboardingCompleted` (bool) and `disclaimerAcceptedAt` (ISO-8601 UTC); the mapping lives in `features/onboarding/domain/onboarding_answers.dart` |

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

The seeder lives under `core/db/` rather than `core/content/` because it depends on Drift
(`ContentDao`, `ContentRows`); `core/content/` stays pure Dart.

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
  and asserts `elapsed < 2 s`, printing the measurement (about 0.4 s for 270 items and 16
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
`dart run tool/list_content_assets.dart --write` (`--check` verifies;
`test/tool/list_content_assets_test.dart` fails when the list is stale, and
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
    how-it-works                     nested -> /learn/how-it-works (selection stages)
  /train                             branch 1
    session/:sessionId               nested -> /train/session/:sessionId (pushed inside the tab)
  /exam                              branch 2
  /progress                          branch 3
  /settings                          branch 4
    profile                          nested -> /settings/profile (edit the onboarding answers)
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

`make lint` (`flutter analyze` + format check) and `make test` (`flutter test`) must pass before a
PR is opened. CI (US-004, `.github/workflows/ci.yml`) runs the same commands on every PR and on
pushes to `main` (`check` job: pub get, codegen, format check, `flutter analyze --fatal-infos`,
`flutter test --coverage`), and `main` is protected so that `check` must be green to merge. A
debug APK is built and uploaded as an artifact on pushes to `main` and on PRs labelled `build`.
Coverage is gated with `make coverage` (see `docs/TESTING.md`). Format with `dart format .`.
