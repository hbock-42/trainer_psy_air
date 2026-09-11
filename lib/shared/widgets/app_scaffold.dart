import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import 'app_top_bar.dart';

/// Page frame: themed background, safe area, optional top bar, body.
///
/// The top bar appears when [title], [onBack] or [actions] is given. There is
/// no bottom navigation here (the tab shell comes with US-005): a screen that
/// lives in a tab is placed inside the shell, which owns the bar.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.title,
    this.onBack,
    this.actions = const [],
    this.backgroundColor,
    this.safeArea = true,
    this.bodyPadding,
    super.key,
  });

  final Widget body;
  final String? title;

  /// Shows a back chevron in the top bar; the scaffold never pops on its
  /// own, the caller decides (Navigator, go_router).
  final VoidCallback? onBack;

  /// Widgets aligned at the end of the top bar (icon buttons, a timer).
  final List<Widget> actions;

  /// Overrides `AppColors.background`.
  final Color? backgroundColor;
  final bool safeArea;

  /// Padding around [body]. Defaults to none: screens decide, lists usually
  /// need to scroll edge to edge.
  final EdgeInsetsGeometry? bodyPadding;

  bool get hasTopBar => title != null || onBack != null || actions.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasTopBar)
          AppTopBar(title: title, onBack: onBack, actions: actions),
        Expanded(
          child: bodyPadding == null
              ? body
              : Padding(padding: bodyPadding!, child: body),
        ),
      ],
    );
    if (safeArea) content = SafeArea(child: content);

    return ColoredBox(
      color: backgroundColor ?? theme.colors.background,
      child: DefaultTextStyle(style: theme.textStyles.body, child: content),
    );
  }
}
