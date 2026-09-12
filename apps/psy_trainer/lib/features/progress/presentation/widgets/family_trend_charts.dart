import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/repositories/model/session.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/time_series.dart';

/// The two stacked score-over-time charts of one family (US-071): accuracy
/// per session (0..100 %) and median response time per session (seconds).
/// `x` is the session index so sessions of the same day do not overlap;
/// the ticks under the baseline carry the session dates.
///
/// Presentational: the caller filters the range and mode and passes the
/// resulting [TimeSeries]; an empty series renders the empty caption.
class FamilyTrendCharts extends StatelessWidget {
  const FamilyTrendCharts({required this.series, super.key});

  final TimeSeries series;

  /// `12/09` (day/month) for the axis ticks.
  static String shortDate(DateTime date) {
    final d = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}';
  }

  /// `12/09/2026 14:32` for tooltips.
  static String longDate(DateTime date) {
    final d = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  static int percent(double fraction) => (fraction * 100).round();

  static double seconds(double ms) => ms / 1000;

  /// "de 40 % à 70 % sur 6 sessions", the semantics summary of the
  /// accuracy chart.
  static String describeAccuracy(BuildContext context, List<TrendPoint> points) =>
      context.l10n.trendAccuracySummary(
        points.length,
        percent(points.last.accuracy),
        percent(points.first.accuracy),
      );

  /// "de 1,4 s à 0,9 s sur 6 sessions", the summary of the speed chart.
  static String describeSpeed(BuildContext context, List<TrendPoint> points) =>
      context.l10n.trendSpeedSummary(
        points.length,
        context.l10n.seconds(seconds(points.last.medianResponseMs)),
        context.l10n.seconds(seconds(points.first.medianResponseMs)),
      );

  /// Up to [max] date ticks spread over the session indices, always the
  /// first and the last.
  static List<LineChartTick> dateTicks(List<TrendPoint> points, {int max = 4}) {
    if (points.isEmpty) return const [];
    if (points.length == 1) {
      return [LineChartTick(0, shortDate(points.first.at))];
    }
    final count = math.min(max, points.length);
    final ticks = <LineChartTick>[];
    for (var i = 0; i < count; i++) {
      final index = ((points.length - 1) * i / (count - 1)).round();
      ticks.add(LineChartTick(index.toDouble(), shortDate(points[index].at)));
    }
    return ticks;
  }

  /// The upper bound of the speed axis: the slowest session rounded up to a
  /// whole second (at least one).
  static double speedCeiling(List<TrendPoint> points) {
    var max = 0.0;
    for (final p in points) {
      max = math.max(max, seconds(p.medianResponseMs));
    }
    return math.max(1, max.ceilToDouble());
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final points = series.points;
    if (points.isEmpty) {
      return Text(context.l10n.trendEmpty, style: theme.textStyles.caption);
    }
    final xTicks = dateTicks(points);
    final ceiling = speedCeiling(points);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(
          title: context.l10n.trendAccuracyTitle,
          subtitle: context.l10n.trendAccuracySubtitle,
        ),
        SizedBox(height: theme.spacing.md),
        AppCard(
          child: LineChart(
            semanticsLabel: context.l10n.trendAccuracyTitle,
            semanticsValue: describeAccuracy(context, points),
            yMin: 0,
            yMax: 1,
            yTicks: LineChart.evenTicks(
              0,
              1,
              count: 3,
              format: (v) => context.l10n.scorePercent(percent(v)),
            ),
            xTicks: xTicks,
            series: [
              LineChartSeries(
                label: context.l10n.trendAccuracyLabel,
                points: [
                  for (final (i, p) in points.indexed)
                    LineChartPoint(i.toDouble(), p.accuracy),
                ],
              ),
            ],
            tooltipBuilder: (context, hit) =>
                TrendTooltip(point: points[hit.x.round()]),
          ),
        ),
        SizedBox(height: theme.spacing.xl),
        SectionHeader(
          title: context.l10n.trendSpeedTitle,
          subtitle: context.l10n.trendSpeedSubtitle,
        ),
        SizedBox(height: theme.spacing.md),
        AppCard(
          child: LineChart(
            semanticsLabel: context.l10n.trendSpeedTitle,
            semanticsValue: describeSpeed(context, points),
            yMin: 0,
            yMax: ceiling,
            yTicks: LineChart.evenTicks(
              0,
              ceiling,
              count: 3,
              format: (v) => context.l10n.seconds(v),
            ),
            xTicks: xTicks,
            series: [
              LineChartSeries(
                label: context.l10n.trendSpeedLabel,
                color: theme.colors.warning,
                points: [
                  for (final (i, p) in points.indexed)
                    LineChartPoint(i.toDouble(), seconds(p.medianResponseMs)),
                ],
              ),
            ],
            tooltipBuilder: (context, hit) =>
                TrendTooltip(point: points[hit.x.round()]),
          ),
        ),
      ],
    );
  }
}

/// Tooltip of both family charts: the session date and kind, its accuracy
/// (`7/10 (70 %)`) and its median response time.
class TrendTooltip extends StatelessWidget {
  const TrendTooltip({required this.point, super.key});

  final TrendPoint point;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final kind = point.mode == SessionMode.exam
        ? context.l10n.activityExam
        : context.l10n.activityPractice;
    return LineChartTooltip(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FamilyTrendCharts.longDate(point.at),
            style: theme.textStyles.label,
          ),
          Text(kind, style: theme.textStyles.caption),
          Text(
            context.l10n.trendTooltipAccuracy(
              point.correct,
              point.attempts,
              FamilyTrendCharts.percent(point.accuracy),
            ),
            style: theme.textStyles.caption.copyWith(
              color: theme.colors.textPrimary,
            ),
          ),
          Text(
            context.l10n.trendTooltipSpeed(
              context.l10n.seconds(
                FamilyTrendCharts.seconds(point.medianResponseMs),
              ),
            ),
            style: theme.textStyles.caption.copyWith(
              color: theme.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
