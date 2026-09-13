import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamepads/gamepads.dart' show GamepadButton;
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/input/gamepad/fake_gamepad_service.dart';
import 'package:psy_trainer/core/input/gamepad/gamepad_models.dart';
import 'package:psy_trainer/core/input/gamepad/gamepad_service_provider.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_engine.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/presentation/p1_psychomotor_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;
  late FakeGamepadService gamepad;

  // A single, very short phase so the widget test does not need to pump
  // for 18 minutes of wall time; the simulation/scoring logic itself is
  // unit-tested directly (determinism, control law, red-zone rule, phase
  // schedule) against the pure-Dart domain classes.
  const params = P1PsychomotorParams(phaseCount: 1, phaseDurationSec: 1);

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
    gamepad = FakeGamepadService();
  });

  ActivitySessionConfig config({
    SessionMode mode = SessionMode.practice,
    int seed = 1,
  }) => ActivitySessionConfig(
    familyId: P1PsychomotorEngine.engineFamilyId,
    mode: mode,
    source: ItemSource.generator(
      generatorId: GeneratorId.p1Psychomotor,
      seed: seed,
      params: params,
      count: 1,
    ),
    timing: const TimingPolicy(sectionMs: 60000),
  );

  Future<void> pumpHost(WidgetTester tester, ActivitySessionRequest request) =>
      pumpApp(
        tester,
        SessionHost(request: request, onFinished: finished.add),
        overrides: [
          progressRepositoryProvider.overrideWithValue(repo),
          engineRegistryProvider.overrideWithValue(
            EngineRegistry(const [P1PsychomotorEngine()]),
          ),
          rendererRegistryProvider.overrideWithValue(
            RendererRegistry(const [P1PsychomotorRenderer()]),
          ),
          engineClockProvider.overrideWithValue(clock),
          gamepadServiceProvider.overrideWithValue(gamepad),
        ],
      );

  group('desktop platform with a fake gamepad connected', () {
    testWidgets(
      'a fake gamepad stream and key events drive the run to completion',
      (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        gamepad.addDevice(
          const GamepadDeviceInfo(id: 'pad1', name: 'Test Pad'),
        );

        // Exam mode: no feedback screen to dismiss, so the session finishes
        // as soon as the renderer submits its `Answer.raw` (matches
        // `multitask_psychomotor`'s own renderer test convention).
        await pumpHost(
          tester,
          ActivitySessionRequest.fresh(config(mode: SessionMode.exam)),
        );
        await tester.tap(find.byKey(SessionHost.startKey));
        await tester.pump();

        // Continuous stick input: null the selected gauge and steer the
        // crosshair, exactly the kind of input a real run would produce.
        gamepad.push(
          const GamepadState(
            deviceId: 'pad1',
            leftStick: StickVector(y: 0.5),
            rightStick: StickVector(x: 0.3, y: 0.2),
            pressedButtons: {GamepadButton.leftBumper},
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));

        // A letter/arithmetic key event, always the physical keyboard
        // regardless of which service drives the sticks.
        await tester.sendKeyDownEvent(LogicalKeyboardKey.f1);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.f1);
        await tester.pump(const Duration(milliseconds: 300));

        gamepad.push(
          const GamepadState(
            deviceId: 'pad1',
            leftStick: StickVector(y: -0.5),
            rightStick: StickVector(x: -0.2, y: -0.1),
          ),
        );
        // Let the ticker reach params.phaseDurationSec (1 s).
        await tester.pump(const Duration(milliseconds: 600));
        await tester.pump();

        expect(finished, hasLength(1));
        expect(finished.single.reason, FinishReason.completed);
        final outcome = repo.attempts.single;
        expect(outcome.answer, isNotNull);
        expect(outcome.answer!['kind'], 'raw');
        debugDefaultTargetPlatformOverride = null;
      },
    );
  });

  group('practice mode', () {
    testWidgets(
      'shows a per-channel summary in place of the live scene once the '
      'last phase is answered',
      (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        gamepad.addDevice(
          const GamepadDeviceInfo(id: 'pad1', name: 'Test Pad'),
        );

        await pumpHost(tester, ActivitySessionRequest.fresh(config()));
        await tester.tap(find.byKey(SessionHost.startKey));
        await tester.pump();

        gamepad.push(
          const GamepadState(deviceId: 'pad1', leftStick: StickVector(y: 0.5)),
        );
        await tester.pump(const Duration(milliseconds: 1100));
        await tester.pump();

        expect(find.text(l10nFr.p1PsychomotorSummaryTitle), findsOneWidget);
        expect(find.byKey(SessionHost.nextKey), findsOneWidget);

        await tester.tap(find.byKey(SessionHost.nextKey));
        await tester.pump();

        expect(finished, hasLength(1));
        debugDefaultTargetPlatformOverride = null;
      },
    );
  });

  group('a device that has never been seen (no gamepad, touch platform)', () {
    testWidgets('exam mode shows a device-required notice and allows skip', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      await pumpHost(
        tester,
        ActivitySessionRequest.fresh(config(mode: SessionMode.exam)),
      );
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      expect(find.text(l10nFr.p1PsychomotorDeviceRequired), findsOneWidget);
      await tester.tap(find.byKey(const Key('p1_psychomotor.skip_section')));
      await tester.pump();

      expect(finished, hasLength(1));
      expect(finished.single.section.skipped, 1);
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
