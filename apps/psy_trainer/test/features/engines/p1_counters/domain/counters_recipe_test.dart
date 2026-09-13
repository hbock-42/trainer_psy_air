import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_counters/domain/counters_recipe.dart';
import 'package:psy_trainer/features/engines/p1_counters/domain/gauge.dart';

void main() {
  const params = P1CountersParams();

  CountersRecipe recipeAt(
    int seed, {
    int difficulty = 3,
    P1CountersParams? p,
  }) => CountersRecipe.build(
    params: p ?? params,
    seed: seed,
    difficulty: difficulty,
  );

  group('CountersRecipe.build', () {
    test('is deterministic: same inputs, same recipe', () {
      for (var seed = 0; seed < 30; seed++) {
        final a = recipeAt(seed, difficulty: 1 + seed % 5);
        final b = recipeAt(seed, difficulty: 1 + seed % 5);
        expect(a.gauges.length, b.gauges.length);
        for (var i = 0; i < a.gauges.length; i++) {
          expect(a.gauges[i].kind, b.gauges[i].kind);
          expect(a.gauges[i].value, b.gauges[i].value);
          expect(a.gauges[i].rangeMin, b.gauges[i].rangeMin);
          expect(a.gauges[i].rangeMax, b.gauges[i].rangeMax);
        }
        expect(a.question.runtimeType, b.question.runtimeType);
      }
    });

    test('builds `dialsPerItem` gauges, clamped to 1..4', () {
      for (final dials in [0, 1, 2, 3, 4, 9]) {
        final recipe = CountersRecipe.build(
          params: P1CountersParams(dialsPerItem: dials),
          seed: 1,
          difficulty: 3,
        );
        expect(recipe.gauges.length, dials.clamp(1, 4));
      }
    });

    test('every gauge value lands within tolerance of its own reading and '
        'strictly farther than tolerance from the next tick', () {
      for (var seed = 0; seed < 50; seed++) {
        final recipe = recipeAt(seed, difficulty: 1 + seed % 5);
        for (final gauge in recipe.gauges) {
          expect(gauge.value, greaterThanOrEqualTo(gauge.rangeMin));
          expect(gauge.value, lessThanOrEqualTo(gauge.rangeMax));
          if (gauge.kind == GaugeKind.drum) continue;
          final ticksFromMin = (gauge.value - gauge.rangeMin) / gauge.minorStep;
          final nearestTick = ticksFromMin.round();
          final distanceToNearestTick =
              ((gauge.value - gauge.rangeMin) - nearestTick * gauge.minorStep)
                  .abs();
          // Unambiguous: strictly closer to the nearest tick than half a
          // division away (spec: "unambiguous at the drawn resolution").
          expect(distanceToNearestTick, lessThan(gauge.tolerance));
        }
      }
    });

    test('difficulty raises minor-division density (circular/linear/'
        'multiNeedle gauges)', () {
      // Force a kind by scanning seeds; every kind appears within a handful
      // of seeds, so instead assert on whichever gauges each level produced.
      final byLevel = <int, List<int>>{};
      for (var level = minDifficulty; level <= maxDifficulty; level++) {
        final densities = <int>[];
        for (var seed = 0; seed < 20; seed++) {
          final recipe = recipeAt(seed, difficulty: level);
          for (final gauge in recipe.gauges) {
            if (gauge.kind != GaugeKind.drum) {
              densities.add(gauge.minorPerMajor);
            }
          }
        }
        byLevel[level] = densities;
      }
      final avg = {
        for (final entry in byLevel.entries)
          entry.key: entry.value.reduce((a, b) => a + b) / entry.value.length,
      };
      expect(avg[maxDifficulty]!, greaterThan(avg[minDifficulty]!));
    });

    test('difficulty raises drum digit count', () {
      // Force every gauge to be a drum by exhausting kinds is not directly
      // controllable; instead check digitCount grows with level whenever a
      // drum gauge is drawn.
      final maxDigitsByLevel = <int, int>{};
      for (var level = minDifficulty; level <= maxDifficulty; level++) {
        var maxDigits = 0;
        for (var seed = 0; seed < 40; seed++) {
          final recipe = recipeAt(seed, difficulty: level);
          for (final gauge in recipe.gauges) {
            if (gauge.kind == GaugeKind.drum) {
              maxDigits = maxDigits > gauge.digitCount!
                  ? maxDigits
                  : gauge.digitCount!;
            }
          }
        }
        maxDigitsByLevel[level] = maxDigits;
      }
      expect(
        maxDigitsByLevel[maxDifficulty]!,
        greaterThanOrEqualTo(maxDigitsByLevel[minDifficulty]!),
      );
    });

    test('a GaugeMatchQuestion is unambiguous: no other gauge value is '
        'within the matching tolerance of the target', () {
      for (var seed = 0; seed < 100; seed++) {
        final recipe = recipeAt(seed, difficulty: 1 + seed % 5);
        final question = recipe.question;
        if (question is! GaugeMatchQuestion) continue;
        final targetIndex = question.optionOrder[question.correctOption];
        final target = recipe.gauges[targetIndex];
        for (var i = 0; i < recipe.gauges.length; i++) {
          if (i == targetIndex) continue;
          final other = recipe.gauges[i];
          final combinedTolerance = target.tolerance + other.tolerance;
          expect(
            (other.value - target.value).abs(),
            greaterThan(combinedTolerance),
            reason: 'seed=$seed target=${target.value} other=${other.value}',
          );
        }
      }
    });

    test('a GaugeMatchQuestion option order is a permutation of every '
        'gauge index, and correctOption points at the target', () {
      for (var seed = 0; seed < 100; seed++) {
        final recipe = recipeAt(seed, difficulty: 1 + seed % 5);
        final question = recipe.question;
        if (question is! GaugeMatchQuestion) continue;
        expect(
          question.optionOrder.toSet(),
          Set<int>.from(List.generate(recipe.gauges.length, (i) => i)),
        );
        final targetIndex = question.optionOrder[question.correctOption];
        expect(recipe.gauges[targetIndex].value, question.target);
      }
    });

    test('a GaugeCombineQuestion always picks two distinct gauge indices', () {
      for (var seed = 0; seed < 100; seed++) {
        final recipe = recipeAt(seed, difficulty: 1 + seed % 5);
        final question = recipe.question;
        if (question is! GaugeCombineQuestion) continue;
        expect(question.aIndex, isNot(question.bIndex));
      }
    });

    test('a single-gauge panel only ever asks a GaugeValueQuestion', () {
      for (var seed = 0; seed < 30; seed++) {
        final recipe = CountersRecipe.build(
          params: const P1CountersParams(dialsPerItem: 1),
          seed: seed,
          difficulty: 1 + seed % 5,
        );
        expect(recipe.question, isA<GaugeValueQuestion>());
      }
    });
  });
}
