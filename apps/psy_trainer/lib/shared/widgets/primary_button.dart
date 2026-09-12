import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import 'app_icon.dart';
import 'app_pressable.dart';
import 'button_content.dart';

/// The main call to action of a screen: filled with the accent colour.
///
/// One per screen at most ("Start", "Validate", "Next"). Disabled when
/// [onPressed] is null.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
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

  /// Optional glyph drawn before the label.
  final AppIconGlyph? icon;

  /// Stretch to the available width (typical at the bottom of a screen).
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
        Color background = colors.accent;
        Color foreground = colors.onAccent;
        if (state.disabled) {
          background = colors.accent.disabledOn(theme);
          foreground = colors.onAccent.disabledOn(theme);
        } else if (state.pressed) {
          background = colors.accent.shifted(theme, 0.18);
        } else if (state.hovered) {
          background = colors.accent.shifted(theme, 0.08);
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
              ),
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.xl,
                vertical: theme.spacing.md,
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
