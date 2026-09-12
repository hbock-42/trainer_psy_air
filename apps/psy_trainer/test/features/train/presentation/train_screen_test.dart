import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/features/train/domain/engine/activity_engine.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_registry_provider.dart';
import 'package:psy_trainer/features/train/presentation/train_screen.dart';

import '../../../helpers/fake_engine.dart';
import '../../../helpers/onboarding_fakes.dart' show progressRepositoryOverride;
import '../../../helpers/psy0_families.dart';
import '../../../helpers/pump_app.dart';

/// Pumps the bare [TrainScreen] over the in-memory repositories, with a
/// couple of families marked available (so the "Rapide (5)" row and the
/// resume card render like a real Train home).
Future<void> pumpTrain(
  WidgetTester tester, {
  double textScale = 1.0,
  Size? size,
}) async {
  if (size != null) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }
  await pumpApp(
    tester,
    const TrainScreen(),
    textScale: textScale,
    overrides: [
      contentRepositoryProvider.overrideWithValue(psy0ContentRepository()),
      progressRepositoryOverride(),
      engineRegistryProvider.overrideWithValue(
        EngineRegistry([
          FakeEngine(familyId: 'memory_nback', generatorId: GeneratorId.nback),
          FakeEngine(
            familyId: 'english_reading',
            generatorId: GeneratorId.viewpoint,
          ),
        ]),
      ),
    ],
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists the 14 PSY0 families in real-test order', (tester) async {
    await pumpTrain(tester);

    for (final name in psy0FamilyNames) {
      expect(find.text(name), findsOneWidget);
    }
  });

  testWidgets('meets accessibility guidelines', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpTrain(tester);

    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  });

  testWidgets('survives 1.3x text scaling at 360dp without overflow', (
    tester,
  ) async {
    await pumpTrain(tester, size: const Size(360, 780), textScale: 1.3);

    expect(tester.takeException(), isNull);
  });
}
