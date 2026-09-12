import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';

/// A checkbox-like row: a square box that shows a check mark when [value] is
/// true, followed by [label]. Tapping anywhere on the row toggles it.
///
/// Built on [AppPressable] (hover, focus ring, Enter/Space) and announced as
/// a checkbox to assistive technologies.
class AcceptToggle extends StatelessWidget {
  const AcceptToggle({
    required this.value,
    required this.label,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;

    return Semantics(
      // AppPressable flags the node as a button; a checkbox is closer to
      // what the user manipulates.
      checked: value,
      label: label,
      excludeSemantics: true,
      onTap: () => onChanged(!value),
      child: AppPressable(
        onPressed: () => onChanged(!value),
        builder: (context, state) {
          var background = colors.surface;
          if (state.pressed) {
            background = colors.surfaceRaised.shifted(theme, 0.06);
          } else if (state.hovered) {
            background = colors.surfaceRaised;
          }
          return AppFocusRing(
            visible: state.focused,
            borderRadius: theme.radii.mdAll,
            child: AnimatedContainer(
              duration: theme.durations.fast,
              decoration: BoxDecoration(
                color: background,
                borderRadius: theme.radii.mdAll,
                border: Border.all(
                  color: value ? colors.accent : colors.border,
                  width: 2,
                ),
              ),
              padding: EdgeInsets.all(theme.spacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: theme.durations.fast,
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: value ? colors.accent : colors.surface,
                      borderRadius: theme.radii.smAll,
                      border: Border.all(
                        color: value ? colors.accent : colors.borderStrong,
                        width: 2,
                      ),
                    ),
                    child: value
                        ? AppIcon(
                            AppIconGlyph.check,
                            size: 16,
                            color: colors.onAccent,
                          )
                        : null,
                  ),
                  SizedBox(width: theme.spacing.md),
                  Expanded(
                    child: Text(
                      label,
                      style: theme.textStyles.body.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
