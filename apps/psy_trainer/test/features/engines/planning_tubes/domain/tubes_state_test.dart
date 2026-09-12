import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/engines/planning_tubes/domain/tubes_state.dart';

/// Hand-made cases straight from the lesson's guided examples
/// (`assets/content/psy0/lessons/planning_tubes/01-billes.fr.md`), colours
/// mapped to ints (rouge=0, bleu=1, vert=2, jaune=3) so the expected
/// distances are known up front and double-check the BFS against text a
/// human worked through by hand.
void main() {
  const capacities = [3, 2, 3];

  group('legalMoves', () {
    test('the top ball of a non-empty tube can go to any tube with room', () {
      final state = TubesState([
        [0, 1], // A: rouge, bleu (bleu on top)
        [], // B
        [2], // C: vert
      ]);
      final moves = legalMoves(state, capacities);
      expect(moves.toSet(), {
        const TubesMove(0, 1), // bleu A -> B
        const TubesMove(0, 2), // bleu A -> C
        const TubesMove(2, 0), // vert C -> A
        const TubesMove(2, 1), // vert C -> B
      });
    });

    test('a full tube is never a destination', () {
      final state = TubesState([
        [0, 1], // A: cap 3, has room
        [0, 1], // B: cap 2, full
        [], // C
      ]);
      final moves = legalMoves(state, capacities);
      expect(moves.any((m) => m.to == 1), isFalse);
    });

    test('an empty tube has no move out of it', () {
      final state = TubesState([
        [],
        [0],
        [1],
      ]);
      final moves = legalMoves(state, capacities);
      expect(moves.any((m) => m.from == 0), isFalse);
    });
  });

  group('applyMove', () {
    test('moves exactly the top ball, leaving the rest untouched', () {
      final state = TubesState([
        [0, 1],
        [],
        [2],
      ]);
      final next = applyMove(state, const TubesMove(0, 1));
      expect(next.tubes, [
        [0],
        [1],
        [2],
      ]);
    });
  });

  group('TubesSolver.solve', () {
    test('start == target: distance 0, no moves', () {
      final state = TubesState([
        [0, 1],
        [],
        [2],
      ]);
      final solution = TubesSolver.solve(
        start: state,
        target: state,
        capacities: capacities,
      );
      expect(solution.distance, 0);
      expect(solution.moves, isEmpty);
    });

    test('guided example 1: one blocking ball -> 3 moves', () {
      // A = [rouge, bleu], B = [], C = [vert] -> A = [bleu], B = [], C =
      // [vert, rouge].
      final start = TubesState([
        [0, 1],
        [],
        [2],
      ]);
      final target = TubesState([
        [1],
        [],
        [2, 0],
      ]);
      final solution = TubesSolver.solve(
        start: start,
        target: target,
        capacities: capacities,
      );
      expect(solution.distance, 3);
      expect(solution.moves, hasLength(3));
      _expectSolutionReachesTarget(start, target, solution.moves, capacities);
    });

    test('guided example 2: vider un tube dans le même ordre -> 5 moves', () {
      // A = [bleu, rouge, vert] (full), B = [], C = [] -> A = [], B = [],
      // C = [bleu, rouge, vert].
      final start = TubesState([
        [1, 0, 2],
        [],
        [],
      ]);
      final target = TubesState([
        [],
        [],
        [1, 0, 2],
      ]);
      final solution = TubesSolver.solve(
        start: start,
        target: target,
        capacities: capacities,
      );
      expect(solution.distance, 5);
      _expectSolutionReachesTarget(start, target, solution.moves, capacities);
    });

    test("guided example 3: l'ordre de pose compte -> 2 moves", () {
      // A = [jaune, vert], B = [rouge], C = [bleu] -> A = [jaune], B = [],
      // C = [bleu, rouge, vert].
      final start = TubesState([
        [3, 2],
        [0],
        [1],
      ]);
      final target = TubesState([
        [3],
        [],
        [1, 0, 2],
      ]);
      final solution = TubesSolver.solve(
        start: start,
        target: target,
        capacities: capacities,
      );
      expect(solution.distance, 2);
      _expectSolutionReachesTarget(start, target, solution.moves, capacities);
    });

    test('the returned distance is truly minimal (no shorter path exists)', () {
      // A trivial one-move case: swapping the tops of two tubes with room
      // takes exactly 1 move (the destination has room), not more.
      final start = TubesState([
        [0],
        [],
        [],
      ]);
      final target = TubesState([
        [],
        [0],
        [],
      ]);
      final solution = TubesSolver.solve(
        start: start,
        target: target,
        capacities: capacities,
      );
      expect(solution.distance, 1);
    });

    test('an unreachable target (different ball count) throws', () {
      final start = TubesState([
        [0],
        [],
        [],
      ]);
      final target = TubesState([
        [0, 1],
        [],
        [],
      ]);
      expect(
        () => TubesSolver.solve(
          start: start,
          target: target,
          capacities: capacities,
        ),
        throwsStateError,
      );
    });
  });
}

/// Replays [moves] from [start] and asserts it lands exactly on [target],
/// respecting [capacities] throughout (the solver must never emit an
/// illegal move).
void _expectSolutionReachesTarget(
  TubesState start,
  TubesState target,
  List<TubesMove> moves,
  List<int> capacities,
) {
  var state = start;
  for (final move in moves) {
    final legal = legalMoves(state, capacities);
    expect(legal, contains(move));
    state = applyMove(state, move);
  }
  expect(state, target);
}
