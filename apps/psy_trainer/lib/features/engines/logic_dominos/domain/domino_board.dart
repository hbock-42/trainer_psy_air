import 'dart:math';

import 'package:psy_content/psy_content.dart';

import 'domino.dart';

/// The rule families of spec §2.4-G / US-024. A board may combine several
/// (the FR explanation names every one that applies).
enum DominoRuleKind {
  /// `+k mod 7` on one or both halves.
  linearEachHalf,

  /// The two halves take turns advancing by `+k mod 7`.
  alternatingTopBottom,

  /// The bottom half mirrors the top half (`bottom = 6 - top`).
  mirroredHalves,

  /// `top + bottom` is the same for every domino.
  constantSum,

  /// Even and odd positions are two independent series.
  interleavedSeries,
}

/// A generated dominoes puzzle: the full series with [missingIndex] hidden,
/// its unique [answer] and the rule(s) that produced it.
///
/// Nothing here is stored on the `GeneratedItem` the engine returns: the
/// renderer and the scorer both call [buildDominoBoard] again with the same
/// `(seed, params, difficulty)` and get back the same board (US-020 "Engine",
/// "keep the stimulus in engine-owned data derived again from the seed").
class DominoBoard {
  const DominoBoard({
    required this.dominoes,
    required this.missingIndex,
    required this.answer,
    required this.ruleKinds,
    required this.layout,
  });

  /// The full series in play order; `dominoes[missingIndex] == answer`, but
  /// the renderer must hide it until the item is answered.
  final List<Domino> dominoes;
  final int missingIndex;
  final Domino answer;
  final List<DominoRuleKind> ruleKinds;
  final DominoLayout layout;
}

/// Builds the board of the recipe `(seed, params, difficulty)`.
///
/// Deterministic: same inputs, same board (same `Random(seed)` sequence).
/// `difficulty` (1..5, clamped to the 1..4 rule catalog below) is the number
/// of interleaved rules; a brute-force solver checks every board against the
/// whole rule catalog and only a board with exactly one solution -- the one
/// the generator built -- is accepted, so an accidental ambiguity (rare, but
/// possible with 7 values) draws a fresh board from the same seeded sequence
/// instead of being shipped.
DominoBoard buildDominoBoard({
  required int seed,
  required DominosParams params,
  required int difficulty,
}) {
  final rng = Random(seed);
  final ruleCount = difficulty.clamp(1, 4);
  // Interleaved series (ruleCount 3-4) needs >=3 dominoes per parity group so
  // 3 equally-spaced points can pin down a progression; the real-test count
  // (spec §3.1 row 6: ~16-20) is always well above this.
  final length = params.length < 6 ? 6 : params.length;

  const maxAttempts = 500;
  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    final built = _buildSeries(rng, ruleCount, length);
    final missingIndex = rng.nextInt(length);
    final trueAnswer = built.dominoes[missingIndex];
    final candidates = _solveCandidates(built.dominoes, missingIndex);
    if (candidates.length == 1 && candidates.single == trueAnswer) {
      return DominoBoard(
        dominoes: built.dominoes,
        missingIndex: missingIndex,
        answer: trueAnswer,
        ruleKinds: built.ruleKinds,
        layout: params.layout,
      );
    }
  }
  throw StateError(
    'dominos: no unique board found after $maxAttempts attempts '
    '(seed=$seed, ruleCount=$ruleCount, length=$length)',
  );
}

typedef _Series = ({List<Domino> dominoes, List<DominoRuleKind> ruleKinds});

_Series _buildSeries(Random rng, int ruleCount, int length) => switch (ruleCount) {
  1 => _linearSingleHalf(rng, length),
  2 => _twoRuleFamily(rng, length),
  3 => _interleaved(rng, length, subRuleCount: 1),
  _ => _interleaved(rng, length, subRuleCount: 2),
};

List<Domino> _zip(List<int> top, List<int> bottom) => [
  for (var i = 0; i < top.length; i++) Domino(top[i], bottom[i]),
];

List<int> _linearValues(Random rng, int len) {
  final start = rng.nextInt(7);
  final k = 1 + rng.nextInt(6); // never 0: a real progression
  return [for (var i = 0; i < len; i++) mod7(start + k * i)];
}

List<int> _constantValues(Random rng, int len) {
  final v = rng.nextInt(7);
  return List.filled(len, v);
}

/// Rule count 1: a single half moves by `+k mod 7`, the other stays fixed.
_Series _linearSingleHalf(Random rng, int length) {
  final movingIsTop = rng.nextBool();
  final moving = _linearValues(rng, length);
  final fixed = _constantValues(rng, length);
  final top = movingIsTop ? moving : fixed;
  final bottom = movingIsTop ? fixed : moving;
  return (dominoes: _zip(top, bottom), ruleKinds: [DominoRuleKind.linearEachHalf]);
}

/// Rule count 2: one relation between top and bottom, on top of a
/// progression -- linear on each half, alternating, mirrored or a constant
/// sum.
_Series _twoRuleFamily(Random rng, int length) {
  switch (rng.nextInt(4)) {
    case 0:
      final top = _linearValues(rng, length);
      final bottom = _linearValues(rng, length);
      return (
        dominoes: _zip(top, bottom),
        ruleKinds: [DominoRuleKind.linearEachHalf],
      );
    case 1:
      return _alternating(rng, length);
    case 2:
      final top = _linearValues(rng, length);
      final bottom = [for (final t in top) mod7(6 - t)];
      return (
        dominoes: _zip(top, bottom),
        ruleKinds: [DominoRuleKind.mirroredHalves],
      );
    default:
      final top = _linearValues(rng, length);
      final sum = rng.nextInt(7);
      final bottom = [for (final t in top) mod7(sum - t)];
      return (
        dominoes: _zip(top, bottom),
        ruleKinds: [DominoRuleKind.constantSum],
      );
  }
}

