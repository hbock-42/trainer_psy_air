/// Content validator (US-014): validates a content tree against the JSON
/// Schemas, the Dart models and the semantic rules of `AUTHORING.md`.
///
/// Usable as a library (tests, other tools) through [ContentValidator]; the
/// CLI wrapper is `tool/validate_content.dart`.
library;

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:psy_trainer/core/content/content.dart';

import 'content_file.dart';
import 'report.dart';
import 'schema_registry.dart';
import 'semantic_checks.dart';

export 'content_file.dart' show ContentFile;
export 'report.dart';
export 'schema_registry.dart' show SchemaRegistry, SchemaViolation;

/// Validates content files and bundles.
///
/// A *bundle* is a directory holding a `manifest.json`; every JSON file below
/// it (except under a folder named `examples`) is checked against the layout
/// and cross-file rules. Any other JSON file is *loose*: it is validated on
/// its own (schema, Dart parser, in-file semantics) but references to other
/// files cannot be checked.
class ContentValidator {
  ContentValidator({
    required this.schemas,
    ContentBundleParser parser = const ContentBundleParser(),
  }) : _parser = parser;

  /// Loads the schemas from [schemaDir] (default `docs/content/schema`).
  factory ContentValidator.load({String schemaDir = defaultSchemaDir}) =>
      ContentValidator(schemas: SchemaRegistry.load(schemaDir));

  static const defaultSchemaDir = 'docs/content/schema';
  static const defaultContentDir = 'assets/content';

  /// Folder names whose content is validated file by file, never as part of
  /// the enclosing bundle (the authoring samples).
  static const looseFolders = {'examples'};

  final SchemaRegistry schemas;
  final ContentBundleParser _parser;

  /// Validates every JSON file under [paths] (files or directories).
  ValidationReport validate(List<String> paths) {
    final sink = IssueSink();
    final files = <ContentFile>[];
    final bundles = <String>[];
    var scanned = 0;

    for (final root in paths) {
      final type = FileSystemEntity.typeSync(root);
      if (type == FileSystemEntityType.notFound) {
        sink.issues.add(
          Issue(
            file: root,
            message: 'path not found',
            source: IssueSource.file,
          ),
        );
        continue;
      }
      final entries = type == FileSystemEntityType.directory
          ? _listJson(Directory(root))
          : [File(root)];
      final bundleRoots = type == FileSystemEntityType.directory
          ? _bundleRoots(Directory(root))
          : const <String>[];
      bundles.addAll(bundleRoots.map((b) => _display(root, b)));
      for (final file in entries) {
        scanned++;
        final display = _display(root, file.path);
        final bundleRoot = _bundleOf(file.path, bundleRoots);
        final loaded = _read(file, display, bundleRoot, sink);
        if (loaded != null) files.add(loaded);
      }
    }

    final summary = <String, FamilySummary>{};
    for (final file in files) {
      _validateFile(file, sink);
      _summarise(file, summary);
    }
    final byBundle = <String, List<ContentFile>>{};
    for (final file in files) {
      final root = file.bundleRoot;
      if (root != null) byBundle.putIfAbsent(root, () => []).add(file);
    }
    for (final entry in byBundle.entries) {
      checkBundle(entry.key, entry.value, sink);
    }

    final issues = sink.issues.toList()
      ..sort((a, b) {
        final bySeverity = a.severity.index.compareTo(b.severity.index);
        if (bySeverity != 0) return bySeverity;
        return a.file.compareTo(b.file);
      });
    final families = summary.values.toList()
      ..sort((a, b) {
        final byModule = (a.moduleId ?? '~').compareTo(b.moduleId ?? '~');
        return byModule != 0 ? byModule : a.familyId.compareTo(b.familyId);
      });
    return ValidationReport(
      roots: paths,
      filesScanned: scanned,
      bundles: bundles,
      looseFiles: files.where((f) => !f.inBundle).length,
      issues: issues,
      families: families,
    );
  }

  // ---------------------------------------------------------------------------

