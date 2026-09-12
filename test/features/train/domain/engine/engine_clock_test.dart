import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/train/domain/engine/engine_clock.dart';

void main() {
  group('ManualClock', () {
    test('fires scheduled callbacks in due-time order while elapsing', () {
      final clock = ManualClock(DateTime.utc(2026, 9));
      final log = <String>[];
      clock.schedule(const Duration(seconds: 3), () => log.add('c'));
      clock.schedule(const Duration(seconds: 1), () => log.add('a'));
      clock.schedule(const Duration(seconds: 2), () => log.add('b'));
      expect(clock.pendingTasks, 3);

      clock.elapse(const Duration(milliseconds: 1500));
      expect(log, ['a']);
      expect(clock.now(), DateTime.utc(2026, 9, 1, 0, 0, 1, 500));

      clock.elapse(const Duration(seconds: 5));
      expect(log, ['a', 'b', 'c']);
      expect(clock.pendingTasks, 0);
      expect(clock.now(), DateTime.utc(2026, 9, 1, 0, 0, 6, 500));
    });

    test('a callback sees the clock at its due time and can reschedule', () {
      final clock = ManualClock();
      final seen = <DateTime>[];
      clock.schedule(const Duration(seconds: 1), () {
        seen.add(clock.now());
        clock.schedule(const Duration(seconds: 1), () => seen.add(clock.now()));
      });
      clock.elapse(const Duration(seconds: 5));
      expect(seen, [
        DateTime.utc(2026, 1, 1, 0, 0, 1),
        DateTime.utc(2026, 1, 1, 0, 0, 2),
      ]);
    });

    test('a cancelled task never fires and is no longer pending', () {
      final clock = ManualClock();
      var fired = false;
      final task = clock.schedule(
        const Duration(seconds: 1),
        () => fired = true,
      );
      expect(task.isActive, isTrue);
      task.cancel();
      expect(task.isActive, isFalse);
      clock.elapse(const Duration(seconds: 2));
      expect(fired, isFalse);
      expect(clock.pendingTasks, 0);
    });

    test('advancing to the past is a no-op', () {
      final clock = ManualClock(DateTime.utc(2026, 5));
      clock.advanceTo(DateTime.utc(2025));
      expect(clock.now(), DateTime.utc(2026, 5));
    });
  });

  group('SystemClock', () {
    test('uses dart:async timers, so it runs under fakeAsync', () {
      fakeAsync((async) {
        final start = DateTime.utc(2026, 9, 5, 9);
        final clock = SystemClock(now: async.getClock(start).now);
        var fired = false;
        final task = clock.schedule(
          const Duration(seconds: 2),
          () => fired = true,
        );
        expect(task.isActive, isTrue);
        async.elapse(const Duration(seconds: 1));
        expect(fired, isFalse);
        expect(clock.now(), start.add(const Duration(seconds: 1)));
        async.elapse(const Duration(seconds: 1));
        expect(fired, isTrue);
        expect(task.isActive, isFalse);
      });
    });

    test('cancel stops the timer', () {
      fakeAsync((async) {
        const clock = SystemClock();
        var fired = false;
        clock.schedule(const Duration(seconds: 1), () => fired = true).cancel();
        async.elapse(const Duration(seconds: 2));
        expect(fired, isFalse);
      });
    });
  });
}
