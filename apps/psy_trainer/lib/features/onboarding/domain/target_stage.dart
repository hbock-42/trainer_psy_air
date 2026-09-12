/// The selection stage the user is preparing for.
///
/// Stored in `UserProfile.targetStage` by [key]. Only PSY0 has content
/// today; the others are listed in onboarding as "coming soon" so the choice
/// is recorded once their trainers exist (EPIC-10, EPIC-11).
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
  bool get isAvailable => this == psy0;

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
