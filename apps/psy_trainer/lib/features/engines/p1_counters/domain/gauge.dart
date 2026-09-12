import 'dart:math' as math;

/// Visual kind of one instrument in a `p1_counters` panel (US-113, spec
/// §2.3 row 7 / §4.1 row 7: "closest PSY1 analogue to a flight-instrument
/// scan").
enum GaugeKind {
  /// Single-needle circular dial (fuel/pressure-style), 270° opening.
  circular,

  /// A straight scale with a sliding pointer.
  linear,

  /// Altimeter-style: a fast "fine" needle (one turn per [Gauge.majorStep],
  /// reused here as the fine needle's cycle length) plus a slow "coarse"
  /// needle (one turn over the whole [Gauge.rangeMax]) -- the classic
  /// hundreds/thousands two-pointer reading.
  multiNeedle,

  /// A rolling-digit odometer/drum counter: read exactly, digit by digit.
  drum,
}

/// Pure needle/pointer <-> value geometry, shared by the painters
/// (`presentation/gauge_painter.dart`) and unit-tested on its own so the
/// forward map (used to draw) and its inverse (used only by tests, to prove
/// the drawing is unambiguous) can never quietly drift apart.
///
/// [circular]'s 270°-opening convention matches `ArcGauge`
/// (`shared/widgets/arc_gauge.dart`) for visual consistency with the rest of
/// the app; [multiNeedle] needles sweep the full circle instead (a real
/// altimeter's pointers are not open like a fuel gauge).
abstract final class GaugeGeometry {
  static const double startAngle = 0.75 * math.pi;
  static const double sweepAngle = 1.5 * math.pi;
  static const double _twoPi = 2 * math.pi;

  /// Needle angle for [value] in `[rangeMin, rangeMax]` (clamped), on the
  /// 270°-opening dial.
  static double circularAngleForValue(num value, num rangeMin, num rangeMax) {
    final fraction = _fraction(value, rangeMin, rangeMax);
    return startAngle + sweepAngle * fraction;
  }

  /// Inverse of [circularAngleForValue]: the value a needle pointing at
  /// [angle] (any real radian value) reads, clamped to `[rangeMin,
  /// rangeMax]`. An angle inside the dial's 90° opening (never produced by
  /// [circularAngleForValue] itself) clamps to whichever end of the sweep
  /// it sits closer to.
  static double circularValueForAngle(
    double angle,
    num rangeMin,
    num rangeMax,
  ) {
    final sinceStart = _normaliseTurn(angle - startAngle);
    double fraction;
    if (sinceStart <= sweepAngle) {
      fraction = sinceStart / sweepAngle;
    } else {
      const gapMidpoint = sweepAngle + (_twoPi - sweepAngle) / 2;
      fraction = sinceStart < gapMidpoint ? 1.0 : 0.0;
    }
    return rangeMin + (rangeMax - rangeMin) * fraction.clamp(0.0, 1.0);
  }

  /// Pointer fraction (0..1) along a linear scale for [value].
  static double linearFractionForValue(num value, num rangeMin, num rangeMax) =>
      _fraction(value, rangeMin, rangeMax);

  /// Inverse of [linearFractionForValue].
  static double linearValueForFraction(
    double fraction,
    num rangeMin,
    num rangeMax,
  ) => rangeMin + (rangeMax - rangeMin) * fraction.clamp(0.0, 1.0);

  /// Full-turn angle of the fast ("fine") needle: one revolution every
  /// [minorCycle] units, wrapping `value % minorCycle`.
  static double fineAngleForValue(num value, num minorCycle) =>
      _twoPi * (_wrap(value, minorCycle) / minorCycle);

  /// Full-turn angle of the slow ("coarse") needle: one revolution over the
  /// whole [rangeMax].
  static double coarseAngleForValue(num value, num rangeMax) =>
      _twoPi * (_wrap(value, rangeMax) / rangeMax);

  /// Inverts a pair of multi-needle angles back into the value they
  /// describe: the fine angle gives the exact position within one
  /// [minorCycle] bracket, the coarse angle picks which bracket (exactly,
  /// since both angles are exact -- no reading ambiguity is introduced by
  /// this inversion, only by the visual resolution the tolerance already
  /// accounts for).
  static double valueForNeedleAngles(
    double fineAngle,
    double coarseAngle,
    num minorCycle,
    num rangeMax,
  ) {
    final fineValue = _normaliseTurn(fineAngle) / _twoPi * minorCycle;
    final coarseValue = _normaliseTurn(coarseAngle) / _twoPi * rangeMax;
    final bracketCount = (rangeMax / minorCycle).round();
    var bracket = ((coarseValue - fineValue) / minorCycle).round();
    if (bracket < 0) bracket = 0;
    if (bracket > bracketCount - 1) bracket = bracketCount - 1;
    return bracket * minorCycle + fineValue;
  }

  static double _fraction(num value, num rangeMin, num rangeMax) {
    final span = rangeMax - rangeMin;
    if (span == 0) return 0;
    return ((value - rangeMin) / span).clamp(0.0, 1.0).toDouble();
  }

  static double _wrap(num value, num modulus) {
    final m = value.toDouble() % modulus.toDouble();
    return m < 0 ? m + modulus : m;
  }

  static double _normaliseTurn(double angle) {
    var a = angle % _twoPi;
    if (a < 0) a += _twoPi;
    return a;
  }
}

/// One instrument of a `p1_counters` panel: purely a value, always
/// recomputed from `(seed, difficulty, params)` by
/// `CountersRecipe.build` -- never stored on the materialised [Item] (same
/// convention as `arithmetic_grid`/`planning_tubes`, see their engine doc
/// comments).
///
/// [majorStep] is overloaded by [kind]: the spacing between two labelled
/// ticks for [GaugeKind.circular]/[GaugeKind.linear]/[GaugeKind.drum], and
/// the fine needle's revolution length (`minorCycle`) for
/// [GaugeKind.multiNeedle] -- both play the same role (the unit [value] is
/// quantised to before an optional sub-tick offset is added), so one field
/// covers every kind without a kind-specific union.
class Gauge {
  const Gauge({
    required this.kind,
    required this.label,
    required this.rangeMin,
    required this.rangeMax,
    required this.majorStep,
    required this.minorPerMajor,
    required this.value,
    this.decimals = 0,
    this.unit,
    this.digitCount,
  }) : assert(minorPerMajor > 0, 'minorPerMajor must be positive'),
       assert(rangeMax > rangeMin, 'rangeMax must exceed rangeMin');

  final GaugeKind kind;

  /// 'A'..'D': how the panel and the MCQ options refer to this gauge.
  final String label;
  final num rangeMin;
  final num rangeMax;
  final num majorStep;

  /// Minor ticks drawn between two major ticks -- the difficulty knob for
  /// "sub-division density" (spec: fast, accurate reading).
  final int minorPerMajor;

  /// The true reading. Always within half a [minorStep] of a tick, and
  /// (spec: "unambiguous at the drawn resolution") never within
  /// [tolerance] of the *next* tick, so a candidate reading the drawn
  /// gauge lands on exactly one minor division.
  final num value;
  final int decimals;
  final String? unit;

  /// [GaugeKind.drum] only: how many digits the drum shows.
  final int? digitCount;

  num get minorStep => majorStep / minorPerMajor;

  /// Half a minor division: the reading tolerance every question about
  /// this gauge alone scores with.
  num get tolerance => minorStep / 2;

  /// [GaugeKind.multiNeedle] only: the fine needle's revolution span (see
  /// the class doc on [majorStep]'s overload).
  num get minorCycle => majorStep;
}
