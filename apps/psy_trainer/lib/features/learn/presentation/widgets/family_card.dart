import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/family_mastery_provider.dart';
import 'confidence_chip.dart';

/// One PSY0 activity on the Learn home: position in the real test, name,
/// what is evaluated, format (items × duration), mastery and quick actions.
///
/// The header (index, name, description) is tappable and opens the family
/// page, like the "Apprendre" action; the buttons keep their own semantics
/// so the whole card is not one opaque button.
class FamilyCard extends ConsumerWidget {
  const FamilyCard({
    required this.family,
    required this.index,
    required this.onLearn,
    required this.onTrain,
    this.onCards,
    super.key,
  });

  final TestFamily family;

  /// 1-based position in the real test order.
  final int index;
  final VoidCallback onLearn;
  final VoidCallback onTrain;

  /// Null until flashcards exist (US-042): the action renders disabled.
  final VoidCallback? onCards;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final name = family.name.resolve(AppStrings.locale);
    final mastery = ref.watch(familyMasteryProvider(family.id));
    final masteryText = switch (mastery) {
      AsyncData(:final value?) => AppStrings.masteryPercent(value),
      _ => AppStrings.familyMasteryUnknown,
    };

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPressable(
            onPressed: onLearn,
            semanticsLabel: AppStrings.familyOpenSemantics(name),
            excludeSemantics: true,
            builder: (context, state) => AnimatedContainer(
              duration: theme.durations.fast,
              decoration: BoxDecoration(
                color: state.hovered || state.pressed
                    ? colors.surfaceRaised
                    : colors.surface,
                borderRadius: BorderRadius.vertical(top: theme.radii.lg),
              ),
              padding: EdgeInsets.fromLTRB(
                theme.spacing.lg,
                theme.spacing.lg,
                theme.spacing.lg,
                theme.spacing.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _IndexBadge(index: index),
                  SizedBox(width: theme.spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: theme.textStyles.title),
                        SizedBox(height: theme.spacing.xs),
                        Text(
                          family.description.resolve(AppStrings.locale),
                          style: theme.textStyles.body.copyWith(
                            color: colors.textSecondary,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: theme.spacing.sm),
                  AppIcon(
                    AppIconGlyph.chevronRight,
                    size: 20,
                    color: colors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              theme.spacing.lg,
              0,
              theme.spacing.lg,
              theme.spacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: theme.spacing.xl,
                  runSpacing: theme.spacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    _Detail(
                      label: AppStrings.familyFormatLabel,
                      value: AppStrings.familyFormat(
                        itemCount: family.defaultItemCount,
                        durationSec: family.defaultDurationSec,
                        perItemSec: family.defaultPerItemTimeSec,
                      ),
                    ),
                    ConfidenceChip(confidence: family.confidence),
                    _Detail(
                      label: AppStrings.familyMasteryLabel,
                      value: masteryText,
                    ),
                  ],
                ),
                SizedBox(height: theme.spacing.md),
                Wrap(
                  spacing: theme.spacing.sm,
                  runSpacing: theme.spacing.sm,
                  children: [
                    SecondaryButton(
                      label: AppStrings.familyActionLearn,
                      icon: AppIconGlyph.book,
                      onPressed: onLearn,
                    ),
                    SecondaryButton(
                      label: AppStrings.familyActionTrain,
                      icon: AppIconGlyph.target,
                      onPressed: onTrain,
                    ),
                    SecondaryButton(
                      label: AppStrings.familyActionCards,
                      onPressed: onCards,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Position of the activity in the real test, as a round accent badge.
class _IndexBadge extends StatelessWidget {
  const _IndexBadge({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      width: theme.spacing.xxl,
      height: theme.spacing.xxl,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colors.accentSubtle,
        borderRadius: theme.radii.fullAll,
      ),
      child: Text(
        '$index',
        style: theme.textStyles.label.copyWith(
          color: theme.colors.textPrimary,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

/// "Label  value" pair used for the format and the mastery slot.
class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Semantics(
      label: label,
      value: value,
      child: ExcludeSemantics(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textStyles.caption),
            Text(value, style: theme.textStyles.label),
          ],
        ),
      ),
    );
  }
}
