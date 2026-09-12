import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// Web executors (US-016). Selected by the conditional import in
/// `open_database.dart`; do not import directly.
///
/// Drift's `WasmDatabase.open` picks the best storage the browser offers
/// (OPFS in a shared worker, OPFS with per-tab locks, IndexedDB in a shared
/// worker, "unsafe" per-tab IndexedDB, or — if none of those are usable —
/// an in-memory database that does not survive a reload) and reports which
/// one it chose. `sqlite3.wasm` and `drift_worker.js` are served from
/// `web/` (see `tools/fetch_web_sqlite.sh`); the URIs are relative so the
/// app works under a GitHub Pages sub-path.
///
/// The `WasmDatabaseResult` of the *last* call is captured in
/// [webDatabaseResultFuture] so `storage_info_web.dart` can report the
/// chosen implementation without opening a second connection (which would
/// spawn a second worker/leader election). It completes once the first
/// query actually runs the `LazyDatabase` callback below.
Completer<WasmDatabaseResult> _lastResult = Completer<WasmDatabaseResult>();

/// The result of the most recent `WasmDatabase.open` call. Awaiting this
/// before any query has happened never completes — callers (the
/// `storageInfoProvider`) must force one first, e.g. with a trivial
/// `SELECT 1` against the already-opened `AppDatabase`.
Future<WasmDatabaseResult> get webDatabaseResultFuture => _lastResult.future;

QueryExecutor openAppDatabaseExecutor() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'psy_trainer',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    if (!_lastResult.isCompleted) _lastResult.complete(result);
    if (result.missingFeatures.isNotEmpty) {
      debugPrint(
        '[db] web storage: ${result.chosenImplementation} '
        '(missing browser features: ${result.missingFeatures.join(', ')})',
      );
    } else {
      debugPrint('[db] web storage: ${result.chosenImplementation}');
    }
    return result.resolvedExecutor;
  });
}

/// A fresh, private-per-call database (a distinct `databaseName` each time,
/// backed by whatever storage the browser offers — there is no true
/// "memory-only" mode in `WasmDatabase.open`). Used by VM-agnostic test
/// helpers that happen to run under `flutter test --platform chrome`.
QueryExecutor openInMemoryExecutor() {
  final name = 'psy_trainer_test_${const Uuid().v4()}';
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: name,
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  });
}
