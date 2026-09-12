import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/settings/domain/reminder_settings.dart';

void main() {
  group('ReminderSettings', () {
    test('defaults are off, 18:00', () {
      const settings = ReminderSettings.defaults;
      expect(settings.enabled, isFalse);
      expect(settings.hour, 18);
      expect(settings.minute, 0);
    });

    test('fromProfile falls back to defaults with no profile', () {
      expect(ReminderSettings.fromProfile(null), ReminderSettings.defaults);
    });

    test('fromProfile falls back to defaults with no stored key', () {
      const profile = UserProfile(locale: 'fr');
      expect(ReminderSettings.fromProfile(profile), ReminderSettings.defaults);
    });

    test('applyTo then fromProfile round-trips every field', () {
      const settings = ReminderSettings(enabled: true, hour: 7, minute: 45);
      final saved = settings.applyTo(const UserProfile(locale: 'fr'));
      expect(
        saved.settings[ReminderSettings.settingsKey],
        isA<Map<String, Object?>>(),
      );
      expect(ReminderSettings.fromProfile(saved), settings);
    });

    test('applyTo preserves other profile fields and settings keys', () {
      final existing = UserProfile(
        locale: 'en',
        examDate: DateTime.utc(2026, 12),
        targetStage: 'psy0',
        settings: const {'themeMode': 'dark'},
      );
      final saved = ReminderSettings.defaults.applyTo(existing);
      expect(saved.locale, 'en');
      expect(saved.examDate, existing.examDate);
      expect(saved.targetStage, 'psy0');
      expect(saved.settings['themeMode'], 'dark');
      expect(
        saved.settings[ReminderSettings.settingsKey],
        isA<Map<String, Object?>>(),
      );
    });

    test('fromJson clamps an out-of-range hour/minute', () {
      final settings = ReminderSettings.fromJson({
        'enabled': true,
        'hour': 27,
        'minute': -3,
      });
      expect(settings.hour, 23);
      expect(settings.minute, 0);
    });

    test('copyWith updates only the given fields', () {
      const settings = ReminderSettings(enabled: true, hour: 8, minute: 30);
      final next = settings.copyWith(hour: 20);
      expect(next.enabled, isTrue);
      expect(next.hour, 20);
      expect(next.minute, 30);
    });
  });
}
