import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_math_word_problems/domain/word_problems.dart';

/// Rounds to one decimal, independently of `roundToOneDecimal` (same
/// formula, but redefined here so a bug in the production helper cannot
/// also hide inside the check meant to catch it).
num _round1(num v) => (v * 10).round() / 10;

void main() {
  const numericParams = GeneratorParams.p1MathWordProblems(
    answerMode: P1AnswerMode.numeric,
  );
  const mcqParams = GeneratorParams.p1MathWordProblems();

  MathWordProblem build({
    required int seed,
    GeneratorParams params = numericParams,
    int difficulty = 3,
  }) => MathWordProblemsGenerator.build(
    params: params as P1MathWordProblemsParams,
    seed: seed,
    difficulty: difficulty,
  );

  test('is deterministic: same params/seed/difficulty, same problem', () {
    final a = build(seed: 42, difficulty: 4);
    final b = build(seed: 42, difficulty: 4);
    expect(a.template, b.template);
    expect(a.variant, b.variant);
    expect(a.operands, b.operands);
    expect(a.expected, b.expected);
    expect(a.stemFr, b.stemFr);
  });

  test('every answer is an integer or a one-decimal value', () {
    for (var seed = 0; seed < 500; seed++) {
      for (
        var difficulty = minDifficulty;
        difficulty <= maxDifficulty;
        difficulty++
      ) {
        final problem = build(seed: seed, difficulty: difficulty);
        expect(problem.expected, _round1(problem.expected), reason: '$problem');
      }
    }
  });

  group('stepsFor', () {
    test('difficulty 1 is always 1 step, maxDifficulty is always maxSteps', () {
      expect(MathWordProblemsGenerator.stepsFor(minDifficulty, 3), 1);
      expect(MathWordProblemsGenerator.stepsFor(maxDifficulty, 3), 3);
    });

    test('never exceeds maxSteps and never drops below 1', () {
      for (final maxSteps in [1, 2, 3, 4]) {
        for (var d = minDifficulty; d <= maxDifficulty; d++) {
          final steps = MathWordProblemsGenerator.stepsFor(d, maxSteps);
          expect(steps, inInclusiveRange(1, maxSteps));
        }
      }
    });

    test('is monotonic in difficulty', () {
      var previous = MathWordProblemsGenerator.stepsFor(minDifficulty, 3);
      for (var d = minDifficulty + 1; d <= maxDifficulty; d++) {
        final steps = MathWordProblemsGenerator.stepsFor(d, 3);
        expect(steps, greaterThanOrEqualTo(previous));
        previous = steps;
      }
    });
  });

  group('speedTimeDistance', () {
    test('every variant solves independently, over many seeds', () {
      var checked = 0;
      for (var seed = 0; seed < 800; seed++) {
        for (
          var difficulty = minDifficulty;
          difficulty <= maxDifficulty;
          difficulty++
        ) {
          final problem = build(seed: seed, difficulty: difficulty);
          if (problem.template != WordProblemTemplate.speedTimeDistance) {
            continue;
          }
          checked++;
          final ops = problem.operands;
          final expected = switch (problem.variant) {
            'distance' => _round1(ops[0] * ops[1]),
            'speed' || 'time' => _round1(ops[0] / ops[1]),
            'multileg' => _round1(
              [
                for (var i = 0; i < ops.length; i += 2) ops[i] * ops[i + 1],
              ].fold<num>(0, (a, b) => a + b),
            ),
            _ => throw StateError('unknown variant ${problem.variant}'),
          };
          expect(problem.expected, expected, reason: '$problem');
        }
      }
      expect(checked, greaterThan(0));
    });

    test('multileg operand count matches steps', () {
      for (var seed = 0; seed < 300; seed++) {
        final problem = build(seed: seed, difficulty: maxDifficulty);
        if (problem.template != WordProblemTemplate.speedTimeDistance) {
          continue;
        }
        if (problem.variant != 'multileg') continue;
        expect(problem.operands.length, problem.steps * 2);
      }
    });
  });

  group('fuelEndurance', () {
    test('every variant solves independently, over many seeds', () {
      var checked = 0;
      for (var seed = 0; seed < 800; seed++) {
        for (
          var difficulty = minDifficulty;
          difficulty <= maxDifficulty;
          difficulty++
        ) {
          final problem = build(seed: seed, difficulty: difficulty);
          if (problem.template != WordProblemTemplate.fuelEndurance) continue;
          checked++;
          final ops = problem.operands;
          final expected = switch (problem.variant) {
            'consumption' => _round1(
              ops[0] * ops.skip(1).fold<num>(0, (a, b) => a + b),
            ),
            'endurance' => _round1(ops[0] / ops[1]),
            _ => throw StateError('unknown variant ${problem.variant}'),
          };
          expect(problem.expected, expected, reason: '$problem');
        }
      }
      expect(checked, greaterThan(0));
    });
  });

  group('proportionality', () {
    test('the chained ratio solves independently, over many seeds', () {
      var checked = 0;
      for (var seed = 0; seed < 800; seed++) {
        for (
          var difficulty = minDifficulty;
          difficulty <= maxDifficulty;
          difficulty++
        ) {
          final problem = build(seed: seed, difficulty: difficulty);
          if (problem.template != WordProblemTemplate.proportionality) {
            continue;
          }
          checked++;
          final ops = problem.operands;
          num value = ops[0] * ops[1];
          for (var i = 2; i < ops.length; i += 2) {
            value = value * ops[i] / ops[i + 1];
          }
          expect(problem.expected, _round1(value), reason: '$problem');
        }
      }
      expect(checked, greaterThan(0));
    });
  });

  group('percentage', () {
    test('every variant solves independently, over many seeds', () {
      var checked = 0;
      for (var seed = 0; seed < 800; seed++) {
        for (
          var difficulty = minDifficulty;
          difficulty <= maxDifficulty;
          difficulty++
        ) {
          final problem = build(seed: seed, difficulty: difficulty);
          if (problem.template != WordProblemTemplate.percentage) continue;
          checked++;
          final ops = problem.operands;
          final expected = switch (problem.variant) {
            'share' => _round1(ops[0] * ops[1] / 100 / ops[2]),
            'chain' => _round1(() {
              num value = ops[0];
              for (var i = 1; i < ops.length; i += 2) {
                final pct = ops[i];
                final sign = ops[i + 1];
                value = value * (100 + sign * pct) / 100;
              }
              return value;
            }()),
            _ => throw StateError('unknown variant ${problem.variant}'),
          };
          expect(problem.expected, expected, reason: '$problem');
        }
      }
      expect(checked, greaterThan(0));
    });

    test('a share only appears at 1 step', () {
      for (var seed = 0; seed < 500; seed++) {
        final problem = build(seed: seed, difficulty: minDifficulty);
        if (problem.template != WordProblemTemplate.percentage) continue;
        if (problem.variant == 'share') expect(problem.steps, 1);
      }
    });
  });

  group('unitConversion', () {
    test('every variant solves independently, over many seeds', () {
      var checked = 0;
      for (var seed = 0; seed < 800; seed++) {
        for (
          var difficulty = minDifficulty;
          difficulty <= maxDifficulty;
          difficulty++
        ) {
          final problem = build(seed: seed, difficulty: difficulty);
          if (problem.template != WordProblemTemplate.unitConversion) {
            continue;
          }
          checked++;
          final ops = problem.operands;
          final expected = switch (problem.variant) {
            'single' => _round1(ops[0] * ops[1]),
            'combine' => _round1(ops[0] * ops[1] + ops[3] * ops[2]),
            'margin' => _round1(
              (ops[0] * ops[1] + ops[3] * ops[2]) * (100 + ops[4]) / 100,
            ),
            _ => throw StateError('unknown variant ${problem.variant}'),
          };
          expect(problem.expected, expected, reason: '$problem');
        }
      }
      expect(checked, greaterThan(0));
    });
  });

  group('average', () {
    test('the mean solves independently, over many seeds', () {
      var checked = 0;
      for (var seed = 0; seed < 500; seed++) {
        for (
          var difficulty = minDifficulty;
          difficulty <= maxDifficulty;
          difficulty++
        ) {
          final problem = build(seed: seed, difficulty: difficulty);
          if (problem.template != WordProblemTemplate.average) continue;
          checked++;
          final ops = problem.operands;
          final expected = _round1(
            ops.fold<num>(0, (a, b) => a + b) / ops.length,
          );
          expect(problem.expected, expected, reason: '$problem');
          expect(ops.length, inInclusiveRange(3, 5));
        }
      }
      expect(checked, greaterThan(0));
    });
  });

  group('timeZone', () {
    test('the offset/duration chain solves independently, over many seeds', () {
      var checked = 0;
      for (var seed = 0; seed < 800; seed++) {
        for (
          var difficulty = minDifficulty;
          difficulty <= maxDifficulty;
          difficulty++
        ) {
          final problem = build(seed: seed, difficulty: difficulty);
          if (problem.template != WordProblemTemplate.timeZone) continue;
          checked++;
          final ops = problem.operands;
          var minutes = ops[0].toInt();
          var offset = ops[1].toInt();
          for (var i = 2; i < ops.length; i += 2) {
            final duration = ops[i].toInt();
            final nextOffset = ops[i + 1].toInt();
            minutes =
                ((minutes + duration - offset * 60 + nextOffset * 60) % 1440 +
                    1440) %
                1440;
            offset = nextOffset;
          }
          expect(problem.expected, _round1(minutes / 60.0), reason: '$problem');
          expect(problem.expected, inInclusiveRange(0, 24));
        }
      }
      expect(checked, greaterThan(0));
    });
  });

  group('mcq mode', () {
    test('produces 4 distinct options, one of them the expected value', () {
      for (var seed = 0; seed < 300; seed++) {
        final problem = build(params: mcqParams, seed: seed);
        expect(problem.mcqOptions.toSet().length, 4);
        expect(
          problem.mcqOptions[problem.correctOptionIndex!],
          problem.expected,
        );
      }
    });

    test('numeric mode never populates mcq fields', () {
      for (var seed = 0; seed < 50; seed++) {
        final problem = build(seed: seed);
        expect(problem.mcqOptions, isEmpty);
        expect(problem.correctOptionIndex, isNull);
      }
    });
  });

  test('every template is reachable within a small seed range', () {
    final seen = <WordProblemTemplate>{};
    for (var seed = 0; seed < 200; seed++) {
      seen.add(build(seed: seed).template);
    }
    expect(seen, WordProblemTemplate.values.toSet());
  });
}
