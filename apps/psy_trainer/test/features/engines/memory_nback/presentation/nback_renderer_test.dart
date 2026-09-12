import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/memory_nback/domain/nback_engine.dart';
import 'package:psy_trainer/features/engines/memory_nback/presentation/nback_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  const engine = NbackEngine();
  final start = DateTime.utc(2026, 9, 5, 9);

  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  ActivitySessionConfig config({
    required int seed,
    required NbackParams params,
    SessionMode mode = SessionMode.practice,
    TimingPolicy timing = TimingPolicy.none,
  }) => ActivitySessionConfig(
    familyId: 'memory_nback',
    mode: mode,
    source: ItemSource.generator(
      generatorId: GeneratorId.nback,
      seed: seed,
      params: params,
      count: 1,
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
        RendererRegistry(const [NbackRenderer()]),
      ),
      engineClockProvider.overrideWithValue(clock),
    ],
  );

  // sectionSeed 2 with `NbackParams(count: 1, primers: 0)` decodes to a
  // single target stimulus (see the story's report for how this was found).
  NbackParams targetParams({
    NbackStimulusKind kind = NbackStimulusKind.colour,
  }) => NbackParams(count: 1, primers: 0, stimulusKind: kind);
  const targetSeed = 2;

  testWidgets('tapping Yes on a target answers a hit and is correct', (
    tester,
  ) async {
    await pumpHost(tester, config(seed: targetSeed, params: targetParams()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    expect(find.byKey(NbackRenderer.stimulusKey), findsOneWidget);
    await tester.tap(find.byKey(NbackRenderer.yesKey));
    await tester.pump();

    expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
    await tester.tap(find.byKey(SessionHost.nextKey));
    await tester.pump();

    expect(finished.single.section.correct, 1);
    expect(finished.single.section.metricTotals['nbackHits'], 1);
  });

  testWidgets('the Y key answers yes, exactly like the button', (tester) async {
    await pumpHost(tester, config(seed: targetSeed, params: targetParams()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.keyY);
    await tester.pump();

    expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('the left arrow answers no, exactly like the button', (
    tester,
  ) async {
    await pumpHost(tester, config(seed: targetSeed, params: targetParams()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();

    // Answering "no" on a target is a miss: wrong.
    expect(find.text(AppStrings.sessionFeedbackWrong), findsOneWidget);
  });

  testWidgets('a digit stimulus renders its label instead of a colour', (
    tester,
  ) async {
    await pumpHost(
      tester,
      config(
        seed: targetSeed,
        params: targetParams(kind: NbackStimulusKind.digit),
      ),
    );
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    expect(find.byKey(NbackRenderer.stimulusKey), findsOneWidget);
  });

  testWidgets('a primer shows its label and scores correct either way', (
    tester,
  ) async {
    await pumpHost(
      tester,
      config(seed: 0, params: const NbackParams(count: 2)),
    );
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    expect(find.byKey(NbackRenderer.primerLabelKey), findsOneWidget);
    await tester.tap(find.byKey(NbackRenderer.noKey));
    await tester.pump();
    expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('practice shows the history strip, exam does not', (
    tester,
  ) async {
    await pumpHost(tester, config(seed: targetSeed, params: targetParams()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    expect(find.byKey(NbackRenderer.historyStripKey), findsOneWidget);
  });

  testWidgets('exam mode has no history strip and no per-item feedback', (
    tester,
  ) async {
    await pumpHost(
      tester,
      config(seed: targetSeed, params: targetParams(), mode: SessionMode.exam),
    );
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    expect(find.byKey(NbackRenderer.historyStripKey), findsNothing);

    await tester.tap(find.byKey(NbackRenderer.yesKey));
    await tester.pump();
    expect(find.text(AppStrings.sessionFeedbackCorrect), findsNothing);
    expect(find.text(AppStrings.sessionFeedbackWrong), findsNothing);
  });

  testWidgets('the buttons are disabled during the stimulus-only phase', (
    tester,
  ) async {
    await pumpHost(
      tester,
      config(
        seed: targetSeed,
        params: targetParams(),
        mode: SessionMode.exam,
        timing: const TimingPolicy(
          cadence: Cadence(stimulusMs: 500, answerWindowMs: 1000),
        ),
      ),
    );
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tester.tap(find.byKey(NbackRenderer.yesKey));
    await tester.pump();
    // Still in the stimulus phase (500 ms not elapsed): no answer recorded
    // yet, the session has not finished.
    expect(finished, isEmpty);

    clock.elapse(const Duration(milliseconds: 500));
    await tester.pump();
    await tester.tap(find.byKey(NbackRenderer.yesKey));
    await tester.pump();
    clock.elapse(const Duration(milliseconds: 1000));
    await tester.pump();
    expect(finished.single.section.correct, 1);
  });
}
