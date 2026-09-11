import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import 'app_icon.dart';
import 'app_pressable.dart';

/// A key of the numeric keypad (US-022): digits, sign, decimal point,
/// backspace, validate.
///
/// Shows [label] in the numeric style, or [icon] when given. [emphasized]
/// fills the key with the accent colour (the "validate" key). Keys stretch to
/// the width their parent gives them (put them in an `Expanded`/`GridView`).
class AppKeypadButton extends StatelessWidget {
  const AppKeypadButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.semanticsLabel,
    this.emphasized = false,
    this.focusNode,
    super.key,
  });

  /// Text on the key; also the semantics label unless [semanticsLabel] is
  /// given (do give one for icon keys: "Delete", "Validate").
  final String label;
  final VoidCallback? onPressed;
  final AppIconGlyph? icon;
  final String? semanticsLabel;
  final bool emphasized;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;

    return AppPressable(
      onPressed: onPressed,
      semanticsLabel: semanticsLabel ?? label,
      excludeSemantics: true,
      focusNode: focusNode,
      minSize: 56,
      builder: (context, state) {
        Color background = emphasized ? colors.accent : colors.surface;
        Color foreground = emphasized ? colors.onAccent : colors.textPrimary;
        Color border = emphasized ? colors.accent : colors.border;
        if (state.disabled) {
          background = background.disabledOn(theme);
          foreground = foreground.disabledOn(theme);
          border = border.disabledOn(theme);
        } else if (state.pressed) {
          background = emphasized
              ? colors.accent.shifted(theme, 0.18)
              : colors.accentSubtle;
          border = emphasized ? background : colors.accent;
        } else if (state.hovered) {
          background = emphasized
              ? colors.accent.shifted(theme, 0.08)
              : colors.surfaceRaised;
          border = emphasized ? background : colors.borderStrong;
        }

        return AppFocusRing(
          visible: state.focused,
          borderRadius: theme.radii.mdAll,
          child: AnimatedContainer(
            duration: theme.durations.fast,
            decoration: BoxDecoration(
              color: background,
              borderRadius: theme.radii.mdAll,
              border: Border.all(color: border, width: 1.5),
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.sm,
              vertical: theme.spacing.sm,
            ),
            child: icon != null
                ? AppIcon(icon!, size: 26, color: foreground)
                : Text(
                    label,
                    style: theme.textStyles.numeric.copyWith(color: foreground),
                    maxLines: 1,
                  ),
          ),
        );
      },
    );
  }
}
