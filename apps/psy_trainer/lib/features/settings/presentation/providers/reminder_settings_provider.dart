import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_logger.dart';
import '../../../../core/repositories/repositories.dart';
import '../../domain/reminder_settings.dart';

/// US-092: the daily reminder's on/off + time, hydrated from
/// `UserProfile.settings['reminder']` once and then held synchronously (same
/// hydration shape as `AppSettingsController` /
/// `ExamRealismOptionsController`) so toggling it in Settings updates the
/// screen immediately while still persisting.
final NotifierProvider<ReminderSettingsController, ReminderSettings>
reminderSettingsProvider =
    NotifierProvider<ReminderSettingsController, ReminderSettings>(
      ReminderSettingsController.new,
    );

class ReminderSettingsController extends Notifier<ReminderSettings> {
  Completer<ReminderSettings>? _hydration;

  ProgressRepository get _repository => ref.read(progressRepositoryProvider);

  @override
  ReminderSettings build() {
    _hydration = Completer<ReminderSettings>();
    unawaited(_hydrate());
    return ReminderSettings.defaults;
  }

  Future<void> _hydrate() async {
    ReminderSettings settings;
    try {
      settings = ReminderSettings.fromProfile(await _repository.profile());
    } on Object catch (error, stack) {
      logError(error, stack, context: 'reminder settings hydration');
      settings = ReminderSettings.defaults;
    }
    state = settings;
    final completer = _hydration;
    if (completer != null && !completer.isCompleted) {
      completer.complete(settings);
    }
  }

  /// `state` once hydrated: synchronously if already known, otherwise a
  /// future that completes with the first value read from the database.
  FutureOr<ReminderSettings> whenHydrated() =>
      _hydration?.isCompleted ?? true ? state : _hydration!.future;

  Future<void> setEnabled({required bool enabled}) =>
      _update((s) => s.copyWith(enabled: enabled));

  Future<void> setTime({required int hour, required int minute}) =>
      _update((s) => s.copyWith(hour: hour, minute: minute));

  Future<void> _update(
    ReminderSettings Function(ReminderSettings) apply,
  ) async {
    final next = apply(state);
    state = next;
    final existing = await _repository.profile();
    await _repository.saveProfile(next.applyTo(existing));
  }
}
