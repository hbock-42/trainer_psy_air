import 'package:flutter_riverpod/misc.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/onboarding/domain/onboarding_answers.dart';
import 'package:psy_trainer/features/onboarding/domain/target_stage.dart';

/// Answers of a user who completed onboarding, for fixtures.
final OnboardingAnswers completedAnswers = OnboardingAnswers(
  disclaimerAcceptedAt: DateTime.utc(2026, 9, 1, 9),
  examDate: DateTime.utc(2027, 9, 4),
  targetStage: TargetStage.psy0,
);

/// An in-memory [ProgressRepository] whose profile records a completed
/// onboarding (with [completedAnswers] unless [answers] is given), or, with
/// [completed] false, no profile at all (a fresh install).
InMemoryProgressRepository fakeProgressRepository({
  bool completed = true,
  OnboardingAnswers? answers,
}) {
  final repository = InMemoryProgressRepository();
  if (completed) {
    repository.storedProfile = (answers ?? completedAnswers).applyTo(null);
  }
  return repository;
}

/// Riverpod override binding [progressRepositoryProvider] to [repository]
/// (or a fresh fake, see [fakeProgressRepository]). Add it to every test that
/// pumps the whole app: the router's guard reads the profile at startup.
Override progressRepositoryOverride({
  ProgressRepository? repository,
  bool completed = true,
}) => progressRepositoryProvider.overrideWithValue(
  repository ?? fakeProgressRepository(completed: completed),
);
