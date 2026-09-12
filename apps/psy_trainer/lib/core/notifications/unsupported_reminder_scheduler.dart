import 'reminder_scheduler.dart';

/// The reminder scheduler on platforms that cannot deliver a scheduled
/// notification yet (macOS, Windows, web — see `docs/ARCHITECTURE.md`
/// "Platforms"): every call is a no-op, [isSupported] is `false`, and
/// Settings reads that to show an explanation instead of the time picker.
class UnsupportedReminderScheduler implements ReminderScheduler {
  const UnsupportedReminderScheduler();

  @override
  bool get isSupported => false;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required ReminderContent content,
  }) async {}

  @override
  Future<void> cancel() async {}
}
