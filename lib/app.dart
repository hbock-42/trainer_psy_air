import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';

/// Root of the application.
///
/// Project-wide constraint: the UI is built on the Flutter `widgets` layer only.
/// This is a [WidgetsApp.router], never a `MaterialApp` or `CupertinoApp`, and
/// nothing under `lib/` may import `package:flutter/material.dart` or
/// `package:flutter/cupertino.dart` (enforced by `test/architecture/`).
///
/// Must sit under a `ProviderScope` (see `main.dart`): the router itself is a
/// Riverpod provider so its redirect guard can read app state.
class PsyTrainerApp extends ConsumerWidget {
  const PsyTrainerApp({super.key});

  static const Color _background = Color(0xFF0B1D3A);
  static const Color _foreground = Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WidgetsApp.router(
      title: 'PSY Trainer',
      color: _background,
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(appRouterProvider),
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
