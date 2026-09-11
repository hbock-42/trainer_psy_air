import 'package:flutter/widgets.dart';

/// Root of the application.
///
/// Project-wide constraint: the UI is built on the Flutter `widgets` layer only.
/// This is a [WidgetsApp], never a `MaterialApp` or `CupertinoApp`, and nothing
/// under `lib/` may import `package:flutter/material.dart` or
/// `package:flutter/cupertino.dart` (enforced by `test/architecture/`).
///
/// Routing (go_router) and state (Riverpod) are wired in US-002; until then the
/// app shows a single placeholder screen.
class PsyTrainerApp extends StatelessWidget {
  const PsyTrainerApp({super.key});

  static const Color _background = Color(0xFF0B1D3A);
  static const Color _foreground = Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'PSY Trainer',
      color: _background,
      debugShowCheckedModeBanner: false,
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        );
      },
      home: const PlaceholderScreen(),
      builder: (context, child) {
        // WidgetsApp provides no default text style: without one, Text renders
        // in the "missing style" yellow/underlined look. Every subtree needs it.
        return DefaultTextStyle(
          style: const TextStyle(
            color: _foreground,
            fontSize: 16,
            decoration: TextDecoration.none,
          ),
          child: ColoredBox(
            color: _background,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}

/// Temporary landing screen, replaced by the navigation shell in US-002.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PSY Trainer',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 12),
              Text(
                'Scaffold ready. Navigation shell comes in US-002.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
