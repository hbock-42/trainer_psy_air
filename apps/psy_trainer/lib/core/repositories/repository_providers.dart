import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database_provider.dart';
import '../db/repositories/local_content_repository.dart';
import '../db/repositories/local_progress_repository.dart';
import '../db/storage_info.dart';
import 'content_repository.dart';
import 'progress_repository.dart';

// `StorageInfo`/`StorageKind` are `core/db/` types, but the About screen
// (US-016) needs to name them (`AsyncValue<StorageInfo>`); re-exporting them
// here keeps `lib/features/` from importing `core/db/` directly (see
// `no_drift_in_features_test.dart`).
export '../db/storage_info.dart' show StorageInfo, StorageKind;

// Composition root of the data layer: the only place that binds the
// repository interfaces to their Drift implementations. Features read these
// providers and never import `core/db/`.
//
// Widget tests override them with the in-memory fakes:
//
// ```dart
// ProviderScope(overrides: [
//   contentRepositoryProvider.overrideWithValue(InMemoryContentRepository()),
//   progressRepositoryProvider.overrideWithValue(InMemoryProgressRepository()),
// ], child: ...)
// ```

/// Read access to the seeded content.
final Provider<ContentRepository> contentRepositoryProvider =
    Provider<ContentRepository>(
      (ref) => LocalContentRepository(ref.watch(appDatabaseProvider)),
    );

/// Sessions, attempts, stats, reviews, lesson progress and profile.
final Provider<ProgressRepository> progressRepositoryProvider =
    Provider<ProgressRepository>(
      (ref) => LocalProgressRepository(ref.watch(appDatabaseProvider)),
    );

/// Where the local database is actually stored (US-016): a real file on
/// native platforms, or — on web — whichever of OPFS/IndexedDB/in-memory
/// drift's `WasmDatabase.open` chose. Read by `AboutScreen` to show the
/// storage notice and by the startup log.
///
/// Forces a trivial query first so the database has actually been opened
/// (drift's web executor only knows what it picked once its `LazyDatabase`
/// callback has run); on native this is a cheap no-op round trip.
final FutureProvider<StorageInfo> storageInfoProvider =
    FutureProvider<StorageInfo>((ref) async {
      final database = ref.watch(appDatabaseProvider);
      await database.customSelect('SELECT 1').getSingle();
      return StorageInfo.resolve();
    });
