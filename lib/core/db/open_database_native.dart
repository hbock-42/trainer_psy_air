import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'open_database.dart';

/// Native (Android, iOS, macOS, Windows, Linux, VM tests) executors. Selected
/// by the conditional import in `open_database.dart`; do not import directly.
QueryExecutor openAppDatabaseExecutor() {
  return LazyDatabase(() async {
    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, appDatabaseFileName));
    return NativeDatabase.createInBackground(file);
  });
}

QueryExecutor openInMemoryExecutor() => NativeDatabase.memory();
