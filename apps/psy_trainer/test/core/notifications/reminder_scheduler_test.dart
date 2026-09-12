import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/notifications/in_memory_reminder_scheduler.dart';
import 'package:psy_trainer/core/notifications/reminder_scheduler.dart';
import 'package:psy_trainer/core/notifications/unsupported_reminder_scheduler.dart';

void main() {
  group('nextDailyFireTime', () {
    test('picks today when the time has not passed yet', () {
      final now = DateTime(2026, 9, 12, 10);
      final fireAt = nextDailyFireTime(hour: 18, minute: 0, now: now);
      expect(fireAt, DateTime(2026, 9, 12, 18));
    });

    test('picks tomorrow when the time already passed today', () {
      final now = DateTime(2026, 9, 12, 19);
      final fireAt = nextDailyFireTime(hour: 18, minute: 0, now: now);
      expect(fireAt, DateTime(2026, 9, 13, 18));
    });

    test('picks tomorrow when the time is exactly now', () {
      final now = DateTime(2026, 9, 12, 18, 30);
      final fireAt = nextDailyFireTime(hour: 18, minute: 30, now: now);
      expect(fireAt, DateTime(2026, 9, 13, 18, 30));
    });

    test('handles the minute boundary correctly', () {
      final now = DateTime(2026, 9, 12, 18, 29);
      final fireAt = nextDailyFireTime(hour: 18, minute: 30, now: now);
      expect(fireAt, DateTime(2026, 9, 12, 18, 30));
    });
  });

  group('InMemoryReminderScheduler', () {
    test('records the last scheduled reminder', () async {
      final scheduler = InMemoryReminderScheduler();
      const content = ReminderContent(title: 't', body: 'b');

      await scheduler.scheduleDaily(hour: 9, minute: 15, content: content);

      expect(scheduler.scheduled, (hour: 9, minute: 15, content: content));
      expect(scheduler.scheduleCalls, hasLength(1));
    });

    test('cancel clears the scheduled reminder', () async {
      final scheduler = InMemoryReminderScheduler();
      await scheduler.scheduleDaily(
        hour: 9,
        minute: 15,
        content: const ReminderContent(title: 't', body: 'b'),
      );

      await scheduler.cancel();

      expect(scheduler.scheduled, isNull);
      expect(scheduler.cancelCalls, 1);
    });

    test(
      'requestPermission reflects isSupported and permissionGranted',
      () async {
        final scheduler = InMemoryReminderScheduler(permissionGranted: false);
        expect(await scheduler.requestPermission(), isFalse);
        expect(scheduler.permissionRequests, 1);
      },
    );

    test('scheduleDaily is a no-op when unsupported', () async {
      final scheduler = InMemoryReminderScheduler(isSupported: false);
      await scheduler.scheduleDaily(
        hour: 9,
        minute: 0,
        content: const ReminderContent(title: 't', body: 'b'),
      );
      expect(scheduler.scheduled, isNull);
    });
  });

  group('UnsupportedReminderScheduler', () {
    test('is not supported and every call is a no-op', () async {
      const scheduler = UnsupportedReminderScheduler();
      expect(scheduler.isSupported, isFalse);
      expect(await scheduler.requestPermission(), isFalse);
      await scheduler.scheduleDaily(
        hour: 9,
        minute: 0,
        content: const ReminderContent(title: 't', body: 'b'),
      );
      await scheduler.cancel();
    });
  });
}
