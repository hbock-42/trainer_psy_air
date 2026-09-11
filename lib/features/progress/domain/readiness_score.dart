import 'package:freezed_annotation/freezed_annotation.dart';

part 'readiness_score.freezed.dart';

/// How ready the candidate is, 0..100, and the three normalised components
/// (each 0..1) it was mixed from with the configured weights (see
/// `StatsConfig.readinessWeights` and `docs/ARCHITECTURE.md`).
@freezed
abstract class ReadinessScore with _$ReadinessScore {
  const factory ReadinessScore({
    required double value,

    /// Weighted mean of family level fractions over all families.
    required double familyComponent,

    /// Lessons read / lessons available (0 when there are no lessons).
    required double lessonComponent,

    /// Mean global score of the most recent exam simulations (0 without).
    required double examComponent,
    required int familiesPractised,
    required int familiesTotal,
    required int lessonsRead,
    required int lessonsTotal,
    required int examsCounted,
  }) = _ReadinessScore;

  const ReadinessScore._();

  int get rounded => value.round();

  bool get hasAnyData =>
      familiesPractised > 0 || lessonsRead > 0 || examsCounted > 0;
}
