import 'reminder_scheduler.dart';

/// A [ReminderScheduler] recording every call instead of touching a
/// platform channel, for widget/unit tests (`InMemoryContentRepository`'s
/// role, but for notifications). [isSupported] and [permissionGranted] are
/// mutable so a test can also exercise the "denied" / "unsupported" paths.
class InMemoryReminderScheduler implements ReminderScheduler {
  InMemoryReminderScheduler({
    this.isSupported = true,
    this.permissionGranted = true,
  });

  @override
  bool isSupported;

  /// What [requestPermission] resolves to.
  bool permissionGranted;

  /// One entry per [scheduleDaily] call, oldest first.
  final List<({int hour, int minute, ReminderContent content})> scheduleCalls =
      [];

  /// How many times [cancel] was called.
  int cancelCalls = 0;

  /// How many times [requestPermission] was called.
  int permissionRequests = 0;

  /// The last scheduled reminder, or `null` before the first call or after
  /// [cancel].
  ({int hour, int minute, ReminderContent content})? get scheduled =>
      scheduleCalls.isEmpty ? null : scheduleCalls.last;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return isSupported && permissionGranted;
  }

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required ReminderContent content,
  }) async {
    if (!isSupported) return;
    scheduleCalls.add((hour: hour, minute: minute, content: content));
  }

  @override
  Future<void> cancel() async {
    cancelCalls++;
    scheduleCalls.clear();
  }
}
