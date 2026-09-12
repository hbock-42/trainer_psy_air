import 'reminder_scheduler.dart';

/// The facts a reminder's body can mention, gathered at schedule time
/// (`ReminderCoordinator`, from `flashcardsDueTodayProvider`,
/// `recommendationsProvider`'s weakest family and `examDateProvider`).
class ReminderContentInputs {
  const ReminderContentInputs({
    this.dueFlashcards = 0,
    this.weakestFamilyName,
    this.examDaysLeft,
  });

  /// Cards due across every deck (0 hides the flashcards line).
  final int dueFlashcards;

  /// Display name of the weakest family/tag (`DashboardLabels`), or `null`
  /// to omit the line (no attempts yet, or every area above the weak
  /// threshold).
  final String? weakestFamilyName;

  /// Whole days until the exam date (0 = today), or `null` when no date is
  /// set (onboarding skipped it).
  final int? examDaysLeft;
}

/// One already-localized line per fact [ReminderContentInputs] can carry,
/// plus the title and a fallback body for when none applies. Built by the
/// caller from `context.l10n` (a `BuildContext`-free record, so this module
/// stays presentation-agnostic and unit-testable without pumping a widget
/// tree) — see `ReminderCoordinator._lines`.
class ReminderLines {
  const ReminderLines({
    required this.title,
    required this.flashcardsDue,
    required this.weakestFamily,
    required this.examToday,
    required this.examCountdown,
    required this.fallback,
  });

  final String title;
  final String Function(int count) flashcardsDue;
  final String Function(String family) weakestFamily;
  final String examToday;
  final String Function(int days) examCountdown;
  final String fallback;
}

/// Picks which lines apply to a given [ReminderContentInputs] and joins
/// them into the notification body (pure Dart: no platform channel, no
/// `BuildContext`), so the selection rules — flashcards line only when due
/// > 0, exam line only when a date is set, "today" instead of "in 0 days",
/// the fallback when nothing applies — are unit-tested directly.
class ReminderContentBuilder {
  const ReminderContentBuilder();

  /// Separates the lines that do apply inside the notification body.
  static const String separator = ' · ';

  ReminderContent build({
    required ReminderContentInputs inputs,
    required ReminderLines lines,
  }) {
    final parts = <String>[
      if (inputs.dueFlashcards > 0) lines.flashcardsDue(inputs.dueFlashcards),
      if (inputs.weakestFamilyName != null)
        lines.weakestFamily(inputs.weakestFamilyName!),
      if (inputs.examDaysLeft != null && inputs.examDaysLeft! >= 0)
        inputs.examDaysLeft == 0
            ? lines.examToday
            : lines.examCountdown(inputs.examDaysLeft!),
    ];
    return ReminderContent(
      title: lines.title,
      body: parts.isEmpty ? lines.fallback : parts.join(separator),
    );
  }
}
