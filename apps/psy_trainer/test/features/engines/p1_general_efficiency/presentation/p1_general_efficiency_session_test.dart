import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_general_efficiency/domain/p1_general_efficiency_engine.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';
import 'package:psy_trainer/features/train/presentation/renderers/mcq_renderer.dart';

import '../../../../helpers/pump_app.dart';

/// `SessionHost` over a plain EFG MCQ (US-116): no `passageId`, so this only
/// proves the family runs end to end through `McqRenderer` with no
/// `passageResolver` supplied (the family never needs one).
void main() {
  final item = McqItem(
    id: 'efg.numeric.0001',
    version: 1,
    familyId: 'p1_general_efficiency',
    difficulty: 1,
    tags: const ['efg', 'efg.numeric'],
    stem: const LocalizedText(fr: 'Quel est le prochain nombre : 2, 4, 6 ?'),
    options: const [
      McqOption(text: LocalizedText(fr: '7')),
      McqOption(text: LocalizedText(fr: '8')),
    ],
    correctIndex: 1,
    explanation: const LocalizedText(fr: 'On ajoute 2.'),
  );

  ActivitySessionConfig config() => ActivitySessionConfig(
    familyId: 'p1_general_efficiency',
    mode: SessionMode.practice,
    source: ItemSource.bank([item]),
    title: const LocalizedText(fr: 'EFG'),
  );

  Future<void> pumpSession(WidgetTester tester) => pumpApp(
    tester,
    SessionHost(
      request: ActivitySessionRequest.fresh(config()),
      onFinished: (_) {},
    ),
    overrides: [
      progressRepositoryProvider.overrideWithValue(
        InMemoryProgressRepository(),
      ),
      engineRegistryProvider.overrideWithValue(
        EngineRegistry(const [P1GeneralEfficiencyEngine()]),
      ),
      rendererRegistryProvider.overrideWithValue(
        RendererRegistry(const [
          McqRenderer(familyId: 'p1_general_efficiency'),
        ]),
      ),
      engineClockProvider.overrideWithValue(ManualClock(DateTime.utc(2026, 9))),
    ],
  );

  testWidgets('runs an EFG MCQ item end to end with no passage panel', (
    tester,
  ) async {
    await pumpSession(tester);
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    expect(
      find.text('Quel est le prochain nombre : 2, 4, 6 ?'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('mcq_option_1')));
    await tester.pump();

    expect(find.text('On ajoute 2.'), findsOneWidget);
  });
}
