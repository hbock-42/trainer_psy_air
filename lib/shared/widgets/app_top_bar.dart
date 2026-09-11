import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import 'app_icon.dart';
import 'app_icon_button.dart';

/// The header row used by [AppScaffold]; exposed so custom layouts (e.g. a
/// screen with a scrolling app bar) can reuse it.
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    this.title,
    this.onBack,
    this.actions = const [],
    super.key,
  });

  final String? title;
  final VoidCallback? onBack;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.sm,
        vertical: theme.spacing.xs,
      ),
      child: Row(
        children: [
          if (onBack != null)
            AppIconButton(
              glyph: AppIconGlyph.chevronLeft,
              semanticsLabel: 'Back',
              onPressed: onBack,
            )
          else
            SizedBox(width: theme.spacing.sm),
          Expanded(
            child: title == null
                ? const SizedBox.shrink()
                : Semantics(
                    header: true,
                    child: Text(
                      title!,
                      style: theme.textStyles.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
          ),
          ...actions,
        ],
      ),
    );
  }
}
