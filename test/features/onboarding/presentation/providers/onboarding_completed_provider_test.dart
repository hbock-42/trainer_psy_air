import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/onboarding/presentation/providers/onboarding_completed_provider.dart';

/// Reference for testing providers in this project:
/// - `ProviderContainer.test()` gives an isolated container that is disposed
///   automatically at the end of the test.
/// - `overrides:` swaps a provider's implementation (fake repository, fixed
///   value) without touching the widget tree.
void main() {
  group('onboardingCompletedProvider', () {
    test('defaults to true until US-090 backs it with the database', () {
      final ProviderContainer container = ProviderContainer.test();

      expect(container.read(onboardingCompletedProvider), isTrue);
    });

    test('notifier updates the state and listeners see it', () {
      final ProviderContainer container = ProviderContainer.test();
      final List<bool> seen = [];
      container.listen<bool>(
        onboardingCompletedProvider,
        (_, next) => seen.add(next),
        fireImmediately: true,
      );

      container.read(onboardingCompletedProvider.notifier).reset();
      container.read(onboardingCompletedProvider.notifier).complete();

      expect(seen, [true, false, true]);
    });

    test('can be overridden with a fixed value in tests', () {
      final ProviderContainer container = ProviderContainer.test(
        overrides: [
          onboardingCompletedProvider.overrideWith(_NotCompletedOnboarding.new),
        ],
      );

      expect(container.read(onboardingCompletedProvider), isFalse);
    });
  });
}

class _NotCompletedOnboarding extends OnboardingCompletedNotifier {
  @override
  bool build() => false;
}
