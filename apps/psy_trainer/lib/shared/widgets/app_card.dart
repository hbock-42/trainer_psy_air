import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import 'app_pressable.dart';

/// A bordered surface grouping related content.
///
/// Give it [onPressed] to make the whole card tappable (hover, press and
/// focus visuals included); [semanticsLabel] is then required for
/// accessibility since the card content can be anything.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding,
    this.onPressed,
    this.semanticsLabel,
    this.focusNode,
    super.key,
  }) : assert(
         onPressed == null || semanticsLabel != null,
         'A tappable AppCard needs a semanticsLabel',
       );

  final Widget child;

  /// Defaults to `AppSpacing.lg` on every side.
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final String? semanticsLabel;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final effectivePadding = padding ?? EdgeInsets.all(theme.spacing.lg);

    if (onPressed == null) {
      return DecoratedBox(
        decoration: _decoration(theme, background: theme.colors.surface),
        child: Padding(padding: effectivePadding, child: child),
      );
    }

    return AppPressable(
      onPressed: onPressed,
      semanticsLabel: semanticsLabel,
      excludeSemantics: true,
      focusNode: focusNode,
      builder: (context, state) {
        var background = theme.colors.surface;
        if (state.pressed) {
          background = theme.colors.surfaceRaised.shifted(theme, 0.06);
        } else if (state.hovered) {
          background = theme.colors.surfaceRaised;
        }
        return AppFocusRing(
          visible: state.focused,
          borderRadius: theme.radii.lgAll,
          child: AnimatedContainer(
            duration: theme.durations.fast,
            decoration: _decoration(
              theme,
              background: background,
              border: state.hovered
                  ? theme.colors.borderStrong
                  : theme.colors.border,
            ),
            padding: effectivePadding,
            child: child,
          ),
        );
      },
    );
  }

  BoxDecoration _decoration(
    AppTheme theme, {
    required Color background,
    Color? border,
  }) {
    return BoxDecoration(
      color: background,
      borderRadius: theme.radii.lgAll,
      border: Border.all(color: border ?? theme.colors.border),
    );
  }
}
