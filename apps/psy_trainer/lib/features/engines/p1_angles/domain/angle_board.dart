import 'dart:math';

import 'package:psy_content/psy_content.dart';

/// Degrees within which a candidate value is considered a match of a drawn
/// angle's true value; also the minimum gap the generator keeps between any
/// two candidates so no candidate is ever ambiguous (spec §2.3 row 5:
/// "9 possibilités, max 4 bonnes réponses").
const int angleMatchToleranceDeg = 2;

/// One angle drawn on the board: two rays from a shared vertex, [sweepDeg]
/// apart, read anticlockwise from [startRad]. Labelled A, B, C... in draw
/// order. [sweepDeg] is the true value the candidate list is testing
/// against (1..359; > 180 only at high difficulty -- a reflex angle).
class DrawnAngle {
  const DrawnAngle({
    required this.label,
    required this.startRad,
    required this.sweepDeg,
  });

  final String label;

  /// Orientation of the first ray, radians, 0 = pointing right (screen
  /// space, before any y-flip the painter applies).
  final double startRad;

  final int sweepDeg;

  bool get isReflex => sweepDeg > 180;
}

/// A materialised `p1_angles` item (spec §2.3 row 5, §4.1 row 5): 1..4 drawn
/// angles and [candidates] candidate values (degrees), of which exactly the
/// [angles]' true values are correct -- [correctIndices] indexes
/// [candidates]. Purely a value: the engine, the scorer and the renderer all
/// derive it again from `(params, seed, difficulty)` through
/// [AngleBoardGenerator.build] rather than storing it on the item.
class AngleBoard {
  const AngleBoard({
    required this.angles,
    required this.candidates,
    required this.correctIndices,
  });

  final List<DrawnAngle> angles;

  /// Candidate values (degrees), length `optionCount`.
  final List<int> candidates;

  /// Indices into [candidates] that are a correct answer (one per drawn
  /// angle); `correctIndices.length == angles.length`.
  final Set<int> correctIndices;
}

/// Builds the deterministic [AngleBoard] of one `p1_angles` recipe.
///
/// `Random(seed)` only, consumed in a fixed order (angle count, then each
/// angle's true value and orientation, then the distractor pool, then a
/// shuffle of the candidate list), so the same `(params, seed, difficulty)`
/// always yields the same board.
///
/// Distractors are kept at least [_minGap] degrees from every true value and
/// from each other; [_minGap] shrinks as [difficulty] rises (closer, harder
/// to tell apart) but never drops below `2 * angleMatchToleranceDeg + 1`, so
/// no candidate is ever within tolerance of more than one true value --
/// there is always exactly one unambiguous match per drawn angle.
abstract final class AngleBoardGenerator {
  static const int _minDeg = 10;
  static const int _maxDeg = 350;
  static const int _step = 5;
  static const int _reflexFloor = 185;

  static AngleBoard build({
    required P1AnglesParams params,
    required int seed,
    required int difficulty,
  }) {
    final rng = Random(seed);
    final level = difficulty.clamp(minDifficulty, maxDifficulty);
    final optionCount = max(params.optionCount, 1);
    final maxCorrect = params.maxCorrect.clamp(1, optionCount);

    final minCount = level >= 4 ? min(2, maxCorrect) : 1;
    final count = min(
      maxCorrect,
      minCount + rng.nextInt(maxCorrect - minCount + 1),
    );

    final allowReflex = level >= 4;
    final trueValues = _pickTrueValues(rng, count, allowReflex);

    final angles = <DrawnAngle>[];
    for (var i = 0; i < trueValues.length; i++) {
      final startRad = rng.nextDouble() * 2 * pi;
      angles.add(
        DrawnAngle(
          label: String.fromCharCode('A'.codeUnitAt(0) + i),
          startRad: startRad,
          sweepDeg: trueValues[i],
        ),
      );
    }

    final minGap = _minGapFor(level);
    final distractorCount = max(0, optionCount - trueValues.length);
    final distractors = _pickDistractors(
      rng,
      count: distractorCount,
      taken: trueValues,
      minGap: minGap,
    );

    final candidates = [...trueValues, ...distractors]..shuffle(rng);
    final trueSet = trueValues.toSet();
    final correctIndices = <int>{
      for (var i = 0; i < candidates.length; i++)
        if (trueSet.contains(candidates[i])) i,
    };

    return AngleBoard(
      angles: angles,
      candidates: candidates,
      correctIndices: correctIndices,
    );
  }

  /// Minimum degrees between any two candidates: 15 at the lowest
  /// difficulty down to 7 at the highest, always `> 2 *
  /// angleMatchToleranceDeg` so a candidate can never sit within tolerance
  /// of two different true values (or of another candidate).
  static int _minGapFor(int level) =>
      max(2 * angleMatchToleranceDeg + 1, 15 - (level - 1) * 2);

  static List<int> _pickTrueValues(Random rng, int count, bool allowReflex) {
    final values = <int>[];
    var attempts = 0;
    while (values.length < count && attempts < 2000) {
      attempts++;
      final ceiling = allowReflex ? _maxDeg : _reflexFloor - _step;
      final steps = ((ceiling - _minDeg) / _step).floor();
      final candidate = _minDeg + _step * rng.nextInt(steps + 1);
      if (values.any((v) => (v - candidate).abs() < 15)) continue;
      values.add(candidate);
    }
    return values;
  }

  static List<int> _pickDistractors(
    Random rng, {
    required int count,
    required List<int> taken,
    required int minGap,
  }) {
    final used = [...taken];
    final distractors = <int>[];
    var attempts = 0;
    while (distractors.length < count && attempts < 5000) {
      attempts++;
      final steps = ((_maxDeg - _minDeg) / _step).floor();
      final candidate = _minDeg + _step * rng.nextInt(steps + 1);
      if (used.any((v) => (v - candidate).abs() < minGap)) continue;
      used.add(candidate);
      distractors.add(candidate);
    }
    // Fallback (only reachable with a pathological params combination): pad
    // with values spaced by _step from the top of the range so the returned
    // candidate list always has the requested length.
    var pad = _maxDeg;
    while (distractors.length < count) {
      if (!used.contains(pad)) {
        used.add(pad);
        distractors.add(pad);
      }
      pad -= _step;
    }
    return distractors;
  }
}
