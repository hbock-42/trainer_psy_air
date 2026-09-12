import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/exam_date_rules.dart';

/// A calendar-day input made of three steppers (day, month, year), built from
/// design-system primitives only (no platform date picker).
///
/// [value] is a UTC calendar day (see `exam_date_rules.dart`); every change
/// goes through [onChanged] with a value clamped to a valid day of the month.
/// Years are limited to `[minYear, maxYear]`; the day and month wrap around.
class DateStepperField extends StatelessWidget {
  const DateStepperField({
    required this.value,
    required this.onChanged,
    required this.minYear,
    required this.maxYear,
    super.key,
  }) : assert(minYear <= maxYear, 'minYear must not exceed maxYear');

  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  final int minYear;
  final int maxYear;

  void _stepDay(int delta) {
    final days = daysInMonth(value.year, value.month);
    final day = (value.day - 1 + delta) % days + 1;
    onChanged(clampedDay(value.year, value.month, day));
  }

  void _stepMonth(int delta) {
    final month = (value.month - 1 + delta) % 12 + 1;
    onChanged(clampedDay(value.year, month, value.day));
  }

  void _stepYear(int delta) {
    final year = (value.year + delta).clamp(minYear, maxYear);
    onChanged(clampedDay(year, value.month, value.day));
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Semantics(
      container: true,
      label: context.l10n.formatLongDate(value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _StepperColumn(
              label: context.l10n.dateFieldDay,
              display: '${value.day}',
              onIncrement: () => _stepDay(1),
              onDecrement: () => _stepDay(-1),
            ),
          ),
          SizedBox(width: theme.spacing.sm),
          Expanded(
            flex: 2,
            child: _StepperColumn(
              label: context.l10n.dateFieldMonth,
              display: context.l10n.monthShort(value.month),
              onIncrement: () => _stepMonth(1),
              onDecrement: () => _stepMonth(-1),
            ),
          ),
          SizedBox(width: theme.spacing.sm),
          Expanded(
            flex: 2,
            child: _StepperColumn(
              label: context.l10n.dateFieldYear,
              display: '${value.year}',
              onIncrement: value.year < maxYear ? () => _stepYear(1) : null,
              onDecrement: value.year > minYear ? () => _stepYear(-1) : null,
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
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

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
  final VoidCallback? onPressed;

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
                color: state.disabled
                    ? colors.textMuted.disabledOn(theme)
                    : colors.textPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}
