import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/onboarding/domain/onboarding_answers.dart';
import 'package:psy_trainer/features/onboarding/domain/target_stage.dart';
import 'package:psy_trainer/features/onboarding/presentation/providers/onboarding_answers_provider.dart';
import 'package:psy_trainer/features/onboarding/presentation/providers/onboarding_completed_provider.dart';

import '../../../../helpers/onboarding_fakes.dart';

/// Reference for testing providers in this project:
/// - `ProviderContainer.test()` gives an isolated container that is disposed
///   automatically at the end of the test.
/// - `overrides:` swaps a provider's implementation (fake repository, fixed
///   value) without touching the widget tree.
void main() {
  ProviderContainer containerWith(ProgressRepository repository) =>
      ProviderContainer.test(
        overrides: [progressRepositoryOverride(repository: repository)],
      );

  group('onboardingCompletedProvider', () {
    test('is null until the profile has been read, then true', () async {
      final container = containerWith(fakeProgressRepository());

      expect(container.read(onboardingCompletedProvider), isNull);
      final notifier = container.read(onboardingCompletedProvider.notifier);
      final FutureOr<bool> pending = notifier.whenHydrated();
      expect(pending, isA<Future<bool>>());

      expect(await pending, isTrue);
      expect(container.read(onboardingCompletedProvider), isTrue);
      // Hydrated: answers synchronously from now on.
      expect(notifier.whenHydrated(), isTrue);
    });

    test('hydrates to false on a fresh install (no profile)', () async {
      final container = containerWith(fakeProgressRepository(completed: false));

      expect(
        await container
            .read(onboardingCompletedProvider.notifier)
            .whenHydrated(),
        isFalse,
      );
      expect(container.read(onboardingCompletedProvider), isFalse);
    });

    test('a legacy profile without the flag counts as not completed', () async {
      final repository = InMemoryProgressRepository()
        ..storedProfile = const UserProfile(locale: 'fr', targetStage: 'psy0');
      final container = containerWith(repository);

      expect(
        await container
            .read(onboardingCompletedProvider.notifier)
            .whenHydrated(),
        isFalse,
      );
    });

    test('a failing repository hydrates to false instead of hanging', () async {
      final container = containerWith(_ThrowingProgressRepository());

      expect(
        await container
            .read(onboardingCompletedProvider.notifier)
            .whenHydrated(),
        isFalse,
      );
    });

    test('complete persists the answers and flips the state', () async {
      final repository = fakeProgressRepository(completed: false);
      final container = containerWith(repository);
      final notifier = container.read(onboardingCompletedProvider.notifier);
      await notifier.whenHydrated();
      final List<bool?> seen = [];
      container.listen<bool?>(
        onboardingCompletedProvider,
        (_, next) => seen.add(next),
        fireImmediately: true,
      );

      expect(await container.read(onboardingAnswersProvider.future), isNull);
      await notifier.complete(completedAnswers);

      expect(seen, [false, true]);
      expect(OnboardingAnswers.isCompleted(repository.storedProfile), isTrue);
      expect(repository.storedProfile?.examDate, completedAnswers.examDate);
      // The answers provider was invalidated and re-reads the profile.
      expect(
        await container.read(onboardingAnswersProvider.future),
        completedAnswers,
      );
    });

    test('complete keeps the existing profile settings when editing', () async {
      final repository = fakeProgressRepository();
      repository.storedProfile = repository.storedProfile!.copyWith(
        locale: 'en',
        settings: {...repository.storedProfile!.settings, 'theme': 'dark'},
      );
      final container = containerWith(repository);
      final notifier = container.read(onboardingCompletedProvider.notifier);

      await notifier.complete(
        completedAnswers.copyWith(
          examDate: () => null,
          targetStage: TargetStage.psy1,
        ),
      );

      final profile = repository.storedProfile!;
      expect(profile.locale, 'en');
      expect(profile.settings['theme'], 'dark');
      expect(profile.examDate, isNull);
      expect(profile.targetStage, 'psy1');
    });

    test('reset marks onboarding as not completed', () async {
      final container = containerWith(fakeProgressRepository());
      final notifier = container.read(onboardingCompletedProvider.notifier);
      await notifier.whenHydrated();

      notifier.reset();

      expect(container.read(onboardingCompletedProvider), isFalse);
      expect(notifier.whenHydrated(), isFalse);
    });

    test('can be overridden with a fixed value in tests', () {
      final ProviderContainer container = ProviderContainer.test(
        overrides: [
          onboardingCompletedProvider.overrideWith(_NotCompletedOnboarding.new),
        ],
      );

      expect(container.read(onboardingCompletedProvider), isFalse);
      expect(
        container.read(onboardingCompletedProvider.notifier).whenHydrated(),
        isFalse,
      );
    });
  });
}

class _NotCompletedOnboarding extends OnboardingCompletedNotifier {
  @override
  bool? build() => false;
}

/// Every call throws, like a corrupted or unopenable database.
class _ThrowingProgressRepository extends InMemoryProgressRepository {
  @override
  Future<UserProfile?> profile() => throw StateError('database unavailable');
}
