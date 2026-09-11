import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import 'app_icon.dart';
import 'app_pressable.dart';

/// A square, icon-only button (top bar actions, back chevron).
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.glyph,
    required this.semanticsLabel,
    this.onPressed,
    this.focusNode,
    super.key,
  });

  final AppIconGlyph glyph;
  final String semanticsLabel;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    return AppPressable(
      onPressed: onPressed,
      semanticsLabel: semanticsLabel,
      excludeSemantics: true,
      focusNode: focusNode,
      builder: (context, state) {
        var background = const Color(0x00000000);
        if (state.pressed) {
          background = colors.surfaceRaised.shifted(theme, 0.08);
        } else if (state.hovered) {
          background = colors.surfaceRaised;
        }
        return AppFocusRing(
          visible: state.focused,
          borderRadius: theme.radii.mdAll,
          child: AnimatedContainer(
            duration: theme.durations.fast,
            width: theme.spacing.minTouchTarget,
            height: theme.spacing.minTouchTarget,
            decoration: BoxDecoration(
              color: background,
              borderRadius: theme.radii.mdAll,
            ),
            alignment: Alignment.center,
            child: AppIcon(
              glyph,
              color: state.disabled
                  ? colors.textMuted.disabledOn(theme)
                  : colors.textPrimary,
            ),
          ),
        );
      },
    );
  }
}
