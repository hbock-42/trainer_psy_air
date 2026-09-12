import 'storage_info.dart';

/// Native (Android, iOS, macOS, Windows, Linux, VM tests): a real SQLite
/// file, always persistent. Selected by the conditional import in
/// `storage_info.dart`; do not import directly.
Future<StorageInfo> resolveStorageInfo() async =>
    const StorageInfo(kind: StorageKind.native, persistent: true);
