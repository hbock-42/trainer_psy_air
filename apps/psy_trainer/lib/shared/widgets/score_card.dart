import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import 'app_card.dart';

/// A headline figure: score, accuracy, streak.
///
/// [delta] (e.g. `+3.5`) is rendered green when positive, red when negative
/// and muted when zero; [deltaSuffix] is appended to it (`%`, ` pts`).
class ScoreCard extends StatelessWidget {
  const ScoreCard({
    required this.title,
    required this.value,
    this.subtitle,
    this.delta,
    this.deltaSuffix = '',
    super.key,
  });

  final String title;

  /// Pre-formatted big value (`87 %`, `12/15`, `1:42`).
  final String value;
  final String? subtitle;
  final double? delta;
  final String deltaSuffix;

  /// `+3.5`, `-2`, `0` — at most one decimal, no trailing `.0`.
  static String formatDelta(double delta) {
    final rounded = (delta * 10).round() / 10;
    final text = rounded == rounded.truncateToDouble()
        ? rounded.toInt().abs().toString()
        : rounded.abs().toStringAsFixed(1);
    if (rounded > 0) return '+$text';
    if (rounded < 0) return '-$text';
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;

    final deltaText = delta == null
        ? null
        : '${formatDelta(delta!)}$deltaSuffix';
    final deltaColor = switch (delta) {
      null => colors.textMuted,
      > 0 => colors.success,
      < 0 => colors.error,
      _ => colors.textMuted,
    };

    return Semantics(
      container: true,
      label: title,
      value: [
        value,
        ?subtitle,
        if (deltaText != null) 'change $deltaText',
      ].join(', '),
      child: ExcludeSemantics(
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title.toUpperCase(),
                style: theme.textStyles.label.copyWith(
                  color: colors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: theme.spacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      style: theme.textStyles.display,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (deltaText != null) ...[
                    SizedBox(width: theme.spacing.sm),
                    Text(
                      deltaText,
                      style: theme.textStyles.numeric.copyWith(
                        fontSize: 16,
                        color: deltaColor,
                      ),
                    ),
                  ],
                ],
              ),
              if (subtitle != null) ...[
                SizedBox(height: theme.spacing.xs),
                Text(subtitle!, style: theme.textStyles.caption),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
