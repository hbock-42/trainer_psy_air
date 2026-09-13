import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_reading_fr/domain/p1_reading_fr_engine.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';
import 'package:psy_trainer/features/train/presentation/renderers/mcq_renderer.dart';

import '../../../../helpers/pump_app.dart';

/// `SessionHost` over a real `p1_reading_fr` passage set (US-116, same
/// wiring as `english`'s own session test): `McqRenderer`'s
/// `passageResolver` fed by a preloaded `PassageCache`, as
/// `practice_session_builder.dart` wires it for a real session.
final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  const passageId = 'p1_reading_fr.reading.p001';
  const passageTitle = 'Changement de porte';
  const passage = Passage(
    id: passageId,
    title: LocalizedText(fr: passageTitle),
    body: LocalizedText(fr: 'Le vol AS 442 change de porte.'),
  );

  final item1 = McqItem(
    id: 'p1_reading_fr.reading.0001',
    version: 1,
    familyId: 'p1_reading_fr',
    difficulty: 2,
    tags: const ['p1_reading_fr', 'p1_reading_fr.comprehension'],
    passageId: passageId,
    stem: const LocalizedText(fr: 'Question un sur le texte'),
    options: const [
      McqOption(text: LocalizedText(fr: 'A')),
      McqOption(text: LocalizedText(fr: 'B')),
    ],
    correctIndex: 0,
    explanation: const LocalizedText(fr: 'Parce que.'),
  );
  final item2 = McqItem(
    id: 'p1_reading_fr.reading.0002',
    version: 1,
    familyId: 'p1_reading_fr',
    difficulty: 2,
    tags: const ['p1_reading_fr', 'p1_reading_fr.comprehension'],
    passageId: passageId,
    stem: const LocalizedText(fr: 'Question deux sur le texte'),
    options: const [
      McqOption(text: LocalizedText(fr: 'A')),
      McqOption(text: LocalizedText(fr: 'B')),
    ],
    correctIndex: 1,
    explanation: const LocalizedText(fr: 'Parce que.'),
  );

  ActivitySessionConfig config() => ActivitySessionConfig(
    familyId: 'p1_reading_fr',
    mode: SessionMode.practice,
    source: ItemSource.bank([item1, item2]),
    title: const LocalizedText(fr: 'Compréhension de lecture'),
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
        EngineRegistry(const [P1ReadingFrEngine()]),
      ),
      rendererRegistryProvider.overrideWithValue(
        RendererRegistry([
          McqRenderer(
            familyId: 'p1_reading_fr',
            passageResolver: (id) => id == passageId ? passage : null,
          ),
        ]),
      ),
      engineClockProvider.overrideWithValue(ManualClock(DateTime.utc(2026, 9))),
    ],
  );

  testWidgets('shows the passage panel, re-openable, across both questions', (
    tester,
  ) async {
    await pumpSession(tester);
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    expect(find.text('Question un sur le texte'), findsOneWidget);
    expect(find.text(passageTitle), findsOneWidget);

    await tester.tap(find.text(l10nFr.mcqPassageHide));
    await tester.pump();
    expect(find.text(l10nFr.mcqPassageShow), findsOneWidget);
    await tester.tap(find.text(l10nFr.mcqPassageShow));
    await tester.pump();
    expect(find.text(l10nFr.mcqPassageHide), findsOneWidget);

    await tester.tap(find.byKey(const Key('mcq_option_0')));
    await tester.pump();
    await tester.tap(find.byKey(SessionHost.nextKey));
    await tester.pump();

    expect(find.text('Question deux sur le texte'), findsOneWidget);
    expect(
      find.text(passageTitle),
      findsOneWidget,
      reason: 'the panel is shown again for the second linked question',
    );
  });
}
