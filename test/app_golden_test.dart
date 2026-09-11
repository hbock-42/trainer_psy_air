import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/features/learn/presentation/learn_screen.dart';

import 'helpers/golden_config.dart';
import 'helpers/psy0_families.dart';
import 'helpers/pump_app.dart';

// Proves the golden setup works end to end. Update with
// `flutter test --update-goldens test/app_golden_test.dart` after an
// intentional change to the Learn home (US-040).
//
// Both screens are text-dense (cards full of copy), so macOS and Linux
// renderings differ on a few percent of pixels (glyph-edge anti-aliasing, see
// golden_config.dart); a layout change moves whole blocks and diffs far more
// than the budget below.
const double _textDenseTolerance = 0.05;

void main() {
  testWidgets('root app renders the learn home empty state (golden)', (
    tester,
  ) async {
    // No content seeded: the pre-US-013 state the app starts in today.
    await pumpGolden(
      tester,
      ProviderScope(
        overrides: [
          contentRepositoryProvider.overrideWithValue(
            psy0ContentRepository(seeded: false),
          ),
        ],
        child: const PsyTrainerApp(),
      ),
    );
    await expectGolden(tester, 'learn_screen', tolerance: _textDenseTolerance);
  });

  testWidgets('learn home with the PSY0 families renders through pumpApp '
      '(golden)', (tester) async {
    await pumpGolden(
      tester,
      const LearnScreen(),
      pump: (tester, child) => pumpApp(
        tester,
        child,
        overrides: [
          contentRepositoryProvider.overrideWithValue(psy0ContentRepository()),
        ],
      ),
    );
    await expectGolden(
      tester,
      'learn_screen_pump_app',
      tolerance: _textDenseTolerance,
    );
  });
}