_Series _alternating(Random rng, int length) {
  final k = 1 + rng.nextInt(6);
  var top = rng.nextInt(7);
  var bottom = rng.nextInt(7);
  var topTurn = rng.nextBool();
  final topList = <int>[top];
  final bottomList = <int>[bottom];
  for (var i = 1; i < length; i++) {
    if (topTurn) {
      top = mod7(top + k);
    } else {
      bottom = mod7(bottom + k);
    }
    topTurn = !topTurn;
    topList.add(top);
    bottomList.add(bottom);
  }
  return (
    dominoes: _zip(topList, bottomList),
    ruleKinds: [DominoRuleKind.alternatingTopBottom],
  );
}

/// Rule count 3-4: even and odd positions are two independent series, each
/// built by [_linearSingleHalf] (rule count 3) or [_twoRuleFamily] (4).
_Series _interleaved(Random rng, int length, {required int subRuleCount}) {
  final evenCount = (length / 2).ceil();
  final oddCount = length - evenCount;
  final subA = subRuleCount == 1
      ? _linearSingleHalf(rng, evenCount)
      : _twoRuleFamily(rng, evenCount);
  final subB = subRuleCount == 1
      ? _linearSingleHalf(rng, oddCount)
      : _twoRuleFamily(rng, oddCount);
  final dominoes = <Domino>[];
  var ai = 0;
  var bi = 0;
  for (var i = 0; i < length; i++) {
    if (i.isEven) {
      dominoes.add(subA.dominoes[ai]);
      ai++;
    } else {
      dominoes.add(subB.dominoes[bi]);
      bi++;
    }
  }
  final kinds = {
    DominoRuleKind.interleavedSeries,
    ...subA.ruleKinds,
    ...subB.ruleKinds,
  }.toList();
  return (dominoes: dominoes, ruleKinds: kinds);
}

// --- Solver ------------------------------------------------------------

/// Every candidate `Domino` that, placed at [missingIndex], makes the whole
/// series consistent with at least one rule of the catalog. A unique board
/// has exactly one.
Set<Domino> _solveCandidates(List<Domino> series, int missingIndex) {
  final candidates = <Domino>{};
  for (var t = 0; t <= 6; t++) {
    for (var b = 0; b <= 6; b++) {
      final candidate = Domino(t, b);
      final trial = [...series];
      trial[missingIndex] = candidate;
      final top = [for (final d in trial) d.top];
      final bottom = [for (final d in trial) d.bottom];
      if (_fitsAnyRule(top, bottom)) candidates.add(candidate);
    }
  }
  return candidates;
}

bool _fitsAnyRule(List<int> top, List<int> bottom) =>
    (_isArithmeticMod7(top) && _isArithmeticMod7(bottom)) ||
    _isAlternating(top, bottom) ||
    (_isMirror(top, bottom) && _isArithmeticMod7(top)) ||
    (_isConstantSum(top, bottom) && _isArithmeticMod7(top)) ||
    _fitsInterleaved(top, bottom);

bool _isArithmeticMod7(List<int> values) {
  if (values.length < 2) return true;
  final step = mod7(values[1] - values[0]);
  for (var i = 2; i < values.length; i++) {
    if (mod7(values[i] - values[i - 1]) != step) return false;
  }
  return true;
}

bool _isMirror(List<int> top, List<int> bottom) {
  for (var i = 0; i < top.length; i++) {
    if (bottom[i] != mod7(6 - top[i])) return false;
  }
  return true;
}

bool _isConstantSum(List<int> top, List<int> bottom) {
  final sum = top[0] + bottom[0];
  for (var i = 1; i < top.length; i++) {
    if (top[i] + bottom[i] != sum) return false;
  }
  return true;
}

bool _isAlternating(List<int> top, List<int> bottom) {
  if (top.length < 3) return false;
  int? k;
  final topChangedAt = <bool>[];
  for (var i = 1; i < top.length; i++) {
    final topChanged = top[i] != top[i - 1];
    final bottomChanged = bottom[i] != bottom[i - 1];
    if (topChanged == bottomChanged) return false;
    final delta = topChanged
        ? mod7(top[i] - top[i - 1])
        : mod7(bottom[i] - bottom[i - 1]);
    if (delta == 0) return false;
    k ??= delta;
    if (delta != k) return false;
    topChangedAt.add(topChanged);
  }
  for (var i = 1; i < topChangedAt.length; i++) {
    if (topChangedAt[i] == topChangedAt[i - 1]) return false;
  }
  return true;
}

/// A relation within one parity group: linear on each half, mirrored or a
/// constant sum (the sub-rules [_twoRuleFamily] may pick).
bool _fitsGroupRule(List<int> top, List<int> bottom) =>
    (_isArithmeticMod7(top) && _isArithmeticMod7(bottom)) ||
    (_isMirror(top, bottom) && _isArithmeticMod7(top)) ||
    (_isConstantSum(top, bottom) && _isArithmeticMod7(top));

bool _fitsInterleaved(List<int> top, List<int> bottom) {
  final evenTop = <int>[];
  final evenBottom = <int>[];
  final oddTop = <int>[];
  final oddBottom = <int>[];
  for (var i = 0; i < top.length; i++) {
    if (i.isEven) {
      evenTop.add(top[i]);
      evenBottom.add(bottom[i]);
    } else {
      oddTop.add(top[i]);
      oddBottom.add(bottom[i]);
    }
  }
  return _fitsGroupRule(evenTop, evenBottom) &&
      _fitsGroupRule(oddTop, oddBottom);
}
