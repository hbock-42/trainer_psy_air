import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/multitask_psychomotor/domain/multitask_engine.dart';
import 'package:psy_trainer/features/engines/multitask_psychomotor/presentation/multitask_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  // A very short run so the widget test does not need to pump for 5
  // minutes of wall time; the simulation logic itself (event rates,
  // determinism) is unit-tested directly against `MultitaskSimulation` /
  // `MultitaskScoring`.
  const params = MultitaskParams(durationSec: 1);

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  ActivitySessionConfig config({
    SessionMode mode = SessionMode.practice,
    int seed = 1,
  }) => ActivitySessionConfig(
    familyId: MultitaskEngine.engineFamilyId,
    mode: mode,
    source: ItemSource.generator(
      generatorId: GeneratorId.multitask,
      seed: seed,
      params: params,
      count: 1,
    ),
    // A generous safety net: the widget's own ticker ends the item well
    // before this, exactly as the real blueprint's `sectionTimeSec` is
    // only a safety net (see `MultitaskRenderer` doc).
    timing: const TimingPolicy(sectionMs: 60000),
  );

  Future<void> pumpHost(WidgetTester tester, ActivitySessionRequest request) =>
      pumpApp(
        tester,
        SessionHost(request: request, onFinished: finished.add),
        overrides: [
          progressRepositoryProvider.overrideWithValue(repo),
          engineRegistryProvider.overrideWithValue(
            EngineRegistry(const [MultitaskEngine()]),
          ),
          rendererRegistryProvider.overrideWithValue(
            RendererRegistry(const [MultitaskRenderer()]),
          ),
          engineClockProvider.overrideWithValue(clock),
        ],
      );

  group('touch platform (no keyboard confirmed yet)', () {
    testWidgets(
      'practice shows the non-representative D-pad until a physical key '
      'arrives',
      (tester) async {
        await pumpHost(tester, ActivitySessionRequest.fresh(config()));
        await tester.tap(find.byKey(SessionHost.startKey));
        await tester.pump();

        expect(
          find.byKey(const Key('multitask.touch_dpad.up')),
          findsOneWidget,
        );
        expect(find.byKey(const Key('multitask.touch_shape')), findsOneWidget);
        expect(find.byKey(const Key('multitask.touch_calc')), findsOneWidget);

        await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowUp);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();

        expect(find.byKey(const Key('multitask.touch_dpad.up')), findsNothing);
      },
    );

    testWidgets(
      'exam mode shows a keyboard-required notice and Skip returns a skip',
      (tester) async {
        await pumpHost(
          tester,
          ActivitySessionRequest.fresh(config(mode: SessionMode.exam)),
        );
        await tester.tap(find.byKey(SessionHost.startKey));
        await tester.pump();

        expect(find.byKey(const Key('multitask.skip_section')), findsOneWidget);
        expect(find.byKey(const Key('multitask.touch_dpad.up')), findsNothing);

        await tester.tap(find.byKey(const Key('multitask.skip_section')));
        await tester.pump();

        expect(find.text(l10nFr.sessionFinishedTitle), findsOneWidget);
        expect(finished, hasLength(1));
        expect(finished.single.section.skipped, 1);
      },
    );
  });

  group('desktop platform (keyboard confirmed from the start)', () {
    // Reset synchronously at the end of each test body: the binding's
    // end-of-test invariant check runs before `tearDown`/`addTearDown`
    // callbacks fire, so those would reset it too late.

    testWidgets('no touch fallback and no exam notice appear', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      await pumpHost(
        tester,
        ActivitySessionRequest.fresh(config(mode: SessionMode.exam)),
      );
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      expect(find.byKey(const Key('multitask.skip_section')), findsNothing);
      expect(find.byKey(const Key('multitask.touch_dpad.up')), findsNothing);
      expect(find.byType(CustomPaint), findsWidgets);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets(
      'holding an arrow, pressing space/F, then letting the ticker reach '
      'the duration submits a raw answer and completes the session',
      (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        // Exam mode: no feedback screen to dismiss, so the session finishes
        // as soon as the renderer submits its `Answer.raw`.
        await pumpHost(
          tester,
          ActivitySessionRequest.fresh(config(mode: SessionMode.exam)),
        );
        await tester.tap(find.byKey(SessionHost.startKey));
        await tester.pump();

        await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump(const Duration(milliseconds: 300));
        await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
        await tester.pump(const Duration(milliseconds: 300));
        await tester.sendKeyDownEvent(LogicalKeyboardKey.keyF);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.keyF);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowUp);

        // Let the ticker reach params.durationSec (1 s).
        await tester.pump(const Duration(milliseconds: 600));
        await tester.pump();

        expect(find.text(l10nFr.sessionFinishedTitle), findsOneWidget);
        expect(finished, hasLength(1));
        expect(finished.single.reason, FinishReason.completed);
        final outcome = repo.attempts.single;
        expect(outcome.answer, isNotNull);
        expect(outcome.answer!['kind'], 'raw');
        debugDefaultTargetPlatformOverride = null;
      },
    );
  });
}
