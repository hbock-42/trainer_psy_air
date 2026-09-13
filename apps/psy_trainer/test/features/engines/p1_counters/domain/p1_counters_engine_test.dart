import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_counters/domain/counters_recipe.dart';
import 'package:psy_trainer/features/engines/p1_counters/domain/p1_counters_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = CountersEngine();
  const params = P1CountersParams();

  test('familyId and generatorId', () {
    expect(engine.familyId, 'p1_counters');
    expect(engine.generatorId, GeneratorId.p1Counters);
  });

  group('generate', () {
    test('is deterministic: same inputs, same item', () {
      for (var seed = 0; seed < 20; seed++) {
        final a = engine.generate(params: params, seed: seed, difficulty: 3);
        final b = engine.generate(params: params, seed: seed, difficulty: 3);
        expect(a, b);
      }
    });

    test('returns a NumericItem or an McqItem, never a GeneratedItem', () {
      for (var seed = 0; seed < 30; seed++) {
        final item = engine.generate(params: params, seed: seed, difficulty: 3);
        expect(item, anyOf(isA<NumericItem>(), isA<McqItem>()));
      }
    });

    test('threads runSeed and index onto origin (US-037)', () {
      final item = engine.generate(
        params: params,
        seed: 5,
        difficulty: 1,
        index: 3,
        runSeed: 999,
      );
      final origin = item is NumericItem
          ? item.origin
          : (item as McqItem).origin;
      expect(
        origin,
        const ItemOrigin(
          generatorId: GeneratorId.p1Counters,
          seed: 5,
          runSeed: 999,
          index: 3,
        ),
      );
    });

    test('id follows the gen.<generatorId>.<seed> convention', () {
      final item = engine.generate(params: params, seed: 42, difficulty: 3);
      final id = item is NumericItem ? item.id : (item as McqItem).id;
      expect(id, 'gen.p1_counters.42');
    });

    test('a value-question item has a tolerance of half a minor division', () {
      for (var seed = 0; seed < 100; seed++) {
        final recipe = CountersRecipe.build(
          params: params,
          seed: seed,
          difficulty: 1 + seed % 5,
        );
        if (recipe.question is! GaugeValueQuestion) continue;
        final question = recipe.question as GaugeValueQuestion;
        final gauge = recipe.gauges[question.gaugeIndex];
        final item =
            engine.generate(
                  params: params,
                  seed: seed,
                  difficulty: 1 + seed % 5,
                )
                as NumericItem;
        expect(item.expected, gauge.value);
        expect(item.tolerance!.value, gauge.tolerance);
      }
    });
  });

  group('score (default Scorer.scoreItem, no override)', () {
    test('exact answer within tolerance scores correct', () {
      for (var seed = 0; seed < 30; seed++) {
        final item = engine.generate(params: params, seed: seed, difficulty: 3);
        if (item is NumericItem) {
          final result = engine.score(item, Answer.numeric(item.expected));
          expect(result.correct, isTrue, reason: 'seed=$seed');
        } else if (item is McqItem) {
          final result = engine.score(item, Answer.choice(item.correctIndex));
          expect(result.correct, isTrue, reason: 'seed=$seed');
        }
      }
    });

    test('an answer well outside tolerance scores wrong', () {
      NumericItem? item;
      for (var seed = 0; seed < 30 && item == null; seed++) {
        final candidate = engine.generate(
          params: params,
          seed: seed,
          difficulty: 3,
        );
        if (candidate is NumericItem) item = candidate;
      }
      expect(item, isNotNull);
      final result = engine.score(item!, Answer.numeric(item.expected + 1000));
      expect(result.correct, isFalse);
    });

    test('the wrong MCQ option scores wrong', () {
      for (var seed = 0; seed < 30; seed++) {
        final item = engine.generate(params: params, seed: seed, difficulty: 3);
        if (item is! McqItem) continue;
        final wrongIndex = (item.correctIndex + 1) % item.options.length;
        final result = engine.score(item, Answer.choice(wrongIndex));
        expect(result.correct, isFalse, reason: 'seed=$seed');
      }
    });
  });

  group('CountersEngine.recipeOf', () {
    test('recomputes the same panel the item was generated from', () {
      for (var seed = 0; seed < 20; seed++) {
        final difficulty = 1 + seed % 5;
        final item = engine.generate(
          params: params,
          seed: seed,
          difficulty: difficulty,
        );
        final expectedRecipe = CountersRecipe.build(
          params: params,
          seed: seed,
          difficulty: difficulty,
        );
        final recipe = CountersEngine.recipeOf(item);
        expect(recipe.gauges.length, expectedRecipe.gauges.length);
        for (var i = 0; i < recipe.gauges.length; i++) {
          expect(recipe.gauges[i].value, expectedRecipe.gauges[i].value);
        }
      }
    });
  });
}
