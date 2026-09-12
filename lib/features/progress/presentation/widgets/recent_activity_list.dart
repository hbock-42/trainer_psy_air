import 'package:flutter/widgets.dart';

import '../../../../core/l10n/strings.dart';
import '../../../../core/repositories/model/session.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/dashboard_labels_provider.dart';
import '../providers/recent_activity_provider.dart';
import 'progress_bands.dart';

/// The last finished sessions, newest first: kind and family / blueprint,
/// date, score.
class RecentActivityList extends StatelessWidget {
  const RecentActivityList({
    required this.activities,
    required this.labels,
    super.key,
  });

  final List<RecentActivity> activities;
  final DashboardLabels labels;

  /// `12/09/2026 14:32` in local time (no `intl` dependency yet; US-091
  /// will localise it).
  static String formatDate(DateTime date) {
    final d = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    if (activities.isEmpty) {
      return Text(
        AppStrings.recentActivityNone,
        style: theme.textStyles.caption,
      );
    }
    final locale = Localizations.maybeLocaleOf(context)?.languageCode ?? 'fr';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < activities.length; i++) ...[
          if (i > 0) SizedBox(height: theme.spacing.sm),
          _ActivityTile(
            activity: activities[i],
            labels: labels,
            locale: locale,
          ),
        ],
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.activity,
    required this.labels,
    required this.locale,
  });

  final RecentActivity activity;
  final DashboardLabels labels;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;

    final kind = activity.isExam
        ? AppStrings.activityExam
        : AppStrings.activityPractice;
    final subject = activity.isExam
        ? (activity.blueprintId == null
              ? null
              : labels.blueprintName(activity.blueprintId!, locale: locale))
        : (activity.familyId == null
              ? null
              : labels.familyName(
                  activity.familyId!,
                  locale: locale,
                  short: false,
                ));
    final title = subject == null ? kind : '$kind · $subject';
    final date = RecentActivityList.formatDate(activity.startedAt);
    final status = activity.status == SessionStatus.abandoned
        ? AppStrings.activityAbandoned
        : null;
    final meta = status == null ? date : '$date · $status';
    final percent = activity.percent;
    final scoreText = percent == null
        ? AppStrings.scoreUnknown
        : AppStrings.scorePercent(percent);
    final scoreColor = activity.score == null
        ? colors.textMuted
        : ProgressBands.score(theme, activity.score!);

    return Semantics(
      container: true,
      label: title,
      value: '$meta, $scoreText',
      child: ExcludeSemantics(
        child: AppCard(
          padding: EdgeInsets.all(theme.spacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: theme.textStyles.bodyStrong),
                    SizedBox(height: theme.spacing.xs),
                    Text(meta, style: theme.textStyles.caption),
                  ],
                ),
              ),
              SizedBox(width: theme.spacing.md),
              Text(
                scoreText,
                style: theme.textStyles.numeric.copyWith(color: scoreColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
