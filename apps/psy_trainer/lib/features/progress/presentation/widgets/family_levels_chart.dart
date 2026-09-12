import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/family_progress.dart';
import '../providers/dashboard_labels_provider.dart';
import 'progress_bands.dart';

/// Family levels (1..5) in real-test order: a [RadarChart] over every
/// content family once at least [RadarChart.minAxes] families have data,
/// a [HorizontalBarChart] of the practised families below that (a polygon
/// with one or two points reads as nothing), and a caption when none has.
///
/// With [onFamilySelected], a row of chips (one per practised family) under
/// the chart opens that family's score-over-time page (US-071): the painted
/// radar labels are not tappable.
class FamilyLevelsChart extends StatelessWidget {
  const FamilyLevelsChart({
    required this.families,
    required this.labels,
    this.onFamilySelected,
    super.key,
  });

  /// In the order of the snapshot, i.e. `TestFamily.order` then orphans.
  final List<FamilyProgress> families;
  final DashboardLabels labels;

  /// Called with the family id of the chip that was pressed.
  final ValueChanged<String>? onFamilySelected;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final locale = Localizations.maybeLocaleOf(context)?.languageCode ?? 'fr';
    final practised = families.where((f) => f.hasData).toList();

    if (practised.isEmpty) {
      return Text(context.l10n.familyLevelsNone, style: theme.textStyles.caption);
    }

    final Widget chart;
    if (practised.length >= RadarChart.minAxes) {
      chart = Center(
        child: RadarChart(
          semanticsLabel: context.l10n.familyLevelsSemanticsLabel,
          axes: [
            for (final f in families)
              RadarChartAxis(
                label: labels.familyName(f.familyId, locale: locale),
                value: f.levelFraction,
                valueLabel: _levelLabel(context, f),
              ),
          ],
        ),
      );
    } else {
      chart = HorizontalBarChart(
        semanticsLabel: context.l10n.familyLevelsSemanticsLabel,
        entries: [
          for (final f in practised)
            BarChartEntry(
              label: labels.familyName(
                f.familyId,
                locale: locale,
                short: false,
              ),
              // Level 1 still shows a bar (one fifth), unlike the radar where
              // it sits at the centre.
              value: f.level / FamilyProgress.maxLevel,
              valueLabel: _levelLabel(context, f),
              color: ProgressBands.level(theme, f.level),
            ),
        ],
      );
    }

    final onFamilySelected = this.onFamilySelected;
    if (onFamilySelected == null) return chart;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        chart,
        SizedBox(height: theme.spacing.lg),
        Text(context.l10n.familyDetailsHint, style: theme.textStyles.caption),
        SizedBox(height: theme.spacing.sm),
        Wrap(
          spacing: theme.spacing.xs,
          runSpacing: theme.spacing.xs,
          children: [
            for (final f in practised)
              FamilyChip(
                label: labels.familyName(f.familyId, locale: locale),
                semanticsLabel: context.l10n.familyTrendOpenSemantics(
                  labels.familyName(f.familyId, locale: locale, short: false),
                ),
                color: ProgressBands.level(theme, f.level),
                onPressed: () => onFamilySelected(f.familyId),
              ),
          ],
        ),
      ],
    );
  }

  static String _levelLabel(BuildContext context, FamilyProgress f) =>
      f.hasData
      ? context.l10n.familyLevel(f.level)
      : context.l10n.familyNotPractised;
}

/// A pill with a level-band dot that opens a family's charts.
class FamilyChip extends StatelessWidget {
  const FamilyChip({
    required this.label,
    required this.semanticsLabel,
    required this.color,
    required this.onPressed,
    super.key,
  });

  final String label;
  final String semanticsLabel;

  /// Colour of the dot: the family's level band.
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    return AppPressable(
      onPressed: onPressed,
      semanticsLabel: semanticsLabel,
      excludeSemantics: true,
      minSize: theme.spacing.xxl,
      builder: (context, state) {
        var background = const Color(0x00000000);
        if (state.pressed) {
          background = colors.surfaceRaised.shifted(theme, 0.08);
        } else if (state.hovered) {
          background = colors.surfaceRaised;
        }
        return AppFocusRing(
          visible: state.focused,
          borderRadius: theme.radii.fullAll,
          child: AnimatedContainer(
            duration: theme.durations.fast,
            decoration: BoxDecoration(
              color: background,
              borderRadius: theme.radii.fullAll,
              border: Border.all(
                color: state.hovered ? colors.borderStrong : colors.border,
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.md,
              vertical: theme.spacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(
                    width: theme.spacing.sm,
                    height: theme.spacing.sm,
                  ),
                ),
                SizedBox(width: theme.spacing.sm),
                // Bounded by the Wrap: a long name (or an unknown id) is
                // ellipsised rather than overflowing.
                Flexible(
                  child: Text(
                    label,
                    style: theme.textStyles.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: theme.spacing.xs),
                AppIcon(
                  AppIconGlyph.chevronRight,
                  size: 14,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
