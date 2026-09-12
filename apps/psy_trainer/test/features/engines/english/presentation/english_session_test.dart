import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/english/domain/english_engine.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';
import 'package:psy_trainer/features/train/presentation/renderers/mcq_renderer.dart';

import '../../../../helpers/pump_app.dart';

/// `SessionHost` over a real passage set (US-027): the passage panel the
/// contract gap was about — `McqRenderer`'s `passageResolver` fed by a
/// preloaded cache, exactly how `practice_session_builder.dart` +
/// `EnglishPassageCache` wire it for a real session.
final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  const passageId = 'english.reading.p001';
  const passageTitle = 'Pre-flight briefing';
  const passage = Passage(
    id: passageId,
    title: LocalizedText(fr: passageTitle),
    body: LocalizedText(fr: 'Before every departure the crew gathers.'),
  );

  final item1 = McqItem(
    id: 'english.reading.0001',
    version: 1,
    familyId: 'english',
    difficulty: 2,
    tags: const ['english.reading'],
    passageId: passageId,
    stem: const LocalizedText(fr: 'Question one about the text'),
    options: const [
      McqOption(text: LocalizedText(fr: 'A')),
      McqOption(text: LocalizedText(fr: 'B')),
    ],
    correctIndex: 0,
    explanation: const LocalizedText(fr: 'Because.'),
  );
  final item2 = McqItem(
    id: 'english.reading.0002',
    version: 1,
    familyId: 'english',
    difficulty: 2,
    tags: const ['english.reading'],
    passageId: passageId,
    stem: const LocalizedText(fr: 'Question two about the text'),
    options: const [
      McqOption(text: LocalizedText(fr: 'A')),
      McqOption(text: LocalizedText(fr: 'B')),
    ],
    correctIndex: 1,
    explanation: const LocalizedText(fr: 'Because.'),
  );

  ActivitySessionConfig config() => ActivitySessionConfig(
    familyId: 'english',
    mode: SessionMode.practice,
    source: ItemSource.bank([item1, item2]),
    title: const LocalizedText(fr: 'Anglais'),
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
        EngineRegistry(const [EnglishEngine()]),
      ),
      rendererRegistryProvider.overrideWithValue(
        RendererRegistry([
          McqRenderer(
            familyId: 'english',
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

    expect(find.text('Question one about the text'), findsOneWidget);
    expect(find.text(passageTitle), findsOneWidget);

    // Hide, then show again: the passage stays re-openable while answering.
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

    expect(find.text('Question two about the text'), findsOneWidget);
    expect(
      find.text(passageTitle),
      findsOneWidget,
      reason: 'the panel is shown again for the second linked question',
    );
  });
}
