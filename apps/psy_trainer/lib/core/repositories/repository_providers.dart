import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/app_database_provider.dart';
import '../db/repositories/local_content_repository.dart';
import '../db/repositories/local_progress_repository.dart';
import 'content_repository.dart';
import 'progress_repository.dart';

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
