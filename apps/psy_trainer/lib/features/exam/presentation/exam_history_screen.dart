import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/strings.dart';
import '../../../core/repositories/model/session.dart';
import '../../../core/repositories/repository_providers.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../../progress/presentation/providers/progress_version_provider.dart';
import '../../progress/presentation/widgets/recent_activity_list.dart';
import 'providers/exam_history_provider.dart';

/// `/exam/history` (US-064): every past simulation, newest first, with its
/// blueprint, date, duration, status and score; tapping a finished one
/// opens its report (US-062). Long-pressing a row asks to delete it
/// (`ProgressRepository.deleteSession`, cascading its attempts).
class ExamHistoryScreen extends ConsumerStatefulWidget {
  const ExamHistoryScreen({super.key});

  static const Key deleteConfirmKey = Key('exam_history.delete_confirm');
  static const Key deleteCancelKey = Key('exam_history.delete_cancel');

  @override
  ConsumerState<ExamHistoryScreen> createState() => _ExamHistoryScreenState();
}

class _ExamHistoryScreenState extends ConsumerState<ExamHistoryScreen> {
  ExamHistoryEntry? _pendingDelete;

  void _askDelete(ExamHistoryEntry entry) =>
      setState(() => _pendingDelete = entry);

  void _cancelDelete() => setState(() => _pendingDelete = null);

  Future<void> _confirmDelete() async {
    final entry = _pendingDelete;
    setState(() => _pendingDelete = null);
    if (entry == null) return;
    await ref
        .read(progressRepositoryProvider)
        .deleteSession(entry.summary.sessionId);
    ref.read(progressVersionProvider.notifier).bump();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final history = ref.watch(examHistoryProvider);
    final pending = _pendingDelete;

    return Stack(
      children: [
        AppScaffold(
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
                    _HistoryRow(
                      entry: entry,
                      onDelete: () => _askDelete(entry),
                    ),
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
        ),
        if (pending != null)
          _DeleteConfirmOverlay(
            theme: theme,
            onConfirm: _confirmDelete,
            onCancel: _cancelDelete,
          ),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry, required this.onDelete});

  final ExamHistoryEntry entry;
  final VoidCallback onDelete;

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
    final duration = entry.duration;
    final metaParts = [
      RecentActivityList.formatDate(summary.startedAt),
      if (duration != null)
        AppStrings.examHistoryDuration((duration.inSeconds / 60).round()),
      statusLabel,
    ];

    return GestureDetector(
      onLongPress: onDelete,
      child: AppCard(
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
                  Text(metaParts.join(' · '), style: theme.textStyles.caption),
                ],
              ),
            ),
            if (summary.status == SessionStatus.completed)
              Text('${summary.percent} %', style: theme.textStyles.title),
          ],
        ),
      ),
    );
  }
}

/// Confirmation overlay for deleting one simulation (long-press on its
/// row), styled like `ExamRunScreen`'s quit-confirmation overlay.
class _DeleteConfirmOverlay extends StatelessWidget {
  const _DeleteConfirmOverlay({
    required this.theme,
    required this.onConfirm,
    required this.onCancel,
  });

  final AppTheme theme;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: theme.colors.background.withValues(alpha: 0.92),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: EdgeInsets.all(theme.spacing.lg),
              child: AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStrings.examHistoryDeleteConfirmTitle,
                      style: theme.textStyles.title,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: theme.spacing.sm),
                    Text(
                      AppStrings.examHistoryDeleteConfirmBody,
                      style: theme.textStyles.body,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: theme.spacing.lg),
                    PrimaryButton(
                      key: ExamHistoryScreen.deleteConfirmKey,
                      label: AppStrings.examHistoryDeleteAction,
                      expand: true,
                      onPressed: onConfirm,
                    ),
                    SizedBox(height: theme.spacing.sm),
                    SecondaryButton(
                      key: ExamHistoryScreen.deleteCancelKey,
                      label: AppStrings.sessionQuitCancelAction,
                      expand: true,
                      onPressed: onCancel,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
