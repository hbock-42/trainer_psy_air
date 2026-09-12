import '../../../core/repositories/model/learning.dart';
import 'target_stage.dart';

/// What onboarding collects, and how it is mapped to and from [UserProfile].
///
/// The profile already has typed columns for `examDate` and `targetStage`;
/// the two onboarding flags live in its free-form `settings` map under
/// [settingsKeyCompleted] and [settingsKeyDisclaimerAcceptedAt] (see
/// `docs/ARCHITECTURE.md`, "JSON blobs"), so no schema migration is needed.
class OnboardingAnswers {
  const OnboardingAnswers({
    required this.disclaimerAcceptedAt,
    required this.targetStage,
    this.examDate,
  });

  /// Answers used when the user skips the questions: no exam date, default
  /// stage. The disclaimer is still accepted (it cannot be skipped).
  const OnboardingAnswers.skipped({required this.disclaimerAcceptedAt})
    : targetStage = TargetStage.defaultStage,
      examDate = null;

  /// `settings` key of the completion flag (`bool`).
  static const String settingsKeyCompleted = 'onboardingCompleted';

  /// `settings` key of the disclaimer acceptance instant (ISO-8601, UTC).
  static const String settingsKeyDisclaimerAcceptedAt = 'disclaimerAcceptedAt';

  /// Locale written when the profile is first created (French only, US-091
  /// adds the setting).
  static const String defaultLocale = 'fr';

  /// When the user accepted the disclaimer (UTC).
  final DateTime disclaimerAcceptedAt;

  /// The exam day (UTC midnight), or null for "I don't know yet".
  final DateTime? examDate;

  final TargetStage targetStage;

  /// Whether [profile] records a completed onboarding.
  static bool isCompleted(UserProfile? profile) =>
      profile?.settings[settingsKeyCompleted] == true;

  /// Reads the answers back from a profile; null when the profile does not
  /// carry a completed onboarding (never ran, or a legacy row).
  static OnboardingAnswers? fromProfile(UserProfile? profile) {
    if (profile == null || !isCompleted(profile)) return null;
    final raw = profile.settings[settingsKeyDisclaimerAcceptedAt];
    final acceptedAt = raw is String ? DateTime.tryParse(raw) : null;
    if (acceptedAt == null) return null;
    return OnboardingAnswers(
      disclaimerAcceptedAt: acceptedAt.toUtc(),
      examDate: profile.examDate?.toUtc(),
      targetStage: TargetStage.fromKey(
        profile.targetStage,
        fallback: TargetStage.defaultStage,
      )!,
    );
  }

  /// The profile to save: [existing] (if any) with these answers applied.
  /// Other `settings` entries and the locale are preserved.
  UserProfile applyTo(UserProfile? existing) {
    return UserProfile(
      locale: existing?.locale ?? defaultLocale,
      settings: {
        ...?existing?.settings,
        settingsKeyCompleted: true,
        settingsKeyDisclaimerAcceptedAt: disclaimerAcceptedAt
            .toUtc()
            .toIso8601String(),
      },
      examDate: examDate,
      targetStage: targetStage.key,
    );
  }

  OnboardingAnswers copyWith({
    DateTime? disclaimerAcceptedAt,
    DateTime? Function()? examDate,
    TargetStage? targetStage,
  }) {
    return OnboardingAnswers(
      disclaimerAcceptedAt: disclaimerAcceptedAt ?? this.disclaimerAcceptedAt,
      examDate: examDate == null ? this.examDate : examDate(),
      targetStage: targetStage ?? this.targetStage,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OnboardingAnswers &&
        other.disclaimerAcceptedAt == disclaimerAcceptedAt &&
        other.examDate == examDate &&
        other.targetStage == targetStage;
  }

  @override
  int get hashCode => Object.hash(disclaimerAcceptedAt, examDate, targetStage);

  @override
  String toString() {
    return 'OnboardingAnswers(disclaimerAcceptedAt: $disclaimerAcceptedAt, '
        'examDate: $examDate, targetStage: $targetStage)';
  }
}
