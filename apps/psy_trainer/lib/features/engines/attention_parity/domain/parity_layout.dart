import 'dart:math';

import 'package:psy_content/psy_content.dart';

/// One number bubble of a parity-sequence series, positioned in the unit
/// square (`x`, `y` both in `0..1`; the renderer maps that onto its canvas).
class ParityNumber {
  const ParityNumber({required this.value, required this.x, required this.y});

  final int value;
  final double x;
  final double y;

  bool get isEven => value.isEven;

  /// String form used as the token of the expected/answered path
  /// (`Answer.sequence` payload).
  String get token => value.toString();

  @override
  bool operator ==(Object other) =>
      other is ParityNumber &&
      other.value == value &&
      other.x == x &&
      other.y == y;

  @override
  int get hashCode => Object.hash(value, x, y);
}

/// The "cloud of numbers" of one parity-sequence series (spec §2.4-D) and the
/// single valid path through it: starting at [startValue] (the lowest number
/// on screen, labelled START), alternately tapping the next ascending even
/// then the next ascending odd number, until [endValue] (labelled END).
///
/// Built by [ParityLayout.build] from `(params, seed, difficulty)` only, with
/// `Random(seed)`: the generator, the scorer and the renderer each rebuild
/// the exact same layout from the materialised `GeneratedItem` (its `seed`,
/// `params` and `difficulty`) instead of it being stored on the item, so
/// `AttentionParityEngine.generate` can keep returning a plain
/// `GeneratedItem` (CONTRACT.md: engine-owned data derived again from the
/// seed).
class ParityLayout {
  const ParityLayout({required this.numbers, required this.path});

  /// The bubbles on screen, in no particular order (their positions carry no
  /// information about the path).
  final List<ParityNumber> numbers;

  /// The values in the order they must be tapped: alternating parity, each
  /// category ascending. Unique for a given [numbers] set.
  final List<int> path;

  int get startValue => path.first;
  int get endValue => path.last;

  /// [path] as the string tokens an `Answer.sequence`/answer payload uses.
  List<String> get pathTokens => [for (final value in path) value.toString()];

  /// Minimum fraction of the unit square's diagonal that separates any two
  /// bubble centres, low enough to distinguish "was this deliberately
  /// packed tight" from a placement bug.
  static const double minSeparation = 0.05;

  factory ParityLayout.build({
    required ParitySequenceParams params,
    required int seed,
    required int difficulty,
  }) {
    final random = Random(seed);
    final count = _countFor(params, difficulty);
    final range = _rangeFor(params, difficulty);
    final values = _pickNumbers(random, range, count);
    final evens = values.where((v) => v.isEven).toList()..sort();
    final odds = values.where((v) => v.isOdd).toList()..sort();
    final path = _interleave(evens, odds);
    final spacing = _spacingFor(count, difficulty);
    final points = _scatter(random, count, spacing);
    final numbers = [
      for (var i = 0; i < path.length; i++)
        ParityNumber(value: path[i], x: points[i].$1, y: points[i].$2),
    ];
    return ParityLayout(numbers: numbers, path: path);
  }

  /// Item count (difficulty axis 1): [ParitySequenceParams.numberCount]
  /// shifted by two per difficulty step away from the middle level (3),
  /// clamped to the 12..20 range required by the story.
  static int _countFor(ParitySequenceParams params, int difficulty) {
    final delta = (difficulty - 3) * 2;
    return (params.numberCount + delta).clamp(12, 20);
  }

  /// Number range (difficulty axis 2): easier levels draw from a narrower
  /// window of [ParitySequenceParams.numberMin]..`numberMax` (numbers read
  /// and compare faster), harder levels use the full configured span.
  static (int min, int max) _rangeFor(
    ParitySequenceParams params,
    int difficulty,
  ) {
    final span = params.numberMax - params.numberMin;
    if (span <= 20) return (params.numberMin, params.numberMax);
    final factor = (0.55 + 0.15 * difficulty).clamp(0.55, 1.0);
    final effectiveSpan = (span * factor).round().clamp(20, span);
    return (params.numberMin, params.numberMin + effectiveSpan);
  }

  /// Picks [count] distinct integers from `[range.min, range.max]` with
  /// `random`. Deterministic for a fixed `random` state.
  static List<int> _pickNumbers(Random random, (int, int) range, int count) {
    final (min, max) = range;
    final pool = [for (var v = min; v <= max; v++) v];
    final n = count.clamp(2, pool.length);
    pool.shuffle(random);
    return pool.take(n).toList();
  }

  /// Zips [evens] and [odds] (both sorted ascending) starting from whichever
  /// list holds the overall minimum, alternating one value at a time until
  /// both are exhausted; once one list runs out the rest of the other is
  /// appended in order. This is the one path that satisfies "alternating
  /// parity, each category ascending" for the given number set.
  static List<int> _interleave(List<int> evens, List<int> odds) {
    if (evens.isEmpty) return odds;
    if (odds.isEmpty) return evens;
    var takeEven = evens.first < odds.first;
    var ei = 0;
    var oi = 0;
    final path = <int>[];
    while (ei < evens.length || oi < odds.length) {
      if (takeEven) {
        if (ei < evens.length) {
          path.add(evens[ei++]);
          takeEven = false;
        } else {
          takeEven = false;
        }
      } else {
        if (oi < odds.length) {
          path.add(odds[oi++]);
          takeEven = true;
        } else {
          takeEven = true;
        }
      }
    }
    return path;
  }

  /// Visual density (difficulty axis 3): the minimum centre-to-centre
  /// distance shrinks as the series holds more numbers and as difficulty
  /// rises, but never below [minSeparation].
  static double _spacingFor(int count, int difficulty) {
    final byCount = 0.30 - (count - 12) * 0.006;
    final byDifficulty = byCount - (difficulty - 1) * 0.02;
    return byDifficulty.clamp(minSeparation, 0.30);
  }

  /// Scatters [count] points in the unit square (with a margin so bubbles
  /// never sit on the edge), rejecting candidates closer than [spacing] to
  /// an existing point; `spacing` relaxes gradually so placement always
  /// terminates for the counts and margins this story uses.
  static List<(double, double)> _scatter(
    Random random,
    int count,
    double spacing,
  ) {
    const margin = 0.08;
    const span = 1 - 2 * margin;
    final points = <(double, double)>[];
    var effective = spacing;
    var attempts = 0;
    while (points.length < count) {
      if (attempts > 400) {
        effective *= 0.9;
        attempts = 0;
      }
      final candidate = (
        margin + random.nextDouble() * span,
        margin + random.nextDouble() * span,
      );
      final farEnough = points.every((p) => _distance(p, candidate) >= effective);
      if (farEnough) {
        points.add(candidate);
        attempts = 0;
      } else {
        attempts++;
      }
    }
    return points;
  }

  static double _distance((double, double) a, (double, double) b) {
    final dx = a.$1 - b.$1;
    final dy = a.$2 - b.$2;
    return sqrt(dx * dx + dy * dy);
  }
}
