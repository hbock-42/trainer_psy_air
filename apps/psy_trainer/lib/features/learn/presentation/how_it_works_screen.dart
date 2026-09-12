import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import 'learn_screen.dart';
import 'selection_stages.dart';
import 'widgets/selection_stage_card.dart';

/// "How the selection works" (US-040): the stages of the Air France cadet
/// selection from `docs/content/psy0-spec.md` §1, each fact tagged with its
/// confidence, plus the 2026 calendar, the retake rules and the full
/// unofficial-trainer disclaimer (spec §7).
class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final secondary = theme.textStyles.body.copyWith(
      color: theme.colors.textSecondary,
    );

    return AppScaffold(
      title: context.l10n.learnHowItWorksTitle,
      onBack: context.pop,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: LearnScreen.maxContentWidth,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(theme.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(context.l10n.howItWorksIntro),
                SizedBox(height: theme.spacing.sm),
                Text(
                  context.l10n.confidenceLegend,
                  style: theme.textStyles.caption,
                ),
                SizedBox(height: theme.spacing.xl),
                SectionHeader(title: context.l10n.howItWorksStagesTitle),
                SizedBox(height: theme.spacing.md),
                for (final (i, stage) in selectionStagesOf(context).indexed) ...[
                  if (i > 0) SizedBox(height: theme.spacing.md),
                  SelectionStageCard(stage: stage, index: i + 1),
                ],
                SizedBox(height: theme.spacing.xl),
                SectionHeader(title: context.l10n.howItWorksCalendarTitle),
                SizedBox(height: theme.spacing.sm),
                Text(context.l10n.howItWorksCalendarBody, style: secondary),
                SizedBox(height: theme.spacing.xl),
                SectionHeader(title: context.l10n.howItWorksRetakeTitle),
                SizedBox(height: theme.spacing.sm),
                Text(context.l10n.howItWorksRetakeBody, style: secondary),
                SizedBox(height: theme.spacing.xl),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.disclaimerTitle,
                        style: theme.textStyles.bodyStrong,
                      ),
                      SizedBox(height: theme.spacing.sm),
                      Text(context.l10n.disclaimerParagraph1),
                      SizedBox(height: theme.spacing.sm),
                      Text(context.l10n.disclaimerParagraph2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
