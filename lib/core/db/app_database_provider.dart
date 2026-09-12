import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'open_database.dart';

/// The single [AppDatabase] of the app, opened on first read and closed when
/// the container is disposed.
///
/// Features never read this provider (they use the repository providers in
/// `core/repositories/repository_providers.dart`); tests that need the real
/// SQL path override it with `AppDatabase(openInMemoryExecutor())`.
final Provider<AppDatabase> appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase(openAppDatabaseExecutor());
  ref.onDispose(database.close);
  return database;
});
