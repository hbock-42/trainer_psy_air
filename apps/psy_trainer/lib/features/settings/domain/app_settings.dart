import '../../../core/repositories/model/learning.dart';

/// User-chosen appearance, matching [AppThemeScope]'s two themes.
enum ThemeModePreference {
  system('system'),
  light('light'),
  dark('dark');

  const ThemeModePreference(this.key);

  final String key;

  static ThemeModePreference fromKey(String? key) =>
      ThemeModePreference.values.firstWhere(
        (v) => v.key == key,
        orElse: () => ThemeModePreference.system,
      );
}

/// UI language. Stored in [UserProfile.locale] (an existing column, unused
/// until this story): `'system'`, `'fr'` or `'en'`. Content language
/// (`LocalizedText.resolve`) is a separate concern — screens read the
/// *effective* locale from `context.l10n.localeName` instead, so it follows
/// `'system'` correctly without this enum needing to resolve anything.
enum LanguagePreference {
  system('system'),
  fr('fr'),
  en('en');

  const LanguagePreference(this.key);

  final String key;

  static LanguagePreference fromKey(String? key) =>
      LanguagePreference.values.firstWhere(
        (v) => v.key == key,
        // Legacy rows (pre-US-091) and new ones without a profile yet: FR,
        // matching the previous hard-coded default (`AppStrings`' locale
        // constant, before ARB-based i18n replaced it).
        orElse: () => LanguagePreference.fr,
      );
}

/// Which on-screen numeric keypad layout to show (US-091: persisted only;
/// engines that offer both layouts read this once they exist).
enum KeypadLayout {
  phone('phone'),
  calculator('calculator');

  const KeypadLayout(this.key);

  final String key;

  static KeypadLayout fromKey(String? key) => KeypadLayout.values.firstWhere(
    (v) => v.key == key,
    orElse: () => KeypadLayout.phone,
  );
}

/// The Settings tab's preferences, persisted in [UserProfile.locale] (the
/// language) and [UserProfile.settings] (everything else — see
/// `docs/ARCHITECTURE.md`, "Settings (US-091)", for the key names).
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeModePreference.system,
    this.language = LanguagePreference.fr,
    this.soundEnabled = true,
    this.keypadLayout = KeypadLayout.phone,
  });

  static const String settingsKeyThemeMode = 'themeMode';
  static const String settingsKeySoundEnabled = 'soundEnabled';
  static const String settingsKeyKeypadLayout = 'keypadLayout';

  final ThemeModePreference themeMode;
  final LanguagePreference language;
  final bool soundEnabled;
  final KeypadLayout keypadLayout;

  /// Defaults when there is no profile yet (before onboarding).
  static const AppSettings defaults = AppSettings();

  factory AppSettings.fromProfile(UserProfile? profile) {
    if (profile == null) return AppSettings.defaults;
    final settings = profile.settings;
    return AppSettings(
      themeMode: ThemeModePreference.fromKey(
        settings[settingsKeyThemeMode] as String?,
      ),
      language: LanguagePreference.fromKey(profile.locale),
      soundEnabled: settings[settingsKeySoundEnabled] as bool? ?? true,
      keypadLayout: KeypadLayout.fromKey(
        settings[settingsKeyKeypadLayout] as String?,
      ),
    );
  }

  /// The profile to save: [existing] (if any) with these settings applied.
  /// Other profile fields (`examDate`, `targetStage`, the onboarding flags
  /// in `settings`) are preserved.
  UserProfile applyTo(UserProfile? existing) {
    return UserProfile(
      locale: language.key,
      examDate: existing?.examDate,
      targetStage: existing?.targetStage,
      settings: {
        ...?existing?.settings,
        settingsKeyThemeMode: themeMode.key,
        settingsKeySoundEnabled: soundEnabled,
        settingsKeyKeypadLayout: keypadLayout.key,
      },
    );
  }

  AppSettings copyWith({
    ThemeModePreference? themeMode,
    LanguagePreference? language,
    bool? soundEnabled,
    KeypadLayout? keypadLayout,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      keypadLayout: keypadLayout ?? this.keypadLayout,
    );
  }
}
