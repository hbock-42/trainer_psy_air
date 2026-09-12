import 'daily_goal.dart';

/// One counted stimulus: a practice attempt, an exam section attempt, or a
/// flashcard review. [StreakService] only needs "when" and "how much" —
/// which repository table it came from does not matter once it is an event.
class ActivityEvent {
  const ActivityEvent({
    required this.at,
    this.itemCount = 1,
    this.responseMs = 0,
  });

  /// When it happened (any timezone; bucketed into a local-midnight day by
  /// [StreakService]).
  final DateTime at;

  /// How many "items" it counts as towards the goal (always 1 today; a
  /// cadence-driven attempt or a flashcard review is one item).
  final int itemCount;

  /// Time spent on it, for the "minutes" goal unit; 0 when unknown
  /// (flashcard reviews do not carry a duration).
  final int responseMs;
}

/// One day of the activity heat-map.
class DailyActivity {
  const DailyActivity({required this.date, required this.itemCount});

  /// Local midnight of that day.
  final DateTime date;
  final int itemCount;
}

/// Everything the dashboard's streak card and heat-map need, computed once
/// by [StreakService.summarize].
class StreakSummary {
  const StreakSummary({
    required this.currentStreak,
    required this.bestStreak,
    required this.todayItems,
    required this.todayMinutes,
    required this.goal,
    required this.heatmap,
  });

  /// Consecutive active days up to and including today (or, when today has
  /// no activity yet, up to yesterday — today is not "broken" until it
  /// ends).
  final int currentStreak;

  /// The longest run of consecutive active days ever seen in [heatmap]'s
  /// source data (not limited to the heat-map's own window).
  final int bestStreak;

  final int todayItems;
  final double todayMinutes;
  final DailyGoal goal;

  /// Oldest first, one entry per day, covering the heat-map's window
  /// (inclusive of today).
  final List<DailyActivity> heatmap;

  double get todayProgress => switch (goal.unit) {
    GoalUnit.items => todayItems.toDouble(),
    GoalUnit.minutes => todayMinutes,
  };

  bool get goalMet => todayProgress >= goal.target;

  /// 0..1, capped at 1 (a ring never overflows).
  double get progressRatio =>
      goal.target <= 0 ? 0 : (todayProgress / goal.target).clamp(0.0, 1.0);
}

/// Pure-Dart streaks and activity heat-map (US-073): current/best streak,
/// today's progress against the [DailyGoal], and a calendar heat-map — all
/// derived from a flat list of [ActivityEvent]s so the caller (a Riverpod
/// provider) stays the only place that reads the repositories.
///
/// Day boundaries are **local midnight** (`DateTime.toLocal()`), not UTC:
/// two attempts either side of local midnight are different days even
/// though the stored `answeredAt` is UTC. [clock] is injected so tests do
/// not depend on the real "now".
class StreakService {
  const StreakService({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  /// Number of weeks the heat-map covers, ending with the current week
  /// (US-073: "last 12 weeks").
  static const int defaultHeatmapWeeks = 12;

  DateTime _today() => _dayKey(_clock());

  static DateTime _dayKey(DateTime dt) {
    final local = dt.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  StreakSummary summarize({
    required List<ActivityEvent> events,
    DailyGoal goal = DailyGoal.defaults,
    int heatmapWeeks = defaultHeatmapWeeks,
  }) {
    assert(heatmapWeeks > 0, 'heatmapWeeks must be positive');
    final itemsByDay = <DateTime, int>{};
    final msByDay = <DateTime, int>{};
    for (final event in events) {
      final day = _dayKey(event.at);
      itemsByDay.update(
        day,
        (v) => v + event.itemCount,
        ifAbsent: () => event.itemCount,
      );
      msByDay.update(
        day,
        (v) => v + event.responseMs,
        ifAbsent: () => event.responseMs,
      );
    }
    final today = _today();

    bool active(DateTime day) => (itemsByDay[day] ?? 0) > 0;

    final currentStreak = _currentStreak(today, active);
    final bestStreak = _bestStreak(itemsByDay.keys.where(active).toSet());

    final heatmapDays = heatmapWeeks * 7;
    final heatmap = [
      for (var i = heatmapDays - 1; i >= 0; i--)
        DailyActivity(
          date: today.subtract(Duration(days: i)),
          itemCount: itemsByDay[today.subtract(Duration(days: i))] ?? 0,
        ),
    ];

    return StreakSummary(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      todayItems: itemsByDay[today] ?? 0,
      todayMinutes: (msByDay[today] ?? 0) / 60000,
      goal: goal,
      heatmap: heatmap,
    );
  }

  static int _currentStreak(DateTime today, bool Function(DateTime) active) {
    var day = active(today) ? today : today.subtract(const Duration(days: 1));
    if (!active(day)) return 0;
    var count = 0;
    while (active(day)) {
      count++;
      day = day.subtract(const Duration(days: 1));
    }
    return count;
  }

  static int _bestStreak(Set<DateTime> activeDays) {
    if (activeDays.isEmpty) return 0;
    final sorted = activeDays.toList()..sort();
    var best = 1;
    var run = 1;
    for (var i = 1; i < sorted.length; i++) {
      final gap = sorted[i].difference(sorted[i - 1]).inDays;
      if (gap == 1) {
        run++;
      } else {
        run = 1;
      }
      if (run > best) best = run;
    }
    return best;
  }
}
