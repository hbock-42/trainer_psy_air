import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_logger.dart';
import '../../../../core/repositories/repositories.dart';
import '../../domain/onboarding_answers.dart';
import 'onboarding_answers_provider.dart';

/// Whether the user has completed onboarding, as the router's guard reads it.
///
/// Backed by the profile in [progressRepositoryProvider]. The state is
/// `null` until the profile has been read once ("hydrating"), then `true` /
/// `false`; the router awaits [OnboardingCompletedNotifier.whenHydrated] on
/// its first redirect so a returning user never sees the onboarding flash.
///
/// Also the reference example of a provider overridden in tests (see
/// `test/features/onboarding/presentation/providers/`).
final NotifierProvider<OnboardingCompletedNotifier, bool?>
onboardingCompletedProvider =
    NotifierProvider<OnboardingCompletedNotifier, bool?>(
      OnboardingCompletedNotifier.new,
    );

class OnboardingCompletedNotifier extends Notifier<bool?> {
  Completer<bool>? _hydration;

  ProgressRepository get _repository => ref.read(progressRepositoryProvider);

  @override
  bool? build() {
    _hydration = Completer<bool>();
    unawaited(_hydrate());
    return null;
  }

  Future<void> _hydrate() async {
    bool done;
    try {
      done = OnboardingAnswers.isCompleted(await _repository.profile());
    } on Object catch (error, stack) {
      // A unreadable profile must not lock the user out of the app: treat it
      // as a fresh install and let onboarding write a new one.
      logError(error, stack, context: 'onboarding hydration');
      done = false;
    }
    _settle(done);
  }

  void _settle(bool done) {
    state = done;
    final completer = _hydration;
    if (completer != null && !completer.isCompleted) completer.complete(done);
  }

  /// `true`/`false` as soon as known: synchronously once hydrated, otherwise
  /// a future that completes with the first value read from the database.
  FutureOr<bool> whenHydrated() => state ?? _hydration!.future;

  /// Persists [answers] into the profile, marks onboarding completed and
  /// refreshes [onboardingAnswersProvider].
  Future<void> complete(OnboardingAnswers answers) async {
    final existing = await _repository.profile();
    await _repository.saveProfile(answers.applyTo(existing));
    ref.invalidate(onboardingAnswersProvider);
    _settle(true);
  }

  /// Marks onboarding as not completed without touching the database (tests
  /// and the future "reset onboarding" setting, US-091).
  void reset() => _settle(false);
}
