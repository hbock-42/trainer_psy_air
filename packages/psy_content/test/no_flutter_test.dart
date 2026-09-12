import 'dart:io';

import 'package:test/test.dart';

/// US-007: `psy_content` is a pure Dart package (content models, parser and
/// validator) so it can run on a future backend without pulling in Flutter.
///
/// Scans every Dart file under `lib/` and fails if any of them imports or
/// exports `package:flutter/...` (with or without `show`/`hide`/`as`
/// combinators).
void main() {
  test('lib/ never imports package:flutter', () {
    final libDir = Directory('lib');
    expect(
      libDir.existsSync(),
      isTrue,
      reason: 'run tests from the package root',
    );

    final forbidden = RegExp(
      r'''^\s*(import|export)\s+['"]package:flutter/''',
      multiLine: true,
    );

    final offenders = <String>[];
    for (final entity in libDir.listSync(recursive: true)) {
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
          'psy_content must stay pure Dart (no Flutter dependency):\n'
          '${offenders.join('\n')}',
    );
  });
}
