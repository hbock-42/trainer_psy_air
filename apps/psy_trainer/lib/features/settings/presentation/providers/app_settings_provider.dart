import 'dart:async';

import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_logger.dart';
import '../../../../core/repositories/repositories.dart';
import '../../domain/app_settings.dart';

/// The Settings tab's preferences (US-091): theme, language, sound,
/// keypad layout. Hydrates once from the profile, then holds state
/// synchronously so toggling a setting updates the UI immediately; each
/// setter also persists (fire-and-forget from the caller's point of view,
/// awaited internally so tests can `await` it).
///
/// Same hydration shape as `OnboardingCompletedNotifier`
/// (`features/onboarding/presentation/providers/`): a private
/// `Completer`-backed hydration the first read waits on, then plain state.
final NotifierProvider<AppSettingsController, AppSettings> appSettingsProvider =
    NotifierProvider<AppSettingsController, AppSettings>(
      AppSettingsController.new,
    );

class AppSettingsController extends Notifier<AppSettings> {
  Completer<AppSettings>? _hydration;

  ProgressRepository get _repository => ref.read(progressRepositoryProvider);

  @override
  AppSettings build() {
    _hydration = Completer<AppSettings>();
    unawaited(_hydrate());
    return AppSettings.defaults;
  }

  Future<void> _hydrate() async {
    AppSettings settings;
    try {
      settings = AppSettings.fromProfile(await _repository.profile());
    } on Object catch (error, stack) {
      logError(error, stack, context: 'settings hydration');
      settings = AppSettings.defaults;
    }
    state = settings;
    final completer = _hydration;
    if (completer != null && !completer.isCompleted) {
      completer.complete(settings);
    }
  }

  /// `state` once hydrated: synchronously if already known, otherwise a
  /// future that completes with the first value read from the database.
  FutureOr<AppSettings> whenHydrated() =>
      _hydration?.isCompleted ?? true ? state : _hydration!.future;

  Future<void> setThemeMode(ThemeModePreference value) =>
      _update((s) => s.copyWith(themeMode: value));

  Future<void> setLanguage(LanguagePreference value) =>
      _update((s) => s.copyWith(language: value));

  Future<void> setSoundEnabled({required bool enabled}) =>
      _update((s) => s.copyWith(soundEnabled: enabled));

  Future<void> setKeypadLayout(KeypadLayout value) =>
      _update((s) => s.copyWith(keypadLayout: value));

  Future<void> _update(AppSettings Function(AppSettings) apply) async {
    final next = apply(state);
    state = next;
    final existing = await _repository.profile();
    await _repository.saveProfile(next.applyTo(existing));
  }
}

/// The theme the root app should render (`AppThemeScope`/`app.dart`).
final Provider<ThemeModePreference> themeModeProvider =
    Provider<ThemeModePreference>(
      (ref) => ref.watch(appSettingsProvider).themeMode,
    );

/// `null` means "follow the system locale" (`WidgetsApp.router(locale:)`);
/// otherwise the explicit choice.
final Provider<Locale?> localeProvider = Provider<Locale?>((ref) {
  final language = ref.watch(appSettingsProvider).language;
  return switch (language) {
    LanguagePreference.system => null,
    LanguagePreference.fr => const Locale('fr'),
    LanguagePreference.en => const Locale('en'),
  };
});

/// Whether engines/exam cues should play sound (persisted only for now; no
/// engine wires it up yet — see the PR description).
final Provider<bool> soundEnabledProvider = Provider<bool>(
  (ref) => ref.watch(appSettingsProvider).soundEnabled,
);

/// Which on-screen numeric keypad layout to show (persisted only for now).
final Provider<KeypadLayout> keypadLayoutProvider = Provider<KeypadLayout>(
  (ref) => ref.watch(appSettingsProvider).keypadLayout,
);
