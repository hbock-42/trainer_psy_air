import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/error_logger.dart';
import '../../../core/l10n/strings.dart';
import '../../../core/repositories/model/session.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/widgets.dart';
import '../domain/stats_service.dart';
import 'providers/dashboard_labels_provider.dart';
import 'providers/family_time_series_provider.dart';
import 'providers/stats_service_provider.dart';
import 'widgets/family_trend_charts.dart';
import 'widgets/segmented_choice.dart';

/// The range of a score-over-time chart: the last 7 days, the last 30 days
/// (the windows of `StatsService`) or everything.
enum TrendRange {
  week(StatsService.shortWindow),
  month(StatsService.longWindow),
  all(null);

  const TrendRange(this.window);

  /// Length of the range; null for [all].
  final Duration? window;

  /// The lower bound of the range ending at [now]; null for [all].
  DateTime? from(DateTime now) => window == null ? null : now.subtract(window!);
}

/// Score-over-time charts of one family (`/progress/family/:familyId`,
/// US-071): accuracy and median response time per session, with a range
/// selector (7 j / 30 j / Tout) and a mode filter (exercises, simulations,
/// both). Reads [familyTimeSeriesProvider] for the chosen query.
class FamilyTrendScreen extends ConsumerStatefulWidget {
  const FamilyTrendScreen({
    required this.familyId,
    this.initialRange = TrendRange.month,
    super.key,
  });

  final String familyId;
  final TrendRange initialRange;

  /// Content of the page is kept readable on wide windows.
  static const double maxContentWidth = 720;

  @override
  ConsumerState<FamilyTrendScreen> createState() => _FamilyTrendScreenState();
}

class _FamilyTrendScreenState extends ConsumerState<FamilyTrendScreen> {
  late TrendRange _range = widget.initialRange;
  SessionMode? _mode;

  /// Read once: a `now` that moved on every build would make a new query
  /// (and a new provider instance) each frame.
  late final DateTime _now = ref.read(statsServiceProvider).now;

  static const List<SegmentedOption<TrendRange>> _ranges = [
    SegmentedOption(value: TrendRange.week, label: AppStrings.trendRange7d),
    SegmentedOption(value: TrendRange.month, label: AppStrings.trendRange30d),
    SegmentedOption(value: TrendRange.all, label: AppStrings.trendRangeAll),
  ];

  static const List<SegmentedOption<SessionMode?>> _modes = [
    SegmentedOption(value: null, label: AppStrings.trendModeAll),
    SegmentedOption(
      value: SessionMode.practice,
      label: AppStrings.trendModePractice,
    ),
    SegmentedOption(value: SessionMode.exam, label: AppStrings.trendModeExam),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final locale = Localizations.maybeLocaleOf(context)?.languageCode ?? 'fr';
    final labels =
        ref.watch(dashboardLabelsProvider).value ?? DashboardLabels.empty;
    final query = (
      familyId: widget.familyId,
      from: _range.from(_now),
      to: null,
      mode: _mode,
    );
    ref.listen(familyTimeSeriesProvider(query), (_, next) {
      if (next case AsyncError(:final error, :final stackTrace)) {
        logError(error, stackTrace, context: 'family time series');
      }
    });
    final series = ref.watch(familyTimeSeriesProvider(query));

    return AppScaffold(
      title: labels.families.containsKey(widget.familyId)
          ? labels.familyName(widget.familyId, locale: locale, short: false)
          : AppStrings.familyTrendTitle,
      onBack: context.pop,
      body: ListView(
        padding: EdgeInsets.all(theme.spacing.lg),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: FamilyTrendScreen.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FilterRow(
                    label: AppStrings.trendRangeLabel,
                    child: SegmentedChoice<TrendRange>(
                      semanticsLabel: AppStrings.trendRangeLabel,
                      options: _ranges,
                      selected: _range,
                      onSelected: (r) => setState(() => _range = r),
                    ),
                  ),
                  SizedBox(height: theme.spacing.md),
                  _FilterRow(
                    label: AppStrings.trendModeLabel,
                    child: SegmentedChoice<SessionMode?>(
                      semanticsLabel: AppStrings.trendModeLabel,
                      options: _modes,
                      selected: _mode,
                      onSelected: (m) => setState(() => _mode = m),
                    ),
                  ),
                  SizedBox(height: theme.spacing.xl),
                  switch (series) {
                    AsyncData(:final value) => FamilyTrendCharts(series: value),
                    AsyncError() => Text(
                      AppStrings.progressError,
                      style: theme.textStyles.body.copyWith(
                        color: theme.colors.error,
                      ),
                    ),
                    _ => Text(
                      AppStrings.trendLoading,
                      style: theme.textStyles.caption,
                    ),
                  },
                  SizedBox(height: theme.spacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: Text(
            label.toUpperCase(),
            style: theme.textStyles.label.copyWith(
              color: theme.colors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
        ),
        SizedBox(height: theme.spacing.xs),
        child,
      ],
    );
  }
}
