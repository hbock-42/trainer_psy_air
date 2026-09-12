import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/error_logger.dart';
import '../../../core/l10n/strings.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../domain/progress_snapshot.dart';
import 'providers/dashboard_labels_provider.dart';
import 'providers/exam_date_provider.dart';
import 'providers/progress_snapshot_provider.dart';
import 'providers/recent_activity_provider.dart';
import 'widgets/family_levels_chart.dart';
import 'widgets/progress_bands.dart';
import 'widgets/progress_empty_state.dart';
import 'widgets/readiness_card.dart';
import 'widgets/recent_activity_list.dart';
import 'widgets/weak_areas_preview.dart';

/// The Progress tab (US-070): readiness gauge, days until the exam, family
/// levels chart, weak areas and recent activity, all read from the cached
/// stats providers (refreshed through `progressVersionProvider`).
///
/// "Train" actions go to the Train tab for now; US-072 will target the
/// weak family directly.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  void _goTrain(BuildContext context) =>
      GoRouter.of(context).go(AppRoutes.train);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    ref.listen(progressSnapshotProvider, (_, next) {
      if (next case AsyncError(:final error, :final stackTrace)) {
        logError(error, stackTrace, context: 'progress snapshot');
      }
    });
    final snapshot = ref.watch(progressSnapshotProvider);
    return AppScaffold(
      title: AppStrings.progressTitle,
      body: switch (snapshot) {
        AsyncData(:final value) when value.isEmpty => ProgressEmptyState(
          onStart: () => _goTrain(context),
        ),
        AsyncData(:final value) => _Dashboard(
          snapshot: value,
          onTrain: () => _goTrain(context),
        ),
        AsyncError() => _Message(
          AppStrings.progressError,
          style: theme.textStyles.body.copyWith(color: theme.colors.error),
        ),
        _ => _Message(AppStrings.progressLoading, style: theme.textStyles.body),
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text, {required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.xl),
        child: Text(text, style: style, textAlign: TextAlign.center),
      ),
    );
  }
}

class _Dashboard extends ConsumerWidget {
  const _Dashboard({required this.snapshot, required this.onTrain});

  final ProgressSnapshot snapshot;
  final VoidCallback onTrain;

  /// Content of the dashboard is kept readable on wide windows.
  static const double _maxContentWidth = 720;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final labels =
        ref.watch(dashboardLabelsProvider).value ?? DashboardLabels.empty;
    final examDate = ref.watch(examDateProvider).value;
    final activities =
        ref.watch(recentActivityProvider).value ?? const <RecentActivity>[];

    return ListView(
      padding: EdgeInsets.all(theme.spacing.lg),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ReadinessCard(
                  readiness: snapshot.readiness,
                  trend: overallTrend(snapshot.families),
                  examDaysLeft: examDate == null
                      ? null
                      : daysUntil(examDate, snapshot.computedAt),
                ),
                SizedBox(height: theme.spacing.xl),
                const SectionHeader(
                  title: AppStrings.familyLevelsTitle,
                  subtitle: AppStrings.familyLevelsSubtitle,
                ),
                SizedBox(height: theme.spacing.md),
                AppCard(
                  child: FamilyLevelsChart(
                    families: snapshot.families,
                    labels: labels,
                  ),
                ),
                SizedBox(height: theme.spacing.xl),
                const SectionHeader(
                  title: AppStrings.weakAreasTitle,
                  subtitle: AppStrings.weakAreasSubtitle,
                ),
                SizedBox(height: theme.spacing.md),
                WeakAreasPreview(
                  weakAreas: snapshot.weakAreas,
                  labels: labels,
                  onTrain: (_) => onTrain(),
                ),
                SizedBox(height: theme.spacing.xl),
                const SectionHeader(
                  title: AppStrings.recentActivityTitle,
                  subtitle: AppStrings.recentActivitySubtitle,
                ),
                SizedBox(height: theme.spacing.md),
                RecentActivityList(activities: activities, labels: labels),
                SizedBox(height: theme.spacing.xl),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
