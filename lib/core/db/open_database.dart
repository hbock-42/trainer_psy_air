import 'package:drift/drift.dart';

import 'open_database_unsupported.dart'
    if (dart.library.io) 'open_database_native.dart'
    as impl;

/// File name of the app database inside the application support directory.
const String appDatabaseFileName = 'psy_trainer.sqlite';

/// Executor for the real app.
///
/// On native platforms: a SQLite file in the application support directory,
/// opened lazily on first query and driven from a background isolate
/// (`NativeDatabase.createInBackground`) so queries never block the UI
/// thread. `package:sqlite3` supplies the native library through Dart build
/// hooks (no `sqlite3_flutter_libs`). On web the executor throws on first
/// use (see `open_database_unsupported.dart`).
QueryExecutor openAppDatabaseExecutor() => impl.openAppDatabaseExecutor();

/// Executor for tests: a fresh, private in-memory database.
QueryExecutor openInMemoryExecutor() => impl.openInMemoryExecutor();
