import 'package:drift/wasm.dart';

import 'open_database_web.dart' show webDatabaseResultFuture;
import 'storage_info.dart';

/// Web: reports the `WasmStorageImplementation` drift chose for the app's
/// `WasmDatabase.open` call in `open_database_web.dart`. Selected by the
/// conditional import in `storage_info.dart`; do not import directly.
///
/// Awaits [webDatabaseResultFuture], which only completes once a query has
/// actually run — callers must ensure the database has been opened first
/// (see `storageInfoProvider` in `core/repositories/`).
Future<StorageInfo> resolveStorageInfo() async {
  final result = await webDatabaseResultFuture;
  return storageInfoFromWasmResult(result);
}

/// Pure mapping from drift's [WasmDatabaseResult] to [StorageInfo], pulled
/// out of [resolveStorageInfo] so it can be unit-tested on the VM without a
/// real `WasmDatabase.open` call (see `test/core/db/storage_info_test.dart`).
StorageInfo storageInfoFromWasmResult(WasmDatabaseResult result) {
  final StorageKind kind;
  switch (result.chosenImplementation) {
    case WasmStorageImplementation.opfsShared:
    case WasmStorageImplementation.opfsLocks:
      kind = StorageKind.opfs;
    case WasmStorageImplementation.sharedIndexedDb:
    case WasmStorageImplementation.unsafeIndexedDb:
      kind = StorageKind.indexedDb;
    case WasmStorageImplementation.inMemory:
      kind = StorageKind.inMemory;
  }
  return StorageInfo(
    kind: kind,
    persistent: kind != StorageKind.inMemory,
    missingFeatures: [
      for (final feature in result.missingFeatures) feature.name,
    ],
  );
}
