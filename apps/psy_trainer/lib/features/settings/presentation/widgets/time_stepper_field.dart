import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';

/// An hour:minute input made of two steppers, built from design-system
/// primitives only (no platform time picker) — same shape as
/// `DateStepperField` (`features/onboarding/presentation/widgets/`), just
/// two columns (hour, minute) instead of three (day, month, year).
///
/// [hour] is 0..23, [minute] is 0..59; both wrap around on step.
class TimeStepperField extends StatelessWidget {
  const TimeStepperField({
    required this.hour,
    required this.minute,
    required this.onChanged,
    super.key,
  });

  final int hour;
  final int minute;

  /// Called with the new (hour, minute) pair on every step.
  final void Function(int hour, int minute) onChanged;

  void _stepHour(int delta) => onChanged((hour + delta) % 24, minute);

  void _stepMinute(int delta) => onChanged(hour, (minute + delta) % 60);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final display =
        '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
    return Semantics(
      container: true,
      label: display,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _StepperColumn(
              label: context.l10n.settingsReminderHour,
              display: hour.toString().padLeft(2, '0'),
              onIncrement: () => _stepHour(1),
              onDecrement: () => _stepHour(-1),
            ),
          ),
          SizedBox(width: theme.spacing.sm),
          Expanded(
            child: _StepperColumn(
              label: context.l10n.settingsReminderMinute,
              display: minute.toString().padLeft(2, '0'),
              onIncrement: () => _stepMinute(1),
              onDecrement: () => _stepMinute(-1),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperColumn extends StatelessWidget {
  const _StepperColumn({
    required this.label,
    required this.display,
    required this.onIncrement,
    required this.onDecrement,
  });

  final String label;
  final String display;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(
          child: Text(
            label,
            style: theme.textStyles.caption,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: theme.spacing.xs),
        _StepButton(
          semanticsLabel: '$label, ${context.l10n.dateFieldIncrement}',
          quarterTurns: 3,
          onPressed: onIncrement,
        ),
        Container(
          height: theme.spacing.minTouchTarget,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: theme.radii.smAll,
            border: Border.all(color: colors.border),
          ),
          child: Text(
            display,
            style: theme.textStyles.numeric,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            semanticsLabel: '$label $display',
          ),
        ),
        _StepButton(
          semanticsLabel: '$label, ${context.l10n.dateFieldDecrement}',
          quarterTurns: 1,
          onPressed: onDecrement,
        ),
      ],
    );
  }
}

/// A chevron button pointing up ([quarterTurns] 3) or down (1).
class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.semanticsLabel,
    required this.quarterTurns,
    required this.onPressed,
  });

  final String semanticsLabel;
  final int quarterTurns;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    return AppPressable(
      onPressed: onPressed,
      semanticsLabel: semanticsLabel,
      excludeSemantics: true,
      minSize: theme.spacing.minTouchTarget,
      builder: (context, state) {
        var background = const Color(0x00000000);
        if (state.pressed) {
          background = colors.surfaceRaised.shifted(theme, 0.08);
        } else if (state.hovered) {
          background = colors.surfaceRaised;
        }
        return AppFocusRing(
          visible: state.focused,
          borderRadius: theme.radii.smAll,
          child: AnimatedContainer(
            duration: theme.durations.fast,
            height: theme.spacing.minTouchTarget,
            decoration: BoxDecoration(
              color: background,
              borderRadius: theme.radii.smAll,
            ),
            alignment: Alignment.center,
            child: RotatedBox(
              quarterTurns: quarterTurns,
              child: AppIcon(
                AppIconGlyph.chevronRight,
                color: colors.textPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}
