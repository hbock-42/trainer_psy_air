import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/repositories.dart';
import '../../domain/onboarding_answers.dart';

/// The onboarding answers stored in the profile (null before onboarding),
/// for screens that display or edit them (Settings, "edit my profile").
///
/// Invalidated by `OnboardingCompletedNotifier.complete`, so watchers
/// re-read the profile after every save.
final FutureProvider<OnboardingAnswers?> onboardingAnswersProvider =
    FutureProvider<OnboardingAnswers?>((ref) async {
      final repository = ref.watch(progressRepositoryProvider);
      return OnboardingAnswers.fromProfile(await repository.profile());
    });
