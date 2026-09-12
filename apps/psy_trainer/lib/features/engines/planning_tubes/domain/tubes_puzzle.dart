import 'dart:math';

import 'package:psy_content/psy_content.dart';

import 'tubes_state.dart';

/// A materialised `planning_tubes` puzzle (spec §2.4-B, US-035): [start] and
/// [target] tube configurations plus one optimal [moves] sequence between
/// them. Purely a value, rebuilt again from `(params, seed, difficulty)` by
/// [TubesPuzzleGenerator.build] -- the engine, the renderer and (via [moves])
/// the "Voir la solution" step-through all derive it the same way, never
/// storing it on the item itself (`NumericItem` has no field for it, see
/// `tubes_engine.dart`).
class TubesPuzzle {
  const TubesPuzzle({
    required this.capacities,
    required this.colourCount,
    required this.start,
    required this.target,
    required this.moves,
  });

  final List<int> capacities;
  final int colourCount;
  final TubesState start;
  final TubesState target;

  /// One optimal move sequence from [start] to [target]; `moves.length` is
  /// the puzzle's minimum move count (the item's expected numeric answer).
  final List<TubesMove> moves;

  int get distance => moves.length;

  /// [start], then the tube state after each of [moves] in order -- used by
  /// the renderer's step-through reveal. `states.length == moves.length + 1`.
  List<TubesState> get states {
    final result = <TubesState>[start];
    var state = start;
    for (final move in moves) {
      state = applyMove(state, move);
      result.add(state);
    }
    return result;
  }
}

/// Builds the deterministic [TubesPuzzle] of one `tubes` recipe.
///
/// A `Random(seed)` fills the tubes with [TubesParams.ballCount] random-
/// coloured balls (respecting [TubesParams.capacities]) for [start], then
/// applies a generous number of random *legal* moves to reach [target] --
/// so [target] is always reachable from [start] by construction. The BFS
/// distance between them is not necessarily that many moves (some undo
/// each other), so [TubesSolver.solve] computes the *actual* minimum and,
/// when it falls outside the difficulty's target distance band, the whole
/// draw is retried (same `Random` instance, so still a deterministic
/// function of `seed`) until it lands inside the band or the attempt cap is
/// hit (falls back to the last draw -- practically never reached, see
/// `tubes_engine_test.dart`).
///
/// **Difficulty bands.** [TubesParams.minMoves]/[TubesParams.maxMoves] are
/// the real-test-derived overall distance range (defaults 2..8); this
/// splits that range into [maxDifficulty] (5) contiguous integer bands, one
/// per difficulty level, the last one absorbing any remainder up to
/// `maxMoves`. With the shipped defaults that is `{2}/{3}/{4}/{5}/{6..8}`.
/// The story's illustrative "1-2 / 3-4 / 5-6 / 7-8 / 9+" bands would need
/// `minMoves: 1` and an unbounded (or larger) `maxMoves`; see the PR report
/// if that shape is actually wanted instead.
abstract final class TubesPuzzleGenerator {
  static const int _maxAttempts = 2000;

  static TubesPuzzle build({
    required TubesParams params,
    required int seed,
    required int difficulty,
  }) {
    final rng = Random(seed);
    final band = _bandFor(params, difficulty);
    final capacities = params.capacities;

    TubesState start;
    TubesState target;
    TubesSolution solution;
    var attempt = 0;
    do {
      start = _randomStart(rng, params);
      final shuffleSteps = band.max + 4 + rng.nextInt(6);
      target = _shuffle(rng, start, capacities, shuffleSteps);
      solution = TubesSolver.solve(
        start: start,
        target: target,
        capacities: capacities,
      );
      attempt++;
    } while ((solution.distance < band.min || solution.distance > band.max) &&
        attempt < _maxAttempts);

    return TubesPuzzle(
      capacities: capacities,
      colourCount: params.colourCount,
      start: start,
      target: target,
      moves: solution.moves,
    );
  }

  static ({int min, int max}) _bandFor(TubesParams params, int difficulty) {
    final lo = params.minMoves;
    final hi = params.maxMoves;
    final span = hi - lo;
    final level = difficulty.clamp(minDifficulty, maxDifficulty);
    final bandLo = lo + ((level - 1) * span) ~/ maxDifficulty;
    final bandHi = level == maxDifficulty
        ? hi
        : lo + (level * span) ~/ maxDifficulty - 1;
    return (min: bandLo, max: max(bandLo, bandHi));
  }

  static TubesState _randomStart(Random rng, TubesParams params) {
    final capacities = params.capacities;
    final tubes = <List<int>>[for (final _ in capacities) <int>[]];
    final totalCapacity = capacities.fold<int>(0, (a, b) => a + b);
    var remaining = min(params.ballCount, totalCapacity);
    while (remaining > 0) {
      final candidates = [
        for (var i = 0; i < tubes.length; i++)
          if (tubes[i].length < capacities[i]) i,
      ];
      if (candidates.isEmpty) break;
      final tube = candidates[rng.nextInt(candidates.length)];
      tubes[tube].add(rng.nextInt(params.colourCount));
      remaining--;
    }
    return TubesState(tubes);
  }

  static TubesState _shuffle(
    Random rng,
    TubesState start,
    List<int> capacities,
    int steps,
  ) {
    var state = start;
    for (var i = 0; i < steps; i++) {
      final moves = legalMoves(state, capacities);
      if (moves.isEmpty) break;
      state = applyMove(state, moves[rng.nextInt(moves.length)]);
    }
    return state;
  }
}
