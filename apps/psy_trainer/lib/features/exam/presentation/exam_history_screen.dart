import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/strings.dart';
import '../../../core/repositories/model/session.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../../progress/presentation/widgets/recent_activity_list.dart';
import 'providers/exam_history_provider.dart';

/// `/exam/history` (US-064, placeholder): every past simulation, newest
/// first, with its blueprint, date, status and score; tapping a finished
/// one opens its report (US-062). Resuming an interrupted exam and
/// deleting a simulation are the rest of US-064, not wired up here.
class ExamHistoryScreen extends ConsumerWidget {
  const ExamHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final history = ref.watch(examHistoryProvider);

    return AppScaffold(
      title: AppStrings.examHistoryTitle,
      onBack: () => context.pop(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: switch (history) {
          AsyncData(value: final list) when list.isEmpty => Text(
            AppStrings.examHistoryEmpty,
            style: theme.textStyles.body.copyWith(
              color: theme.colors.textSecondary,
            ),
          ),
          AsyncData(value: final list) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (i, entry) in list.indexed) ...[
                if (i > 0) SizedBox(height: theme.spacing.sm),
                _HistoryRow(entry: entry),
              ],
            ],
          ),
          AsyncError() => Text(
            AppStrings.examHistoryError,
            style: theme.textStyles.body.copyWith(
              color: theme.colors.textSecondary,
            ),
          ),
          _ => Text(
            AppStrings.examHistoryLoading,
            style: theme.textStyles.body.copyWith(
              color: theme.colors.textSecondary,
            ),
          ),
        },
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});

  final ExamHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final summary = entry.summary;
    final name = entry.blueprintName ?? summary.blueprintId ?? '?';
    final canOpen = summary.status != SessionStatus.inProgress;
    final statusLabel = switch (summary.status) {
      SessionStatus.completed => AppStrings.examHistoryStatusCompleted,
      SessionStatus.abandoned => AppStrings.examHistoryStatusAbandoned,
      SessionStatus.inProgress => AppStrings.examHistoryStatusInProgress,
    };

    return AppCard(
      key: Key('exam_history.row.${summary.sessionId}'),
      onPressed: canOpen
          ? () => context.push(AppRoutes.examReport(summary.sessionId))
          : null,
      semanticsLabel: '$name, $statusLabel',
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textStyles.bodyStrong),
                SizedBox(height: theme.spacing.xs),
                Text(
                  '${RecentActivityList.formatDate(summary.startedAt)} · '
                  '$statusLabel',
                  style: theme.textStyles.caption,
                ),
              ],
            ),
          ),
          if (summary.status == SessionStatus.completed)
            Text('${summary.percent} %', style: theme.textStyles.title),
        ],
      ),
    );
  }
}
