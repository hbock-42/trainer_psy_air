import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'reminder_scheduler.dart';

/// [ReminderScheduler] on Android/iOS: a daily notification through
/// `flutter_local_notifications`, whose `zonedSchedule` needs a timezone
/// database ([_ensureTimeZones]) even though every instant we build is
/// already local (`nextDailyFireTime`) — there is no `flutter_timezone`-style
/// dependency here, so the local zone is approximated by the first IANA
/// location whose current UTC offset matches the device's, falling back to
/// UTC (only shifts the fire hour on the rare device where none matches).
class PluginReminderScheduler implements ReminderScheduler {
  PluginReminderScheduler({
    FlutterLocalNotificationsPlugin? plugin,
    DateTime Function() now = DateTime.now,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
       _now = now;

  final FlutterLocalNotificationsPlugin _plugin;
  final DateTime Function() _now;
  bool _initialized = false;

  /// Android notification channel every reminder is posted on.
  static const String _channelId = 'reminders';
  static const String _channelName = 'Reminders';

  @override
  bool get isSupported => true;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _ensureTimeZones();
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    _initialized = true;
  }

  void _ensureTimeZones() {
    tz_data.initializeTimeZones();
    final offset = _now().timeZoneOffset;
    for (final name in tz.timeZoneDatabase.locations.keys) {
      final location = tz.getLocation(name);
      if (location.currentTimeZone.offset == offset.inMilliseconds) {
        tz.setLocalLocation(location);
        return;
      }
    }
    tz.setLocalLocation(tz.UTC);
  }

  @override
  Future<bool> requestPermission() async {
    await _ensureInitialized();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      final granted = await ios.requestPermissions(alert: true, sound: true);
      return granted ?? false;
    }
    // Neither resolves (e.g. macOS build of this class, unused in
    // practice since `reminderSchedulerProvider` picks the unsupported
    // stub there): assume permission is not needed.
    return true;
  }

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required ReminderContent content,
  }) async {
    await _ensureInitialized();
    final fireAt = nextDailyFireTime(hour: hour, minute: minute, now: _now());
    final scheduledDate = tz.TZDateTime.from(fireAt, tz.local);
    await _plugin.zonedSchedule(
      reminderNotificationId,
      content.title,
      content.body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(_channelId, _channelName),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancel() async {
    await _ensureInitialized();
    await _plugin.cancel(reminderNotificationId);
  }
}
