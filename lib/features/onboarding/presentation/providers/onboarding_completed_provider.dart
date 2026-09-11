import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the user has completed onboarding.
///
/// Placeholder: defaults to `true` so the app opens on the tabs. US-090 backs
/// it with the database and keeps this provider as the read model, so the
/// router's redirect does not change. Also the reference example of a
/// provider overridden in tests (see
/// `test/features/onboarding/presentation/providers/`).
final NotifierProvider<OnboardingCompletedNotifier, bool>
onboardingCompletedProvider =
    NotifierProvider<OnboardingCompletedNotifier, bool>(
      OnboardingCompletedNotifier.new,
    );

class OnboardingCompletedNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void complete() => state = true;

  /// For tests and the future "reset onboarding" setting.
  void reset() => state = false;
}
