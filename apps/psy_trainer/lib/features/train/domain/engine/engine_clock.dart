import 'dart:async';

/// A scheduled callback that can be cancelled (see [EngineClock.schedule]).
abstract interface class ScheduledTask {
  void cancel();
  bool get isActive;
}

/// Time source and scheduler of the activity runtime.
///
/// Everything time-related in `ActivitySession` (response times, per-item
/// and per-section limits, cadence) goes through this interface so the
/// state machine is deterministic in tests: use [ManualClock] to step time by
/// hand, or [SystemClock] inside `fakeAsync` (its timers are faked; pass
/// `now: async.getClock(start).now` for the time source).
abstract interface class EngineClock {
  DateTime now();

  /// Runs [callback] once after [delay].
  ScheduledTask schedule(Duration delay, void Function() callback);
}

/// [EngineClock] over `DateTime.now` and `dart:async` [Timer]s.
class SystemClock implements EngineClock {
  const SystemClock({DateTime Function() now = DateTime.now}) : _now = now;

  final DateTime Function() _now;

  @override
  DateTime now() => _now();

  @override
  ScheduledTask schedule(Duration delay, void Function() callback) =>
      _TimerTask(Timer(delay, callback));
}

class _TimerTask implements ScheduledTask {
  _TimerTask(this._timer);

  final Timer _timer;

  @override
  void cancel() => _timer.cancel();

  @override
  bool get isActive => _timer.isActive;
}

/// [EngineClock] whose time only moves when a test calls [elapse] (or
/// [advanceTo]); scheduled callbacks fire in due-time order while elapsing.
///
/// Usable in plain `test()`s and in `testWidgets` without `fakeAsync`.
class ManualClock implements EngineClock {
  ManualClock([DateTime? start]) : _now = start ?? DateTime.utc(2026);

  DateTime _now;
  final List<_ManualTask> _tasks = [];

  @override
  DateTime now() => _now;

  /// Callbacks not yet fired.
  int get pendingTasks => _tasks.where((t) => t.isActive).length;

  @override
  ScheduledTask schedule(Duration delay, void Function() callback) {
    final task = _ManualTask(_now.add(delay), callback);
    _tasks.add(task);
    return task;
  }

  /// Moves time forward by [duration], firing due callbacks in order. A
  /// callback that schedules another task within the window fires it too.
  void elapse(Duration duration) => advanceTo(_now.add(duration));

  /// Moves time forward to [target] (no-op when in the past).
  void advanceTo(DateTime target) {
    if (!target.isAfter(_now)) return;
    while (true) {
      _ManualTask? next;
      for (final task in _tasks) {
        if (!task.isActive || task.dueAt.isAfter(target)) continue;
        if (next == null || task.dueAt.isBefore(next.dueAt)) next = task;
      }
      if (next == null) break;
      _now = next.dueAt;
      next.fire();
      _tasks.remove(next);
    }
    _tasks.removeWhere((t) => !t.isActive);
    _now = target;
  }
}

class _ManualTask implements ScheduledTask {
  _ManualTask(this.dueAt, this._callback);

  final DateTime dueAt;
  final void Function() _callback;
  bool _active = true;

  @override
  bool get isActive => _active;

  @override
  void cancel() => _active = false;

  void fire() {
    if (!_active) return;
    _active = false;
    _callback();
  }
}
