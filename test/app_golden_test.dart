import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/features/learn/presentation/learn_screen.dart';

import 'helpers/golden_config.dart';
import 'helpers/pump_app.dart';

// Proves the golden setup works end to end. Update with
// `flutter test --update-goldens test/app_golden_test.dart` after an
// intentional change to the learn placeholder screen.
void main() {
  testWidgets('root app renders the learn screen (golden)', (tester) async {
    await pumpGolden(tester, const ProviderScope(child: PsyTrainerApp()));
    await expectGolden(tester, 'learn_screen');
  });

  testWidgets('learn screen renders through pumpApp (golden)', (tester) async {
    await pumpGolden(tester, const LearnScreen(), pump: pumpApp);
    await expectGolden(tester, 'learn_screen_pump_app');
  });
}
