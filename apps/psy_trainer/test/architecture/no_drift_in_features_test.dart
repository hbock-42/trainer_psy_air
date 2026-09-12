import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// US-012: features depend on the repository interfaces in
/// `lib/core/repositories/`, never on Drift or the database layer, so a
/// remote backend can be swapped in without touching them.
///
/// Scans every Dart file under `lib/features/` and fails on any import or
/// export of `package:drift`, `package:sqlite3` or `lib/core/db/` (relative
/// or `package:psy_trainer/core/db/...`).
void main() {
  test('lib/features/ never imports Drift, sqlite3 or core/db', () {
    final featuresDir = Directory('lib/features');
    expect(
      featuresDir.existsSync(),
      isTrue,
      reason: 'run tests from the package root',
    );

    final forbidden = RegExp(
      r'''^\s*(import|export)\s+['"](package:drift|package:sqlite3|package:psy_trainer/core/db/|(\.\./)+core/db/)''',
      multiLine: true,
    );

    final offenders = <String>[];
    for (final entity in featuresDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
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
          'Features must use ContentRepository/ProgressRepository from '
          'lib/core/repositories/ (see docs/ARCHITECTURE.md, "Data layer"):\n'
          '${offenders.join('\n')}',
    );
  });

  test('the rule catches every forbidden import form', () {
    final forbidden = RegExp(
      r'''^\s*(import|export)\s+['"](package:drift|package:sqlite3|package:psy_trainer/core/db/|(\.\./)+core/db/)''',
      multiLine: true,
    );
    const bad = [
      "import 'package:drift/drift.dart';",
      "import 'package:drift/native.dart' as native;",
      "export 'package:sqlite3/sqlite3.dart';",
      "import 'package:psy_trainer/core/db/app_database.dart';",
      "import '../../../core/db/app_database.dart';",
    ];
    const good = [
      "import 'package:psy_trainer/core/repositories/repositories.dart';",
      "import '../../../core/repositories/progress_repository.dart';",
      "import 'package:flutter_riverpod/flutter_riverpod.dart';",
    ];
    for (final line in bad) {
      expect(forbidden.hasMatch(line), isTrue, reason: line);
    }
    for (final line in good) {
      expect(forbidden.hasMatch(line), isFalse, reason: line);
    }
  });
}
