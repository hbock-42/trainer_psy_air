import 'package:flutter/widgets.dart' show Locale, ValueKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_counters/domain/p1_counters_engine.dart';
import 'package:psy_trainer/features/engines/p1_counters/presentation/p1_counters_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

/// Widget test of `p1_counters` through the real `SessionHost`, the real
/// engine and the real renderer (see
/// `test/features/train/presentation/engine/session_host_test.dart`, the
/// template for this file). Seed 0 (difficulty 3, default params) yields a
/// `GaugeValueQuestion` (a `NumericItem`); seed 1 yields a
/// `GaugeMatchQuestion` (an `McqItem`) -- see the domain tests for why
/// every seed is deterministic.
final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  const engine = CountersEngine();
  const params = P1CountersParams();

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  Item itemAt(int seed) =>
      engine.generate(params: params, seed: seed, difficulty: 3);

  Future<void> pumpHost(WidgetTester tester, ActivitySessionRequest request) =>
      pumpApp(
        tester,
        SessionHost(request: request, onFinished: finished.add),
        overrides: [
          progressRepositoryProvider.overrideWithValue(repo),
          engineRegistryProvider.overrideWithValue(EngineRegistry([engine])),
          rendererRegistryProvider.overrideWithValue(
            RendererRegistry(const [CountersRenderer()]),
          ),
          engineClockProvider.overrideWithValue(clock),
        ],
      );

  group('a NumericItem (value question)', () {
    final item = itemAt(0) as NumericItem;

    ActivitySessionConfig practiceConfig() => ActivitySessionConfig(
      familyId: 'p1_counters',
      mode: SessionMode.practice,
      source: ItemSource.bank([item]),
    );

    testWidgets('the stem, the panel and the keypad are shown', (tester) async {
      await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      expect(find.text(item.stem.fr), findsOneWidget);
      expect(find.byKey(const ValueKey('numeric_key_5')), findsOneWidget);
    });

    testWidgets('the exact expected value scores correct and shows it', (
      tester,
    ) async {
      await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      for (final digit in item.expected.round().toString().split('')) {
        await tester.tap(find.byKey(ValueKey('numeric_key_$digit')));
        await tester.pump();
      }
      await tester.tap(find.byKey(const ValueKey('numeric_key_validate')));
      await tester.pump();

      expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
      // Practice feedback shows the exact value (US-113 spec).
      expect(find.text(item.explanation.fr), findsOneWidget);
    });
  });

  group('an McqItem (match question)', () {
    final item = itemAt(1) as McqItem;

    ActivitySessionConfig practiceConfig() => ActivitySessionConfig(
      familyId: 'p1_counters',
      mode: SessionMode.practice,
      source: ItemSource.bank([item]),
    );

    testWidgets('the stem, the panel and every option are shown', (
      tester,
    ) async {
      await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      expect(find.text(item.stem.fr), findsOneWidget);
      for (final option in item.options) {
        expect(find.text(option.text!.fr), findsOneWidget);
      }
    });

    testWidgets('picking the correct option scores it correct', (tester) async {
      await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      await tester.tap(find.text(item.options[item.correctIndex].text!.fr));
      await tester.pump();

      expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
    });

    testWidgets('picking a wrong option scores it wrong', (tester) async {
      await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      final wrongIndex = (item.correctIndex + 1) % item.options.length;
      await tester.tap(find.text(item.options[wrongIndex].text!.fr));
      await tester.pump();

      expect(find.text(l10nFr.sessionFeedbackWrong), findsOneWidget);
    });
  });

  testWidgets('the briefing shows the worked example panel', (tester) async {
    final item = itemAt(0) as NumericItem;
    await pumpHost(
      tester,
      ActivitySessionRequest.fresh(
        ActivitySessionConfig(
          familyId: 'p1_counters',
          mode: SessionMode.practice,
          source: ItemSource.bank([item]),
        ),
      ),
    );
    expect(find.text(l10nFr.sessionExamplePlaceholder), findsNothing);
    expect(find.text(l10nFr.p1CountersExampleCaption), findsOneWidget);
  });
}
