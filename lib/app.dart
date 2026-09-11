import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/strings.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WidgetsApp.router(
      title: AppStrings.appName,
      color: AppColors.light.background,
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(appRouterProvider),
      builder: (context, child) {
        // WidgetsApp provides no theme nor default text style. AppThemeScope
        // installs both (tokens + DefaultTextStyle body) for every route and
        // overlay; the theme follows the platform brightness until a setting
        // exists (US-091).
        final theme = AppTheme.forBrightness(
          MediaQuery.platformBrightnessOf(context),
        );
        return AppThemeScope(
          theme: theme,
          child: ColoredBox(
            color: theme.colors.background,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
