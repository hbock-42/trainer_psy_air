import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_raven_matrices/domain/matrix_board.dart';
import 'package:psy_trainer/features/engines/p1_raven_matrices/domain/matrix_figure.dart';

void main() {
  const params = P1RavenMatricesParams();

  test('is deterministic: same inputs, same board', () {
    final a = buildMatrixBoard(seed: 123, params: params, difficulty: 3);
    final b = buildMatrixBoard(seed: 123, params: params, difficulty: 3);
    expect(a.answer, b.answer);
    expect(a.candidates, b.candidates);
    expect(a.correctIndex, b.correctIndex);
    for (var r = 0; r < 3; r++) {
      for (var c = 0; c < 3; c++) {
        expect(a.cells[r][c], b.cells[r][c]);
      }
    }
  });

  test('a different seed yields a different board (overwhelmingly likely)', () {
    final a = buildMatrixBoard(seed: 1, params: params, difficulty: 3);
    final b = buildMatrixBoard(seed: 2, params: params, difficulty: 3);
    expect(a.candidates, isNot(b.candidates));
  });

  test('always exactly 8 candidates, one of them the answer', () {
    final board = buildMatrixBoard(seed: 42, params: params, difficulty: 2);
    expect(board.candidates, hasLength(8));
    expect(board.candidates[board.correctIndex], board.answer);
  });

  test('the 8 candidates are pairwise distinct', () {
    final board = buildMatrixBoard(seed: 7, params: params, difficulty: 5);
    expect(board.candidates.toSet(), hasLength(8));
  });

  group('uniqueness solver: exactly one candidate matches every rule', () {
    for (var difficulty = 1; difficulty <= 5; difficulty++) {
      test('difficulty $difficulty over 60 seeds', () {
        for (var seed = 0; seed < 60; seed++) {
          final board = buildMatrixBoard(
            seed: seed,
            params: params,
            difficulty: difficulty,
          );
          final matches = board.candidates
              .where((figure) => figure == board.answer)
              .length;
          expect(
            matches,
            1,
            reason:
                'seed=$seed difficulty=$difficulty produced $matches '
                'matching candidates',
          );
        }
      });
    }
  });

  test('difficulty drives how many attributes actually vary', () {
    // Low difficulty: at most 2 active rules; high: up to 4. Sampled over
    // several seeds since which attributes are picked is randomised.
    var lowMax = 0;
    var highMax = 0;
    for (var seed = 0; seed < 30; seed++) {
      final low = buildMatrixBoard(seed: seed, params: params, difficulty: 1);
      final high = buildMatrixBoard(seed: seed, params: params, difficulty: 5);
      lowMax = lowMax > low.activeRules.length
          ? lowMax
          : low.activeRules.length;
      highMax = highMax > high.activeRules.length
          ? highMax
          : high.activeRules.length;
    }
    expect(lowMax, lessThanOrEqualTo(2));
    expect(highMax, greaterThan(lowMax));
  });

  test('distractors each differ from the answer in exactly one attribute', () {
    final board = buildMatrixBoard(seed: 9, params: params, difficulty: 3);
    final answer = board.answer;
    for (var i = 0; i < board.candidates.length; i++) {
      if (i == board.correctIndex) continue;
      final candidate = board.candidates[i];
      var diffCount = 0;
      if (candidate.outerShape != answer.outerShape) diffCount++;
      if (candidate.innerShape != answer.innerShape) diffCount++;
      if (candidate.count != answer.count) diffCount++;
      if (candidate.rotationStep != answer.rotationStep) diffCount++;
      if (candidate.fill != answer.fill) diffCount++;
      if (candidate.sizeStep != answer.sizeStep) diffCount++;
      if (candidate.position != answer.position) diffCount++;
      expect(diffCount, 1);
    }
  });

  test('MatrixAttribute has 7 dimensions (one distractor each)', () {
    expect(MatrixAttribute.values, hasLength(7));
  });
}
