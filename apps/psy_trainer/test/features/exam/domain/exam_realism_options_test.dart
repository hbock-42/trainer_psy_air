import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/exam/domain/exam_realism_options.dart';

void main() {
  group('ExamRealismOptions', () {
    test('defaults are the non-strict, current-behaviour values', () {
      const options = ExamRealismOptions.defaults;
      expect(options.negativeMarkingCulture, isFalse);
      expect(options.hideRemainingTime, isFalse);
      expect(options.hideTimerEnglish, isFalse);
      expect(options.randomizeGenerated, isTrue);
      expect(options.allowPauseBetweenSections, isTrue);
      expect(options.immersiveFullScreen, isFalse);
      expect(options.soundCuesEnabled, isFalse);
    });

    test('fromProfile falls back to defaults with no profile', () {
      expect(ExamRealismOptions.fromProfile(null), ExamRealismOptions.defaults);
    });

    test('fromProfile falls back to defaults with no stored key', () {
      const profile = UserProfile(locale: 'fr');
      expect(
        ExamRealismOptions.fromProfile(profile),
        ExamRealismOptions.defaults,
      );
    });

    test('applyTo then fromProfile round-trips every field', () {
      const options = ExamRealismOptions(
        negativeMarkingCulture: true,
        hideRemainingTime: true,
        hideTimerEnglish: true,
        randomizeGenerated: false,
        allowPauseBetweenSections: false,
        immersiveFullScreen: true,
        soundCuesEnabled: true,
      );
      final saved = options.applyTo(const UserProfile(locale: 'fr'));
      expect(
        saved.settings[ExamRealismOptions.settingsKey],
        isA<Map<String, Object?>>(),
      );
      expect(ExamRealismOptions.fromProfile(saved), options);
    });

    test('applyTo preserves other profile fields and settings keys', () {
      final existing = UserProfile(
        locale: 'en',
        examDate: DateTime.utc(2026, 12),
        targetStage: 'psy0',
        settings: const {'themeMode': 'dark'},
      );
      final saved = ExamRealismOptions.defaults.applyTo(existing);
      expect(saved.locale, 'en');
      expect(saved.examDate, existing.examDate);
      expect(saved.targetStage, 'psy0');
      expect(saved.settings['themeMode'], 'dark');
      expect(
        saved.settings[ExamRealismOptions.settingsKey],
        isA<Map<String, Object?>>(),
      );
    });

    test('a value of the wrong shape at the settings key falls back to '
        'defaults instead of throwing', () {
      const profile = UserProfile(
        locale: 'fr',
        settings: {'exam.realism': 'not a map'},
      );
      expect(
        ExamRealismOptions.fromProfile(profile),
        ExamRealismOptions.defaults,
      );
    });

    test('realConditions sets every option to its strictest value', () {
      const preset = ExamRealismOptions.realConditions;
      expect(preset.negativeMarkingCulture, isTrue);
      expect(preset.hideRemainingTime, isTrue);
      expect(preset.hideTimerEnglish, isTrue);
      expect(preset.randomizeGenerated, isTrue);
      expect(preset.allowPauseBetweenSections, isFalse);
      expect(preset.immersiveFullScreen, isTrue);
      expect(preset.soundCuesEnabled, isTrue);
      expect(preset.isRealConditions, isTrue);
      expect(ExamRealismOptions.defaults.isRealConditions, isFalse);
    });

    test('copyWith changes only the given fields', () {
      const options = ExamRealismOptions.defaults;
      final updated = options.copyWith(negativeMarkingCulture: true);
      expect(updated.negativeMarkingCulture, isTrue);
      expect(updated.hideRemainingTime, options.hideRemainingTime);
      expect(
        updated.allowPauseBetweenSections,
        options.allowPauseBetweenSections,
      );
    });
  });
}
