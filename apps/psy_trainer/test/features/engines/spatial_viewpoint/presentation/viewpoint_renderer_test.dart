import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/spatial_viewpoint/domain/viewpoint_engine.dart';
import 'package:psy_trainer/features/engines/spatial_viewpoint/domain/viewpoint_explanation.dart';
import 'package:psy_trainer/features/engines/spatial_viewpoint/domain/viewpoint_scene.dart';
import 'package:psy_trainer/features/engines/spatial_viewpoint/presentation/viewpoint_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

/// `ItemSource.generator` draws one seed per item from `Random(sessionSeed)`
/// (see `item_source.dart`); replicated here so the test knows the exact
/// scene -- and so the exact right answer -- a session with
/// `sessionSeed`/`difficulty` will show as its first item.
int _firstItemSeed(int sessionSeed) => Random(sessionSeed).nextInt(1 << 31);

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  const sessionSeed = 1;
  const difficulty = 2;
  const params = ViewpointParams();
  final itemSeed = _firstItemSeed(sessionSeed);
  final scene = buildViewpointScene(
    seed: itemSeed,
    params: params,
    difficulty: difficulty,
  );

  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  ActivitySessionConfig config() => const ActivitySessionConfig(
    familyId: 'spatial_viewpoint',
    mode: SessionMode.practice,
    source: ItemSource.generator(
      generatorId: GeneratorId.viewpoint,
      seed: sessionSeed,
      params: params,
      count: 1,
      difficulty: DifficultyRange(min: difficulty, max: difficulty),
    ),
  );

  Future<void> pumpHost(WidgetTester tester) => pumpApp(
    tester,
    SessionHost(
      request: ActivitySessionRequest.fresh(config()),
      onFinished: finished.add,
    ),
    overrides: [
      progressRepositoryProvider.overrideWithValue(repo),
      engineRegistryProvider.overrideWithValue(
        EngineRegistry(const [ViewpointEngine()]),
      ),
      rendererRegistryProvider.overrideWithValue(
        RendererRegistry(const [ViewpointRenderer()]),
      ),
      engineClockProvider.overrideWithValue(clock),
    ],
  );

  testWidgets('tapping the correct position answers correctly', (tester) async {
    await pumpHost(tester);
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tester.tap(
      find.byKey(ValueKey('viewpoint_position_${scene.correctAzimuth}')),
    );
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
    expect(find.text(explanationFor(scene)), findsOneWidget);

    await tester.tap(find.byKey(SessionHost.nextKey));
    await tester.pump();
    expect(find.text(l10nFr.sessionFinishedTitle), findsOneWidget);
    expect(finished, hasLength(1));
    expect(finished.single.section.correct, 1);
  });

  testWidgets('tapping a wrong position scores wrong', (tester) async {
    await pumpHost(tester);
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final wrongAzimuth = (scene.correctAzimuth % 8) + 1;
    await tester.tap(find.byKey(ValueKey('viewpoint_position_$wrongAzimuth')));
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackWrong), findsOneWidget);
  });

  testWidgets('a keyboard digit 1-8 answers the item directly', (tester) async {
    await pumpHost(tester);
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tester.sendKeyEvent(_digitKey(scene.correctAzimuth));
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });
}

LogicalKeyboardKey _digitKey(int azimuth) => const [
  LogicalKeyboardKey.digit1,
  LogicalKeyboardKey.digit2,
  LogicalKeyboardKey.digit3,
  LogicalKeyboardKey.digit4,
  LogicalKeyboardKey.digit5,
  LogicalKeyboardKey.digit6,
  LogicalKeyboardKey.digit7,
  LogicalKeyboardKey.digit8,
][azimuth - 1];
