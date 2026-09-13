/// The selection stage the user is preparing for.
///
/// Stored in `UserProfile.targetStage` by [key]. PSY0, PSY1 (US-101) and
/// PSY2 (US-111/US-112) all have content today; PSY2 has no timed engine
/// (spec ethics note), only lessons, interview practice and self-assessment.
enum TargetStage {
  psy0('psy0'),
  psy1('psy1'),
  psy2('psy2');

  const TargetStage(this.key);

  /// Value persisted in the profile (`psy0` | `psy1` | `psy2`).
  final String key;

  /// The stage picked when the user skips the question.
  static const TargetStage defaultStage = psy0;

  /// Whether the app has a trainer for this stage.
  bool get isAvailable => true;

  /// Parses a stored [key]; unknown or null values fall back to [fallback]
  /// (null by default).
  static TargetStage? fromKey(String? key, {TargetStage? fallback}) {
    if (key == null) return fallback;
    for (final stage in values) {
      if (stage.key == key) return stage;
    }
    return fallback;
  }
}
