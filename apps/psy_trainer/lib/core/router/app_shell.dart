import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/widgets.dart';
import '../l10n/strings.dart';
import 'app_routes.dart';

/// Shell around the five tab branches: the active branch's navigator plus
/// the main navigation ([AppTabBar]).
///
/// Narrow windows get a bottom bar; windows at least
/// [AppTabBar.railBreakpoint] wide (tablets, desktop, web) get a left rail.
/// Each branch keeps its own navigator stack while hidden (indexed stack);
/// tapping the already selected tab pops that branch back to its root.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  /// Tabs in [AppRoutes.tabs] (branch index) order.
  static const List<AppTabItem> tabs = [
    AppTabItem(label: AppStrings.tabLearn, glyph: AppIconGlyph.book),
    AppTabItem(label: AppStrings.tabTrain, glyph: AppIconGlyph.target),
    AppTabItem(label: AppStrings.tabExam, glyph: AppIconGlyph.clock),
    AppTabItem(label: AppStrings.tabProgress, glyph: AppIconGlyph.chart),
    AppTabItem(label: AppStrings.tabSettings, glyph: AppIconGlyph.settings),
  ];

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      // Re-tapping the active tab resets it to its first route.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(
      tabs.length == AppRoutes.tabs.length,
      'AppShell.tabs must match AppRoutes.tabs',
    );
    return AppScaffold(
      safeArea: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= AppTabBar.railBreakpoint;
          final tabBar = AppTabBar(
            items: tabs,
            selectedIndex: navigationShell.currentIndex,
            onSelected: _onTabSelected,
            layout: wide ? AppTabBarLayout.rail : AppTabBarLayout.bottom,
            semanticsLabel: AppStrings.tabBarLabel,
          );
          // The bar consumes the safe-area inset on its own edge; screens must
          // not pad for it a second time.
          final content = MediaQuery.removePadding(
            context: context,
            removeBottom: !wide,
            removeLeft: wide,
            child: navigationShell,
          );
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                tabBar,
                Expanded(child: content),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: content),
              tabBar,
            ],
          );
        },
      ),
    );
  }
}
