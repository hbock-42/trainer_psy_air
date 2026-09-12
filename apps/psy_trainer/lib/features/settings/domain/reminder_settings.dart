import '../../../core/repositories/model/learning.dart';

/// US-092 "local reminders": whether the daily reminder is on and at which
/// time it fires. Persisted as a nested JSON object at
/// `UserProfile.settings['reminder']` (see `docs/ARCHITECTURE.md`, "Data
/// layer" -> `user_profile`), the same pattern as `ExamRealismOptions`
/// (`features/exam/domain/exam_realism_options.dart`) rather than folded
/// into `AppSettings`, since it is scoped to this one feature.
class ReminderSettings {
  const ReminderSettings({
    this.enabled = false,
    this.hour = defaultHour,
    this.minute = defaultMinute,
  });

  /// Whether the daily reminder is scheduled.
  final bool enabled;

  /// Local hour (0..23) it fires at.
  final int hour;

  /// Local minute (0..59) it fires at.
  final int minute;

  /// A quiet-hours-friendly default: late afternoon, once school/work is
  /// typically done.
  static const int defaultHour = 18;
  static const int defaultMinute = 0;

  static const String settingsKey = 'reminder';

  static const String _keyEnabled = 'enabled';
  static const String _keyHour = 'hour';
  static const String _keyMinute = 'minute';

  static const ReminderSettings defaults = ReminderSettings();

  /// Reads `profile.settings['reminder']`; [defaults] for a missing
  /// profile, a missing key or a value of the wrong shape.
  factory ReminderSettings.fromProfile(UserProfile? profile) {
    final raw = profile?.settings[settingsKey];
    if (raw is! Map) return defaults;
    return ReminderSettings.fromJson(raw.cast<String, Object?>());
  }

  factory ReminderSettings.fromJson(Map<String, Object?> json) {
    final hour = json[_keyHour] as int? ?? defaults.hour;
    final minute = json[_keyMinute] as int? ?? defaults.minute;
    return ReminderSettings(
      enabled: json[_keyEnabled] as bool? ?? defaults.enabled,
      hour: hour.clamp(0, 23),
      minute: minute.clamp(0, 59),
    );
  }

  Map<String, Object?> toJson() => {
    _keyEnabled: enabled,
    _keyHour: hour,
    _keyMinute: minute,
  };

  /// The profile to save: [existing] (if any) with these settings applied
  /// under [settingsKey]; every other `settings` entry and profile field is
  /// preserved.
  UserProfile applyTo(UserProfile? existing) {
    if (existing == null) {
      return UserProfile(locale: 'fr', settings: {settingsKey: toJson()});
    }
    return existing.copyWith(
      settings: {...existing.settings, settingsKey: toJson()},
    );
  }

  ReminderSettings copyWith({bool? enabled, int? hour, int? minute}) {
    return ReminderSettings(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ReminderSettings &&
      other.enabled == enabled &&
      other.hour == hour &&
      other.minute == minute;

  @override
  int get hashCode => Object.hash(enabled, hour, minute);

  @override
  String toString() =>
      'ReminderSettings(enabled: $enabled, hour: $hour, minute: $minute)';
}
