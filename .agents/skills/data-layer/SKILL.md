---
name: data-layer
description: Work with the Drift database, repositories, content seeding or web persistence in this app — use when adding a table, a repository method, a UserProfile.settings key, or touching core/db.
---

# Data layer

```
features/*  ->  core/repositories/  (interfaces + models + providers)  <-  core/db/  (Drift)
```

Features only ever see `ContentRepository`/`ProgressRepository`
(`core/repositories/repository_providers.dart`, providers `contentRepositoryProvider` /
`progressRepositoryProvider`) plus the pure-Dart models next to them (`TrainingSession`,
`Attempt`, `ItemStat`, `FamilyStats`, `SessionFamilyStats`, `FlashcardReview`, `LessonRead`,
`UserProfile`, `ContentInfo`) and the content models from `package:psy_content`. **No file
under `lib/features/` may import `package:drift`, `package:sqlite3` or `lib/core/db/`** —
enforced by `test/architecture/no_drift_in_features_test.dart`. Widget tests override the two
providers with `InMemoryContentRepository`/`InMemoryProgressRepository`
(`core/repositories/in_memory/`), which pass the same contract tests
(`test/core/repositories/*_contract.dart`) as the Drift implementations.

## `core/db/` map

| File/folder | Role |
|---|---|
| `app_database.dart` | `AppDatabase` (`@DriftDatabase`), `schemaVersion`, migration strategy |
| `open_database.dart` | conditional import: native (`NativeDatabase.createInBackground`), web (`WasmDatabase.open`), unsupported fallback |
| `storage_info.dart` | `StorageInfo.resolve()`: where the db actually lives (native file / web OPFS / IndexedDB / in-memory) |
| `tables/` | `AuditedTable` mixin (id + createdAt/updatedAt), content mirrors, user tables |
| `daos/` | one DAO per concern, typed queries — the only place SQL is written |
| `content_rows.dart` | `ContentRows`: content models -> table companions (used by the seeder) |
| `seed/` | `AssetReader`, `ContentBundleLoader`, `ContentSeeder`, `contentReadyProvider` — see "Content seeding" |
| `repositories/` | `LocalContentRepository`, `LocalProgressRepository` |
| `converters.dart` | `JsonMapConverter` for `TEXT` JSON blobs |

## Schema v1 tables

Every table: `id TEXT PRIMARY KEY`, `created_at`, `updated_at`. Content mirrors (`modules`,
`families`, `items`, `lessons`, `decks`, `flashcards`, `blueprints`) carry indexed columns +
`version` + a full `json` blob and are re-seeded, never hand-migrated. User tables: `sessions`,
`attempts`, `item_stats`, `flashcard_reviews`, `lesson_progress`, `user_profile` (single row,
`id = 'me'`). Full column list and indexes: `docs/ARCHITECTURE.md` "Data layer" table.

