import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';

/// Title of a group of content on a screen, with an optional subtitle and a
/// trailing widget (a "See all" [SecondaryButton], a count, ...).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: theme.textStyles.title),
                if (subtitle != null) ...[
                  SizedBox(height: theme.spacing.xs),
                  Text(subtitle!, style: theme.textStyles.caption),
                ],
              ],
            ),
          ),
        ),
        if (trailing != null) ...[SizedBox(width: theme.spacing.md), trailing!],
      ],
    );
  }
}
