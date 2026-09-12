import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// `lib/features/*/domain/` is pure Dart (docs/ARCHITECTURE.md, "Dependency
/// direction"): no Flutter (widgets, Riverpod) and no Drift, so engines,
/// scoring and stats run in plain `test()`s and could move to a server.
///
/// Scans every Dart file under a `domain/` folder of `lib/features/` and
/// fails on any import or export of `package:flutter/`,
/// `package:flutter_riverpod`, `package:riverpod`, `package:drift` or
/// `package:sqlite3`, or of a `presentation/` folder.
void main() {
  final forbidden = RegExp(
    r'''^\s*(import|export)\s+['"](package:flutter/|package:flutter_riverpod|package:riverpod|package:drift|package:sqlite3|dart:ui|[^'"]*/presentation/)''',
    multiLine: true,
  );

  test('lib/features/*/domain/ never imports Flutter, Riverpod or Drift', () {
    final featuresDir = Directory('lib/features');
    expect(
      featuresDir.existsSync(),
      isTrue,
      reason: 'run tests from the package root',
    );

    final offenders = <String>[];
    for (final entity in featuresDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final segments = entity.uri.pathSegments;
      if (!segments.contains('domain')) continue;
      final source = entity.readAsStringSync();
      for (final match in forbidden.allMatches(source)) {
        final line =
            '\n'.allMatches(source.substring(0, match.start)).length + 1;
        offenders.add('${entity.path}:$line: ${match.group(0)!.trim()}');
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'domain/ is pure Dart; move providers to presentation/providers/ '
          'and data access behind a repository interface:\n'
          '${offenders.join('\n')}',
    );
  });

  test('the rule catches every forbidden import form', () {
    const bad = [
      "import 'package:flutter/widgets.dart';",
      "import 'package:flutter/foundation.dart' show immutable;",
      "import 'package:flutter_riverpod/flutter_riverpod.dart';",
      "import 'package:riverpod/riverpod.dart';",
      "import 'package:drift/drift.dart';",
      "export 'package:sqlite3/sqlite3.dart';",
      "import 'dart:ui';",
      "import '../presentation/providers/x.dart';",
    ];
    const good = [
      "import 'package:freezed_annotation/freezed_annotation.dart';",
      "import 'package:psy_trainer/core/repositories/repositories.dart';",
      "import '../../../core/content/content.dart';",
      "import 'dart:math' as math;",
    ];
    for (final line in bad) {
      expect(forbidden.hasMatch(line), isTrue, reason: line);
    }
    for (final line in good) {
      expect(forbidden.hasMatch(line), isFalse, reason: line);
    }
  });
}
