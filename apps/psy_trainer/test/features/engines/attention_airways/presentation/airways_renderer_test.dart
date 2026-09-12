import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/attention_airways/domain/airways_engine.dart';
import 'package:psy_trainer/features/engines/attention_airways/presentation/airways_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  // A short, fast series so the widget test does not have to pump a real
  // 30 s: `durationSec: 3` with a tight spawn interval guarantees at least
  // one aircraft is already airborne a few hundred milliseconds in.
  const params = AirwaysParams(
    routeCount: 2,
    spawnIntervalMs: 200,
    durationSec: 3,
  );

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  ActivitySessionConfig config({int seed = 1}) => ActivitySessionConfig(
    familyId: AirwaysEngine.engineFamilyId,
    mode: SessionMode.exam,
    liveFeedback: true,
    source: ItemSource.generator(
      generatorId: GeneratorId.airways,
      seed: seed,
      params: params,
      count: 1,
    ),
    // A safety net well above the simulation's own 3 s: the renderer's
    // `Ticker` is expected to submit first (see the renderer's class doc
    // on the current zero-margin blueprint value).
    timing: const TimingPolicy(perItemMs: 15000),
  );

  Future<void> pumpHost(WidgetTester tester, ActivitySessionRequest request) =>
      pumpApp(
        tester,
        SessionHost(request: request, onFinished: finished.add),
        overrides: [
          progressRepositoryProvider.overrideWithValue(repo),
          engineRegistryProvider.overrideWithValue(
            EngineRegistry(const [AirwaysEngine()]),
          ),
          rendererRegistryProvider.overrideWithValue(
            RendererRegistry(const [AirwaysRenderer()]),
          ),
          engineClockProvider.overrideWithValue(clock),
        ],
      );

  testWidgets('the briefing shows the capacity rule and the route legend', (
    tester,
  ) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(config()));
    expect(find.text(l10nFr.airwaysExampleCapacity(4, 2)), findsOneWidget);
    expect(find.text(l10nFr.airwaysExampleButtonLabel(1)), findsOneWidget);
    expect(find.text(l10nFr.airwaysExampleButtonLabel(2)), findsOneWidget);
  });

  testWidgets('a touch reroute increases the reroute counter', (tester) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(config()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    expect(find.text(l10nFr.airwaysReroutesCounter(0)), findsOneWidget);

    // Let the first scheduled aircraft take to the air (it always spawns
    // within the first ~200 ms) but keep well clear of its ~1.8-3.4 s
    // travel time, so it is still divertible.
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Exactly one of the two routes has that aircraft; try both buttons so
    // the test does not depend on which one the RNG picked.
    await tester.tap(find.byKey(const Key('airways.route_button.0')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('airways.route_button.1')));
    await tester.pump();

    expect(find.text(l10nFr.airwaysReroutesCounter(1)), findsOneWidget);
  });

  testWidgets('a keyboard digit reroutes the same way as its button', (
    tester,
  ) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(config(seed: 2)));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await tester.pump();

    expect(find.text(l10nFr.airwaysReroutesCounter(1)), findsOneWidget);
  });

  testWidgets(
    'the renderer submits its own answer when the series ends, with live '
    'feedback and the metrics recorded',
    (tester) async {
      await pumpHost(tester, ActivitySessionRequest.fresh(config()));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      // Drive the Ticker past the 3 s series (params.durationSec).
      for (var i = 0; i < 32; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Live feedback: the item stays on the feedback phase (awaits Next)
      // rather than jumping straight to the finished screen -- the runtime
      // never finishes the section on its own after an answer with
      // feedback enabled.
      expect(find.byKey(SessionHost.nextKey), findsOneWidget);
      expect(finished, isEmpty);

      await tester.tap(find.byKey(SessionHost.nextKey));
      await tester.pump();

      expect(finished, hasLength(1));
      final outcome = finished.single.outcomes.single;
      expect(outcome.answer, isA<RawAnswer>());
      final payload = (outcome.answer as RawAnswer).payload;
      expect(payload['survivedMs'], 3000);
      expect(payload['violations'], isA<int>());
      expect(payload['reroutes'], isA<int>());
      expect(outcome.result.correct, (payload['violations'] as int) == 0);

      await tester.pump();
      expect(repo.attempts, hasLength(1));
    },
  );
}
