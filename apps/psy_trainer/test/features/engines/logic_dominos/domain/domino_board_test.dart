import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/logic_dominos/domain/domino.dart';
import 'package:psy_trainer/features/engines/logic_dominos/domain/domino_board.dart';

void main() {
  const params = DominosParams();

  group('buildDominoBoard determinism', () {
    test('same (seed, params, difficulty) yields the same board', () {
      for (final difficulty in [1, 2, 3, 4]) {
        final a = buildDominoBoard(
          seed: 123,
          params: params,
          difficulty: difficulty,
        );
        final b = buildDominoBoard(
          seed: 123,
          params: params,
          difficulty: difficulty,
        );
        expect(b.dominoes, a.dominoes);
        expect(b.missingIndex, a.missingIndex);
        expect(b.answer, a.answer);
        expect(b.ruleKinds, a.ruleKinds);
      }
    });

    test('a different seed usually yields a different board', () {
      final a = buildDominoBoard(seed: 1, params: params, difficulty: 2);
      final b = buildDominoBoard(seed: 2, params: params, difficulty: 2);
      expect(a.dominoes, isNot(b.dominoes));
    });
  });

  group('buildDominoBoard uniqueness (spec §2.4-G, US-024)', () {
    for (final difficulty in [1, 2, 3, 4]) {
      test(
        'difficulty $difficulty: 200 seeds all resolve to a unique, correct board',
        () {
          for (var seed = 0; seed < 200; seed++) {
            final board = buildDominoBoard(
              seed: seed,
              params: params,
              difficulty: difficulty,
            );
            expect(board.dominoes.length, params.length);
            expect(board.dominoes[board.missingIndex], board.answer);
            expect(board.answer.top, inInclusiveRange(0, 6));
            expect(board.answer.bottom, inInclusiveRange(0, 6));
            final candidates = solveDominoCandidates(
              board.dominoes,
              board.missingIndex,
            );
            expect(
              candidates,
              {board.answer},
              reason:
                  'seed=$seed difficulty=$difficulty must have one solution',
            );
          }
        },
      );
    }

    test('difficulty 3-4 boards name the interleaved-series rule', () {
      for (var seed = 0; seed < 50; seed++) {
        final board3 = buildDominoBoard(
          seed: seed,
          params: params,
          difficulty: 3,
        );
        expect(board3.ruleKinds, contains(DominoRuleKind.interleavedSeries));
        final board4 = buildDominoBoard(
          seed: seed,
          params: params,
          difficulty: 4,
        );
        expect(board4.ruleKinds, contains(DominoRuleKind.interleavedSeries));
      }
    });

    test('difficulty 1 boards are a single linear rule', () {
      for (var seed = 0; seed < 50; seed++) {
        final board = buildDominoBoard(
          seed: seed,
          params: params,
          difficulty: 1,
        );
        expect(board.ruleKinds, [DominoRuleKind.linearEachHalf]);
      }
    });

    test(
      'an out-of-catalog difficulty (5) is clamped to the ruleCount-4 family',
      () {
        final clamped = buildDominoBoard(
          seed: 7,
          params: params,
          difficulty: 4,
        );
        final over = buildDominoBoard(seed: 7, params: params, difficulty: 5);
        expect(over.dominoes, clamped.dominoes);
      },
    );
  });

  group('solveDominoCandidates', () {
    test('a clean linear series has exactly one solution', () {
      // top: 0,1,2,3,4,5 (+1 mod 7); bottom constant at 3.
      final series = [for (var i = 0; i < 6; i++) Domino(i, 3)];
      final candidates = solveDominoCandidates(series, 3);
      expect(candidates, {const Domino(3, 3)});
    });

    test('a single visible domino cannot pin down the missing one', () {
      final series = [const Domino(2, 5), const Domino(0, 0)];
      final candidates = solveDominoCandidates(series, 1);
      expect(candidates.length, greaterThan(1));
    });

    test('a mirrored series (bottom = 6 - top) is solved uniquely', () {
      final top = [0, 2, 4, 6, 1, 3];
      final series = [
        for (var i = 0; i < top.length; i++) Domino(top[i], mod7(6 - top[i])),
      ];
      final candidates = solveDominoCandidates(series, 2);
      expect(candidates, {Domino(top[2], mod7(6 - top[2]))});
    });

    test('a constant-sum series is solved uniquely', () {
      const sum = 6;
      final top = [0, 1, 2, 3, 4, 5];
      final series = [for (final t in top) Domino(t, mod7(sum - t))];
      final candidates = solveDominoCandidates(series, 4);
      expect(candidates, {Domino(top[4], mod7(sum - top[4]))});
    });
  });
}
