@TestOn('browser')
library;

import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/db/storage_info.dart';
import 'package:psy_trainer/core/db/storage_info_web.dart';

/// US-016: maps drift's `WasmStorageImplementation` (what `WasmDatabase.open`
/// reports it picked) to the coarser `StorageKind` shown in Settings → About.
///
/// `@TestOn('browser')` because `package:drift/wasm.dart` needs
/// `dart:js_interop` and does not compile on the VM — run with
/// `flutter test --platform chrome test/core/db/storage_info_web_test.dart`
/// (see `docs/TESTING.md`); a plain `flutter test` (VM) skips this file.
/// [storageInfoFromWasmResult] itself is pure Dart (no actual browser APIs
/// touched), so this does not need the real `WasmDatabase.open` flow — that
/// round trip is covered by `web_smoke_test.dart`.
void main() {
  WasmDatabaseResult resultOf(
    WasmStorageImplementation impl, {
    Set<MissingBrowserFeature> missing = const {},
  }) {
    // storageInfoFromWasmResult never reads `resolvedExecutor`, so a
    // connection that never actually resolves is fine here (and keeps this
    // file free of a real executor, native or wasm).
    final connection = DatabaseConnection.delayed(
      Completer<DatabaseConnection>().future,
    );
    return WasmDatabaseResult(connection, impl, missing);
  }

  test('OPFS implementations map to StorageKind.opfs, persistent', () {
    for (final impl in [
      WasmStorageImplementation.opfsShared,
      WasmStorageImplementation.opfsLocks,
    ]) {
      final info = storageInfoFromWasmResult(resultOf(impl));
      expect(info.kind, StorageKind.opfs);
      expect(info.persistent, isTrue);
    }
  });

  test(
    'IndexedDB implementations map to StorageKind.indexedDb, persistent',
    () {
      for (final impl in [
        WasmStorageImplementation.sharedIndexedDb,
        WasmStorageImplementation.unsafeIndexedDb,
      ]) {
        final info = storageInfoFromWasmResult(resultOf(impl));
        expect(info.kind, StorageKind.indexedDb);
        expect(info.persistent, isTrue);
      }
    },
  );

  test('inMemory maps to StorageKind.inMemory, not persistent', () {
    final info = storageInfoFromWasmResult(
      resultOf(
        WasmStorageImplementation.inMemory,
        missing: {
          MissingBrowserFeature.sharedWorkers,
          MissingBrowserFeature.fileSystemAccess,
        },
      ),
    );
    expect(info.kind, StorageKind.inMemory);
    expect(info.persistent, isFalse);
    expect(
      info.missingFeatures,
      unorderedEquals(['sharedWorkers', 'fileSystemAccess']),
    );
  });

  test('no missing features reports an empty list', () {
    final info = storageInfoFromWasmResult(
      resultOf(WasmStorageImplementation.opfsShared),
    );
    expect(info.missingFeatures, isEmpty);
  });
}
