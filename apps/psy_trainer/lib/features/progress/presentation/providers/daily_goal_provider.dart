import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_logger.dart';
import '../../../../core/repositories/repositories.dart';
import '../../domain/daily_goal.dart';

/// The daily goal (US-073), persisted in `UserProfile.settings['goal']`.
/// Same hydrate-once-then-hold-state shape as `AppSettingsController`
/// (`features/settings/presentation/providers/app_settings_provider.dart`):
/// the settings screen is the only writer, the dashboard's `StreakCard` and
/// `streakSummaryProvider` the readers.
final NotifierProvider<DailyGoalController, DailyGoal> dailyGoalProvider =
    NotifierProvider<DailyGoalController, DailyGoal>(DailyGoalController.new);

class DailyGoalController extends Notifier<DailyGoal> {
  Completer<DailyGoal>? _hydration;

  ProgressRepository get _repository => ref.read(progressRepositoryProvider);

  @override
  DailyGoal build() {
    _hydration = Completer<DailyGoal>();
    unawaited(_hydrate());
    return DailyGoal.defaults;
  }

  Future<void> _hydrate() async {
    DailyGoal goal;
    try {
      goal = DailyGoal.fromProfile(await _repository.profile());
    } on Object catch (error, stack) {
      logError(error, stack, context: 'daily goal hydration');
      goal = DailyGoal.defaults;
    }
    state = goal;
    final completer = _hydration;
    if (completer != null && !completer.isCompleted) {
      completer.complete(goal);
    }
  }

  FutureOr<DailyGoal> whenHydrated() =>
      _hydration?.isCompleted ?? true ? state : _hydration!.future;

  Future<void> setTarget(int target) =>
      _update((g) => g.copyWith(target: target));

  Future<void> setUnit(GoalUnit unit) => _update((g) => g.copyWith(unit: unit));

  Future<void> _update(DailyGoal Function(DailyGoal) apply) async {
    final next = apply(state);
    state = next;
    final existing = await _repository.profile();
    await _repository.saveProfile(next.applyTo(existing));
  }
}
