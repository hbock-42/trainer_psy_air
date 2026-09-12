// Coverage gate for `flutter test --coverage`.
//
// Parses an lcov file, prints line coverage for the whole package and for
// the "gated" paths (feature domain/data layers and core), and exits with 1
// when the gated coverage is below `--min`.
//
// Usage (from the repo root; the app's lcov lives under its own package):
//   dart run tools/coverage_gate.dart --file apps/psy_trainer/coverage/lcov.info [--min 70]
//
// Pure Dart on purpose (only `dart:io`) so CI can run it without a Flutter
// device or extra packages. The parsing and policy live in [evaluateCoverage]
// so `tools/test/coverage_gate_test.dart` can exercise them on fixtures.

import 'dart:io';

/// Default threshold (percent) applied to gated paths.
const double defaultMinimum = 70;

/// Default lcov location produced by `flutter test --coverage`.
const String defaultLcovPath = 'coverage/lcov.info';

/// Files that never count: generated sources.
final List<RegExp> excludedFilePatterns = <RegExp>[
  RegExp(r'\.g\.dart$'),
  RegExp(r'\.freezed\.dart$'),
  RegExp(r'\.drift\.dart$'),
];

/// Paths whose coverage is subject to the threshold.
///
/// `lib/features/<feature>/domain/**`, `lib/features/<feature>/data/**` and
/// `lib/core/**`. Presentation code is measured but not gated: it is covered
/// by widget/golden tests that are slower to write and less valuable per line.
final List<RegExp> gatedPathPatterns = <RegExp>[
  RegExp(r'^lib/features/[^/]+/domain/'),
  RegExp(r'^lib/features/[^/]+/data/'),
  RegExp(r'^lib/core/'),
];

/// Line-coverage totals for one file.
class FileCoverage {
  const FileCoverage({
    required this.path,
    required this.linesFound,
    required this.linesHit,
  });

  final String path;
  final int linesFound;
  final int linesHit;
}

/// Aggregated totals over a set of files.
class CoverageSummary {
  const CoverageSummary({required this.linesFound, required this.linesHit});

  const CoverageSummary.empty() : this(linesFound: 0, linesHit: 0);

  final int linesFound;
  final int linesHit;

  bool get hasLines => linesFound > 0;

  /// Percentage of hit lines, or `null` when nothing was measured.
  double? get percent => hasLines ? linesHit * 100 / linesFound : null;

  CoverageSummary operator +(FileCoverage file) => CoverageSummary(
    linesFound: linesFound + file.linesFound,
    linesHit: linesHit + file.linesHit,
  );
}

/// Outcome of running the gate.
class GateResult {
  const GateResult({
    required this.overall,
    required this.gated,
    required this.minimum,
    required this.passed,
    required this.message,
  });

  final CoverageSummary overall;
  final CoverageSummary gated;
  final double minimum;
  final bool passed;
  final String message;

  int get exitCode => passed ? 0 : 1;
}

