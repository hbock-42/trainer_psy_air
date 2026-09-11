import 'package:flutter/widgets.dart';

import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import 'accept_toggle.dart';
import 'onboarding_step_layout.dart';

/// Step 1: welcome text and the unofficial-trainer disclaimer, which must be
/// accepted before going any further (no skip on this step).
class WelcomeStep extends StatelessWidget {
  const WelcomeStep({
    required this.accepted,
    required this.onAcceptedChanged,
    required this.onContinue,
    super.key,
  });

  final bool accepted;
  final ValueChanged<bool> onAcceptedChanged;

  /// Called on "Continue"; the button is disabled until [accepted].
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final spacing = theme.spacing;

    return OnboardingStepLayout(
      headline: AppStrings.onboardingWelcomeHeadline,
      intro: AppStrings.onboardingWelcomeIntro,
      content: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.disclaimerTitle, style: theme.textStyles.title),
              SizedBox(height: spacing.sm),
              const Text(AppStrings.disclaimerParagraph1),
              SizedBox(height: spacing.sm),
              const Text(AppStrings.disclaimerParagraph2),
            ],
          ),
        ),
        SizedBox(height: spacing.lg),
        AcceptToggle(
          value: accepted,
          label: AppStrings.onboardingDisclaimerAccept,
          onChanged: onAcceptedChanged,
        ),
        if (!accepted) ...[
          SizedBox(height: spacing.sm),
          Text(
            AppStrings.onboardingDisclaimerRequired,
            style: theme.textStyles.caption,
          ),
        ],
      ],
      actions: [
        PrimaryButton(
          label: AppStrings.actionContinue,
          expand: true,
          onPressed: accepted ? onContinue : null,
        ),
      ],
    );
  }
}
