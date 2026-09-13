import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_attention_sustained/domain/attention_sustained_engine.dart';
import 'package:psy_trainer/features/engines/p1_attention_sustained/presentation/attention_sustained_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  const engine = AttentionSustainedEngine();
  final start = DateTime.utc(2026, 9, 13, 9);

  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  // Same seed/params as `attention_sustained_engine_test.dart`: runSeed 13
  // with `itemsPerSeries: 5` rolls filler, lure, target, filler, filler.
  const params = P1AttentionSustainedParams();
  const runSeed = 13;

  ActivitySessionConfig config({
    SessionMode mode = SessionMode.practice,
    TimingPolicy timing = TimingPolicy.none,
    int count = 3,
  }) => ActivitySessionConfig(
    familyId: 'p1_attention_sustained',
    mode: mode,
    source: ItemSource.generator(
      generatorId: GeneratorId.p1AttentionSustained,
      seed: runSeed,
      params: params,
      count: count,
    ),
    timing: timing,
  );

  Future<void> pumpHost(
    WidgetTester tester,
    ActivitySessionConfig sessionConfig,
  ) => pumpApp(
    tester,
    SessionHost(
      request: ActivitySessionRequest.fresh(sessionConfig),
      onFinished: finished.add,
    ),
    overrides: [
      progressRepositoryProvider.overrideWithValue(repo),
      engineRegistryProvider.overrideWithValue(EngineRegistry(const [engine])),
      rendererRegistryProvider.overrideWithValue(
        RendererRegistry(const [AttentionSustainedRenderer()]),
      ),
      engineClockProvider.overrideWithValue(clock),
    ],
  );

  /// Answers item 0 (filler) and item 1 (lure) both correctly ("not
  /// target") in practice mode and moves past their feedback, so the test
  /// can then interact with item 2, the run's real target.
  Future<void> skipToTarget(WidgetTester tester) async {
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.byKey(AttentionSustainedRenderer.notTargetKey));
      await tester.pump();
      await tester.tap(find.byKey(SessionHost.nextKey));
      await tester.pump();
    }
  }

  testWidgets('tapping Target on a target item answers a hit and is correct', (
    tester,
  ) async {
    await pumpHost(tester, config());
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    await skipToTarget(tester);

    expect(find.byKey(AttentionSustainedRenderer.stimulusKey), findsOneWidget);
    await tester.tap(find.byKey(AttentionSustainedRenderer.targetKey));
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
    await tester.tap(find.byKey(SessionHost.nextKey));
    await tester.pump();

    expect(finished.single.section.correct, 3);
    expect(finished.single.section.metricTotals['attentionHits'], 1);
    expect(
      finished.single.section.metricTotals['attentionCorrectRejections'],
      2,
    );
  });

  testWidgets('the space key answers target, exactly like the button', (
    tester,
  ) async {
    await pumpHost(tester, config());
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    await skipToTarget(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('the N key answers not-target, exactly like the button', (
    tester,
  ) async {
    await pumpHost(tester, config());
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    // Item 0 is a filler: "not target" is correct.
    await tester.sendKeyEvent(LogicalKeyboardKey.keyN);
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('answering target on a non-target item is a false alarm', (
    tester,
  ) async {
    await pumpHost(tester, config());
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tester.tap(find.byKey(AttentionSustainedRenderer.targetKey));
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackWrong), findsOneWidget);
  });

  testWidgets('the active rule is shown in both practice and exam mode', (
    tester,
  ) async {
    await pumpHost(tester, config(mode: SessionMode.exam));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    expect(find.byKey(AttentionSustainedRenderer.ruleLabelKey), findsOneWidget);
  });

  testWidgets('exam mode gives no per-item feedback', (tester) async {
    await pumpHost(tester, config(mode: SessionMode.exam));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tester.tap(find.byKey(AttentionSustainedRenderer.notTargetKey));
    await tester.pump();
    expect(find.text(l10nFr.sessionFeedbackCorrect), findsNothing);
    expect(find.text(l10nFr.sessionFeedbackWrong), findsNothing);
  });

  testWidgets('the buttons are disabled during the stimulus-only phase', (
    tester,
  ) async {
    await pumpHost(
      tester,
      config(
        mode: SessionMode.exam,
        count: 1,
        timing: const TimingPolicy(
          cadence: Cadence(stimulusMs: 500, answerWindowMs: 1000),
        ),
      ),
    );
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tester.tap(find.byKey(AttentionSustainedRenderer.notTargetKey));
    await tester.pump();
    // Still in the stimulus phase (500 ms not elapsed): no answer recorded.
    expect(finished, isEmpty);

    clock.elapse(const Duration(milliseconds: 500));
    await tester.pump();
    await tester.tap(find.byKey(AttentionSustainedRenderer.notTargetKey));
    await tester.pump();
    clock.elapse(const Duration(milliseconds: 1000));
    await tester.pump();
    expect(finished.single.section.correct, 1);
  });
}
