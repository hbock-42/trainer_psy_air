import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/attention_rules/domain/attention_rules_engine.dart';
import 'package:psy_trainer/features/engines/attention_rules/domain/stimulus_rule_set.dart';
import 'package:psy_trainer/features/engines/attention_rules/presentation/attention_rules_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  const params = StimulusResponseParams();
  // US-037: the run's actual rule set is derived from the run seed, not
  // straight from `params` (see `StimulusRuleSet.fromRunSeed`); every
  // config below plays `seed: 1`, so this is the rule the briefing and
  // the run itself must agree on.
  final ruleSet = StimulusRuleSet.fromRunSeed(1, params);

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  ActivitySessionConfig config({int seed = 1, int count = 3}) =>
      ActivitySessionConfig(
        familyId: AttentionRulesEngine.engineFamilyId,
        mode: SessionMode.exam,
        liveFeedback: true,
        source: ItemSource.generator(
          generatorId: GeneratorId.stimulusResponse,
          seed: seed,
          params: params,
          count: count,
        ),
        timing: const TimingPolicy(
          cadence: Cadence(stimulusMs: 500, answerWindowMs: 3000),
        ),
      );

  Future<void> pumpHost(WidgetTester tester, ActivitySessionRequest request) =>
      pumpApp(
        tester,
        SessionHost(request: request, onFinished: finished.add),
        overrides: [
          progressRepositoryProvider.overrideWithValue(repo),
          engineRegistryProvider.overrideWithValue(
            EngineRegistry(const [AttentionRulesEngine()]),
          ),
          rendererRegistryProvider.overrideWithValue(
            RendererRegistry(const [AttentionRulesRenderer()]),
          ),
          engineClockProvider.overrideWithValue(clock),
        ],
      );

  testWidgets('the briefing shows this run\'s actual rule, not repeated '
      'again during the run', (tester) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(config()));
    expect(
      find.text(
        l10nFr.attentionRulesExampleShapes(
          ruleSet.shapeA,
          ruleSet.keyA,
          ruleSet.shapeB,
          ruleSet.keyB,
        ),
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        l10nFr.attentionRulesExampleColours(
          ruleSet.colourA,
          ruleSet.keyA,
          ruleSet.colourB,
          ruleSet.keyB,
        ),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    expect(
      find.text(
        l10nFr.attentionRulesExampleShapes(
          ruleSet.shapeA,
          ruleSet.keyA,
          ruleSet.shapeB,
          ruleSet.keyB,
        ),
      ),
      findsNothing,
    );
  });

  testWidgets(
    'the cadence flashes the shape then blanks it, keeping live feedback',
    (tester) async {
      await pumpHost(tester, ActivitySessionRequest.fresh(config(count: 1)));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      // Stimulus phase: the shape is painted.
      expect(find.byType(CustomPaint), findsWidgets);

      final trial = ruleSet.trial(
        (const ItemSource.generator(
                  generatorId: GeneratorId.stimulusResponse,
                  seed: 1,
                  params: params,
                  count: 1,
                ).materialise(const AttentionRulesEngine()).single.item
                as GeneratedItem)
            .seed,
      );

      clock.elapse(const Duration(milliseconds: 500));
      await tester.pump();
      // Answer phase: the input is still accepted through the fallback
      // buttons even though the flash is gone.
      expect(
        find.byKey(const Key('attention_rules.touch_key_a')),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(
          Key(
            'attention_rules.touch_key_${trial.correctKey == ruleSet.keyA ? 'a' : 'b'}',
          ),
        ),
      );
      await tester.pump();
      expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
    },
  );

  testWidgets('a physical key press answers the stimulus', (tester) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(config(count: 1)));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    clock.elapse(const Duration(milliseconds: 500));
    await tester.pump();

    final trial = ruleSet.trial(
      (const ItemSource.generator(
                generatorId: GeneratorId.stimulusResponse,
                seed: 1,
                params: params,
                count: 1,
              ).materialise(const AttentionRulesEngine()).single.item
              as GeneratedItem)
          .seed,
    );
    final key = trial.correctKey == 'n'
        ? LogicalKeyboardKey.keyN
        : LogicalKeyboardKey.keyX;

    await tester.sendKeyEvent(key);
    await tester.pump();
    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('a wrong physical key press is scored wrong, live', (
    tester,
  ) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(config(count: 1)));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    clock.elapse(const Duration(milliseconds: 500));
    await tester.pump();

    final trial = ruleSet.trial(
      (const ItemSource.generator(
                generatorId: GeneratorId.stimulusResponse,
                seed: 1,
                params: params,
                count: 1,
              ).materialise(const AttentionRulesEngine()).single.item
              as GeneratedItem)
          .seed,
    );
    final wrongKey = trial.correctKey == 'n'
        ? LogicalKeyboardKey.keyX
        : LogicalKeyboardKey.keyN;

    await tester.sendKeyEvent(wrongKey);
    await tester.pump();
    expect(find.text(l10nFr.sessionFeedbackWrong), findsOneWidget);
  });
}
