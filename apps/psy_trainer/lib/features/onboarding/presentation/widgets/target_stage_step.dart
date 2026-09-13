import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/target_stage.dart';
import 'onboarding_step_layout.dart';

/// Step 3: the stage the user prepares. PSY0, PSY1 and PSY2 (US-111/US-112)
/// are all selectable.
class TargetStageStep extends StatelessWidget {
  const TargetStageStep({
    required this.selected,
    required this.onSelected,
    required this.onFinish,
    required this.finishLabel,
    super.key,
  });

  final TargetStage selected;
  final ValueChanged<TargetStage> onSelected;

  /// Null while a submission is in flight (button disabled).
  final VoidCallback? onFinish;

  /// "Finish" when onboarding, "Save" when editing from Settings.
  final String finishLabel;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final spacing = theme.spacing;

    return OnboardingStepLayout(
      headline: context.l10n.onboardingStageHeadline,
      intro: context.l10n.onboardingStageIntro,
      content: [
        for (final stage in TargetStage.values) ...[
          if (stage != TargetStage.values.first) SizedBox(height: spacing.sm),
          _StageTile(
            stage: stage,
            selected: stage == selected,
            onPressed: stage.isAvailable ? () => onSelected(stage) : null,
          ),
        ],
      ],
      actions: [
        PrimaryButton(label: finishLabel, expand: true, onPressed: onFinish),
      ],
    );
  }
}

class _StageTile extends StatelessWidget {
  const _StageTile({
    required this.stage,
    required this.selected,
    required this.onPressed,
  });

  final TargetStage stage;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final title = switch (stage) {
      TargetStage.psy0 => context.l10n.stagePsy0Title,
      TargetStage.psy1 => context.l10n.stagePsy1Title,
      TargetStage.psy2 => context.l10n.stagePsy2Title,
    };
    final subtitle = switch (stage) {
      TargetStage.psy0 => context.l10n.stagePsy0Subtitle,
      TargetStage.psy1 => context.l10n.stagePsy1Subtitle,
      TargetStage.psy2 => context.l10n.stagePsy2Subtitle,
    };
    final state = !stage.isAvailable
        ? AnswerOptionState.disabled
        : selected
        ? AnswerOptionState.selected
        : AnswerOptionState.idle;

    return AnswerOptionTile(
      label: '$title. $subtitle',
      state: state,
      onPressed: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          SizedBox(height: theme.spacing.xs),
          Row(
            children: [
              if (!stage.isAvailable)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colors.warningSubtle,
                    borderRadius: theme.radii.fullAll,
                  ),
                  child: Text(
                    subtitle,
                    style: theme.textStyles.caption.copyWith(
                      color: theme.colors.warning,
                    ),
                  ),
                )
              else
                Flexible(
                  child: Text(subtitle, style: theme.textStyles.caption),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
