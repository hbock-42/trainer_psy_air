/// Result types of the content validator (US-014).
library;

/// How serious an [Issue] is. Only errors fail the run.
enum Severity { error, warning }

/// Which layer of the validator raised an [Issue].
enum IssueSource {
  /// JSON could not be read or decoded, or the file is misplaced.
  file,

  /// Violation of the JSON Schema in `docs/content/schema/`.
  schema,

  /// `ContentBundleParser` (the Dart models) rejected the file.
  parse,

  /// A cross-field or cross-file rule (unique ids, references, ranges...).
  semantic,
}

/// One problem found in a content file.
class Issue {
  const Issue({
    required this.file,
    required this.message,
    required this.source,
    this.severity = Severity.error,
    this.entityId,
    this.path,
  });

  /// File the problem was found in, relative to the scanned root.
  final String file;

  /// Id of the entity (item, card, section...) the problem belongs to.
  final String? entityId;

  /// JSON pointer inside the file (schema issues), when known.
  final String? path;

  final String message;
  final Severity severity;
  final IssueSource source;

  bool get isError => severity == Severity.error;

  Map<String, Object?> toJson() => {
    'file': file,
    if (entityId != null) 'entityId': entityId,
    if (path != null) 'path': path,
    'message': message,
    'severity': severity.name,
    'source': source.name,
  };

  @override
  String toString() {
    final where = [
      file,
      if (entityId != null) '[$entityId]',
      if (path != null && path!.isNotEmpty) path,
    ].join(' ');
    return '$where: $message';
  }
}

/// Item counts of one family, for the per-family summary.
class FamilySummary {
  FamilySummary({required this.familyId, this.moduleId});

  final String familyId;

  /// Module the family belongs to; null for loose files.
  String? moduleId;

  /// Whether a `family.json` was found for this id.
  bool declared = false;

  final Map<int, int> byDifficulty = {for (var d = 1; d <= 5; d++) d: 0};
  final Map<String, int> byType = {};
  int passages = 0;
  int lessons = 0;
  int decks = 0;
  int cards = 0;

  int get items => byDifficulty.values.fold(0, (a, b) => a + b);

  void addItem({required int difficulty, required String type}) {
    byDifficulty.update(difficulty, (n) => n + 1, ifAbsent: () => 1);
    byType.update(type, (n) => n + 1, ifAbsent: () => 1);
  }

  Map<String, Object?> toJson() => {
    'familyId': familyId,
    if (moduleId != null) 'moduleId': moduleId,
    'declared': declared,
    'items': items,
    'byDifficulty': {for (final e in byDifficulty.entries) '${e.key}': e.value},
    'byType': byType,
    'passages': passages,
    'lessons': lessons,
    'decks': decks,
    'cards': cards,
  };
}

/// Outcome of one validator run.
class ValidationReport {
  ValidationReport({
    required this.roots,
    required this.filesScanned,
    required this.bundles,
    required this.looseFiles,
    required this.issues,
    required this.families,
  });

  /// Paths given to the validator.
  final List<String> roots;

  final int filesScanned;

  /// Bundle roots (directories holding a `manifest.json`) that were found.
  final List<String> bundles;

  /// Files validated on their own because they are not part of a bundle.
  final int looseFiles;

  final List<Issue> issues;
  final List<FamilySummary> families;

  List<Issue> get errors => issues.where((i) => i.isError).toList();
  List<Issue> get warnings => issues.where((i) => !i.isError).toList();
  bool get ok => errors.isEmpty;

  Map<String, Object?> toJson() => {
    'ok': ok,
    'roots': roots,
    'filesScanned': filesScanned,
    'bundles': bundles,
    'looseFiles': looseFiles,
    'errorCount': errors.length,
    'warningCount': warnings.length,
    'errors': errors.map((i) => i.toJson()).toList(),
    'warnings': warnings.map((i) => i.toJson()).toList(),
    'families': families.map((f) => f.toJson()).toList(),
  };
}
