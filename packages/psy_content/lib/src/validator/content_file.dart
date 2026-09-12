/// A content JSON file as seen by the validator, plus small JSON accessors
/// shared by the semantic checks.
library;

import 'package:path/path.dart' as p;

/// One `*.json` file found under a scanned root.
class ContentFile {
  ContentFile({
    required this.absolutePath,
    required this.displayPath,
    required this.json,
    required this.kind,
    this.bundleRoot,
  });

  final String absolutePath;

  /// Path shown in messages (relative to the scanned root).
  final String displayPath;

  /// Decoded JSON; an empty map when the file could not be decoded.
  final Map<String, Object?> json;

  /// Value of the top-level `kind`, when it is a string.
  final String? kind;

  /// Absolute path of the bundle root (the folder holding `manifest.json`)
  /// this file belongs to, or null for a loose file.
  final String? bundleRoot;

  bool get inBundle => bundleRoot != null;

  /// Path relative to the bundle root, with `/` separators.
  String get bundlePath => bundleRoot == null
      ? p.basename(absolutePath)
      : p.split(p.relative(absolutePath, from: bundleRoot)).join('/');

  List<String> get _segments => bundlePath.split('/');

  /// First folder under the bundle root (`psy0`), or null at the root.
  String? get moduleDir => _segments.length > 1 ? _segments.first : null;

  /// Second folder under the bundle root when it is a family folder
  /// (`psy0/english/...` gives `english`; `psy0/lessons/x.json` gives null).
  String? get familyDir {
    final s = _segments;
    if (s.length < 3) return null;
    if (const {'lessons', 'blueprints', 'media'}.contains(s[1])) return null;
    return s[1];
  }

  /// Absolute path of the module folder, when the file sits in a bundle.
  String? get moduleRoot {
    final root = bundleRoot;
    final module = moduleDir;
    return root == null || module == null ? null : p.join(root, module);
  }

  /// Top-level `id` of the file, when present.
  String? get id => str(json, 'id');
}

// JSON accessors tolerant of wrong shapes: the schema layer already reports
// those, the semantic checks just skip what they cannot read.

String? str(Map<String, Object?> json, String key) {
  final v = json[key];
  return v is String ? v : null;
}

int? integer(Map<String, Object?> json, String key) {
  final v = json[key];
  return v is int ? v : null;
}

Map<String, Object?>? obj(Map<String, Object?> json, String key) {
  final v = json[key];
  return v is Map<String, Object?> ? v : null;
}

List<Object?> list(Map<String, Object?> json, String key) {
  final v = json[key];
  return v is List<Object?> ? v : const [];
}

List<Map<String, Object?>> objects(Map<String, Object?> json, String key) =>
    list(json, key).whereType<Map<String, Object?>>().toList();

List<String> strings(Map<String, Object?> json, String key) =>
    list(json, key).whereType<String>().toList();
