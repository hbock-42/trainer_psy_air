import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import 'app_icon.dart';
import 'app_pressable.dart';

/// Visual state of an [AnswerOptionTile].
enum AnswerOptionState {
  /// Not chosen, tappable.
  idle,

  /// Chosen by the user, answer not yet revealed.
  selected,

  /// Revealed as the right answer.
  correct,

  /// Chosen by the user and revealed as wrong.
  wrong,

  /// Not tappable (answer revealed, time is up, ...).
  disabled;

  bool get isInteractive => this == idle || this == selected;
}

/// One answer of a multiple-choice question.
///
/// Optional [index] (1..6) is shown as a leading badge and doubles as the
/// keyboard shortcut hint; [state] drives the colours and the trailing mark.
/// Pure presentational: the engine decides the state, the tile only reports
/// taps through [onPressed].
class AnswerOptionTile extends StatelessWidget {
  const AnswerOptionTile({
    required this.label,
    this.state = AnswerOptionState.idle,
    this.index,
    this.onPressed,
    this.child,
    this.focusNode,
    super.key,
  }) : assert(
         index == null || (index >= 1 && index <= 6),
         'index must be between 1 and 6',
       );

  /// The answer text (also the accessibility label).
  final String label;
  final AnswerOptionState state;

  /// 1-based position shown as a leading badge.
  final int? index;

  /// Ignored when [state] is not interactive ([AnswerOptionState.correct],
  /// [AnswerOptionState.wrong], [AnswerOptionState.disabled]).
  final VoidCallback? onPressed;

  /// Replaces the text (figure, formula) while [label] stays the semantics.
  final Widget? child;

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final effectiveOnPressed = state.isInteractive ? onPressed : null;

    final badge = index == null ? '' : 'Option $index. ';
    final stateHint = switch (state) {
      AnswerOptionState.idle => null,
      AnswerOptionState.selected => 'Selected',
      AnswerOptionState.correct => 'Correct answer',
      AnswerOptionState.wrong => 'Wrong answer',
      AnswerOptionState.disabled => null,
    };

    return AppPressable(
      onPressed: effectiveOnPressed,
      semanticsLabel: '$badge$label',
      semanticsHint: stateHint,
      selected: state == AnswerOptionState.selected,
      excludeSemantics: true,
      focusNode: focusNode,
      builder: (context, pressable) {
        final look = _resolve(theme, pressable);
        return AppFocusRing(
          visible: pressable.focused,
          borderRadius: theme.radii.mdAll,
          child: AnimatedContainer(
            duration: theme.durations.normal,
            decoration: BoxDecoration(
              color: look.background,
              borderRadius: theme.radii.mdAll,
              border: Border.all(color: look.border, width: 2),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.lg - 2,
              vertical: theme.spacing.md - 2,
            ),
            child: Row(
              children: [
                if (index != null) ...[
                  _IndexBadge(
                    index: index!,
                    background: look.badgeBackground,
                    foreground: look.badgeForeground,
                  ),
                  SizedBox(width: theme.spacing.md),
                ],
                Expanded(
                  child: DefaultTextStyle(
                    style: theme.textStyles.bodyStrong.copyWith(
                      color: look.foreground,
                    ),
                    child: child ?? Text(label),
                  ),
                ),
                if (look.trailing != null) ...[
                  SizedBox(width: theme.spacing.md),
                  AppIcon(look.trailing!, color: look.border),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  _TileLook _resolve(AppTheme theme, PressableState pressable) {
    final colors = theme.colors;
    switch (state) {
      case AnswerOptionState.idle:
        var background = colors.surface;
        if (pressable.pressed) {
          background = colors.surfaceRaised.shifted(theme, 0.06);
        } else if (pressable.hovered) {
          background = colors.surfaceRaised;
        }
        return _TileLook(
          background: background,
          border: pressable.hovered ? colors.borderStrong : colors.border,
          foreground: colors.textPrimary,
          badgeBackground: colors.surfaceRaised,
          badgeForeground: colors.textSecondary,
        );
      case AnswerOptionState.selected:
        return _TileLook(
          background: colors.accentSubtle,
          border: colors.accent,
          foreground: colors.textPrimary,
          badgeBackground: colors.accent,
          badgeForeground: colors.onAccent,
        );
      case AnswerOptionState.correct:
        return _TileLook(
          background: colors.successSubtle,
          border: colors.success,
          foreground: colors.textPrimary,
          badgeBackground: colors.success,
          badgeForeground: colors.onSuccess,
          trailing: AppIconGlyph.check,
        );
      case AnswerOptionState.wrong:
        return _TileLook(
          background: colors.errorSubtle,
          border: colors.error,
          foreground: colors.textPrimary,
          badgeBackground: colors.error,
          badgeForeground: colors.onError,
          trailing: AppIconGlyph.cross,
        );
      case AnswerOptionState.disabled:
        return _TileLook(
          background: colors.surface.disabledOn(theme),
          border: colors.border,
          foreground: colors.textMuted,
          badgeBackground: colors.surfaceRaised.disabledOn(theme),
          badgeForeground: colors.textMuted,
        );
    }
  }
}

class _TileLook {
  const _TileLook({
    required this.background,
    required this.border,
    required this.foreground,
    required this.badgeBackground,
    required this.badgeForeground,
    this.trailing,
  });

  final Color background;
  final Color border;
  final Color foreground;
  final Color badgeBackground;
  final Color badgeForeground;
  final AppIconGlyph? trailing;
}

class _IndexBadge extends StatelessWidget {
  const _IndexBadge({
    required this.index,
    required this.background,
    required this.foreground,
  });

  final int index;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return AnimatedContainer(
      duration: theme.durations.normal,
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      decoration: BoxDecoration(
        color: background,
        borderRadius: theme.radii.smAll,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.xs),
      child: Text(
        '$index',
        style: theme.textStyles.label.copyWith(color: foreground),
      ),
    );
  }
}
