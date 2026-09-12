import 'package:flutter/widgets.dart';

import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/family_progress.dart';
import '../providers/dashboard_labels_provider.dart';
import 'progress_bands.dart';

/// Family levels (1..5) in real-test order: a [RadarChart] over every
/// content family once at least [RadarChart.minAxes] families have data,
/// a [HorizontalBarChart] of the practised families below that (a polygon
/// with one or two points reads as nothing), and a caption when none has.
class FamilyLevelsChart extends StatelessWidget {
  const FamilyLevelsChart({
    required this.families,
    required this.labels,
    super.key,
  });

  /// In the order of the snapshot, i.e. `TestFamily.order` then orphans.
  final List<FamilyProgress> families;
  final DashboardLabels labels;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final locale = Localizations.maybeLocaleOf(context)?.languageCode ?? 'fr';
    final practised = families.where((f) => f.hasData).toList();

    if (practised.isEmpty) {
      return Text(AppStrings.familyLevelsNone, style: theme.textStyles.caption);
    }

    if (practised.length >= RadarChart.minAxes) {
      return Center(
        child: RadarChart(
          semanticsLabel: AppStrings.familyLevelsSemanticsLabel,
          axes: [
            for (final f in families)
              RadarChartAxis(
                label: labels.familyName(f.familyId, locale: locale),
                value: f.levelFraction,
                valueLabel: _levelLabel(f),
              ),
          ],
        ),
      );
    }

    return HorizontalBarChart(
      semanticsLabel: AppStrings.familyLevelsSemanticsLabel,
      entries: [
        for (final f in practised)
          BarChartEntry(
            label: labels.familyName(f.familyId, locale: locale, short: false),
            // Level 1 still shows a bar (one fifth), unlike the radar where
            // it sits at the centre.
            value: f.level / FamilyProgress.maxLevel,
            valueLabel: _levelLabel(f),
            color: ProgressBands.level(theme, f.level),
          ),
      ],
    );
  }

  static String _levelLabel(FamilyProgress f) => f.hasData
      ? AppStrings.familyLevel(f.level)
      : AppStrings.familyNotPractised;
}
