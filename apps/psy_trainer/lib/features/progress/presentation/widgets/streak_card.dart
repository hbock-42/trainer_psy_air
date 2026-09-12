import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/daily_goal.dart';
import '../../domain/streak_service.dart';
import 'activity_heatmap.dart';

/// Dashboard card (US-073): the current/best streak, today's progress
/// against the daily goal (a small [ArcGauge] ring) and the 12-week activity
/// heat-map.
class StreakCard extends StatelessWidget {
  const StreakCard({required this.summary, super.key});

  final StreakSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = context.l10n;
    final goalLabel = summary.goal.unit == GoalUnit.items
        ? l10n.streakGoalItems(summary.todayItems, summary.goal.target)
        : l10n.streakGoalMinutes(
            summary.todayMinutes.round(),
            summary.goal.target,
          );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.streakCardTitle.toUpperCase(),
            style: theme.textStyles.label.copyWith(
              color: theme.colors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: theme.spacing.md),
          Row(
            children: [
              ArcGauge(
                value: summary.progressRatio,
                size: 88,
                color: summary.goalMet
                    ? theme.colors.success
                    : theme.colors.accent,
                semanticsLabel: l10n.streakSemanticsLabel,
                semanticsValue: l10n.streakSemanticsValue(
                  summary.currentStreak,
                  summary.bestStreak,
                  goalLabel,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${summary.currentStreak}',
                    style: theme.textStyles.title,
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(width: theme.spacing.lg),
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.streakDays(summary.currentStreak),
                        style: theme.textStyles.bodyStrong,
                      ),
                      SizedBox(height: theme.spacing.xs),
                      Text(
                        l10n.streakBest(summary.bestStreak),
                        style: theme.textStyles.caption,
                      ),
                      SizedBox(height: theme.spacing.xs),
                      Text(goalLabel, style: theme.textStyles.caption),
                      if (summary.goalMet) ...[
                        SizedBox(height: theme.spacing.xs),
                        Text(
                          l10n.streakGoalMet,
                          style: theme.textStyles.caption.copyWith(
                            color: theme.colors.success,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: theme.spacing.md),
          ActivityHeatmap(
            days: summary.heatmap,
            semanticsLabel: l10n.activityHeatmapSemanticsLabel,
            semanticsValue: l10n.activityHeatmapSemanticsValue(
              summary.heatmap.where((d) => d.itemCount > 0).length,
              summary.heatmap.length,
            ),
          ),
        ],
      ),
    );
  }
}
