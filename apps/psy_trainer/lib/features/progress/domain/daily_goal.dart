import '../../../core/repositories/model/learning.dart';

/// Unit the daily goal is expressed in.
enum GoalUnit {
  items('items'),
  minutes('minutes');

  const GoalUnit(this.key);

  final String key;

  static GoalUnit fromKey(String? key) =>
      GoalUnit.values.firstWhere((v) => v.key == key, orElse: () => items);
}

/// "Objectif quotidien" (US-073): how many items (or minutes) of practice a
/// day counts as "done" — drives [StreakSummary.goalMet] and the dashboard's
/// progress ring. Persisted in `UserProfile.settings['goal']` as
/// `{'target': int, 'unit': 'items' | 'minutes'}` (see
/// `docs/ARCHITECTURE.md`, "Settings").
class DailyGoal {
  const DailyGoal({this.target = 20, this.unit = GoalUnit.items})
    : assert(target > 0, 'target must be positive');

  static const String settingsKey = 'goal';
  static const String _keyTarget = 'target';
  static const String _keyUnit = 'unit';

  /// Common presets offered by the settings screen.
  static const List<int> itemPresets = [10, 20, 30, 50];
  static const List<int> minutePresets = [10, 15, 20, 30];

  final int target;
  final GoalUnit unit;

  static const DailyGoal defaults = DailyGoal();

  factory DailyGoal.fromProfile(UserProfile? profile) {
    final raw = profile?.settings[settingsKey];
    if (raw is! Map) return defaults;
    final target = raw[_keyTarget];
    final unit = raw[_keyUnit];
    return DailyGoal(
      target: target is int && target > 0 ? target : defaults.target,
      unit: GoalUnit.fromKey(unit is String ? unit : null),
    );
  }

  Map<String, Object?> toJson() => {_keyTarget: target, _keyUnit: unit.key};

  /// The profile to save: [existing] (if any) with this goal applied. Every
  /// other profile field, and every other `settings` key, is preserved.
  UserProfile applyTo(UserProfile? existing) {
    final base = existing ?? const UserProfile(locale: 'fr');
    return base.copyWith(settings: {...base.settings, settingsKey: toJson()});
  }

  DailyGoal copyWith({int? target, GoalUnit? unit}) =>
      DailyGoal(target: target ?? this.target, unit: unit ?? this.unit);

  @override
  bool operator ==(Object other) =>
      other is DailyGoal && other.target == target && other.unit == unit;

  @override
  int get hashCode => Object.hash(target, unit);
}
