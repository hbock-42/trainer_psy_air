import 'package:drift/drift.dart';

/// Fallback for platforms without `dart:io` (today: web). Keeps the web
/// build compiling; opening the database throws until web persistence is
/// wired (drift `WasmDatabase` needs `sqlite3.wasm` and `drift_worker.js`
/// served from `web/`, which is outside US-011). Selected by the conditional
/// import in `open_database.dart`; do not import directly.
QueryExecutor openAppDatabaseExecutor() => LazyDatabase(() async {
  throw UnsupportedError(
    'The local database is not available on this platform yet '
    '(web persistence needs drift WasmDatabase assets in web/).',
  );
});

QueryExecutor openInMemoryExecutor() => openAppDatabaseExecutor();
