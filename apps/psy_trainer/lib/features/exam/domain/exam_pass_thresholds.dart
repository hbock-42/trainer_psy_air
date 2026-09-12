/// Estimated pass thresholds shown on the exam report (US-062).
///
/// The real PSY0 board never discloses a pass mark (`docs/content/
/// psy0-spec.md` §2.2: a ranking, not a threshold); this is a configurable
/// in-app estimate, always labelled "estimation" in the UI. Keyed by
/// [ExamBlueprint.id]; [defaultThreshold] covers any blueprint not listed
/// here (a new blueprint, a custom one later).
abstract final class ExamPassThresholds {
  /// 0..1 score fraction, matching `ExamSummary.score`.
  static const double defaultThreshold = 0.65;

  static const Map<String, double> byBlueprintId = {
    'psy0.blueprint.full': 0.65,
    'psy0.blueprint.short': 0.65,
  };

  static double of(String? blueprintId) =>
      byBlueprintId[blueprintId] ?? defaultThreshold;
}
