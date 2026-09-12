import 'package:drift/drift.dart';

import 'open_database_unsupported.dart'
    if (dart.library.io) 'open_database_native.dart'
    if (dart.library.js_interop) 'open_database_web.dart'
    as impl;

/// File name of the app database inside the application support directory
/// (native platforms only; the web executor uses a database *name*, see
/// `open_database_web.dart`).
const String appDatabaseFileName = 'psy_trainer.sqlite';

/// Executor for the real app.
///
/// On native platforms: a SQLite file in the application support directory,
/// opened lazily on first query and driven from a background isolate
/// (`NativeDatabase.createInBackground`) so queries never block the UI
/// thread. `package:sqlite3` supplies the native library through Dart build
/// hooks (no `sqlite3_flutter_libs`). On web (US-016): drift's
/// `WasmDatabase.open` against `sqlite3.wasm` + `drift_worker.js` served
/// from `web/` (see `open_database_web.dart`); `open_database_unsupported.dart`
/// is now only reached on a hypothetical platform with neither `dart:io`
/// nor `dart:js_interop`.
QueryExecutor openAppDatabaseExecutor() => impl.openAppDatabaseExecutor();

/// Executor for tests: a fresh, private in-memory database.
QueryExecutor openInMemoryExecutor() => impl.openInMemoryExecutor();
