import 'dart:async';

import '../../../../core/repositories/model/attempt.dart';
import '../../../../core/repositories/model/session.dart';
import '../../../../core/repositories/progress_repository.dart';
import '../adaptive/adaptive_difficulty_policy.dart';
import 'activity_engine.dart';
import 'activity_session_config.dart';
import 'activity_session_state.dart';
import 'answer.dart';
import 'engine_clock.dart';
import 'item_result.dart';
import 'item_source.dart';
import 'scorer.dart';
import 'session_result.dart';

/// Called when a repository write fails; the session keeps running.
typedef PersistenceErrorHandler =
    void Function(Object error, StackTrace stackTrace);

/// The generic activity runtime (US-020): sequences the items of one
/// activity, runs the timing policy, scores answers through the engine and
/// persists attempts as they happen.
///
/// ```
/// briefing --start()--> running(0) --answer()/timeout--> ... --> finished
///                          |  ^                                  ^
///                  pause() v  | resume()          abort() -------+
///                        paused
/// ```
///
/// - `answer(a)` scores and records the current item; with feedback
///   (practice, or exam with live feedback) the item stays on screen until
///   `next()`; without, the session advances at once. Under a cadence the
///   session advances when the window ends, never earlier.
/// - A per-item limit or cadence window that expires records a timeout
///   attempt ([Answer.timeout], `answer = null` in the database). A section
///   limit that expires ends the session ([FinishReason.sectionTimeout]).
/// - `pause()` / `resume()` exist in practice only (`config.canPause`);
///   response times exclude paused time.
/// - Persistence: `startSession` when the first item appears (unless the
///   config attaches to an existing session), `recordAttempt` per item,
///   `finishSession` on completion or abort when the config owns the
///   session. Writes are chained; await [idle] to observe them.
///
/// All time comes from [clock]; nothing here touches `DateTime.now()` or
/// `Timer` directly, so the whole machine runs under [ManualClock] or
/// `fakeAsync`.
class ActivitySession {
  /// A fresh session. Items are materialised now, so a generator source
  /// with a given seed always yields the same run.
  ActivitySession({
    required ActivitySessionConfig config,
    required EngineRegistry registry,
    required ProgressRepository repository,
    EngineClock clock = const SystemClock(),
    PersistenceErrorHandler? onPersistenceError,
  }) : this._(
         config: config,
         registry: registry,
         repository: repository,
         clock: clock,
         onPersistenceError: onPersistenceError,
         attempts: const [],
       );

  /// Rebuilds an interrupted session from its stored config and attempts:
  /// the next item to play is the one after the last recorded attempt
  /// (of this section, for exams), earlier outcomes are restored from the
  /// attempts, and a section limit is reduced by the response time already
  /// spent. The state starts at `briefing` with `startIndex` set.
  ///
  /// Throws [ArgumentError] when the session carries no config.
  ActivitySession.resume({
    required TrainingSession session,
    required List<Attempt> attempts,
    required EngineRegistry registry,
    required ProgressRepository repository,
    EngineClock clock = const SystemClock(),
    PersistenceErrorHandler? onPersistenceError,
  }) : this._(
         config: _configOf(session),
         registry: registry,
         repository: repository,
         clock: clock,
         onPersistenceError: onPersistenceError,
         attempts: attempts,
       );

  ActivitySession._({
    required this.config,
    required EngineRegistry registry,
    required ProgressRepository repository,
    required EngineClock clock,
    required PersistenceErrorHandler? onPersistenceError,
    required List<Attempt> attempts,
  }) : _engine = registry.byFamily(config.familyId),
       _repository = repository,
       _clock = clock,
       _onPersistenceError = onPersistenceError,
       _sessionId = config.sessionId {
    final source = config.source;
    if (source is AdaptiveSource) {
      _items = List<SessionItem?>.filled(source.count, null);
      _adaptiveState = source.policy.initial(source.initialDifficulty);
    } else {
      _items = List<SessionItem?>.of(source.materialise(_engine));
    }
    _restore(attempts);
    _state = ActivitySessionState.briefing(
      itemCount: _items.length,
      startIndex: _outcomes.length,
    );
  }

