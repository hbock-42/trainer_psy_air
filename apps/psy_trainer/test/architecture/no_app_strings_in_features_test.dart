import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// US-091: every UI string moved from the FR-only `AppStrings` constants to
/// ARB-based `AppLocalizations` (read through `context.l10n`, see
/// `lib/core/l10n/l10n_extensions.dart`). `AppStrings` itself now only holds
/// the handful of strings two pure-Dart `domain/` files build without a
/// `BuildContext` (see the class doc in `lib/core/l10n/strings.dart`).
///
/// Scans every Dart file under `lib/features/` and fails if any of them
/// references `AppStrings.`, except the two allowed files.
void main() {
  test(
    'lib/features/ never uses AppStrings. outside its two domain exceptions',
    () {
      final featuresDir = Directory('lib/features');
      expect(
        featuresDir.existsSync(),
        isTrue,
        reason: 'run tests from the package root',
      );

      const allowed = {
        'lib/features/engines/logic_dominos/domain/domino_explanation.dart',
        'lib/features/engines/spatial_viewpoint/domain/viewpoint_explanation.dart',
      };

      final forbidden = RegExp(r'\bAppStrings\.');

      final offenders = <String>[];
      for (final entity in featuresDir.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final relative = entity.path.replaceAll(r'\', '/');
        if (allowed.contains(relative)) continue;
        final source = entity.readAsStringSync();
        for (final match in forbidden.allMatches(source)) {
          final line =
              '\n'.allMatches(source.substring(0, match.start)).length + 1;
          offenders.add('$relative:$line');
        }
      }

      expect(
        offenders,
        isEmpty,
        reason:
            'AppStrings. is only allowed in the two domain exceptions listed '
            'in this test (no BuildContext available there); every other '
            'screen/widget must read context.l10n instead:\n'
            '${offenders.join('\n')}',
      );
    },
  );
}
