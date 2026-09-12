import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';
import 'app_icon.dart';
import 'app_pressable.dart';

/// One entry of an [AppTabBar]: a glyph and its label.
@immutable
class AppTabItem {
  const AppTabItem({required this.label, required this.glyph});

  /// Visible label; also the accessibility label of the tab.
  final String label;
  final AppIconGlyph glyph;
}

/// How an [AppTabBar] is laid out.
enum AppTabBarLayout {
  /// Horizontal bar at the bottom of the screen (phones).
  bottom,

  /// Vertical rail on the leading edge (tablets, desktop, wide web windows).
  rail,
}

/// The app's main navigation: one tab per top-level destination.
///
/// Purely presentational: it shows [selectedIndex] and reports taps through
/// [onSelected] (including a tap on the already selected tab, so the caller
/// can pop that tab to its root). Every tab is an [AppPressable]: keyboard
/// focusable, Enter/Space activation, 48dp minimum hit target, and a
/// `Semantics` button node carrying the label and the selected flag.
///
/// Pick [AppTabBarLayout.rail] when the window is at least [railBreakpoint]
/// logical pixels wide; [AppTabBarLayout.bottom] otherwise. The bar handles
/// the safe-area inset on its own edge (bottom, or leading side for the rail),
/// so the caller should remove that inset from the content next to it.
class AppTabBar extends StatelessWidget {
  const AppTabBar({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.layout = AppTabBarLayout.bottom,
    this.semanticsLabel,
    super.key,
  }) : assert(items.length >= 2, 'A tab bar needs at least two tabs'),
       assert(
         selectedIndex >= 0 && selectedIndex < items.length,
         'selectedIndex out of range',
       );

  /// Window width (logical pixels) from which the rail layout is preferred.
  static const double railBreakpoint = 900;

  /// Total width of the rail layout (border and padding included).
  static const double railWidth = 112;

  final List<AppTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final AppTabBarLayout layout;

  /// Accessibility label of the whole bar (e.g. "Main navigation").
  final String? semanticsLabel;

  bool get _isRail => layout == AppTabBarLayout.rail;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final side = BorderSide(color: colors.border);

    final tabs = [
      for (var i = 0; i < items.length; i++)
        _Tab(
          item: items[i],
          selected: i == selectedIndex,
          rail: _isRail,
          onPressed: () => onSelected(i),
        ),
    ];

    final Widget content;
    if (_isRail) {
      // Scrollable so a short, wide window (or large text) never overflows.
      content = SizedBox(
        width: railWidth - 2 * theme.spacing.xs,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: theme.spacing.lg),
              for (final tab in tabs) ...[
                tab,
                SizedBox(height: theme.spacing.xs),
              ],
            ],
          ),
        ),
      );
    } else {
      // IntrinsicHeight so every tab's hover/press tint spans the same
      // height whatever its label; five children, so the cost is negligible.
      content = IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [for (final tab in tabs) Expanded(child: tab)],
        ),
      );
    }

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticsLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: _isRail ? Border(right: side) : Border(top: side),
        ),
        child: SafeArea(
          top: _isRail,
          left: _isRail,
          right: false,
          child: Padding(
            padding: EdgeInsets.all(theme.spacing.xs),
            child: content,
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.item,
    required this.selected,
    required this.rail,
    required this.onPressed,
  });

  final AppTabItem item;
  final bool selected;
  final bool rail;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    // Bottom tabs sit five abreast on a phone: a smaller label keeps them on
    // one line; the rail has room for the regular label size.
    final labelStyle = rail
        ? theme.textStyles.label
        : theme.textStyles.caption.copyWith(fontWeight: FontWeight.w600);

    return AppPressable(
      onPressed: onPressed,
      selected: selected,
      semanticsLabel: item.label,
      excludeSemantics: true,
      builder: (context, state) {
        final foreground = selected
            ? colors.accent
            : state.hovered || state.pressed
            ? colors.textPrimary
            : colors.textSecondary;
        // The icon sits on `indicator` (`accentSubtle`) where `accent`
        // reads fine, but the label below sits directly on the tab bar's
        // `surface`: `accent`-on-`surface` text falls well short of the
        // WCAG AA ratio (2.68:1; `textContrastGuideline` caught it,
        // US-123) -- `textPrimary` (already used for hover/press) keeps
        // the selected tab distinguishable via the indicator pill and bold
        // weight instead of colour alone.
        final labelForeground = selected ? colors.textPrimary : foreground;
        var background = const Color(0x00000000);
        if (state.pressed) {
          background = colors.surfaceRaised.shifted(theme, 0.08);
        } else if (state.hovered) {
          background = colors.surfaceRaised;
        }
        final indicator = selected
            ? colors.accentSubtle
            : const Color(0x00000000);

        return AppFocusRing(
          visible: state.focused,
          borderRadius: theme.radii.mdAll,
          child: AnimatedContainer(
            duration: theme.durations.fast,
            decoration: BoxDecoration(
              color: background,
              borderRadius: theme.radii.mdAll,
            ),
            padding: EdgeInsets.symmetric(
              vertical: theme.spacing.sm,
              horizontal: theme.spacing.xs,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: theme.durations.normal,
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing.lg,
                    vertical: theme.spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: indicator,
                    borderRadius: theme.radii.fullAll,
                  ),
                  child: AppIcon(item.glyph, color: foreground),
                ),
                SizedBox(height: theme.spacing.xs),
                Text(
                  item.label,
                  style: labelStyle.copyWith(color: labelForeground),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
