import 'package:drift/drift.dart';

/// Fallback for a platform with neither `dart:io` (native) nor
/// `dart:js_interop` (web, US-016) — not reached by any Flutter target this
/// app ships today, kept so the conditional import in `open_database.dart`
/// always has a default. Selected by that conditional import; do not import
/// directly.
QueryExecutor openAppDatabaseExecutor() => LazyDatabase(() async {
  throw UnsupportedError(
    'The local database is not available on this platform '
    '(neither dart:io nor dart:js_interop is present).',
  );
});

QueryExecutor openInMemoryExecutor() => openAppDatabaseExecutor();
