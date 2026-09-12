import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_extensions.dart';
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
      headline: context.l10n.onboardingWelcomeHeadline,
      intro: context.l10n.onboardingWelcomeIntro,
      content: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.disclaimerTitle, style: theme.textStyles.title),
              SizedBox(height: spacing.sm),
              Text(context.l10n.disclaimerParagraph1),
              SizedBox(height: spacing.sm),
              Text(context.l10n.disclaimerParagraph2),
            ],
          ),
        ),
        SizedBox(height: spacing.lg),
        AcceptToggle(
          value: accepted,
          label: context.l10n.onboardingDisclaimerAccept,
          onChanged: onAcceptedChanged,
        ),
        if (!accepted) ...[
          SizedBox(height: spacing.sm),
          Text(
            context.l10n.onboardingDisclaimerRequired,
            style: theme.textStyles.caption,
          ),
        ],
      ],
      actions: [
        PrimaryButton(
          label: context.l10n.actionContinue,
          expand: true,
          onPressed: accepted ? onContinue : null,
        ),
      ],
    );
  }
}
