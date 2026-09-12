import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_angles/domain/angle_board.dart';

void main() {
  const defaultParams = GeneratorParams.p1Angles();

  AngleBoard build({
    GeneratorParams params = defaultParams,
    int seed = 1,
    int difficulty = 3,
  }) => AngleBoardGenerator.build(
    params: params as P1AnglesParams,
    seed: seed,
    difficulty: difficulty,
  );

  test('is deterministic: same params/seed/difficulty, same board', () {
    final a = build(seed: 42, difficulty: 4);
    final b = build(seed: 42, difficulty: 4);
    expect(
      a.angles.map((x) => (x.label, x.startRad, x.sweepDeg)).toList(),
      b.angles.map((x) => (x.label, x.startRad, x.sweepDeg)).toList(),
    );
    expect(a.candidates, b.candidates);
    expect(a.correctIndices, b.correctIndices);
  });

  test('a different seed usually yields a different board', () {
    final a = build();
    final b = build(seed: 2);
    expect(a.candidates, isNot(b.candidates));
  });

  test('always builds the announced 9 candidates by default', () {
    for (var seed = 0; seed < 100; seed++) {
      final board = build(seed: seed);
      expect(board.candidates, hasLength(9));
    }
  });

  test('draws between 1 and maxCorrect angles, and exactly one correct '
      'candidate per drawn angle', () {
    for (var seed = 0; seed < 300; seed++) {
      for (
        var difficulty = minDifficulty;
        difficulty <= maxDifficulty;
        difficulty++
      ) {
        final board = build(seed: seed, difficulty: difficulty);
        expect(
          board.angles.length,
          inInclusiveRange(1, 4),
          reason: 'seed=$seed difficulty=$difficulty',
        );
        expect(
          board.correctIndices.length,
          board.angles.length,
          reason: 'seed=$seed difficulty=$difficulty',
        );
      }
    }
  });

  test('labels angles A, B, C... in draw order', () {
    for (var seed = 0; seed < 50; seed++) {
      final board = build(seed: seed, difficulty: 4);
      for (var i = 0; i < board.angles.length; i++) {
        expect(board.angles[i].label, String.fromCharCode(65 + i));
      }
    }
  });

  test('only high difficulty (>=4) ever draws a reflex angle (>180°)', () {
    var sawReflexHigh = false;
    for (var seed = 0; seed < 500; seed++) {
      for (var difficulty = 1; difficulty <= 3; difficulty++) {
        final board = build(seed: seed, difficulty: difficulty);
        for (final angle in board.angles) {
          expect(
            angle.isReflex,
            isFalse,
            reason: 'seed=$seed difficulty=$difficulty',
          );
        }
      }
      final board = build(seed: seed, difficulty: 5);
      if (board.angles.any((a) => a.isReflex)) sawReflexHigh = true;
    }
    expect(sawReflexHigh, isTrue);
  });

  test('every drawn angle has exactly one matching candidate, and every '
      'correct candidate matches exactly one drawn angle: no ambiguity', () {
    for (var seed = 0; seed < 500; seed++) {
      for (
        var difficulty = minDifficulty;
        difficulty <= maxDifficulty;
        difficulty++
      ) {
        final board = build(seed: seed, difficulty: difficulty);
        for (final angle in board.angles) {
          final matches = <int>[
            for (var i = 0; i < board.candidates.length; i++)
              if ((board.candidates[i] - angle.sweepDeg).abs() <=
                  angleMatchToleranceDeg)
                i,
          ];
          expect(
            matches,
            hasLength(1),
            reason:
                'seed=$seed difficulty=$difficulty angle=${angle.label} '
                'candidates=${board.candidates}',
          );
          expect(matches.single, isIn(board.correctIndices));
        }
        // No two candidates are ever within tolerance of each other unless
        // they are literally the same value (never happens: candidates are
        // constructed distinct).
        for (var i = 0; i < board.candidates.length; i++) {
          for (var j = i + 1; j < board.candidates.length; j++) {
            expect(
              board.candidates[i],
              isNot(board.candidates[j]),
              reason: 'seed=$seed difficulty=$difficulty',
            );
          }
        }
      }
    }
  });

  test('candidates never include a true value twice and correctIndices size '
      'matches the drawn angle count', () {
    for (var seed = 0; seed < 200; seed++) {
      final board = build(seed: seed);
      final trueValues = board.angles.map((a) => a.sweepDeg).toSet();
      final flaggedValues = {
        for (final i in board.correctIndices) board.candidates[i],
      };
      expect(flaggedValues, trueValues);
    }
  });

  test('a custom optionCount/maxCorrect is respected', () {
    const params = GeneratorParams.p1Angles(optionCount: 6, maxCorrect: 2);
    for (var seed = 0; seed < 100; seed++) {
      final board = build(params: params, seed: seed, difficulty: 5);
      expect(board.candidates, hasLength(6));
      expect(board.angles.length, inInclusiveRange(1, 2));
    }
  });
}
