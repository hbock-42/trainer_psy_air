import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/recommendation.dart';

/// "Train next" (US-072): the ranked weak areas plus the rule-based nudges
/// `RecommendationService` produced, each with an FR reason and a one-tap
/// action. Replaces `WeakAreasPreview` on the dashboard.
class TrainNextCard extends StatelessWidget {
  const TrainNextCard({
    required this.recommendations,
    required this.onAction,
    super.key,
  });

  final List<Recommendation> recommendations;

  /// Called with the recommendation whose action button was pressed; the
  /// caller maps `kind` / `targetId` / `secondaryId` to a route.
  final ValueChanged<Recommendation> onAction;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    if (recommendations.isEmpty) {
      return Text(context.l10n.trainNextEmpty, style: theme.textStyles.caption);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < recommendations.length; i++) ...[
          if (i > 0) SizedBox(height: theme.spacing.sm),
          _RecommendationTile(
            recommendation: recommendations[i],
            onAction: () => onAction(recommendations[i]),
          ),
        ],
      ],
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({
    required this.recommendation,
    required this.onAction,
  });

  final Recommendation recommendation;
  final VoidCallback onAction;

  /// Below this width the action button sits under the description.
  static const double _sideBySideMinWidth = 400;

  String _actionLabel(BuildContext context) => switch (recommendation.kind) {
    RecommendationKind.family ||
    RecommendationKind.tag => context.l10n.trainNextActionFamily,
    RecommendationKind.examSim => context.l10n.trainNextActionExam,
    RecommendationKind.lesson => context.l10n.trainNextActionLesson,
    RecommendationKind.flashcards => context.l10n.trainNextActionFlashcards,
  };

  AppIconGlyph get _icon => switch (recommendation.kind) {
    RecommendationKind.family || RecommendationKind.tag => AppIconGlyph.target,
    RecommendationKind.examSim => AppIconGlyph.chart,
    RecommendationKind.lesson => AppIconGlyph.book,
    RecommendationKind.flashcards => AppIconGlyph.clock,
  };

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final description = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(recommendation.title, style: theme.textStyles.bodyStrong),
        SizedBox(height: theme.spacing.xs),
        Text(
          recommendation.reason,
          style: theme.textStyles.caption.copyWith(
            color: theme.colors.textSecondary,
          ),
        ),
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
                  label: _actionLabel(context),
                  icon: _icon,
                  expand: true,
                  onPressed: onAction,
                ),
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: description),
              SizedBox(width: theme.spacing.md),
              SecondaryButton(
                label: _actionLabel(context),
                icon: _icon,
                onPressed: onAction,
              ),
            ],
          );
        },
      ),
    );
  }
}
