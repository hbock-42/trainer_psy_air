import 'storage_info_native.dart'
    if (dart.library.js_interop) 'storage_info_web.dart'
    as impl;

/// Where the local database actually lives, coarse enough to show a user
/// (US-016).
enum StorageKind {
  /// A real SQLite file on disk (`NativeDatabase`, Android/iOS/macOS/Windows).
  native,

  /// The web build persisted through the Origin Private File System (shared
  /// worker or per-tab locks) — the most reliable web storage drift offers.
  opfs,

  /// The web build persisted through IndexedDB (shared worker, or the
  /// per-tab "unsafe" fallback) — used when OPFS isn't available, notably on
  /// GitHub Pages, which serves no COOP/COEP headers.
  indexedDb,

  /// No persistence at all: the browser supports neither OPFS nor
  /// IndexedDB (or both failed), so drift fell back to an in-memory
  /// database that is lost on reload. Only ever seen on native as the
  /// `openInMemoryExecutor()` test executor.
  inMemory,
}

/// Where the database is stored, for the About screen (US-016) and startup
/// logging. [StorageInfo.resolve] on native platforms resolves immediately;
/// on web it awaits the `WasmDatabase.open` result captured by
/// `open_database_web.dart`; the caller must first read `appDatabaseProvider`
/// (or otherwise run a query) so that open has actually happened.
class StorageInfo {
  const StorageInfo({
    required this.kind,
    required this.persistent,
    this.missingFeatures = const [],
  });

  final StorageKind kind;

  /// Whether data survives a reload/restart. False only for [StorageKind.inMemory].
  final bool persistent;

  /// Browser features drift probed and did not find (web only); empty
  /// everywhere else. Human-readable, already-`toString()`-ed names, for
  /// logging — not localized.
  final List<String> missingFeatures;

  static Future<StorageInfo> resolve() => impl.resolveStorageInfo();
}
