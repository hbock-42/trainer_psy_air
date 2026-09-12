import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/family_progress.dart';
import '../../domain/readiness_score.dart';
import 'progress_bands.dart';

/// Headline card of the dashboard: the readiness gauge (0..100), the overall
/// trend and, when an exam date is set, the days left until it.
class ReadinessCard extends StatelessWidget {
  const ReadinessCard({
    required this.readiness,
    required this.trend,
    this.examDaysLeft,
    super.key,
  });

  final ReadinessScore readiness;
  final TrendDirection trend;

  /// Whole days until the exam (0 = today, negative = passed); null when no
  /// exam date is set.
  final int? examDaysLeft;

  /// Below this width the gauge and its details stack vertically.
  static const double _sideBySideMinWidth = 300;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final value = readiness.rounded;
    final band = ProgressBands.readiness(theme, readiness.value);

    final gauge = ArcGauge(
      value: readiness.value / 100,
      color: band,
      semanticsLabel: context.l10n.readinessSemanticsLabel,
      semanticsValue:
          '$value ${context.l10n.readinessOutOf}, ${_trendText(context)}',
      // Scales down rather than overflowing at large text scales.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$value',
              style: theme.textStyles.display.copyWith(color: band),
              maxLines: 1,
            ),
            Text(context.l10n.readinessOutOf, style: theme.textStyles.caption),
          ],
        ),
      ),
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _TrendLine(trend: trend),
        SizedBox(height: theme.spacing.sm),
        Text(
          context.l10n.readinessFamilies(
            readiness.familiesPractised,
            readiness.familiesTotal,
          ),
          style: theme.textStyles.caption,
        ),
        Text(
          context.l10n.readinessLessons(
            readiness.lessonsRead,
            readiness.lessonsTotal,
          ),
          style: theme.textStyles.caption,
        ),
        Text(
          context.l10n.readinessExams(readiness.examsCounted),
          style: theme.textStyles.caption,
        ),
      ],
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  context.l10n.readinessTitle.toUpperCase(),
                  style: theme.textStyles.label.copyWith(
                    color: colors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              if (examDaysLeft != null) ...[
                SizedBox(width: theme.spacing.sm),
                ExamCountdownChip(daysLeft: examDaysLeft!),
              ],
            ],
          ),
          SizedBox(height: theme.spacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < _sideBySideMinWidth) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(child: gauge),
                    SizedBox(height: theme.spacing.md),
                    details,
                  ],
                );
              }
              return Row(
                children: [
                  gauge,
                  SizedBox(width: theme.spacing.lg),
                  Expanded(child: details),
                ],
              );
            },
          ),
          SizedBox(height: theme.spacing.md),
          Text(context.l10n.readinessHint, style: theme.textStyles.caption),
        ],
      ),
    );
  }

  String _trendText(BuildContext context) => switch (trend) {
    TrendDirection.up => context.l10n.readinessTrendUp,
    TrendDirection.flat => context.l10n.readinessTrendFlat,
    TrendDirection.down => context.l10n.readinessTrendDown,
  };
}

class _TrendLine extends StatelessWidget {
  const _TrendLine({required this.trend});

  final TrendDirection trend;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final (arrow, text, color) = switch (trend) {
      TrendDirection.up => (
        '↗',
        context.l10n.readinessTrendUp,
        theme.colors.success,
      ),
      TrendDirection.flat => (
        '→',
        context.l10n.readinessTrendFlat,
        theme.colors.textSecondary,
      ),
      TrendDirection.down => (
        '↘',
        context.l10n.readinessTrendDown,
        theme.colors.error,
      ),
    };
    // The gauge's semantics already announces the trend.
    return ExcludeSemantics(
      child: Row(
        children: [
          Text(arrow, style: theme.textStyles.numeric.copyWith(color: color)),
          SizedBox(width: theme.spacing.xs),
          Flexible(
            child: Text(
              text,
              style: theme.textStyles.bodyStrong.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

/// `J-12` pill: days left until the exam date, or "passed" once it is gone.
class ExamCountdownChip extends StatelessWidget {
  const ExamCountdownChip({required this.daysLeft, super.key});

  final int daysLeft;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final passed = daysLeft < 0;
    final text = passed
        ? context.l10n.examDatePassed
        : context.l10n.examDaysLeft(daysLeft);
    final long = passed
        ? context.l10n.examDatePassed
        : context.l10n.examDaysLeftLong(daysLeft);
    final background = passed ? colors.surfaceRaised : colors.accentSubtle;
    final foreground = passed ? colors.textSecondary : colors.textPrimary;
    return Semantics(
      label: context.l10n.examDateSemanticsLabel,
      value: long,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            borderRadius: theme.radii.fullAll,
            border: Border.all(color: colors.border),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.md,
              vertical: theme.spacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon(AppIconGlyph.clock, size: 16, color: foreground),
                SizedBox(width: theme.spacing.xs),
                Text(
                  text,
                  style: theme.textStyles.label.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