  static ActivitySessionConfig _configOf(TrainingSession session) {
    if (session.config.isEmpty) {
      throw ArgumentError.value(
        session.id,
        'session',
        'has no ActivitySessionConfig to resume from',
      );
    }
    return ActivitySessionConfig.fromJson(
      session.config,
    ).copyWith(sessionId: session.id);
  }

  final ActivitySessionConfig config;
  final ActivityEngine _engine;
  final ProgressRepository _repository;
  final EngineClock _clock;
  final PersistenceErrorHandler? _onPersistenceError;

  /// Materialised on construction for every source but `ItemSource
  /// .adaptive`, whose items are null until [_itemAt] materialises them
  /// (lazily, item by item, once their difficulty is known).
  late final List<SessionItem?> _items;
  final List<ItemOutcome> _outcomes = [];

  /// Non-null only for an `ItemSource.adaptive` source; the current level
  /// and streaks (US-053).
  AdaptiveDifficultyState? _adaptiveState;
  final List<LevelChange> _levelChanges = [];
  final StreamController<ActivitySessionState> _states =
      StreamController<ActivitySessionState>.broadcast(sync: true);
  late ActivitySessionState _state;

  String? _sessionId;
  Future<void> _persistence = Future<void>.value();
  bool _disposed = false;

  // Current item bookkeeping.
  int _index = 0;
  bool _answered = false;
  DateTime? _itemStartedAt;
  int _itemPausedMs = 0;
  DateTime? _pausedAt;
  ScheduledTask? _itemTask;
  ScheduledTask? _stimulusTask;
  ScheduledTask? _sectionTask;
  DateTime? _itemDeadline;
  DateTime? _stimulusDeadline;
  DateTime? _sectionDeadline;
  int _sectionSpentMs = 0;
  Duration? _itemRemainingAtPause;
  Duration? _stimulusRemainingAtPause;
  Duration? _sectionRemainingAtPause;

  // --- Observation -----------------------------------------------------------

  ActivitySessionState get state => _state;

  /// Every state change after the current [state].
  Stream<ActivitySessionState> get states => _states.stream;

  /// The items materialised so far, in play order. For every source but
  /// `ItemSource.adaptive` this is every item, from construction; an
  /// adaptive source only ever has the items shown up to now (later ones
  /// depend on answers not yet given) — `state.itemCount` is the total.
  List<SessionItem> get items =>
      List.unmodifiable(_items.whereType<SessionItem>());

  /// Outcomes recorded so far, in play order.
  List<ItemOutcome> get outcomes => List.unmodifiable(_outcomes);

  /// The persisted session id, once `startSession` returned (or the
  /// attached one).
  String? get sessionId => _sessionId;

  /// Completes when every queued repository write has settled.
  Future<void> get idle => _persistence;

  bool get showsFeedback => config.showsFeedback;
  bool get canPause => config.canPause;

  // --- Commands --------------------------------------------------------------

  /// Leaves the briefing: starts (or attaches to) the stored session and
  /// shows the first item. Ignored unless in `briefing`.
  void start() {
    if (_disposed || !_state.isBriefing) return;
    if (_outcomes.length >= _items.length) {
      _finish(FinishReason.completed);
      return;
    }
    if (_sessionId == null) {
      _enqueue(() async {
        final session = await _repository.startSession(
          mode: config.mode,
          familyId: config.familyId,
          blueprintId: config.blueprintId,
          config: config.toJson(),
          startedAt: _clock.now(),
        );
        _sessionId = session.id;
      });
    }
    final sectionLimit = config.timing.section;
    if (sectionLimit != null) {
      final remaining = sectionLimit - Duration(milliseconds: _sectionSpentMs);
      _scheduleSection(remaining.isNegative ? Duration.zero : remaining);
    }
    _showItem(_outcomes.length);
  }

  /// Answers the current item. Ignored when no item is waiting for an
  /// answer (briefing, paused, already answered, finished). A
  /// [TimeoutAnswer] is the runtime's own and is rejected.
  void answer(Answer answer) {
    if (answer.isTimeout) {
      throw ArgumentError.value(
        answer,
        'answer',
        'timeouts are recorded by the session',
      );
    }
    if (_disposed || !_state.isRunning || _answered) return;
    final result = _engine.score(_itemAt(_index).item, answer);
    _record(answer, result, _elapsedOnItemMs());
    _afterAnswer(result);
  }

