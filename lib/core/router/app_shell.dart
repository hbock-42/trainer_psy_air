import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Shell around the five tab branches.
///
/// Renders the active branch's navigator only. The bottom navigation bar is
/// added in US-005; `navigationShell.goBranch(index)` switches tab and
/// `navigationShell.currentIndex` tells which one is active.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => navigationShell;
}
