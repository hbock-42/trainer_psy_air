import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_theme.dart';

/// Common frame of an onboarding step: a scrolling column (headline, intro,
/// step content) with the actions pinned at the bottom, both capped at
/// [maxContentWidth] and centred on wide windows.
class OnboardingStepLayout extends StatelessWidget {
  const OnboardingStepLayout({
    required this.headline,
    required this.content,
    required this.actions,
    this.intro,
    super.key,
  });

  /// Widest the content gets on desktop/web.
  static const double maxContentWidth = 560;

  final String headline;
  final String? intro;
  final List<Widget> content;

  /// Buttons stacked at the bottom, first one on top.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final spacing = theme.spacing;
    final horizontal = EdgeInsets.symmetric(horizontal: spacing.lg);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: horizontal.copyWith(top: spacing.md, bottom: spacing.lg),
            child: _Capped(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    header: true,
                    child: Text(headline, style: theme.textStyles.headline),
                  ),
                  if (intro != null) ...[
                    SizedBox(height: spacing.sm),
                    Text(
                      intro!,
                      style: theme.textStyles.body.copyWith(
                        color: theme.colors.textSecondary,
                      ),
                    ),
                  ],
                  SizedBox(height: spacing.lg),
                  ...content,
                ],
              ),
            ),
          ),
        ),
        if (actions.isNotEmpty)
          Padding(
            padding: horizontal.copyWith(top: spacing.sm, bottom: spacing.lg),
            child: _Capped(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < actions.length; i++) ...[
                    if (i > 0) SizedBox(height: spacing.sm),
                    actions[i],
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _Capped extends StatelessWidget {
  const _Capped({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: OnboardingStepLayout.maxContentWidth,
        ),
        child: child,
      ),
    );
  }
}