  static List<File> _listJson(Directory dir) =>
      dir
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .where((f) => f.path.toLowerCase().endsWith('.json'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  /// Directories under [dir] (itself included) holding a `manifest.json`.
  static List<String> _bundleRoots(Directory dir) {
    final roots = <String>[];
    if (File(p.join(dir.path, 'manifest.json')).existsSync()) {
      roots.add(p.normalize(dir.absolute.path));
    }
    for (final entity in dir.listSync(recursive: true, followLinks: false)) {
      if (entity is File && p.basename(entity.path) == 'manifest.json') {
        roots.add(p.normalize(p.dirname(entity.absolute.path)));
      }
    }
    return roots.toSet().toList()..sort();
  }

  /// The deepest bundle root [path] belongs to, unless a loose folder sits in
  /// between.
  static String? _bundleOf(String path, List<String> bundleRoots) {
    final absolute = p.normalize(File(path).absolute.path);
    String? best;
    for (final root in bundleRoots) {
      if (!p.isWithin(root, absolute)) continue;
      final inside = p.split(p.relative(absolute, from: root));
      final segments = inside.sublist(0, inside.length - 1);
      if (segments.any(looseFolders.contains)) continue;
      if (best == null || root.length > best.length) best = root;
    }
    return best;
  }

  static String _display(String root, String path) {
    final rel = p.relative(path, from: root);
    if (rel == '.') return p.split(p.normalize(root)).join('/');
    if (rel.startsWith('..')) return p.normalize(path);
    return p.split(p.join(p.normalize(root), rel)).join('/');
  }

  ContentFile? _read(
    File file,
    String display,
    String? bundleRoot,
    IssueSink sink,
  ) {
    Object? decoded;
    try {
      decoded = jsonDecode(file.readAsStringSync());
    } on FormatException catch (e) {
      sink.issues.add(
        Issue(
          file: display,
          message: 'invalid JSON: ${e.message}',
          source: IssueSource.file,
        ),
      );
      return null;
    } on IOException catch (e) {
      sink.issues.add(
        Issue(
          file: display,
          message: 'cannot read: $e',
          source: IssueSource.file,
        ),
      );
      return null;
    }
    if (decoded is! Map<String, Object?>) {
      sink.issues.add(
        Issue(
          file: display,
          message: 'expected a JSON object at the top level',
          source: IssueSource.file,
        ),
      );
      return null;
    }
    final kind = decoded['kind'];
    return ContentFile(
      absolutePath: p.normalize(file.absolute.path),
      displayPath: display,
      json: decoded,
      kind: kind is String ? kind : null,
      bundleRoot: bundleRoot,
    );
  }

  void _validateFile(ContentFile file, IssueSink sink) {
    final kind = file.kind;
    if (kind == null) {
      sink.issues.add(
        Issue(
          file: file.displayPath,
          message:
              'missing "kind" (one of ${schemas.kinds.map((k) => '"$k"').join(', ')})',
          source: IssueSource.file,
        ),
      );
      return;
    }
    if (!schemas.hasKind(kind)) {
      sink.issues.add(
        Issue(
          file: file.displayPath,
          message:
              'unknown kind "$kind" (schemas define '
              '${schemas.kinds.map((k) => '"$k"').join(', ')})',
          source: IssueSource.file,
        ),
      );
      return;
    }

    // 1. JSON Schema.
    for (final violation in schemas.validate(kind, file.json)) {
      sink.issues.add(
        Issue(
          file: file.displayPath,
          entityId: _entityIdAt(file.json, violation.path),
          path: violation.path,
          message: violation.message,
          source: IssueSource.schema,
        ),
      );
    }

    // 2. Dart models: the parser must agree with the schemas.
    try {
      _parse(kind, file);
    } on ContentParseException catch (e) {
      sink.issues.add(
        Issue(
          file: file.displayPath,
          entityId: e.entityId,
          message: 'Dart parser: ${e.message}',
          source: IssueSource.parse,
        ),
      );
    } on UnsupportedError catch (e) {
      sink.issues.add(
        Issue(
          file: file.displayPath,
          message: e.message ?? 'unsupported kind',
          source: IssueSource.parse,
        ),
      );
    }

    // 3. Semantic rules.
    checkFile(file, sink);
  }

  /// Runs the `ContentBundleParser` method matching [kind]. A kind the
  /// schemas know but the parser does not is a contract mismatch.
  void _parse(String kind, ContentFile file) {
    final json = file.json;
    final name = file.displayPath;
    switch (kind) {
      case 'manifest':
        _parser.manifestFromJson(json, file: name);
      case 'module':
        _parser.moduleFromJson(json, file: name);
      case 'family':
        _parser.familyFromJson(json, file: name);
      case 'bank':
        _parser.bankFromJson(json, file: name);
      case 'lesson':
        _parser.lessonFromJson(json, file: name);
      case 'deck':
        _parser.deckFromJson(json, file: name);
      case 'blueprint':
        _parser.blueprintFromJson(json, file: name);
      case 'lexical_fields':
        _parser.lexicalFieldsFromJson(json, file: name);
      default:
        throw UnsupportedError(
          'kind "$kind" has a schema but no ContentBundleParser method; '
          'add it to lib/core/content and to the validator',
        );
    }
  }

  /// Id of the innermost entity (item, card, section, passage) containing
  /// [pointer], falling back to the file's own id.
  static String? _entityIdAt(Map<String, Object?> json, String pointer) {
    Object? current = json;
    String? id = str(json, 'id');
    for (final segment in pointer.split('/')) {
      if (segment.isEmpty) continue;
      if (current is List<Object?>) {
        final index = int.tryParse(segment);
        if (index == null || index < 0 || index >= current.length) break;
        current = current[index];
      } else if (current is Map<String, Object?>) {
        current = current[segment];
      } else {
        break;
      }
      if (current is Map<String, Object?>) {
        id = str(current, 'id') ?? id;
      }
    }
    return id;
  }

  static void _summarise(ContentFile file, Map<String, FamilySummary> out) {
    FamilySummary family(String familyId) => out.putIfAbsent(
      familyId,
      () => FamilySummary(familyId: familyId, moduleId: file.moduleDir),
    )..moduleId ??= file.moduleDir;

    switch (file.kind) {
      case 'family':
        final id = file.id;
        if (id != null) family(id).declared = true;
      case 'bank':
        final familyId = str(file.json, 'familyId');
        if (familyId == null) return;
        final summary = family(familyId);
        summary.passages += objects(file.json, 'passages').length;
        for (final item in objects(file.json, 'items')) {
          final difficulty = integer(item, 'difficulty');
          summary.addItem(
            difficulty: difficulty != null && difficulty >= 1 && difficulty <= 5
                ? difficulty
                : 0,
            type: str(item, 'type') ?? '?',
          );
        }
      case 'lesson':
        final familyId = str(file.json, 'familyId');
        if (familyId != null) family(familyId).lessons++;
      case 'deck':
        final familyId = str(file.json, 'familyId');
        if (familyId == null) return;
        final summary = family(familyId);
        summary.decks++;
        summary.cards += objects(file.json, 'cards').length;
    }
  }
}
