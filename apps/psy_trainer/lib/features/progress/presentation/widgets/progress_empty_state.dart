import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';

/// Shown instead of the dashboard while nothing has been practised, read or
/// simulated: explains what will appear and sends the candidate to a first
/// drill.
class ProgressEmptyState extends StatelessWidget {
  const ProgressEmptyState({required this.onStart, super.key});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: AppIcon(
                  AppIconGlyph.chart,
                  size: 56,
                  color: theme.colors.textMuted,
                ),
              ),
              SizedBox(height: theme.spacing.lg),
              Semantics(
                header: true,
                child: Text(
                  context.l10n.progressEmptyTitle,
                  style: theme.textStyles.title,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: theme.spacing.sm),
              Text(
                context.l10n.progressEmptyBody,
                style: theme.textStyles.body.copyWith(
                  color: theme.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: theme.spacing.xl),
              PrimaryButton(
                label: context.l10n.progressEmptyAction,
                icon: AppIconGlyph.play,
                onPressed: onStart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
