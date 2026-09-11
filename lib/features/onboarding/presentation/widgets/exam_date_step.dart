import 'package:flutter/widgets.dart';

import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/exam_date_rules.dart';
import 'date_stepper_field.dart';
import 'onboarding_step_layout.dart';

/// Step 2: the exam date, optional. Shows the suggested next PSY0 session
/// and a day/month/year stepper; a date before today is refused inline.
class ExamDateStep extends StatelessWidget {
  const ExamDateStep({
    required this.date,
    required this.now,
    required this.onDateChanged,
    required this.onContinue,
    required this.onUnknown,
    super.key,
  });

  /// How many years ahead of [now] the year stepper goes.
  static const int yearsAhead = 5;

  /// The draft date (UTC calendar day).
  final DateTime date;

  /// Reference instant for validation and the suggestion.
  final DateTime now;
  final ValueChanged<DateTime> onDateChanged;

  /// Called with the validated [date]; the button is disabled otherwise.
  final ValueChanged<DateTime> onContinue;

  /// "I don't know yet": continue without a date.
  final VoidCallback onUnknown;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final spacing = theme.spacing;
    final error = validateExamDate(date, now: now);
    final suggestion = nextPsy0Date(now);

    return OnboardingStepLayout(
      headline: AppStrings.onboardingExamDateHeadline,
      intro: AppStrings.onboardingExamDateIntro,
      content: [
        Text.rich(
          TextSpan(
            text: AppStrings.onboardingExamDateSuggestion,
            children: [
              TextSpan(
                text: AppStrings.formatLongDate(suggestion),
                style: theme.textStyles.bodyStrong,
              ),
            ],
          ),
          style: theme.textStyles.body,
        ),
        SizedBox(height: spacing.lg),
        DateStepperField(
          value: date,
          onChanged: onDateChanged,
          minYear: now.year,
          maxYear: now.year + yearsAhead,
        ),
        SizedBox(height: spacing.md),
        Text(
          AppStrings.formatLongDate(date),
          style: theme.textStyles.bodyStrong,
          textAlign: TextAlign.center,
        ),
        if (error != null) ...[
          SizedBox(height: spacing.sm),
          Semantics(
            liveRegion: true,
            child: Text(
              _message(error),
              style: theme.textStyles.label.copyWith(color: theme.colors.error),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
      actions: [
        PrimaryButton(
          label: AppStrings.actionContinue,
          expand: true,
          onPressed: error == null ? () => onContinue(date) : null,
        ),
        SecondaryButton(
          label: AppStrings.onboardingExamDateUnknown,
          expand: true,
          onPressed: onUnknown,
        ),
      ],
    );
  }

  static String _message(ExamDateError error) => switch (error) {
    ExamDateError.inThePast => AppStrings.onboardingExamDateInThePast,
  };
}
