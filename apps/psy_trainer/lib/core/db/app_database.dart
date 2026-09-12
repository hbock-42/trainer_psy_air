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
/// and generated with `drift_dev schema steps`; do that together with the
/// first bump (v2). Until then the strategy is create-only: v1 has no
/// upgrade path, and content mirrors are simply re-seeded from assets
/// (US-013), so only user tables need care in migrations.
@DriftDatabase(
  tables: [
    ContentMetaTable,
    Modules,
    Families,
    Items,
    Lessons,
    Decks,
    Flashcards,
    Blueprints,
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
  int get schemaVersion => 1;

  /// Datetimes are stored as ISO-8601 text (UTC, millisecond precision), not
  /// unix seconds: cadence-driven activities record several attempts per
  /// second and sync (EPIC-13) needs sub-second `updatedAt` watermarks.
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
