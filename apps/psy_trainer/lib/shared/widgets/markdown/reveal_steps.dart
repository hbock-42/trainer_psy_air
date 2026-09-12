import 'package:flutter/widgets.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../primary_button.dart';
import '../secondary_button.dart';

/// One step of a worked example, revealed by [RevealSteps].
@immutable
class RevealStepData {
  const RevealStepData({required this.title, required this.content});

  final String title;
  final Widget content;
}

/// A worked example (US-043): the statement is always visible, and each
/// step is revealed one at a time by "Étape suivante", with a "Tout
/// afficher" shortcut to reveal every remaining step at once.
class RevealSteps extends StatefulWidget {
  const RevealSteps({
    required this.title,
    required this.statement,
    required this.steps,
    super.key,
  });

  final String title;
  final Widget statement;
  final List<RevealStepData> steps;

  @override
  State<RevealSteps> createState() => _RevealStepsState();
}

class _RevealStepsState extends State<RevealSteps> {
  int _revealed = 0;

  @override
  void didUpdateWidget(RevealSteps oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title) {
      // A different worked example (lesson navigation): start collapsed
      // again rather than keeping a stale reveal count.
      _revealed = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final total = widget.steps.length;
    final done = _revealed >= total;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(theme.spacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.border),
        borderRadius: theme.radii.lgAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(widget.title, style: theme.textStyles.title),
          ),
          SizedBox(height: theme.spacing.sm),
          widget.statement,
          for (final (i, step) in widget.steps.indexed)
            if (i < _revealed)
              Padding(
                padding: EdgeInsets.only(top: theme.spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(step.title, style: theme.textStyles.bodyStrong),
                    SizedBox(height: theme.spacing.xs),
                    step.content,
                  ],
                ),
              ),
          if (!done) ...[
            SizedBox(height: theme.spacing.md),
            Wrap(
              spacing: theme.spacing.sm,
              runSpacing: theme.spacing.sm,
              children: [
                PrimaryButton(
                  label: context.l10n.lessonRevealNextStep,
                  onPressed: () => setState(() => _revealed++),
                ),
                if (total - _revealed > 1)
                  SecondaryButton(
                    label: context.l10n.lessonRevealAllSteps,
                    onPressed: () => setState(() => _revealed = total),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