  /// Moves to the next item after feedback. Ignored unless the session is
  /// waiting for it (`ActivityRunning.awaitsNext`).
  void next() {
    if (_disposed) return;
    final running = _state;
    if (running is! ActivityRunning || !running.awaitsNext) return;
    _advance();
  }

  /// Practice only (throws [StateError] in exam mode). Freezes every timer.
  /// Ignored unless running.
  void pause() {
    if (!canPause) throw StateError('pause is not allowed in ${config.mode}');
    if (_disposed) return;
    final running = _state;
    if (running is! ActivityRunning) return;
    final now = _clock.now();
    _pausedAt = now;
    _itemRemainingAtPause = _remaining(_itemDeadline, now);
    _stimulusRemainingAtPause = _remaining(_stimulusDeadline, now);
    _sectionRemainingAtPause = _remaining(_sectionDeadline, now);
    _cancelItemTasks();
    _sectionTask?.cancel();
    _emit(
      ActivitySessionState.paused(
        snapshot: running,
        itemRemaining: _itemRemainingAtPause,
        sectionRemaining: _sectionRemainingAtPause,
      ),
    );
  }

  /// Resumes a paused session; timers restart with the time they had left.
  void resume() {
    if (_disposed) return;
    final paused = _state;
    if (paused is! ActivityPaused) return;
    final now = _clock.now();
    _itemPausedMs += now.difference(_pausedAt!).inMilliseconds;
    _pausedAt = null;
    final sectionRemaining = _sectionRemainingAtPause;
    if (sectionRemaining != null) _scheduleSection(sectionRemaining);
    final itemRemaining = _itemRemainingAtPause;
    if (itemRemaining != null && !_answeredWithoutCadence) {
      _scheduleItem(itemRemaining);
    } else {
      _itemDeadline = null;
    }
    final stimulusRemaining = _stimulusRemainingAtPause;
    if (stimulusRemaining != null &&
        paused.snapshot.phase == ItemPhase.stimulus) {
      _scheduleStimulus(stimulusRemaining);
    } else {
      _stimulusDeadline = null;
    }
    _emit(
      paused.snapshot.copyWith(
        itemDeadline: _itemDeadline,
        sectionDeadline: _sectionDeadline,
      ),
    );
  }

  /// Ends the session now as [FinishReason.aborted]; the current item is
  /// left unplayed. Ignored once finished.
  void abort() {
    if (_disposed || _state.isFinished) return;
    _finish(FinishReason.aborted);
  }

