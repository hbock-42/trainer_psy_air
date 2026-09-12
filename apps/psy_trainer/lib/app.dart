import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/l10n_extensions.dart';
import 'core/router/app_router.dart';
import 'core/router/startup_gate.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/domain/app_settings.dart';
import 'features/settings/presentation/providers/app_settings_provider.dart';

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
    final themeMode = ref.watch(themeModeProvider);
    return WidgetsApp.router(
      title: 'PSY Trainer',
      color: AppColors.light.background,
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(appRouterProvider),
      locale: ref.watch(localeProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        // WidgetsApp provides no theme nor default text style. AppThemeScope
        // installs both (tokens + DefaultTextStyle body) for every route and
        // overlay. The brightness follows the theme setting (US-091):
        // "system" reads the platform brightness, "light"/"dark" are
        // explicit.
        final brightness = switch (themeMode) {
          ThemeModePreference.system => MediaQuery.platformBrightnessOf(
            context,
          ),
          ThemeModePreference.light => Brightness.light,
          ThemeModePreference.dark => Brightness.dark,
        };
        final theme = AppTheme.forBrightness(brightness);
        // StartupGate keeps the Router (child) unmounted until the content
        // is seeded and the onboarding flag is known (US-013).
        return AppThemeScope(
          theme: theme,
          child: ColoredBox(
            color: theme.colors.background,
            child: StartupGate(child: child ?? const SizedBox.shrink()),
          ),
        );
      },
    );
  }
}
