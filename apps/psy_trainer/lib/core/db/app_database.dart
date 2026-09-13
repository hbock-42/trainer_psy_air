import 'package:drift/drift.dart';

import '../repositories/model/session.dart';
import 'converters.dart';
import 'daos/attempts_dao.dart';
import 'daos/content_dao.dart';
import 'daos/flashcard_reviews_dao.dart';
import 'daos/item_stats_dao.dart';
import 'daos/lesson_progress_dao.dart';
import 'daos/sessions_dao.dart';
import 'daos/user_profile_dao.dart';
import 'tables/content_tables.dart';
import 'tables/progress_tables.dart';

part 'app_database.g.dart';

/// The app's SQLite database (US-011).
///
/// Open it with [AppDatabase.new] and an executor from `open_database.dart`
/// (`NativeDatabase.createInBackground` in the app, `NativeDatabase.memory()`
/// in tests). Features never touch this class: they go through the
/// repository interfaces in `core/repositories/` (enforced by
/// `test/architecture/no_drift_in_features_test.dart`).
///
/// ## Schema versioning
///
/// [schemaVersion] is the version of the *database* schema, independent of
/// the content bundle's `schemaVersion`/`contentVersion` (recorded in
/// `content_meta`). Bump it whenever a table or column changes and add a
/// step in [migration]:
///
/// ```dart
/// onUpgrade: stepByStep(
///   from1To2: (m, schema) async {
///     await m.addColumn(schema.sessions, schema.sessions.deviceId);
///   },
/// ),
/// ```
///
/// `stepByStep` needs the schema snapshots exported by
/// `dart run drift_dev schema dump lib/core/db/app_database.dart drift_schemas/`
/// and generated with `drift_dev schema steps`; set that up together with
/// the first bump that touches a *user* table (a column added/changed on
/// `sessions`, `attempts`...). A change that only adds a **content mirror**
/// table (like `passages` in v2, US-027) needs no data migration — content
/// mirrors are re-seeded from assets whenever `content_meta` is stale
/// (US-013) — so its `onUpgrade` step is a plain `m.createTable(...)`; only
/// user tables need the `stepByStep` treatment.
@DriftDatabase(
  tables: [
    ContentMetaTable,
    Modules,
    Families,
    Items,
    Passages,
    Lessons,
    Decks,
    Flashcards,
    Blueprints,
    LexicalFields,
    InterviewQuestions,
    ModuleSeedState,
    Sessions,
    Attempts,
    ItemStats,
    FlashcardReviews,
    LessonProgress,
    UserProfiles,
  ],
  daos: [
    ContentDao,
    SessionsDao,
    AttemptsDao,
    ItemStatsDao,
    FlashcardReviewsDao,
    LessonProgressDao,
    UserProfileDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 5;

  /// v2 (US-027): added `passages` (mirror of `ItemBank.passages`, so a
  /// running session can resolve the `Passage` an `McqItem.passageId`
  /// points to — see `ContentRepository.passage`/`passagesByIds`). It is a
  /// content mirror, re-seeded from assets like every other one (see
  /// "Content seeding" in ARCHITECTURE.md), so the upgrade only has to
  /// create the table; the seeder fills it on the next run.
  ///
  /// v3 (US-030/US-085): added `lexical_fields` (mirror of
  /// `LexicalFieldBank.fields`, the *Boîte à mots* semantic categories the
  /// `word_boxes` generator draws from — see
  /// `ContentRepository.lexicalFields`/`lexicalField`). Same story: a
  /// content mirror, so the upgrade only creates the table.
  ///
  /// v4 (US-111): added `interview_questions` (mirror of
  /// `InterviewQuestionBank.questions`, the PSY2 interview practice bank —
  /// see `ContentRepository.interviewQuestions`/`interviewQuestion`).
  /// Content mirror, so the upgrade only creates the table.
  ///
  /// v5 (US-125): added `module_seed_state` (one row per module, the gate
  /// `ContentSeeder.seedModule` uses for lazy per-module seeding — see
  /// "Content seeding" in ARCHITECTURE.md). A fresh, empty content mirror
  /// table: the upgrade only creates it, the next launch seeds every module
  /// that has no row yet.

  /// Datetimes are stored as ISO-8601 text (UTC, millisecond precision), not
  /// unix seconds: cadence-driven activities record several attempts per
  /// second and sync (EPIC-13) needs sub-second `updatedAt` watermarks.
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(passages);
      }
      if (from < 3) {
        await m.createTable(lexicalFields);
      }
      if (from < 4) {
        await m.createTable(interviewQuestions);
      }
      if (from < 5) {
        await m.createTable(moduleSeedState);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
