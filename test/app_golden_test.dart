import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/app.dart';

import 'helpers/golden_config.dart';
import 'helpers/pump_app.dart';

// Proves the golden setup works end to end. Update with
// `flutter test --update-goldens test/app_golden_test.dart` after an
// intentional change to the placeholder screen.
void main() {
  testWidgets('root app renders the placeholder screen (golden)', (
    tester,
  ) async {
    await pumpGolden(tester, const PsyTrainerApp());
    await expectGolden(tester, 'placeholder_screen');
  });

  testWidgets('placeholder screen renders through pumpApp (golden)', (
    tester,
  ) async {
    await pumpGolden(tester, const PlaceholderScreen(), pump: pumpApp);
    await expectGolden(tester, 'placeholder_screen_pump_app');
  });
}
