import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/attention_parity/domain/attention_parity_engine.dart';
import 'package:psy_trainer/features/engines/attention_parity/presentation/attention_parity_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  const engine = AttentionParityEngine();
  const params = ParitySequenceParams();
  final start = DateTime.utc(2026, 9, 5, 9);

  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  ActivitySessionConfig config() => const ActivitySessionConfig(
    familyId: 'attention_parity',
    mode: SessionMode.practice,
    source: ItemSource.generator(
      generatorId: GeneratorId.paritySequence,
      seed: 123,
      params: params,
      count: 1,
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
      engineRegistryProvider.overrideWithValue(EngineRegistry(const [engine])),
      rendererRegistryProvider.overrideWithValue(
        RendererRegistry(const [AttentionParityRenderer()]),
      ),
      engineClockProvider.overrideWithValue(clock),
    ],
  );

  Future<void> tapNumber(WidgetTester tester, int value) async {
    await tester.tap(find.byKey(AttentionParityRenderer.numberKey(value)));
    await tester.pump();
  }

  /// Replicates `GeneratorSource._generate` (`item_source.dart`): the
  /// session draws the per-item seed and difficulty from `Random(sourceSeed)`
  /// rather than using the source seed directly.
  List<int> expectedPath() {
    final itemSeed = Random(123).nextInt(1 << 31);
    final generated =
        engine.generate(params: params, seed: itemSeed, difficulty: 3)
            as GeneratedItem;
    return AttentionParityEngine.layoutOf(generated).path;
  }

  testWidgets('tapping the whole path in order answers once, no restarts', (
    tester,
  ) async {
    await pumpHost(tester);
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    expect(
      find.text(AppStrings.attentionParityRestartCount(0)),
      findsOneWidget,
    );

    for (final value in expectedPath()) {
      await tapNumber(tester, value);
    }
    await tester.tap(find.byKey(SessionHost.nextKey));
    await tester.pump();

    expect(find.text(AppStrings.sessionFinishedTitle), findsOneWidget);
    expect(finished, hasLength(1));
    expect(finished.single.section.correct, 1);
    expect(finished.single.section.metricTotals['restarts'], 0);
    expect(
      finished.single.section.metricTotals['totalTaps'],
      expectedPath().length,
    );
  });

  testWidgets('a wrong tap restarts the series and bumps the counter', (
    tester,
  ) async {
    await pumpHost(tester);
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final path = expectedPath();

    // Tapping the second element first is always wrong: the path must
    // start with path[0].
    await tapNumber(tester, path[1]);
    expect(
      find.text(AppStrings.attentionParityRestartCount(1)),
      findsOneWidget,
    );

    for (final value in path) {
      await tapNumber(tester, value);
    }
    await tester.tap(find.byKey(SessionHost.nextKey));
    await tester.pump();

    expect(find.text(AppStrings.sessionFinishedTitle), findsOneWidget);
    expect(finished.single.section.correct, 1);
    expect(finished.single.section.metricTotals['restarts'], 1);
    expect(finished.single.section.metricTotals['totalTaps'], path.length + 1);
  });
}
