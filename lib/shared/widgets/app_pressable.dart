import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';

/// Snapshot of the interaction state of an [AppPressable], handed to its
/// builder so the caller can pick colours and shapes per state.
@immutable
class PressableState {
  const PressableState({
    required this.enabled,
    required this.hovered,
    required this.focused,
    required this.pressed,
  });

  final bool enabled;
  final bool hovered;
  final bool focused;
  final bool pressed;

  bool get disabled => !enabled;

  @override
  bool operator ==(Object other) {
    return other is PressableState &&
        other.enabled == enabled &&
        other.hovered == hovered &&
        other.focused == focused &&
        other.pressed == pressed;
  }

  @override
  int get hashCode => Object.hash(enabled, hovered, focused, pressed);

  @override
  String toString() {
    return 'PressableState(enabled: $enabled, hovered: $hovered, '
        'focused: $focused, pressed: $pressed)';
  }
}

/// The interaction primitive of the design system.
///
/// Wraps [builder] with everything an accessible, widget-layer-only control
/// needs and nothing about its look:
///
/// * tap / press via [GestureDetector] (press feedback on pointer down, cancel
///   on drag away);
/// * hover and focus highlight, keyboard activation (Enter/Space) via
///   [FocusableActionDetector];
/// * a minimum hit target of [AppSpacing.minTouchTarget] on both axes;
/// * a [Semantics] node flagged as a button, with [semanticsLabel] and the
///   enabled/selected flags.
///
/// Buttons, tiles and keypad keys build on this; they only decide the visuals
/// in [builder].
class AppPressable extends StatefulWidget {
  const AppPressable({
    required this.builder,
    this.onPressed,
    this.semanticsLabel,
    this.semanticsHint,
    this.selected,
    this.focusNode,
    this.autofocus = false,
    this.minSize,
    this.cursor = SystemMouseCursors.click,
    this.excludeSemantics = false,
    super.key,
  });

  final Widget Function(BuildContext context, PressableState state) builder;

  /// Null makes the control disabled: no gestures, no focus, dimmed visuals.
  final VoidCallback? onPressed;

  /// Accessibility label. When null, the label is derived from the subtree.
  final String? semanticsLabel;
  final String? semanticsHint;

  /// Selected flag for toggle-like controls (answer options, tabs).
  final bool? selected;

  final FocusNode? focusNode;
  final bool autofocus;

  /// Minimum width/height. Defaults to the theme's `minTouchTarget` (48).
  final double? minSize;

  final MouseCursor cursor;

  /// When true the semantics of the built visuals are dropped so only
  /// [semanticsLabel] is announced (otherwise child labels are merged in).
  final bool excludeSemantics;

  bool get enabled => onPressed != null;

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  void _activate() {
    widget.onPressed?.call();
  }

  @override
  void didUpdateWidget(AppPressable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled && _pressed) {
      _pressed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = AppTheme.of(context).spacing;
    final minSize = widget.minSize ?? spacing.minTouchTarget;
    final state = PressableState(
      enabled: widget.enabled,
      hovered: _hovered && widget.enabled,
      focused: _focused && widget.enabled,
      pressed: _pressed && widget.enabled,
    );

    return Semantics(
      container: true,
      button: true,
      enabled: widget.enabled,
      selected: widget.selected,
      label: widget.semanticsLabel,
      hint: widget.semanticsHint,
      onTap: widget.enabled ? _activate : null,
      child: FocusableActionDetector(
        enabled: widget.enabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: widget.enabled ? widget.cursor : MouseCursor.defer,
        onShowHoverHighlight: (value) => setState(() => _hovered = value),
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _activate();
              return null;
            },
          ),
          ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
            onInvoke: (_) {
              _activate();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onTapDown: widget.enabled ? (_) => _setPressed(true) : null,
          onTapUp: widget.enabled ? (_) => _setPressed(false) : null,
          onTapCancel: widget.enabled ? () => _setPressed(false) : null,
          onTap: widget.enabled ? _activate : null,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
            child: widget.excludeSemantics
                ? ExcludeSemantics(child: widget.builder(context, state))
                : widget.builder(context, state),
          ),
        ),
      ),
    );
  }
}

/// Draws a focus ring around [child] when [visible]. Shared by every control
/// so focus looks the same everywhere.
class AppFocusRing extends StatelessWidget {
  const AppFocusRing({
    required this.visible,
    required this.borderRadius,
    required this.child,
    super.key,
  });

  final bool visible;
  final BorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: visible
            ? [BoxShadow(color: theme.colors.focusRing, spreadRadius: 2.5)]
            : null,
      ),
      child: child,
    );
  }
}

/// Colour helpers for interaction states.
extension AppColorStates on Color {
  /// Slightly darker (light theme) or lighter (dark theme) version, used for
  /// hover and press feedback.
  Color shifted(AppTheme theme, double amount) {
    final target = theme.isDark
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF000000);
    return Color.lerp(this, target, amount)!;
  }

  /// Faded toward the page background, used for disabled controls.
  Color disabledOn(AppTheme theme) {
    return Color.lerp(this, theme.colors.background, 0.55)!;
  }
}
