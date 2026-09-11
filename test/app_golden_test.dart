import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/features/learn/presentation/learn_screen.dart';

import 'helpers/golden_config.dart';
import 'helpers/pump_app.dart';

// Proves the golden setup works end to end. Update with
// `flutter test --update-goldens test/app_golden_test.dart` after an
// intentional change to the learn placeholder screen.
//
// The learn placeholder is a full screen of disclaimer text, so macOS and
// Linux renderings differ on ~3.7 % of pixels (glyph-edge anti-aliasing, see
// golden_config.dart); a layout change moves whole text blocks and diffs far
// more than the budget below.
const double _textDenseTolerance = 0.05;

void main() {
  testWidgets('root app renders the learn screen (golden)', (tester) async {
    await pumpGolden(tester, const ProviderScope(child: PsyTrainerApp()));
    await expectGolden(tester, 'learn_screen', tolerance: _textDenseTolerance);
  });

  testWidgets('learn screen renders through pumpApp (golden)', (tester) async {
    await pumpGolden(tester, const LearnScreen(), pump: pumpApp);
    await expectGolden(
      tester,
      'learn_screen_pump_app',
      tolerance: _textDenseTolerance,
    );
  });
}
