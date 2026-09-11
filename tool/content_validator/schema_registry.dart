/// JSON Schema layer of the content validator.
///
/// Everything here is driven by the schema files themselves: the registry
/// loads every `*.schema.json` of a folder, resolves cross-file `$ref`s
/// through their `$id`, and finds the schema of a file kind by looking for a
/// `properties.kind.const` (at the root or under `$defs`). Adding a schema
/// file or a new `$defs` entry with a `kind` is enough for a new file kind to
/// be validated; no Dart change is needed.
library;

import 'dart:convert';
import 'dart:io';

import 'package:json_schema/json_schema.dart';

/// One schema violation, already located and worded for an author.
class SchemaViolation {
  const SchemaViolation(
    this.path,
    this.message, {
    this.isDiscriminator = false,
  });

  /// JSON pointer to the offending value in the instance (`/items/3/stem`).
  final String path;
  final String message;

  /// True for a `const` mismatch: inside a `oneOf`, it means the branch is
  /// not the one the author meant (`type`, `mode`).
  final bool isDiscriminator;

  @override
  String toString() => '$path: $message';
}

/// Loads the schemas of `docs/content/schema/` and validates JSON instances.
class SchemaRegistry {
  SchemaRegistry._(this._byKind, this.directory);

  /// Reads every `*.schema.json` in [directory]. Throws a [StateError] when
  /// the folder is missing or a schema cannot be compiled.
  factory SchemaRegistry.load(String directory) {
    final dir = Directory(directory);
    if (!dir.existsSync()) {
      throw StateError('schema directory not found: $directory');
    }
    final raw = <String, Map<String, Object?>>{};
    for (final file in dir.listSync().whereType<File>()) {
      if (!file.path.endsWith('.schema.json')) continue;
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is! Map<String, Object?>) {
        throw StateError('${file.path}: schema is not a JSON object');
      }
      final id = decoded[r'$id'];
      if (id is! String) {
        throw StateError('${file.path}: schema has no "\$id"');
      }
      raw[id] = decoded;
    }
    if (raw.isEmpty) throw StateError('no *.schema.json in $directory');

    final provider = RefProvider.sync(
      (ref) => raw[Uri.parse(ref).removeFragment().toString()],
    );
    final compiled = <String, JsonSchema>{};
    for (final entry in raw.entries) {
      compiled[entry.key] = JsonSchema.create(
        entry.value,
        schemaVersion: SchemaVersion.draft2020_12,
        refProvider: provider,
      );
    }

