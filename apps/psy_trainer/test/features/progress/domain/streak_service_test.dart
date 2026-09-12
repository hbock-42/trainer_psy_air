import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/progress/domain/progress_domain.dart';

/// Fixed "now": 2026-09-12 18:00, local time (device timezone in CI is UTC,
/// so this doubles as the UTC instant — the point of the local-midnight
/// tests below is the *boundary*, not a specific offset).
final DateTime now = DateTime(2026, 9, 12, 18);

DateTime daysAgo(int days, {int hour = 12}) =>
    DateTime(now.year, now.month, now.day - days, hour);

StreakService service() => StreakService(clock: () => now);

void main() {
  group('StreakService.summarize', () {
    test('an empty history has no streak and no progress', () {
      final summary = service().summarize(events: const []);
      expect(summary.currentStreak, 0);
      expect(summary.bestStreak, 0);
      expect(summary.todayItems, 0);
      expect(summary.goalMet, isFalse);
      expect(summary.progressRatio, 0);
    });

    test('today counts towards the current streak and the goal', () {
      final summary = service().summarize(
        events: [ActivityEvent(at: daysAgo(0))],
        goal: const DailyGoal(target: 1),
      );
      expect(summary.currentStreak, 1);
      expect(summary.todayItems, 1);
      expect(summary.goalMet, isTrue);
      expect(summary.progressRatio, 1);
    });

    test('three consecutive active days give a streak of 3', () {
      final summary = service().summarize(
        events: [
          ActivityEvent(at: daysAgo(0)),
          ActivityEvent(at: daysAgo(1)),
          ActivityEvent(at: daysAgo(2)),
        ],
      );
      expect(summary.currentStreak, 3);
      expect(summary.bestStreak, 3);
    });

    test('a gap breaks the streak', () {
      final summary = service().summarize(
        events: [
          ActivityEvent(at: daysAgo(0)),
          // daysAgo(1) missing.
          ActivityEvent(at: daysAgo(2)),
          ActivityEvent(at: daysAgo(3)),
        ],
      );
      expect(summary.currentStreak, 1);
      // The older 2-day run is still the best.
      expect(summary.bestStreak, 2);
    });

    test(
      'no activity today does not break the streak yet if yesterday was active',
      () {
        final summary = service().summarize(
          events: [
            ActivityEvent(at: daysAgo(1)),
            ActivityEvent(at: daysAgo(2)),
          ],
        );
        expect(summary.currentStreak, 2);
        expect(summary.todayItems, 0);
      },
    );

    test('inactive today and yesterday gives a streak of 0', () {
      final summary = service().summarize(
        events: [ActivityEvent(at: daysAgo(2))],
      );
      expect(summary.currentStreak, 0);
    });

    test('an event just after local midnight belongs to the new day', () {
      final justAfterMidnight = DateTime(now.year, now.month, now.day, 0, 1);
      final justBeforeMidnightYesterday = DateTime(
        now.year,
        now.month,
        now.day - 1,
        23,
        59,
      );
      final summary = service().summarize(
        events: [
          ActivityEvent(at: justAfterMidnight),
          ActivityEvent(at: justBeforeMidnightYesterday),
        ],
      );
      // Two distinct active days -> a streak of 2, not 1.
      expect(summary.currentStreak, 2);
      expect(summary.todayItems, 1);
    });

    test('minutes goal sums responseMs of the day, in minutes', () {
      final summary = service().summarize(
        events: [
          ActivityEvent(at: daysAgo(0), responseMs: 5 * 60000),
          ActivityEvent(at: daysAgo(0), responseMs: 3 * 60000),
        ],
        goal: const DailyGoal(target: 10, unit: GoalUnit.minutes),
      );
      expect(summary.todayMinutes, 8);
      expect(summary.goalMet, isFalse);
      expect(summary.progressRatio, closeTo(0.8, 1e-9));
    });

    test('goal reached exactly at the target', () {
      final summary = service().summarize(
        events: List.generate(20, (_) => ActivityEvent(at: daysAgo(0))),
      );
      expect(summary.todayItems, 20);
      expect(summary.goalMet, isTrue);
      expect(summary.progressRatio, 1);
    });

    test('the heat-map covers the requested window, oldest first', () {
      final summary = service().summarize(
        events: [
          ActivityEvent(at: daysAgo(0)),
          ActivityEvent(at: daysAgo(5)),
        ],
        heatmapWeeks: 1,
      );
      expect(summary.heatmap, hasLength(7));
      expect(summary.heatmap.first.date, daysAgo(6, hour: 0));
      expect(summary.heatmap.last.date, daysAgo(0, hour: 0));
      expect(summary.heatmap.last.itemCount, 1);
      expect(summary.heatmap[1].itemCount, 1); // daysAgo(5)
      expect(summary.heatmap[2].itemCount, 0); // daysAgo(4)
    });

    test('several events the same day sum into one heat-map cell', () {
      final summary = service().summarize(
        events: [
          ActivityEvent(at: daysAgo(0, hour: 9)),
          ActivityEvent(at: daysAgo(0, hour: 10)),
          ActivityEvent(at: daysAgo(0, hour: 11)),
        ],
        heatmapWeeks: 1,
      );
      expect(summary.heatmap.last.itemCount, 3);
      expect(summary.todayItems, 3);
    });
  });
}
