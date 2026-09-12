import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import 'app_pressable.dart';

/// One option of a [SegmentedChoice].
@immutable
class SegmentedOption<T> {
  const SegmentedOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// A row of mutually exclusive pills (range `7 j / 30 j / Tout`, mode
/// filter): one [AppPressable] per option with the selected flag, wrapped in
/// a semantics group labelled [semanticsLabel]. Wraps on narrow screens.
class SegmentedChoice<T> extends StatelessWidget {
  const SegmentedChoice({
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.semanticsLabel,
    super.key,
  });

  final List<SegmentedOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticsLabel,
      child: Wrap(
        spacing: theme.spacing.xs,
        runSpacing: theme.spacing.xs,
        children: [
          for (final option in options)
            _Pill(
              label: option.label,
              selected: option.value == selected,
              onPressed: () => onSelected(option.value),
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    return AppPressable(
      onPressed: onPressed,
      selected: selected,
      semanticsLabel: label,
      excludeSemantics: true,
      // Was `theme.spacing.xxl` (32): below Android's 48 dp minimum tap
      // target (`androidTapTargetGuideline` caught it, US-123).
      minSize: theme.spacing.minTouchTarget,
      builder: (context, state) {
        var background = selected
            ? colors.accentSubtle
            : const Color(0x00000000);
        if (state.pressed) {
          background = colors.surfaceRaised.shifted(theme, 0.08);
        } else if (state.hovered && !selected) {
          background = colors.surfaceRaised;
        }
        final border = selected ? colors.accent : colors.borderStrong;
        final foreground = selected ? colors.textPrimary : colors.textSecondary;
        return AppFocusRing(
          visible: state.focused,
          borderRadius: theme.radii.fullAll,
          child: AnimatedContainer(
            duration: theme.durations.fast,
            decoration: BoxDecoration(
              color: background,
              borderRadius: theme.radii.fullAll,
              border: Border.all(color: border),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.md,
              vertical: theme.spacing.xs,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: theme.textStyles.label.copyWith(color: foreground),
            ),
          ),
        );
      },
    );
  }
}
