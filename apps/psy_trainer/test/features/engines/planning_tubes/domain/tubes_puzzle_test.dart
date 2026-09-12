import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/planning_tubes/domain/tubes_puzzle.dart';
import 'package:psy_trainer/features/engines/planning_tubes/domain/tubes_state.dart';

void main() {
  const params = TubesParams();

  group('TubesPuzzleGenerator.build', () {
    test('is deterministic: same (params, seed, difficulty), same puzzle', () {
      final a = TubesPuzzleGenerator.build(
        params: params,
        seed: 123,
        difficulty: 3,
      );
      final b = TubesPuzzleGenerator.build(
        params: params,
        seed: 123,
        difficulty: 3,
      );
      expect(a.start, b.start);
      expect(a.target, b.target);
      expect(a.distance, b.distance);
      expect(
        a.moves.map((m) => '$m').toList(),
        b.moves.map((m) => '$m').toList(),
      );
    });

    test('a different seed (usually) yields a different puzzle', () {
      final a = TubesPuzzleGenerator.build(
        params: params,
        seed: 1,
        difficulty: 3,
      );
      final b = TubesPuzzleGenerator.build(
        params: params,
        seed: 2,
        difficulty: 3,
      );
      expect(a.start != b.start || a.target != b.target, isTrue);
    });

    test('start respects the ball count and capacities', () {
      for (var seed = 0; seed < 20; seed++) {
        final puzzle = TubesPuzzleGenerator.build(
          params: params,
          seed: seed,
          difficulty: 3,
        );
        final totalBalls = puzzle.start.tubes.fold<int>(
          0,
          (sum, t) => sum + t.length,
        );
        expect(totalBalls, params.ballCount);
        for (var i = 0; i < puzzle.capacities.length; i++) {
          expect(
            puzzle.start.tubes[i].length,
            lessThanOrEqualTo(puzzle.capacities[i]),
          );
        }
      }
    });

    test('target is always reachable from start (solver never throws)', () {
      for (var seed = 0; seed < 50; seed++) {
        for (var difficulty = 1; difficulty <= 5; difficulty++) {
          expect(
            () => TubesPuzzleGenerator.build(
              params: params,
              seed: seed,
              difficulty: difficulty,
            ),
            returnsNormally,
          );
        }
      }
    });

    test('the optimal move sequence actually replays from start to target', () {
      final puzzle = TubesPuzzleGenerator.build(
        params: params,
        seed: 7,
        difficulty: 4,
      );
      var state = puzzle.start;
      for (final move in puzzle.moves) {
        state = _applyMove(state, move);
      }
      expect(state, puzzle.target);
      expect(puzzle.states.first, puzzle.start);
      expect(puzzle.states.last, puzzle.target);
      expect(puzzle.states.length, puzzle.moves.length + 1);
    });

    test(
      'each difficulty level lands in its own distance band (defaults 2..8)',
      () {
        // Bands derived from TubesParams defaults (minMoves: 2, maxMoves: 8)
        // split into 5 contiguous integer bands: {2}/{3}/{4}/{5}/{6..8}.
        const bands = {1: (2, 2), 2: (3, 3), 3: (4, 4), 4: (5, 5), 5: (6, 8)};
        for (final entry in bands.entries) {
          final (lo, hi) = entry.value;
          for (var seed = 0; seed < 10; seed++) {
            final puzzle = TubesPuzzleGenerator.build(
              params: params,
              seed: seed * 1000 + entry.key,
              difficulty: entry.key,
            );
            expect(
              puzzle.distance,
              inInclusiveRange(lo, hi),
              reason:
                  'difficulty ${entry.key}, seed ${seed * 1000 + entry.key}',
            );
          }
        }
      },
    );
  });
}

TubesState _applyMove(TubesState state, TubesMove move) {
  final tubes = [for (final t in state.tubes) List<int>.of(t)];
  final ball = tubes[move.from].removeLast();
  tubes[move.to].add(ball);
  return TubesState(tubes);
}
