import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import 'app_icon.dart';
import 'app_pressable.dart';
import 'button_content.dart';

/// A less prominent action: outlined, text in the primary text colour.
///
/// Use next to a [PrimaryButton] ("Skip", "Back to menu") or on its own for
/// neutral actions.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = false,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppIconGlyph? icon;
  final bool expand;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;

    return AppPressable(
      onPressed: onPressed,
      semanticsLabel: label,
      excludeSemantics: true,
      focusNode: focusNode,
      autofocus: autofocus,
      builder: (context, state) {
        Color background = const Color(0x00000000);
        Color border = colors.borderStrong;
        Color foreground = colors.textPrimary;
        if (state.disabled) {
          border = colors.border;
          foreground = colors.textMuted.disabledOn(theme);
        } else if (state.pressed) {
          background = colors.surfaceRaised.shifted(theme, 0.08);
        } else if (state.hovered) {
          background = colors.surfaceRaised;
        }

        return AppFocusRing(
          visible: state.focused,
          borderRadius: theme.radii.mdAll,
          child: AnimatedScale(
            scale: state.pressed ? 0.97 : 1,
            duration: theme.durations.fast,
            child: AnimatedContainer(
              duration: theme.durations.fast,
              decoration: BoxDecoration(
                color: background,
                borderRadius: theme.radii.mdAll,
                border: Border.all(color: border, width: 1.5),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.xl - 1.5,
                vertical: theme.spacing.md - 1.5,
              ),
              child: ButtonContent(
                label: label,
                icon: icon,
                color: foreground,
                expand: expand,
                style: theme.textStyles.bodyStrong,
              ),
            ),
          ),
        );
      },
    );
  }
}