**`user_profile.settings`** is a JSON map holding every preference that isn't a first-class
column: `onboardingCompleted`/`disclaimerAcceptedAt`, `themeMode`, `soundEnabled`,
`keypadLayout`, `locale`, `exam.realism` (7 booleans), `reminder`, `goal`, `module`. **Adding a
new preference**: add a `<feature>/domain/<x>_settings.dart` mapping type with
`fromProfile`/`applyTo`, a `<x>Provider` (`ChangeNotifier`-free, "hydrate once then hold state
synchronously" shape — copy `ExamRealismOptionsController` or `ActiveModuleController`), and
**document the new key in `docs/ARCHITECTURE.md`** ("Data layer" table) in the same PR.

## Design decisions to follow

- **Ids**: user rows get a uuid v4 from the repository layer (never `AUTOINCREMENT`); content
  mirrors keep the bundle's content id.
- **Dates**: ISO-8601 text in UTC, millisecond precision (`storeDateTimeAsText: true`); order
  within a session by `attempts.position`, never by time.
- **Generated items** are not in `items`: an attempt on one stores
  `origin = {generatorId, seed, params}` instead of `item_id`; `attempts.family_id` is
  denormalised so per-family aggregates never join `items`.
- **JSON blobs** carry the full entity (`toJson()`); free-form `config`/`answer`/`settings` so
  a content-contract change never needs a migration.
- **Aggregates in SQL**, not Dart: `AttemptsDao.familyAggregates` / `.sessionFamilyAggregates`
  use window functions so the stats service never loads raw attempts (see
  `progress-analytics` skill).
- Executor is `NativeDatabase.createInBackground` (never blocks the UI thread); tests use
  `NativeDatabase.memory()`.

## Web persistence (US-016)

`open_database_web.dart` uses `WasmDatabase.open(sqlite3Uri: 'sqlite3.wasm', driftWorkerUri:
'drift_worker.js')` (relative URIs, sub-path safe). It picks the best storage the browser
supports and reports it via `StorageInfo`/`storageInfoProvider`: `opfsShared`/`opfsLocks` ->
`opfs` (persistent), `sharedIndexedDb`/`unsafeIndexedDb` -> `indexedDb` (persistent),
`inMemory` -> lost on reload (private browsing or unsupported browser). GitHub Pages sends no
COOP/COEP headers, so it runs on `opfsShared` or falls back to IndexedDB — still persistent.
`web/sqlite3.wasm` / `web/drift_worker.js` are prebuilt binaries pinned to `pubspec.lock`
versions; refresh with `tools/fetch_web_sqlite.sh` (`--check` to verify without downloading).

**Testing the web path**: `flutter test --platform chrome` cannot open a real `WasmDatabase`
(its dev server doesn't serve `web/`) — do not add a test that tries; see
`apps/psy_trainer/test/core/db/storage_info_web_test.dart` for what *is* tested
(`@TestOn('browser')`, pure mapping logic) and `docs/TESTING.md` "Web persistence tests" for
the manual verification procedure after `make build-web`.

## Content seeding (US-013)

```
assets/content/**  --rootBundle-->  AssetReader  -->  ContentBundleLoader  -->  ContentSeeder  -->  ContentDao.replaceAll
```

`ContentSeeder.seedIfNeeded()` compares `manifest.contentVersion` with the stored
`content_meta` row; newer -> re-seed (delete + batch insert every content table, one
transaction); equal -> no-op; older (downgraded build) -> left alone. **User data is never
touched** by `replaceAll` — only the content tables. Lessons: the seeder reads the `.md` file a
lesson's `file` points to and stores it in `body` (`file` becomes null after seeding) so the
viewer never touches the asset bundle. New folder under `assets/content/` -> `make
content-assets` (see `author-content` skill) or the seeder reports a missing file with a hint.

Startup: `StartupGate` (`core/router/startup_gate.dart`) watches `contentReadyProvider` +
`onboardingCompletedProvider` and shows `SplashScreen` / `ErrorScreen` (with retry) / the
router accordingly.

## Backup export/import (US-074)

`BackupService` (`features/settings/domain/backup_service.dart`, pure Dart) shapes/validates a
single versioned JSON envelope (`format`, `version`, `exportedAt`, `app`, `data: {sessions,
attempts, itemStats, flashcardReviews, lessonProgress, profile}`), each row a `BackupRow` (id +
`updatedAt` + `fields` = the row's own `toJson()`/`fromJson()`, never a bespoke mapping).
`ProgressRepository.exportSnapshot()`/`.importSnapshot()` merge by id (`sessions`/`attempts`,
newer `updatedAt` wins) or by natural key (`itemStats`/`flashcardReviews`/`lessonProgress`/
`profile`, since two exports can assign different ids to the same item). Content tables are
never part of a backup. Export via `share_plus` (`XFile.fromData`, Material-free); import via a
paste-JSON `PlainTextArea` (no Material file picker exists on this stack).

## Tests

Drift tests open an in-memory db per test:

```dart
late AppDatabase db;
setUp(() => db = AppDatabase(NativeDatabase.memory()));
tearDown(() => db.close());
```

Test the DAO's public queries (insert/read back, ordering, filtering) and migrations, not SQL
details; use a fixed clock for `createdAt`. See `docs/TESTING.md` "DAO tests" and "Testing
time" for the clock/`fake_async` conventions this layer relies on.

## Migrating the schema

1. Edit the table class, bump `AppDatabase.schemaVersion`.
2. First bump only: `dart run drift_dev schema dump lib/core/db/app_database.dart
   drift_schemas/` then `dart run drift_dev schema steps drift_schemas/
   lib/core/db/schema_versions.dart`; wire `onUpgrade: stepByStep(...)`.
3. Add a migration test with `drift_dev schema generate` fixtures.
4. `make gen`, then update `docs/ARCHITECTURE.md` "Data layer" with the change.

Content mirrors need no migration path (re-seeded); only user tables do.