    // Map every `kind` const to the (sub)schema that declares it.
    final byKind = <String, JsonSchema>{};
    for (final entry in raw.entries) {
      final root = compiled[entry.key]!;
      final rootKind = _kindOf(entry.value);
      if (rootKind != null) byKind[rootKind] = root;
      final defs = entry.value[r'$defs'];
      if (defs is Map<String, Object?>) {
        for (final def in defs.entries) {
          final value = def.value;
          if (value is! Map<String, Object?>) continue;
          final kind = _kindOf(value);
          if (kind == null) continue;
          byKind[kind] = root.resolvePath(
            Uri.parse('${entry.key}#/\$defs/${def.key}'),
          );
        }
      }
    }
    return SchemaRegistry._(byKind, directory);
  }

  final Map<String, JsonSchema> _byKind;
  final String directory;

  /// File kinds the schemas know about (`bank`, `lesson`...), sorted.
  List<String> get kinds => _byKind.keys.toList()..sort();

  bool hasKind(String kind) => _byKind.containsKey(kind);

  /// Validates [instance] against the schema of [kind]. Returns an empty list
  /// when it conforms. Throws [ArgumentError] for an unknown kind.
  List<SchemaViolation> validate(String kind, Object? instance) {
    final schema = _byKind[kind];
    if (schema == null) throw ArgumentError.value(kind, 'kind', 'unknown kind');
    return _explain(schema, instance, '');
  }

  static String? _kindOf(Map<String, Object?> schema) {
    final props = schema['properties'];
    if (props is! Map<String, Object?>) return null;
    final kind = props['kind'];
    if (kind is! Map<String, Object?>) return null;
    final value = kind['const'];
    return value is String ? value : null;
  }

  // ---------------------------------------------------------------------------
  // Error explanation.
  //
  // json_schema reports a failed `oneOf` / `allOf` / `then` as a single opaque
  // error ("violated No element"). We re-validate the failing sub-instance
  // against each branch and keep the branch with the fewest problems, which
  // for discriminated unions (`type`, `mode`) is the branch the author meant.

  static List<SchemaViolation> _explain(
    JsonSchema schema,
    Object? instance,
    String prefix,
  ) {
    final results = schema.validate(instance);
    final out = <SchemaViolation>[];
    final plain = <ValidationError>[];

    for (final error in results.errors) {
      final schemaPath = error.schemaPath;
      final keyword = schemaPath.substring(schemaPath.lastIndexOf('/') + 1);
      final sub = _instanceAt(instance, error.instancePath);
      final subPrefix = '$prefix${error.instancePath}';
      switch (keyword) {
        case 'oneOf' || 'anyOf' || 'allOf':
          final parent = _resolve(schema, _parentPath(schemaPath));
          if (parent == null) {
            plain.add(error);
            continue;
          }
          final branches = switch (keyword) {
            'oneOf' => parent.oneOf,
            'anyOf' => parent.anyOf,
            _ => parent.allOf,
          };
          if (branches.isEmpty) {
            plain.add(error);
            continue;
          }
          if (keyword == 'allOf') {
            for (final branch in branches) {
              out.addAll(_explain(branch, sub, subPrefix));
            }
            continue;
          }
          List<SchemaViolation>? best;
          for (final branch in branches) {
            final found = _explain(branch, sub, subPrefix);
            if (best == null || _score(found) < _score(best)) best = found;
          }
          if (best == null || best.isEmpty) {
            // Every branch passed on its own: too many alternatives matched.
            out.add(
              SchemaViolation(
                subPrefix,
                'matches more than one alternative of oneOf '
                '(${_alternatives(branches)})',
              ),
            );
          } else {
            out.addAll(best);
          }
        case 'then' || 'else':
          final parent = _resolve(schema, _parentPath(schemaPath));
          final branch = keyword == 'then'
              ? parent?.thenSchema
              : parent?.elseSchema;
          if (branch == null) {
            plain.add(error);
            continue;
          }
          final found = _explain(branch, sub, subPrefix);
          if (found.isEmpty) {
            plain.add(error);
          } else {
            final condition = parent?.ifSchema;
            out.addAll(
              found.map(
                (v) => SchemaViolation(
                  v.path,
                  '${v.message} (required when ${_describeIf(condition)})',
                ),
              ),
            );
          }
        default:
          plain.add(error);
      }
    }

    // `unevaluatedProperties` only makes sense when the rest of the object is
    // fine: a failing `allOf` drops its annotations and every base property
    // then looks "unevaluated". Keep those errors only when nothing else is
    // wrong at this level.
    final hasOther =
        out.isNotEmpty || plain.any((e) => !_isUnevaluated(e.schemaPath));
    final seen = <String>{};
    for (final error in plain) {
      if (hasOther && _isUnevaluated(error.schemaPath)) continue;
      final (path, message) = _describe(schema, error);
      if (!seen.add('$path|$message')) continue;
      out.add(
        SchemaViolation(
          '$prefix$path',
          message,
          isDiscriminator: error.message.startsWith('const violated'),
        ),
      );
    }
    return out;
  }

  /// Lower is closer to valid; a discriminator mismatch outweighs any number
  /// of ordinary errors so that `{"type": "mcq", ...}` is always explained
  /// through the mcq branch.
  static int _score(List<SchemaViolation> violations) =>
      violations.length +
      violations.where((v) => v.isDiscriminator).length * 1000;

  static bool _isUnevaluated(String schemaPath) =>
      schemaPath.endsWith('/unevaluatedProperties');

  static String _parentPath(String schemaPath) =>
      schemaPath.substring(0, schemaPath.lastIndexOf('/'));

  /// Resolves the `schemaPath` of a [ValidationError] back to a [JsonSchema].
  /// json_schema writes it either as `<$id>/<pointer>` or as `/<pointer>`
  /// relative to the root the error was raised in.
  static JsonSchema? _resolve(JsonSchema root, String rawSchemaPath) {
    // Paths of `$ref`'d definitions carry a trailing slash.
    final schemaPath = rawSchemaPath.length > 1 && rawSchemaPath.endsWith('/')
        ? rawSchemaPath.substring(0, rawSchemaPath.length - 1)
        : rawSchemaPath;
    try {
      if (schemaPath.startsWith('/') || schemaPath.startsWith('#')) {
        final pointer = schemaPath.startsWith('#')
            ? schemaPath.substring(1)
            : schemaPath;
        return root.resolvePath(Uri.parse('#$pointer'));
      }
      final split = schemaPath.indexOf('.json/');
      if (split < 0) return root.resolvePath(Uri.parse(schemaPath));
      final base = schemaPath.substring(0, split + 5);
      final pointer = schemaPath.substring(split + 5);
      return root.resolvePath(Uri.parse('$base#$pointer'));
    } on Object {
      return null;
    }
  }

  static Object? _instanceAt(Object? instance, String pointer) {
    var current = instance;
    for (final segment in pointer.split('/')) {
      if (segment.isEmpty) continue;
      final key = segment.replaceAll('~1', '/').replaceAll('~0', '~');
      if (current is List<Object?>) {
        final index = int.tryParse(key);
        if (index == null || index < 0 || index >= current.length) return null;
        current = current[index];
      } else if (current is Map<String, Object?>) {
        current = current[key];
      } else {
        return null;
      }
    }
    return current;
  }

  /// Names the alternatives of a `oneOf` by their discriminating `const`s or
  /// `required` lists, e.g. `body | file` or `type=mcq | type=numeric`.
  static String _alternatives(List<JsonSchema> branches) {
    final names = <String>[];
    for (final raw in branches) {
      final branch = _deref(raw);
      String? name;
      for (final prop in branch.properties.entries) {
        final constValue = prop.value.constValue;
        if (constValue != null) {
          name = '${prop.key}=$constValue';
          break;
        }
      }
      name ??= branch.requiredProperties?.join('+');
      names.add(name ?? '?');
    }
    return names.join(' | ');
  }

  static String _describeIf(JsonSchema? condition) {
    if (condition == null) return 'the condition holds';
    final parts = <String>[];
    for (final prop in condition.properties.entries) {
      final constValue = prop.value.constValue;
      if (constValue != null) parts.add('${prop.key} is "$constValue"');
    }
    return parts.isEmpty ? 'the condition holds' : parts.join(' and ');
  }

  static JsonSchema _deref(JsonSchema schema) {
    var current = schema;
    for (var i = 0; i < 8 && current.ref != null; i++) {
      current = current.resolvePath(current.ref);
    }
    return current;
  }

  /// Rewrites json_schema's messages (which dump the whole instance) into
  /// short, author-facing ones, and returns the instance path they apply to.
  static (String, String) _describe(JsonSchema root, ValidationError error) {
    final message = error.message;
    final schemaPath = error.schemaPath;
    var path = error.instancePath;

    final required = RegExp(
      r'^required prop missing: (\S+) from',
    ).firstMatch(message);
    if (required != null) {
      final prop = required.group(1)!;
      // The same failure is reported twice: on the object and on `/prop`.
      if (path.endsWith('/$prop')) {
        path = path.substring(0, path.length - prop.length - 1);
      }
      return (path, 'missing required property "$prop"');
    }
    if (schemaPath.endsWith('/unevaluatedProperties')) {
      return (path, 'unexpected property');
    }
    final additional = RegExp(
      r'^unallowed additional property (.+)$',
    ).firstMatch(message);
    if (additional != null) {
      return ('$path/${additional.group(1)}', 'unexpected property');
    }
    if (message.startsWith('const violated')) {
      final expected = _resolve(root, schemaPath)?.constValue;
      final got = _short(message.substring('const violated '.length));
      return (
        path,
        expected == null
            ? 'must be the constant value, got $got'
            : 'must be "$expected", got $got',
      );
    }
    if (message.startsWith('enum violated')) {
      final values = _resolve(root, schemaPath)?.enumValues;
      final got = _short(message.substring('enum violated '.length));
      final allowed = values == null
          ? ''
          : ' (allowed: ${values.map((v) => '"$v"').join(', ')})';
      return (path, 'value $got is not allowed$allowed');
    }
    final type = RegExp(
      r'^type: wanted \[(.+?)\] got (.*)$',
    ).firstMatch(message);
    if (type != null) {
      return (path, 'expected ${type.group(1)}, got ${_short(type.group(2)!)}');
    }
    final pattern = RegExp(
      r'^pattern violated \((.*) vs (.*)\)$',
      dotAll: true,
    ).firstMatch(message);
    if (pattern != null) {
      return (
        path,
        '${_short(pattern.group(1)!)} does not match pattern ${pattern.group(2)}',
      );
    }
    final unique = RegExp(
      r'^uniqueItems violated: .* \[(\d+)\]==\[(\d+)\]$',
      dotAll: true,
    ).firstMatch(message);
    if (unique != null) {
      return (
        path,
        'duplicate entries at indexes ${unique.group(1)} and ${unique.group(2)}',
      );
    }
    // Strip the "<schema path>: " prefix some messages carry.
    final generic = message.replaceFirst(RegExp(r'^#?[^\s:]*: '), '');
    return (path, _short(generic, 200));
  }

  static String _short(String text, [int max = 60]) {
    final flat = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    return flat.length <= max ? flat : '${flat.substring(0, max - 1)}…';
  }
}
