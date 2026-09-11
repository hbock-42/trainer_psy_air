import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Project-wide UI constraint: the app is built on the `widgets` layer only.
///
/// Scans every Dart file under `lib/` and fails if any of them imports or
/// exports the Material or Cupertino libraries (with or without `show`/`hide`/
/// `as` combinators).
void main() {
  test('lib/ never imports package:flutter/material.dart or cupertino.dart', () {
    final libDir = Directory('lib');
    expect(
      libDir.existsSync(),
      isTrue,
      reason: 'run tests from the package root',
    );

    final forbidden = RegExp(
      r'''^\s*(import|export)\s+['"]package:flutter/(material|cupertino)\.dart['"]''',
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
          'Material/Cupertino imports are forbidden under lib/ '
          '(use package:flutter/widgets.dart):\n${offenders.join('\n')}',
    );
  });
}
