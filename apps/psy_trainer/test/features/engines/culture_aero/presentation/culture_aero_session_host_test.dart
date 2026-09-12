import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/culture_aero/domain/culture_aero_engine.dart';
import 'package:psy_trainer/features/engines/culture_aero/presentation/culture_aero_explanation.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';
import 'package:psy_trainer/features/train/presentation/renderers/mcq_renderer.dart';

import '../../../../helpers/pump_app.dart';

/// `culture_aero` (US-028) through the real `SessionHost`, the real
/// `CultureAeroEngine` and the shared `McqRenderer` (reused, not forked —
/// see `test/features/train/presentation/renderers/mcq_renderer_test.dart`
/// and `test/features/engines/arithmetic_grid/presentation/
/// arithmetic_grid_session_host_test.dart`, the templates for this file).
void main() {
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  const engine = CultureAeroEngine();
  const renderer = McqRenderer(
    familyId: 'culture_aero',
    explanationFooter: cultureAeroExplanationFooter,
  );

  setUp(() {
    clock = ManualClock(DateTime.utc(2026, 9, 5, 9));
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  McqItem item({
    required String id,
    int correctIndex = 0,
    bool allowSkip = false,
    DateTime? validAsOf,
  }) => McqItem(
    id: id,
    version: 1,
    familyId: 'culture_aero',
    difficulty: 3,
    tags: const ['culture.history'],
    stem: LocalizedText(fr: 'Question $id'),
    options: const [
      McqOption(text: LocalizedText(fr: 'A')),
      McqOption(text: LocalizedText(fr: 'B')),
      McqOption(text: LocalizedText(fr: 'C')),
      McqOption(text: LocalizedText(fr: 'D')),
    ],
    correctIndex: correctIndex,
    explanation: const LocalizedText(fr: 'Explication détaillée.'),
    allowSkip: allowSkip,
    validAsOf: validAsOf,
  );

  ActivitySessionConfig config({
    required List<Item> items,
    SessionMode mode = SessionMode.practice,
  }) => ActivitySessionConfig(
    familyId: 'culture_aero',
    mode: mode,
    source: ItemSource.bank(items),
  );

  Future<void> pumpHost(WidgetTester tester, ActivitySessionConfig config) =>
      pumpApp(
        tester,
        SessionHost(
          request: ActivitySessionRequest.fresh(config),
          onFinished: finished.add,
        ),
        overrides: [
          progressRepositoryProvider.overrideWithValue(repo),
          engineRegistryProvider.overrideWithValue(EngineRegistry([engine])),
          rendererRegistryProvider.overrideWithValue(
            RendererRegistry(const [renderer]),
          ),
          engineClockProvider.overrideWithValue(clock),
        ],
      );

  Future<void> start(WidgetTester tester) async {
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
  }

  testWidgets('practice: runs through 3 bank items to the finished screen', (
    tester,
  ) async {
    final items = [
      item(id: 'q1'),
      item(id: 'q2', correctIndex: 1),
      item(id: 'q3', correctIndex: 2),
    ];
    await pumpHost(tester, config(items: items));
    await start(tester);

    for (final (index, it) in items.indexed) {
      expect(
        find.text('Question ${it.id}', findRichText: true),
        findsOneWidget,
      );
      await tester.tap(find.byKey(ValueKey('mcq_option_${it.correctIndex}')));
      await tester.pump();
      expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
      if (index < items.length - 1) {
        await tester.tap(find.byKey(SessionHost.nextKey));
        await tester.pump();
      }
    }
    await tester.tap(find.byKey(SessionHost.nextKey));
    await tester.pump();

    expect(find.text(AppStrings.sessionFinishedTitle), findsOneWidget);
    expect(repo.attempts, hasLength(3));
    expect(repo.attempts.every((a) => a.isCorrect), isTrue);
  });

  testWidgets('exam: 3 bank items, silent feedback, Valider required', (
    tester,
  ) async {
    final items = [item(id: 'q1'), item(id: 'q2'), item(id: 'q3')];
    await pumpHost(tester, config(items: items, mode: SessionMode.exam));
    await start(tester);

    for (var i = 0; i < items.length; i++) {
      expect(find.byKey(const ValueKey('mcq_validate')), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('mcq_option_0')));
      await tester.pump();
      expect(find.byKey(SessionHost.feedbackKey), findsNothing);
      await tester.tap(find.byKey(const ValueKey('mcq_validate')));
      await tester.pump();
      await tester.pump();
    }

    expect(find.text(AppStrings.sessionFinishedTitle), findsOneWidget);
    expect(repo.attempts, hasLength(3));
  });

  testWidgets('the skip option ("Je ne sais pas") only appears when '
      'the item allows it', (tester) async {
    await pumpHost(tester, config(items: [item(id: 'q1')]));
    await start(tester);
    expect(find.text(AppStrings.mcqSkipOption), findsNothing);
  });

  testWidgets('allowSkip shows the skip option and it scores a skip, not '
      'wrong', (tester) async {
    await pumpHost(tester, config(items: [item(id: 'q1', allowSkip: true)]));
    await start(tester);

    expect(find.text(AppStrings.mcqSkipOption), findsOneWidget);
    await tester.tap(find.text(AppStrings.mcqSkipOption));
    await tester.pump();

    expect(find.text(AppStrings.sessionFeedbackSkipped), findsOneWidget);
    expect(repo.attempts.single.isCorrect, isFalse);
  });

  testWidgets('a validAsOf item shows the "Donnée valable au ..." footer '
      'under the explanation', (tester) async {
    final validAsOf = DateTime.utc(2026, 3, 15);
    await pumpHost(
      tester,
      config(
        items: [item(id: 'q1', validAsOf: validAsOf)],
      ),
    );
    await start(tester);

    await tester.tap(find.byKey(const ValueKey('mcq_option_0')));
    await tester.pump();

    expect(
      find.text('Explication détaillée.', findRichText: true),
      findsOneWidget,
    );
    expect(find.text(AppStrings.cultureValidAsOf(validAsOf)), findsOneWidget);
  });

  testWidgets('an item without validAsOf shows no extra footer', (
    tester,
  ) async {
    await pumpHost(tester, config(items: [item(id: 'q1')]));
    await start(tester);

    await tester.tap(find.byKey(const ValueKey('mcq_option_0')));
    await tester.pump();

    expect(
      find.text(AppStrings.cultureValidAsOf(DateTime.utc(2026, 3, 15))),
      findsNothing,
    );
  });
}
