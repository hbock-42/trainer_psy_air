import 'package:flutter/widgets.dart';

/// The single [Page] type used by every go_router route in the app.
///
/// There is no `MaterialPage`/`CupertinoPage` here (widgets layer only), so
/// this page creates its own [PageRoute] with a short fade + slide-up
/// transition. Change the transition in one place to change it everywhere.
///
/// The route reads [child] from its current `settings` at build time rather
/// than capturing it: when go_router updates a page in place (same key, new
/// child, e.g. switching a shell branch) the Navigator swaps the settings and
/// the new child must be shown. A plain `PageRouteBuilder` would keep showing
/// the first child.
class AppPage<T> extends Page<T> {
  const AppPage({
    required this.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    this.transitionDuration = const Duration(milliseconds: 220),
  });

  /// The route's content.
  final Widget child;

  /// Duration of the enter/exit transition.
  final Duration transitionDuration;

  @override
  Route<T> createRoute(BuildContext context) => _AppPageRoute<T>(this);
}

class _AppPageRoute<T> extends PageRoute<T> {
  _AppPageRoute(AppPage<T> page) : super(settings: page);

  static const Offset _slideFrom = Offset(0, 0.04);

  AppPage<T> get _page => settings as AppPage<T>;

  @override
  Duration get transitionDuration => _page.transitionDuration;

  @override
  Duration get reverseTransitionDuration => _page.transitionDuration;

  @override
  bool get opaque => true;

  @override
  bool get maintainState => true;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: _page.child,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final CurvedAnimation curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: _slideFrom,
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
