import 'package:flutter/widgets.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';

/// Small pill showing how sure we are that a value mirrors the real test
/// (spec "How to read this document"): confirmed / reported / assumed.
///
/// With [text] the chip reads "text · tag" (a fact with its own confidence);
/// without it only the tag is shown.
class ConfidenceChip extends StatelessWidget {
  const ConfidenceChip({required this.confidence, this.text, super.key});

  final Confidence confidence;
  final String? text;

  static String labelOf(BuildContext context, Confidence confidence) =>
      switch (confidence) {
        Confidence.confirmed => context.l10n.confidenceConfirmed,
        Confidence.reported => context.l10n.confidenceReported,
        Confidence.assumed => context.l10n.confidenceAssumed,
      };

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final (Color background, Color foreground) = switch (confidence) {
      Confidence.confirmed => (colors.successSubtle, colors.success),
      Confidence.reported => (colors.accentSubtle, colors.textPrimary),
      Confidence.assumed => (colors.warningSubtle, colors.warning),
    };
    final tag = labelOf(context, confidence);
    final label = text == null ? tag : '$text · $tag';

    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            borderRadius: theme.radii.fullAll,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.sm,
              vertical: theme.spacing.xs / 2,
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  if (text != null)
                    TextSpan(
                      text: '$text · ',
                      style: theme.textStyles.caption.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  TextSpan(
                    text: tag,
                    style: theme.textStyles.caption.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
