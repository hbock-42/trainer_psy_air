/// A single daily local reminder (US-092): title + body, already localized
/// by the caller (`ReminderCoordinator`, which has an `l10n` and composes
/// this through [ReminderContentBuilder]).
class ReminderContent {
  const ReminderContent({required this.title, required this.body});

  final String title;
  final String body;

  @override
  bool operator ==(Object other) =>
      other is ReminderContent && other.title == title && other.body == body;

  @override
  int get hashCode => Object.hash(title, body);

  @override
  String toString() => 'ReminderContent($title: $body)';
}

/// Schedules (or cancels) the app's single daily reminder notification.
///
/// One implementation per platform capability, chosen by
/// `reminderSchedulerProvider` (`reminder_scheduler_provider.dart`):
///
/// - [isSupported] phones/tablets (Android, iOS) ->
///   `PluginReminderScheduler` (`reminder_scheduler_plugin.dart`), backed by
///   `flutter_local_notifications`;
/// - desktop/web -> a no-op stub (`UnsupportedReminderScheduler`), so
///   Settings can explain the limitation instead of failing silently.
///
/// Tests use `InMemoryReminderScheduler` (records calls, never touches a
/// platform channel).
abstract class ReminderScheduler {
  /// Whether this platform can actually deliver a scheduled notification.
  /// Settings hides the time picker (and shows an explanation) when false.
  bool get isSupported;

  /// Asks the OS for notification permission (Android 13+
  /// `POST_NOTIFICATIONS`, iOS `requestPermissions`). Returns whether the
  /// app may now show notifications; always `false` when [isSupported] is
  /// `false`.
  Future<bool> requestPermission();

  /// (Re)schedules the single daily reminder for [hour]:[minute] (local
  /// time, 24h) with [content], replacing any previously scheduled one.
  /// A no-op when [isSupported] is `false`.
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required ReminderContent content,
  });

  /// Cancels the scheduled reminder, if any. A no-op when [isSupported] is
  /// `false`.
  Future<void> cancel();
}

/// The notification id every implementation schedules under: the app has
/// exactly one reminder, so there is nothing to disambiguate.
const int reminderNotificationId = 1;

/// The next local instant at which a daily [hour]:[minute] alarm fires,
/// counted from [now]: today if that time has not yet passed, tomorrow
/// otherwise. Pure and platform-free, so it is unit-tested without a
/// notification plugin; the real scheduler (`PluginReminderScheduler`)
/// calls this to build the `zonedSchedule` instant, and it also backs the
/// "next fire time" test for [ReminderScheduler] implementations generally.
DateTime nextDailyFireTime({
  required int hour,
  required int minute,
  required DateTime now,
}) {
  final local = now.toLocal();
  var candidate = DateTime(local.year, local.month, local.day, hour, minute);
  if (!candidate.isAfter(local)) {
    candidate = candidate.add(const Duration(days: 1));
  }
  return candidate;
}
