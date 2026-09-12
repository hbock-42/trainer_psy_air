import 'package:flutter/widgets.dart';

import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/weak_area.dart';
import '../providers/dashboard_labels_provider.dart';

/// The top [maxItems] weak areas (families first, then tags, weakest first
/// as the snapshot orders them), each with a "train" action. US-072 replaces
/// the action with a targeted recommendation.
class WeakAreasPreview extends StatelessWidget {
  const WeakAreasPreview({
    required this.weakAreas,
    required this.labels,
    required this.onTrain,
    this.maxItems = 3,
    super.key,
  });

  final List<WeakArea> weakAreas;
  final DashboardLabels labels;

  /// Called with the weak area whose "train" button was pressed.
  final ValueChanged<WeakArea> onTrain;
  final int maxItems;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    if (weakAreas.isEmpty) {
      return Text(AppStrings.weakAreasNone, style: theme.textStyles.caption);
    }
    final locale = Localizations.maybeLocaleOf(context)?.languageCode ?? 'fr';
    final shown = weakAreas.take(maxItems).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < shown.length; i++) ...[
          if (i > 0) SizedBox(height: theme.spacing.sm),
          _WeakAreaTile(
            area: shown[i],
            name: shown[i].isFamily
                ? labels.familyName(shown[i].id, locale: locale, short: false)
                : shown[i].id,
            onTrain: () => onTrain(shown[i]),
          ),
        ],
      ],
    );
  }
}

class _WeakAreaTile extends StatelessWidget {
  const _WeakAreaTile({
    required this.area,
    required this.name,
    required this.onTrain,
  });

  final WeakArea area;
  final String name;
  final VoidCallback onTrain;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final reasons = [
      if (area.reasons.contains(WeakAreaReason.lowAccuracy))
        AppStrings.weakReasonLowAccuracy,
      if (area.reasons.contains(WeakAreaReason.negativeTrend))
        AppStrings.weakReasonNegativeTrend,
    ].join(' · ');
    final detail = AppStrings.weakAreaDetail(
      (area.accuracy * 100).round(),
      area.attempts,
    );
    final description = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(name, style: theme.textStyles.bodyStrong),
        SizedBox(height: theme.spacing.xs),
        Text(
          reasons,
          style: theme.textStyles.caption.copyWith(color: theme.colors.error),
        ),
        Text(detail, style: theme.textStyles.caption),
      ],
    );
    return AppCard(
      padding: EdgeInsets.all(theme.spacing.md),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Narrow phones (and large text): the action goes under the text.
          if (constraints.maxWidth < _sideBySideMinWidth) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                description,
                SizedBox(height: theme.spacing.md),
                SecondaryButton(
                  label: AppStrings.weakAreaTrain,
                  icon: AppIconGlyph.target,
                  expand: true,
                  onPressed: onTrain,
                ),
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: description),
              SizedBox(width: theme.spacing.md),
              SecondaryButton(
                label: AppStrings.weakAreaTrain,
                icon: AppIconGlyph.target,
                onPressed: onTrain,
              ),
            ],
          );
        },
      ),
    );
  }

  /// Below this width the "train" button sits under the description.
  static const double _sideBySideMinWidth = 400;
}
