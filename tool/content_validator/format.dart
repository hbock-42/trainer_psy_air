/// Human-readable rendering of a [ValidationReport].
library;

import 'report.dart';

/// Renders [report] for a terminal. With [quiet], only the errors and the
/// final verdict are printed (no summary table, no warnings).
String formatReport(ValidationReport report, {bool quiet = false}) {
  final out = StringBuffer();
  if (!quiet) {
    out.writeln('Content validation: ${report.roots.join(', ')}');
    out.writeln(
      '${report.filesScanned} JSON file(s), '
      '${report.bundles.length} bundle(s)'
      '${report.bundles.isEmpty ? '' : ' (${report.bundles.join(', ')})'}, '
      '${report.looseFiles} loose file(s)',
    );
    out.writeln();
    if (report.families.isNotEmpty) {
      out.write(_familyTable(report.families));
      out.writeln();
    }
  }
  if (report.errors.isNotEmpty) {
    out.writeln('ERRORS (${report.errors.length})');
    for (final issue in report.errors) {
      out.writeln('  ${_line(issue)}');
    }
    out.writeln();
  }
  if (!quiet && report.warnings.isNotEmpty) {
    out.writeln('WARNINGS (${report.warnings.length})');
    for (final issue in report.warnings) {
      out.writeln('  ${_line(issue)}');
    }
    out.writeln();
  }
  out.write(
    '${report.ok ? 'OK' : 'FAILED'}: ${report.errors.length} error(s), '
    '${report.warnings.length} warning(s) in ${report.filesScanned} file(s)',
  );
  return out.toString();
}

String _line(Issue issue) {
  final where = [
    issue.file,
    if (issue.entityId != null) '[${issue.entityId}]',
    if (issue.path != null && issue.path!.isNotEmpty) issue.path,
  ].join(' ');
  final tag = switch (issue.source) {
    IssueSource.schema => 'schema',
    IssueSource.parse => 'dart',
    IssueSource.semantic => 'rule',
    IssueSource.file => 'file',
  };
  return '$where: ${issue.message}  ($tag)';
}

String _familyTable(List<FamilySummary> families) {
  final types = <String>{for (final f in families) ...f.byType.keys}.toList()
    ..sort();
  final header = [
    'family',
    'module',
    'items',
    for (var d = 1; d <= 5; d++) 'd$d',
    ...types,
    'passages',
    'lessons',
    'decks',
    'cards',
  ];
  final rows = <List<String>>[header];
  for (final f in families) {
    rows.add([
      f.declared ? f.familyId : '${f.familyId} (no family.json)',
      f.moduleId ?? '-',
      '${f.items}',
      for (var d = 1; d <= 5; d++) '${f.byDifficulty[d] ?? 0}',
      for (final t in types) '${f.byType[t] ?? 0}',
      '${f.passages}',
      '${f.lessons}',
      '${f.decks}',
      '${f.cards}',
    ]);
  }
  final widths = List<int>.generate(
    header.length,
    (i) => rows.map((r) => r[i].length).reduce((a, b) => a > b ? a : b),
  );
  final out = StringBuffer();
  for (final (r, row) in rows.indexed) {
    final cells = <String>[];
    for (final (i, cell) in row.indexed) {
      // Left-align the two text columns, right-align the counts.
      cells.add(i < 2 ? cell.padRight(widths[i]) : cell.padLeft(widths[i]));
    }
    out.writeln(cells.join('  '));
    if (r == 0) {
      out.writeln(widths.map((w) => '-' * w).join('  '));
    }
  }
  return out.toString();
}
