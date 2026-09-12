import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/error_logger.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../domain/progress_snapshot.dart';
import '../domain/recommendation.dart';
import 'providers/dashboard_labels_provider.dart';
import 'providers/exam_date_provider.dart';
import 'providers/progress_snapshot_provider.dart';
import 'providers/recent_activity_provider.dart';
import 'providers/recommendations_provider.dart';
import 'widgets/exam_score_chart_card.dart';
import 'widgets/family_levels_chart.dart';
import 'widgets/progress_bands.dart';
import 'widgets/progress_empty_state.dart';
import 'widgets/readiness_card.dart';
import 'widgets/recent_activity_list.dart';
import 'widgets/train_next_card.dart';

/// The Progress tab (US-070): readiness gauge, days until the exam, family
/// levels chart, "train next" recommendations (US-072) and recent activity,
/// all read from the cached stats providers (refreshed through
/// `progressVersionProvider`).
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  void _goTrain(BuildContext context) =>
      GoRouter.of(context).go(AppRoutes.train);

  /// Where a recommendation's one-tap action goes. A weak tag has no
  /// dedicated launcher target (the practice launcher is family-scoped, see
  /// the story's final report), so it falls back to the Train tab like the
  /// pre-US-072 weak-area preview did.
  void _onRecommendation(BuildContext context, Recommendation rec) {
    final router = GoRouter.of(context);
    switch (rec.kind) {
      case RecommendationKind.family:
        router.go(AppRoutes.trainFamily(rec.targetId!));
      case RecommendationKind.tag:
        router.go(AppRoutes.train);
      case RecommendationKind.examSim:
        router.go(AppRoutes.exam);
      case RecommendationKind.lesson:
        router.go(AppRoutes.learnLesson(rec.targetId!, rec.secondaryId!));
      case RecommendationKind.flashcards:
        router.go(AppRoutes.learnCards);
    }
  }

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
      title: context.l10n.progressTitle,
      body: switch (snapshot) {
        AsyncData(:final value) when value.isEmpty => ProgressEmptyState(
          onStart: () => _goTrain(context),
        ),
        AsyncData(:final value) => _Dashboard(
          snapshot: value,
          onRecommendation: (rec) => _onRecommendation(context, rec),
        ),
        AsyncError() => _Message(
          context.l10n.progressError,
          style: theme.textStyles.body.copyWith(color: theme.colors.error),
        ),
        _ => _Message(context.l10n.progressLoading, style: theme.textStyles.body),
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
  const _Dashboard({required this.snapshot, required this.onRecommendation});

  final ProgressSnapshot snapshot;
  final ValueChanged<Recommendation> onRecommendation;

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
    final recommendations =
        ref.watch(recommendationsProvider).value ?? const <Recommendation>[];

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
                SectionHeader(
                  title: context.l10n.familyLevelsTitle,
                  subtitle: context.l10n.familyLevelsSubtitle,
                ),
                SizedBox(height: theme.spacing.md),
                AppCard(
                  child: FamilyLevelsChart(
                    families: snapshot.families,
                    labels: labels,
                    onFamilySelected: (id) =>
                        GoRouter.of(context).go(AppRoutes.progressFamily(id)),
                  ),
                ),
                SizedBox(height: theme.spacing.xl),
                // Hidden (header included) until a simulation is completed.
                ExamScoreChartCard(labels: labels),
                SectionHeader(
                  title: context.l10n.trainNextTitle,
                  subtitle: context.l10n.trainNextSubtitle,
                ),
                SizedBox(height: theme.spacing.md),
                TrainNextCard(
                  recommendations: recommendations,
                  onAction: onRecommendation,
                ),
                SizedBox(height: theme.spacing.xl),
                SectionHeader(
                  title: context.l10n.recentActivityTitle,
                  subtitle: context.l10n.recentActivitySubtitle,
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
