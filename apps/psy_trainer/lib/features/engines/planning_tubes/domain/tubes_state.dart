import 'dart:collection';

/// A `planning_tubes` (US-035) puzzle configuration: `tubes[i]` lists the
/// colour indices of tube `i`'s balls from the bottom of the U to the top
/// (top = `tubes[i].last`). Purely a value: equality and [key] compare the
/// stacks themselves, never object identity, so [TubesSolver] can key a
/// `Set`/`Map` by state.
class TubesState {
  TubesState(List<List<int>> tubes)
    : tubes = List.unmodifiable([
        for (final t in tubes) List<int>.unmodifiable(t),
      ]);

  final List<List<int>> tubes;

  int get tubeCount => tubes.length;

  /// Canonical string encoding (`"0,1|2|3,4"`), used as the BFS visited-set
  /// key and for equality/hashing.
  String get key => tubes.map((t) => t.join(',')).join('|');

  @override
  bool operator ==(Object other) => other is TubesState && other.key == key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => 'TubesState($key)';
}

/// One move: the top ball of tube [from] onto tube [to].
class TubesMove {
  const TubesMove(this.from, this.to);

  final int from;
  final int to;

  @override
  bool operator ==(Object other) =>
      other is TubesMove && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);

  @override
  String toString() => '$from→$to';
}

/// Result of [TubesSolver.solve]: the optimal move count ([distance]) and
/// one optimal [moves] sequence (empty when already solved).
class TubesSolution {
  const TubesSolution({required this.distance, required this.moves});

  final int distance;
  final List<TubesMove> moves;
}

/// The legal moves out of [state] under [capacities]: the top ball of any
/// non-empty tube onto any *other* tube that still has room. No colour
/// matching is required (spec §2.4-B / the lesson's assumed rule: one ball
/// at a time, only the top ball, capacity respected).
List<TubesMove> legalMoves(TubesState state, List<int> capacities) {
  final moves = <TubesMove>[];
  for (var from = 0; from < state.tubeCount; from++) {
    if (state.tubes[from].isEmpty) continue;
    for (var to = 0; to < state.tubeCount; to++) {
      if (to == from) continue;
      if (state.tubes[to].length >= capacities[to]) continue;
      moves.add(TubesMove(from, to));
    }
  }
  return moves;
}

/// [state] after applying [move] (assumed legal; callers only ever pass
/// moves drawn from [legalMoves]).
TubesState applyMove(TubesState state, TubesMove move) {
  final tubes = [for (final t in state.tubes) List<int>.of(t)];
  final ball = tubes[move.from].removeLast();
  tubes[move.to].add(ball);
  return TubesState(tubes);
}

/// Breadth-first search over the (tiny) tube-state graph: [solve] returns
/// the minimum number of moves from [start] to [target] and one optimal
/// sequence achieving it, used both as the item's expected numeric answer
/// and as the "Voir la solution" step-through.
abstract final class TubesSolver {
  static TubesSolution solve({
    required TubesState start,
    required TubesState target,
    required List<int> capacities,
  }) {
    if (start == target) {
      return const TubesSolution(distance: 0, moves: []);
    }
    final visited = <String>{start.key};
    final parent = <String, (TubesState, TubesMove)>{};
    final queue = Queue<TubesState>()..add(start);

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      for (final move in legalMoves(current, capacities)) {
        final next = applyMove(current, move);
        if (visited.contains(next.key)) continue;
        visited.add(next.key);
        parent[next.key] = (current, move);
        if (next == target) {
          return TubesSolution(
            distance: _pathLength(parent, start, next),
            moves: _reconstruct(parent, start, next),
          );
        }
        queue.add(next);
      }
    }
    throw StateError('TubesSolver: no legal-move path from $start to $target');
  }

  static List<TubesMove> _reconstruct(
    Map<String, (TubesState, TubesMove)> parent,
    TubesState start,
    TubesState end,
  ) {
    final moves = <TubesMove>[];
    var current = end;
    while (current.key != start.key) {
      final (prev, move) = parent[current.key]!;
      moves.add(move);
      current = prev;
    }
    return moves.reversed.toList();
  }

  static int _pathLength(
    Map<String, (TubesState, TubesMove)> parent,
    TubesState start,
    TubesState end,
  ) {
    var count = 0;
    var current = end;
    while (current.key != start.key) {
      current = parent[current.key]!.$1;
      count++;
    }
    return count;
  }
}
