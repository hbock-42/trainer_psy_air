import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/db/storage_info.dart';

/// US-016: on native platforms (this test runs on the VM) `StorageInfo`
/// always reports a real, persistent SQLite file. The web mapping
/// (`WasmStorageImplementation` -> `StorageKind`) is tested separately in
/// `storage_info_web_test.dart`, which needs `--platform chrome`: it
/// imports `package:drift/wasm.dart`, and that library does not compile on
/// the VM (it pulls in `dart:js_interop` bindings).
void main() {
  test('StorageInfo.resolve() on native is a persistent local file', () async {
    final info = await StorageInfo.resolve();
    expect(info.kind, StorageKind.native);
    expect(info.persistent, isTrue);
    expect(info.missingFeatures, isEmpty);
  });
}