/// Parses lcov text into per-file line coverage.
///
/// Only the records we need are read: `SF:` (source file), `DA:<line>,<hits>`
/// (per-line hit count) and `end_of_record`. `LF`/`LH` summary lines are
/// ignored and totals are recomputed from `DA` entries so a file with no
/// summary still counts. Paths are normalised to forward slashes.
List<FileCoverage> parseLcov(String content) {
  final files = <FileCoverage>[];
  String? currentPath;
  var found = 0;
  var hit = 0;

  void flush() {
    if (currentPath != null) {
      files.add(
        FileCoverage(path: currentPath!, linesFound: found, linesHit: hit),
      );
    }
    currentPath = null;
    found = 0;
    hit = 0;
  }

  for (final rawLine in content.split('\n')) {
    final line = rawLine.trim();
    if (line.startsWith('SF:')) {
      flush();
      currentPath = line.substring(3).replaceAll(r'\', '/');
    } else if (line.startsWith('DA:')) {
      final parts = line.substring(3).split(',');
      if (parts.length < 2) continue;
      final hits = int.tryParse(parts[1].trim()) ?? 0;
      found += 1;
      if (hits > 0) hit += 1;
    } else if (line == 'end_of_record') {
      flush();
    }
  }
  flush();
  return files;
}

bool isExcluded(String path) =>
    excludedFilePatterns.any((pattern) => pattern.hasMatch(path));

bool isGated(String path) =>
    gatedPathPatterns.any((pattern) => pattern.hasMatch(path));

/// Applies the exclusion and gating policy to parsed coverage.
GateResult evaluateCoverage(
  List<FileCoverage> files, {
  double minimum = defaultMinimum,
}) {
  var overall = const CoverageSummary.empty();
  var gated = const CoverageSummary.empty();

  for (final file in files) {
    if (isExcluded(file.path)) continue;
    overall = overall + file;
    if (isGated(file.path)) gated = gated + file;
  }

  final gatedPercent = gated.percent;
  final bool passed;
  final String message;
  if (gatedPercent == null) {
    passed = true;
    message =
        'No measured lines under lib/features/**/{domain,data} or lib/core '
        'yet; gate skipped.';
  } else if (gatedPercent + 1e-9 >= minimum) {
    passed = true;
    message =
        'Gated coverage ${_fmt(gatedPercent)}% meets the minimum '
        '${_fmt(minimum)}%.';
  } else {
    passed = false;
    message =
        'Gated coverage ${_fmt(gatedPercent)}% is below the minimum '
        '${_fmt(minimum)}%.';
  }

  return GateResult(
    overall: overall,
    gated: gated,
    minimum: minimum,
    passed: passed,
    message: message,
  );
}

/// Human-readable report printed by the CLI.
String formatReport(GateResult result) {
  final buffer = StringBuffer()
    ..writeln('Coverage report')
    ..writeln('  overall        : ${_summary(result.overall)}')
    ..writeln('  domain/data/core: ${_summary(result.gated)}')
    ..writeln('  minimum (gated): ${_fmt(result.minimum)}%')
    ..writeln(
      result.passed ? 'PASS: ${result.message}' : 'FAIL: ${result.message}',
    );
  return buffer.toString();
}

String _summary(CoverageSummary s) {
  final percent = s.percent;
  if (percent == null) return 'n/a (0 lines measured)';
  return '${_fmt(percent)}% (${s.linesHit}/${s.linesFound} lines)';
}

String _fmt(double value) => value.toStringAsFixed(1);

/// Parsed command-line options.
class GateOptions {
  const GateOptions({required this.minimum, required this.file});

  final double minimum;
  final String file;
}

/// Minimal argument parsing (no `package:args`, to keep the tool dependency
/// free). Accepts `--min N`, `--min=N`, `--file PATH`, `--file=PATH`.
GateOptions parseArgs(List<String> args) {
  var minimum = defaultMinimum;
  var file = defaultLcovPath;

  String? valueOf(String name, int index) {
    final arg = args[index];
    if (arg == '--$name') {
      if (index + 1 >= args.length) {
        throw FormatException('--$name requires a value');
      }
      return args[index + 1];
    }
    if (arg.startsWith('--$name=')) return arg.substring(name.length + 3);
    return null;
  }

  for (var i = 0; i < args.length; i++) {
    final min = valueOf('min', i);
    if (min != null) {
      final parsed = double.tryParse(min);
      if (parsed == null || parsed < 0 || parsed > 100) {
        throw const FormatException('--min must be a number between 0 and 100');
      }
      minimum = parsed;
      if (args[i] == '--min') i++;
      continue;
    }
    final path = valueOf('file', i);
    if (path != null) {
      file = path;
      if (args[i] == '--file') i++;
      continue;
    }
    throw FormatException('Unknown argument: ${args[i]}');
  }

  return GateOptions(minimum: minimum, file: file);
}

void main(List<String> args) {
  final GateOptions options;
  try {
    options = parseArgs(args);
  } on FormatException catch (e) {
    stderr
      ..writeln(e.message)
      ..writeln(
        'Usage: dart run tools/coverage_gate.dart [--min <percent>] '
        '[--file <lcov path>]',
      );
    exitCode = 2;
    return;
  }

  final lcov = File(options.file);
  if (!lcov.existsSync()) {
    stderr.writeln(
      'Coverage file not found: ${options.file}. '
      'Run `flutter test --coverage` first.',
    );
    exitCode = 2;
    return;
  }

  final result = evaluateCoverage(
    parseLcov(lcov.readAsStringSync()),
    minimum: options.minimum,
  );
  stdout.write(formatReport(result));
  exitCode = result.exitCode;
}
