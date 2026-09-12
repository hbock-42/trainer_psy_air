import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/attention_rules/domain/attention_rules_engine.dart';
import 'package:psy_trainer/features/engines/attention_rules/domain/stimulus_rule_set.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = AttentionRulesEngine();
  const params = StimulusResponseParams();

  group('generate', () {
    test('is deterministic: same seed/params/difficulty, same item', () {
      final a = engine.generate(params: params, seed: 7, difficulty: 3);
      final b = engine.generate(params: params, seed: 7, difficulty: 3);
      expect(a, equals(b));
    });

    test('returns a GeneratedItem carrying the recipe unchanged', () {
      final item =
          engine.generate(params: params, seed: 11, difficulty: 3)
              as GeneratedItem;
      expect(
        item.id,
        ActivityEngine.generatedItemId(GeneratorId.stimulusResponse, 11),
      );
      expect(item.generatorId, GeneratorId.stimulusResponse);
      expect(item.seed, 11);
      expect(item.params, params);
      expect(item.familyId, 'attention_rules');
    });

    test('different seeds materialise different stimuli', () {
      final trials = {
        for (var seed = 0; seed < 20; seed++)
          seed: StimulusTrial.forItem(
            engine.generate(params: params, seed: seed, difficulty: 3)
                as GeneratedItem,
          ).correctKey,
      };
      // Not every seed yields the same key (otherwise the drill would be
      // trivial): both keys appear across a handful of stimuli.
      expect(trials.values.toSet(), containsAll(<String>['n', 'x']));
    });
  });

  group('rule set determinism (spec §2.4-C)', () {
    test('the rule set is identical for every item of a run', () {
      final ruleSet0 = StimulusRuleSet.fromParams(params);
      // Different items of the same run share the one `params` instance
      // (see item_source.dart / StimulusRuleSet's doc); the resulting rule
      // must therefore be identical whatever the item's own seed is.
      for (var seed = 0; seed < 50; seed++) {
        final ruleSet = StimulusRuleSet.fromParams(params);
        expect(ruleSet.shapeA, ruleSet0.shapeA);
        expect(ruleSet.shapeB, ruleSet0.shapeB);
        expect(ruleSet.colourA, ruleSet0.colourA);
        expect(ruleSet.colourB, ruleSet0.colourB);
        expect(ruleSet.keyA, ruleSet0.keyA);
        expect(ruleSet.keyB, ruleSet0.keyB);
      }
    });

    test('maps the family default params to the documented example', () {
      final ruleSet = StimulusRuleSet.fromParams(params);
      expect(ruleSet.shapeA, StimulusShape.square);
      expect(ruleSet.shapeB, StimulusShape.triangle);
      expect(ruleSet.colourA, StimulusColour.blue);
      expect(ruleSet.colourB, StimulusColour.orange);
      expect(ruleSet.keyA, 'n');
      expect(ruleSet.keyB, 'x');
    });

    test('reacts to different params (session-to-session variation)', () {
      const otherParams = StimulusResponseParams(
        shapes: [StimulusShape.circle, StimulusShape.diamond],
        colours: [StimulusColour.green, StimulusColour.pink],
        keys: ['a', 'b'],
      );
      final ruleSet = StimulusRuleSet.fromParams(otherParams);
      expect(ruleSet.shapeA, StimulusShape.circle);
      expect(ruleSet.shapeB, StimulusShape.diamond);
      expect(ruleSet.colourA, StimulusColour.green);
      expect(ruleSet.colourB, StimulusColour.pink);
      expect(ruleSet.keyA, 'a');
      expect(ruleSet.keyB, 'b');
    });

    test('ruleDepth above 2 adds distractor shapes/colours, not branches', () {
      const wideParams = StimulusResponseParams(
        shapes: [
          StimulusShape.square,
          StimulusShape.triangle,
          StimulusShape.circle,
          StimulusShape.star,
        ],
        colours: [
          StimulusColour.blue,
          StimulusColour.orange,
          StimulusColour.green,
          StimulusColour.pink,
        ],
        ruleDepth: 4,
      );
      final ruleSet = StimulusRuleSet.fromParams(wideParams);
      expect(ruleSet.distractorShapes, [
        StimulusShape.circle,
        StimulusShape.star,
      ]);
      expect(ruleSet.distractorColours, [
        StimulusColour.green,
        StimulusColour.pink,
      ]);
      // The rule mapping itself is unaffected.
      expect(ruleSet.keyForShape(StimulusShape.square), 'n');
      expect(ruleSet.keyForShape(StimulusShape.triangle), 'x');
    });
  });

  group('balanced stimulus sequence across rule branches', () {
    test('a large run visits all 4 branches in roughly equal shares', () {
      final ruleSet = StimulusRuleSet.fromParams(params);
      var filledA = 0, filledB = 0, emptyA = 0, emptyB = 0;
      const n = 4000;
      for (var seed = 0; seed < n; seed++) {
        final trial = ruleSet.trial(seed);
        if (trial.fill == StimulusFill.filled) {
          trial.shape == ruleSet.shapeA ? filledA++ : filledB++;
        } else {
          trial.colour == ruleSet.colourA ? emptyA++ : emptyB++;
        }
      }
      for (final count in [filledA, filledB, emptyA, emptyB]) {
        expect(count / n, closeTo(0.25, 0.05));
      }
    });

    test('a realistic 36-item run uses both keys, not just one', () {
      final ruleSet = StimulusRuleSet.fromParams(params);
      final keys = [
        for (var seed = 100; seed < 136; seed++) ruleSet.trial(seed).correctKey,
      ];
      expect(keys.where((k) => k == 'n'), isNotEmpty);
      expect(keys.where((k) => k == 'x'), isNotEmpty);
    });
  });

  group('score', () {
    // A direct `generate()` call with no `runSeed` falls back to
    // `runSeed = seed` (see `ActivityEngine.generate`), so the item's own
    // rule set is `StimulusRuleSet.fromRunSeed(seed, params)` -- not the
    // canonical `fromParams` (US-037): find the seed through the same
    // path `engine.score`/`StimulusTrial.forItem` actually uses.
    GeneratedItem itemFor(int seed) =>
        engine.generate(params: params, seed: seed, difficulty: 3)
            as GeneratedItem;

    String correctKeyFor(int seed) =>
        StimulusTrial.forItem(itemFor(seed)).correctKey;

    test('the correct key press scores right', () {
      final seed = List.generate(
        200,
        (i) => i,
      ).firstWhere((s) => correctKeyFor(s) == 'n');
      final item = itemFor(seed);
      final result = engine.score(item, const Answer.key('n'));
      expect(result.correct, isTrue);
    });

    test('the wrong key press scores wrong', () {
      final seed = List.generate(
        200,
        (i) => i,
      ).firstWhere((s) => correctKeyFor(s) == 'n');
      final item = itemFor(seed);
      final result = engine.score(item, const Answer.key('x'));
      expect(result.correct, isFalse);
    });

    test('key press is case-insensitive', () {
      final seed = List.generate(
        200,
        (i) => i,
      ).firstWhere((s) => correctKeyFor(s) == 'n');
      final item = itemFor(seed);
      final result = engine.score(item, const Answer.key('N'));
      expect(result.correct, isTrue);
    });

    test('a skip is scored as a skip', () {
      final item = itemFor(0);
      final result = engine.score(item, const Answer.skip());
      expect(result.skipped, isTrue);
      expect(result.correct, isFalse);
    });
  });
}