  /// Cancels timers and closes the state stream. Does not finish the
  /// session: call [abort] first if it is still running.
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _cancelItemTasks();
    _sectionTask?.cancel();
    _states.close();
  }

  // --- Item lifecycle --------------------------------------------------------

  void _showItem(int index) {
    _index = index;
    _answered = false;
    _itemPausedMs = 0;
    final now = _clock.now();
    _itemStartedAt = now;
    _itemDeadline = null;
    _stimulusDeadline = null;
    final limit = config.timing.itemLimit;
    if (limit != null) _scheduleItem(limit);
    final stimulus = config.timing.stimulus;
    if (stimulus != null) _scheduleStimulus(stimulus);
    _emit(
      ActivitySessionState.running(
        itemIndex: index,
        itemCount: _items.length,
        item: _itemAt(index).item,
        phase: stimulus != null ? ItemPhase.stimulus : ItemPhase.answer,
        itemStartedAt: now,
        itemDeadline: _itemDeadline,
        sectionDeadline: _sectionDeadline,
        level: _adaptiveState?.level,
      ),
    );
  }

  /// The item at [index], materialising it first if it is an as-yet-unshown
  /// item of an `ItemSource.adaptive` source (at the adaptive state's
  /// current level, the one this constructor or the last recorded answer
  /// left it at).
  SessionItem _itemAt(int index) {
    final existing = _items[index];
    if (existing != null) return existing;
    final item = config.source.materialiseAdaptive(
      _engine,
      index,
      _adaptiveState!.level,
    );
    _items[index] = item;
    return item;
  }

  /// Folds one answered item into the adaptive state, recording a
  /// [LevelChange] when the level moves. No-op for any other source.
  void _applyAdaptive(int index, ItemResult result, int responseMs) {
    final state = _adaptiveState;
    if (state == null) return;
    final source = config.source as AdaptiveSource;
    final next = source.policy.update(
      state,
      correct: result.correct,
      responseMs: responseMs,
      fastThresholdMs: source.fastThresholdMs,
      itemLimitMs: config.timing.itemLimit?.inMilliseconds,
    );
    if (next.level != state.level) {
      _levelChanges.add(
        LevelChange(atItemIndex: index + 1, from: state.level, to: next.level),
      );
    }
    _adaptiveState = next;
  }

  void _afterAnswer(ItemResult result) {
    _answered = true;
    _stimulusTask?.cancel();
    _stimulusDeadline = null;
    final feedback = showsFeedback ? result : null;
    if (config.timing.isCadence) {
      _emitAnswered(feedback: feedback, awaitsNext: false);
    } else {
      _itemTask?.cancel();
      _itemDeadline = null;
      if (showsFeedback) {
        _emitAnswered(feedback: feedback, awaitsNext: true);
      } else {
        _advance();
      }
    }
  }

  void _onStimulusEnd() {
    _stimulusDeadline = null;
    final running = _state;
    if (running is! ActivityRunning || _answered) return;
    _emit(running.copyWith(phase: ItemPhase.answer));
  }

  void _onItemTimeout() {
    _itemDeadline = null;
    if (!_answered) {
      _record(const Answer.timeout(), ItemResult.timeout, _elapsedOnItemMs());
      _answered = true;
    }
    if (config.timing.isCadence || !showsFeedback) {
      _advance();
    } else {
      _emitAnswered(feedback: ItemResult.timeout, awaitsNext: true);
    }
  }

  void _onSectionTimeout() {
    _sectionDeadline = null;
    if (_state.isRunning && !_answered) {
      _record(const Answer.timeout(), ItemResult.timeout, _elapsedOnItemMs());
      _answered = true;
    }
    _finish(FinishReason.sectionTimeout);
  }

  void _advance() {
    _cancelItemTasks();
    if (_index + 1 < _items.length) {
      _showItem(_index + 1);
    } else {
      _finish(FinishReason.completed);
    }
  }

  void _finish(FinishReason reason) {
    _cancelItemTasks();
    _sectionTask?.cancel();
    _sectionDeadline = null;
    final result = SessionResult(
      mode: config.mode,
      familyId: config.familyId,
      reason: reason,
      outcomes: List.unmodifiable(_outcomes),
      section: Scorer.section(
        _outcomes,
        itemCount: _items.length,
        policy: config.scoringPolicy,
      ),
      sessionId: _sessionId,
      sectionIndex: config.sectionIndex,
      levelChanges: List.unmodifiable(_levelChanges),
    );
    final started = _sessionId != null || !_state.isBriefing;
    if (config.ownsSession && started) {
      final endedAt = _clock.now();
      _enqueue(() async {
        final id = _sessionId;
        if (id == null) return;
        await _repository.finishSession(
          id,
          status: reason == FinishReason.aborted
              ? SessionStatus.abandoned
              : SessionStatus.completed,
          score: result.score,
          endedAt: endedAt,
        );
      });
    }
    _emit(ActivitySessionState.finished(result: result));
  }

  // --- Recording -------------------------------------------------------------

  void _record(Answer answer, ItemResult result, int responseMs) {
    final entry = _itemAt(_index);
    final outcome = ItemOutcome(
      index: _index,
      item: entry.item,
      answer: answer,
      result: result,
      responseMs: responseMs,
    );
    _outcomes.add(outcome);
    _applyAdaptive(_index, result, responseMs);
    final answeredAt = _clock.now();
    _enqueue(() async {
      final id = _sessionId;
      if (id == null) return;
      await _repository.recordAttempt(
        NewAttempt(
          sessionId: id,
          familyId: config.familyId,
          isCorrect: result.correct,
          responseMs: responseMs,
          position: config.positionOffset + outcome.index,
          itemId: entry.itemId,
          origin: entry.origin,
          answer: answer.isTimeout ? null : answer.toJson(),
          sectionIndex: config.sectionIndex,
          answeredAt: answeredAt,
        ),
      );
    });
  }

  void _restore(List<Attempt> attempts) {
    final section = config.sectionIndex;
    final mine =
        attempts
            .where((a) => section == null || a.sectionIndex == section)
            .toList()
          ..sort((a, b) => a.position.compareTo(b.position));
    for (final attempt in mine) {
      final index = attempt.position - config.positionOffset;
      if (index < 0 || index >= _items.length || index != _outcomes.length) {
        continue;
      }
      final json = attempt.answer;
      final answer = json == null
          ? const Answer.timeout()
          : Answer.fromJson(json);
      final result = ItemResult(
        correct: attempt.isCorrect,
        timedOut: answer.isTimeout,
        skipped: answer.isSkip,
      );
      _outcomes.add(
        ItemOutcome(
          index: index,
          item: _restoredItemAt(index, attempt).item,
          answer: answer,
          result: result,
          responseMs: attempt.responseMs,
        ),
      );
      // Already-played items of an adaptive source are read back from their
      // own attempt (their difficulty was decided by the policy when they
      // were shown); the policy itself is replayed forward the same way it
      // ran the first time, so the level resumes exactly where it left off.
      _applyAdaptive(index, result, attempt.responseMs);
      _sectionSpentMs += attempt.responseMs;
    }
  }

  /// The item at [index] for [_restore]: already materialised for every
  /// non-adaptive source; for `ItemSource.adaptive`, rebuilt from the
  /// attempt's own [Attempt.origin] (the difficulty it was actually shown
  /// at), not from the adaptive state (which has not replayed this far yet).
  SessionItem _restoredItemAt(int index, Attempt attempt) {
    final existing = _items[index];
    if (existing != null) return existing;
    final source = config.source as AdaptiveSource;
    final origin = attempt.origin!;
    final item = SessionItem(
      item: ItemSource.itemFromOrigin(
        _engine,
        origin,
        index: index,
        runSeed: source.runSeed,
      ),
      origin: origin,
    );
    _items[index] = item;
    return item;
  }

  void _enqueue(Future<void> Function() write) {
    _persistence = _persistence.then((_) => write()).catchError((
      Object error,
      StackTrace stackTrace,
    ) {
      _onPersistenceError?.call(error, stackTrace);
    });
  }

  // --- Timers ----------------------------------------------------------------

  void _scheduleItem(Duration delay) {
    _itemTask?.cancel();
    _itemDeadline = _clock.now().add(delay);
    _itemTask = _clock.schedule(delay, _onItemTimeout);
  }

  void _scheduleStimulus(Duration delay) {
    _stimulusTask?.cancel();
    _stimulusDeadline = _clock.now().add(delay);
    _stimulusTask = _clock.schedule(delay, _onStimulusEnd);
  }

  void _scheduleSection(Duration delay) {
    _sectionTask?.cancel();
    _sectionDeadline = _clock.now().add(delay);
    _sectionTask = _clock.schedule(delay, _onSectionTimeout);
  }

  void _cancelItemTasks() {
    _itemTask?.cancel();
    _stimulusTask?.cancel();
    _itemTask = null;
    _stimulusTask = null;
    _itemDeadline = null;
    _stimulusDeadline = null;
  }

  /// Answered without a cadence: the item timer is already gone.
  bool get _answeredWithoutCadence => _answered && !config.timing.isCadence;

  int _elapsedOnItemMs() =>
      _clock.now().difference(_itemStartedAt!).inMilliseconds - _itemPausedMs;

  static Duration? _remaining(DateTime? deadline, DateTime now) {
    if (deadline == null) return null;
    final left = deadline.difference(now);
    return left.isNegative ? Duration.zero : left;
  }

  void _emitAnswered({
    required ItemResult? feedback,
    required bool awaitsNext,
  }) {
    final running = _state;
    if (running is! ActivityRunning) return;
    _emit(
      running.copyWith(
        phase: ItemPhase.answered,
        feedback: feedback,
        awaitsNext: awaitsNext,
        itemDeadline: _itemDeadline,
      ),
    );
  }

  void _emit(ActivitySessionState state) {
    _state = state;
    if (!_states.isClosed) _states.add(state);
  }
}
