import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// File name of the app database inside the application support directory.
const String appDatabaseFileName = 'psy_trainer.sqlite';

/// Executor for the real app: a SQLite file in the application support
/// directory, opened lazily on first query and driven from a background
/// isolate so queries never block the UI thread. `package:sqlite3` supplies
/// the native library through Dart build hooks (no `sqlite3_flutter_libs`).
QueryExecutor openAppDatabaseExecutor() {
  return LazyDatabase(() async {
    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, appDatabaseFileName));
    return NativeDatabase.createInBackground(file);
  });
}

/// Executor for tests: a fresh, private in-memory database.
QueryExecutor openInMemoryExecutor() => NativeDatabase.memory();
