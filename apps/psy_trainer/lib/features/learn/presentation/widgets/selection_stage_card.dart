import 'package:flutter/widgets.dart';

import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/selection_stage.dart';
import 'confidence_chip.dart';

/// One step of the selection timeline on the "how it works" page: number,
/// title, when/where, description and confidence-tagged facts.
class SelectionStageCard extends StatelessWidget {
  const SelectionStageCard({
    required this.stage,
    required this.index,
    super.key,
  });

  final SelectionStage stage;

  /// 1-based position in the timeline.
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final badgeColor = stage.isTarget ? colors.accent : colors.accentSubtle;
    final badgeText = stage.isTarget ? colors.onAccent : colors.textPrimary;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: theme.spacing.xxl,
            height: theme.spacing.xxl,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: theme.radii.fullAll,
            ),
            child: Text(
              '$index',
              style: theme.textStyles.label.copyWith(color: badgeText),
            ),
          ),
          SizedBox(width: theme.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(stage.title, style: theme.textStyles.title),
                ),
                SizedBox(height: theme.spacing.xs),
                Text(stage.when, style: theme.textStyles.caption),
                SizedBox(height: theme.spacing.sm),
                Text(stage.body),
                SizedBox(height: theme.spacing.md),
                Wrap(
                  spacing: theme.spacing.sm,
                  runSpacing: theme.spacing.sm,
                  children: [
                    if (stage.eliminatory)
                      ConfidenceChip(
                        confidence: stage.confidence,
                        text: AppStrings.howItWorksEliminatory,
                      ),
                    for (final fact in stage.facts)
                      ConfidenceChip(
                        confidence: fact.confidence,
                        text: fact.text,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
