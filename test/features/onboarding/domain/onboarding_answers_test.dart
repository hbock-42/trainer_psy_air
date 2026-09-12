import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/onboarding/domain/onboarding_answers.dart';
import 'package:psy_trainer/features/onboarding/domain/target_stage.dart';

void main() {
  final acceptedAt = DateTime.utc(2026, 9, 12, 8, 30);
  final examDate = DateTime.utc(2027, 9, 4);

  group('TargetStage', () {
    test('only PSY0 is available and is the default', () {
      expect(TargetStage.defaultStage, TargetStage.psy0);
      expect(TargetStage.psy0.isAvailable, isTrue);
      expect(TargetStage.psy1.isAvailable, isFalse);
      expect(TargetStage.psy2.isAvailable, isFalse);
    });

    test('round-trips through its key and falls back on unknown values', () {
      for (final stage in TargetStage.values) {
        expect(TargetStage.fromKey(stage.key), stage);
      }
      expect(TargetStage.fromKey(null), isNull);
      expect(TargetStage.fromKey('psy9'), isNull);
      expect(
        TargetStage.fromKey('psy9', fallback: TargetStage.psy0),
        TargetStage.psy0,
      );
    });
  });

  group('OnboardingAnswers', () {
    test('skipped keeps the disclaimer and uses the defaults', () {
      final skipped = OnboardingAnswers.skipped(
        disclaimerAcceptedAt: acceptedAt,
      );
      expect(skipped.disclaimerAcceptedAt, acceptedAt);
      expect(skipped.examDate, isNull);
      expect(skipped.targetStage, TargetStage.psy0);
    });

    test('applyTo creates a French profile with the completion flags', () {
      final answers = OnboardingAnswers(
        disclaimerAcceptedAt: acceptedAt,
        examDate: examDate,
        targetStage: TargetStage.psy0,
      );

      final profile = answers.applyTo(null);

      expect(profile.locale, 'fr');
      expect(profile.examDate, examDate);
      expect(profile.targetStage, 'psy0');
      expect(profile.settings[OnboardingAnswers.settingsKeyCompleted], isTrue);
      expect(
        profile.settings[OnboardingAnswers.settingsKeyDisclaimerAcceptedAt],
        '2026-09-12T08:30:00.000Z',
      );
      expect(OnboardingAnswers.isCompleted(profile), isTrue);
    });

    test('applyTo preserves the locale and other settings', () {
      const existing = UserProfile(
        locale: 'en',
        settings: {
          'theme': 'dark',
          OnboardingAnswers.settingsKeyCompleted: true,
        },
        targetStage: 'psy0',
      );
      final answers = OnboardingAnswers(
        disclaimerAcceptedAt: acceptedAt,
        targetStage: TargetStage.psy1,
      );

      final profile = answers.applyTo(existing);

      expect(profile.locale, 'en');
      expect(profile.settings['theme'], 'dark');
      expect(profile.examDate, isNull);
      expect(profile.targetStage, 'psy1');
    });

    test('fromProfile reads back what applyTo wrote', () {
      final answers = OnboardingAnswers(
        disclaimerAcceptedAt: acceptedAt,
        examDate: examDate,
        targetStage: TargetStage.psy0,
      );
      expect(OnboardingAnswers.fromProfile(answers.applyTo(null)), answers);
    });

    test('fromProfile is null without a completed onboarding', () {
      expect(OnboardingAnswers.fromProfile(null), isNull);
      expect(
        OnboardingAnswers.fromProfile(const UserProfile(locale: 'fr')),
        isNull,
      );
      expect(OnboardingAnswers.isCompleted(null), isFalse);
      // Completed flag without an acceptance instant: treated as not done.
      expect(
        OnboardingAnswers.fromProfile(
          const UserProfile(
            locale: 'fr',
            settings: {OnboardingAnswers.settingsKeyCompleted: true},
          ),
        ),
        isNull,
      );
    });

    test('fromProfile falls back to PSY0 for an unknown stage', () {
      final profile = UserProfile(
        locale: 'fr',
        settings: {
          OnboardingAnswers.settingsKeyCompleted: true,
          OnboardingAnswers.settingsKeyDisclaimerAcceptedAt: acceptedAt
              .toIso8601String(),
        },
        targetStage: 'psy7',
      );
      expect(
        OnboardingAnswers.fromProfile(profile)?.targetStage,
        TargetStage.psy0,
      );
    });

    test('copyWith can clear the exam date', () {
      final answers = OnboardingAnswers(
        disclaimerAcceptedAt: acceptedAt,
        examDate: examDate,
        targetStage: TargetStage.psy0,
      );
      expect(answers.copyWith(examDate: () => null).examDate, isNull);
      expect(answers.copyWith().examDate, examDate);
      expect(
        answers.copyWith(targetStage: TargetStage.psy2).targetStage,
        TargetStage.psy2,
      );
    });

    test('value equality', () {
      final a = OnboardingAnswers(
        disclaimerAcceptedAt: acceptedAt,
        targetStage: TargetStage.psy0,
      );
      final b = OnboardingAnswers(
        disclaimerAcceptedAt: acceptedAt,
        targetStage: TargetStage.psy0,
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a.toString(), contains('psy0'));
      expect(a, isNot(a.copyWith(examDate: () => examDate)));
    });
  });
}
