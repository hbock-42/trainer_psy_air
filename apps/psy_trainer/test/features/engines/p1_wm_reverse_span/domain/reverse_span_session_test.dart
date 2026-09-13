import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_wm_reverse_span/domain/reverse_span_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

/// Runs a real `p1_wm_reverse_span` section through `ActivitySession` under
/// a `ManualClock`: an `ItemSource.adaptive` run (how practice always plays
/// a generator-backed family, `practice_session_builder.dart`) so the
/// shared `AdaptiveDifficultyPolicy` actually moves the level -- and, via
/// `ReverseSpanEngine.lengthForDifficulty`, the span length -- within the
/// series, exactly like every other generated family's in-run adaptation.
/// Practice always shows feedback (`ActivitySessionConfig.showsFeedback`),
/// so every answer here is followed by `next()` before the following item
/// appears.
void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  const engine = ReverseSpanEngine();
  const params = P1WmReverseSpanParams(count: 6);
  const runSeed = 100;

  late ManualClock clock;
  late InMemoryProgressRepository repo;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
  });

  ActivitySession session({int initialDifficulty = 1}) {
    final s = ActivitySession(
      config: ActivitySessionConfig(
        familyId: 'p1_wm_reverse_span',
        mode: SessionMode.practice,
        source: ItemSource.adaptive(
          generatorId: GeneratorId.p1WmReverseSpan,
          runSeed: runSeed,
          params: params,
          count: 6,
          initialDifficulty: initialDifficulty,
        ),
        timing: const TimingPolicy(perItemMs: 4000),
      ),
      registry: EngineRegistry(const [engine]),
      repository: repo,
      clock: clock,
    );
    addTearDown(s.dispose);
    return s;
  }

  ActivityRunning running(ActivitySession s) => s.state as ActivityRunning;
  ActivityFinished finished(ActivitySession s) => s.state as ActivityFinished;

  GeneratedItem currentItem(ActivitySession s) =>
      running(s).item as GeneratedItem;

  /// Answers the current item correctly, moves past the feedback (`next()`,
  /// required in practice mode) and elapses a small gap so the next item's
  /// response time is deterministic.
  void answerCorrectlyAndAdvance(ActivitySession s) {
    final item = currentItem(s);
    final sequence = ReverseSpanEngine.sequenceOf(item);
    clock.elapse(const Duration(milliseconds: 100));
    s.answer(Answer.sequence(sequence.expectedReverse));
    s.next();
  }

  test('the per-item limit and cadence-free phase behave as configured', () {
    final s = session();
    s.start();
    final r = running(s);
    expect(r.itemIndex, 0);
    expect(r.phase, ItemPhase.answer);
    expect(r.itemDeadline, start.add(const Duration(milliseconds: 4000)));
  });

  test('the span length adapts within the series as the shared adaptive '
      'policy moves the level', () {
    final s = session();
    s.start();

    final firstItem = currentItem(s);
    final firstLength = ReverseSpanEngine.sequenceOf(firstItem).digits.length;
    expect(firstLength, ReverseSpanEngine.lengthForDifficulty(1, params));

    // Three consecutive correct-and-fast answers move the level (and so
    // the span length) up by 1 (AdaptiveDifficultyPolicy.standard).
    for (var i = 0; i < 3; i++) {
      answerCorrectlyAndAdvance(s);
    }

    final laterItem = currentItem(s);
    final laterLength = ReverseSpanEngine.sequenceOf(laterItem).digits.length;
    expect(laterLength, greaterThan(firstLength));
    expect(running(s).level, greaterThan(1));
  });

  test('an exact reverse recall scores correct', () {
    final s = session(initialDifficulty: 2);
    s.start();

    final item = currentItem(s);
    final sequence = ReverseSpanEngine.sequenceOf(item);
    s.answer(Answer.sequence(sequence.expectedReverse));
    expect(s.outcomes.single.isCorrect, isTrue);
  });

  test('a forward (non-reversed) recall of a non-palindrome is wrong', () {
    final s = session(initialDifficulty: 2);
    s.start();

    final item = currentItem(s);
    final digits = ReverseSpanEngine.sequenceOf(item).digits;
    final forward = [for (final digit in digits) '$digit'];
    final reversed = ReverseSpanEngine.sequenceOf(item).expectedReverse;
    expect(forward, isNot(reversed)); // this run's digits are not a palindrome
    s.answer(Answer.sequence(forward));
    expect(s.outcomes.single.isCorrect, isFalse);
  });

  test('a missed answer window records a timeout; next() moves on', () {
    final s = session();
    s.start();
    clock.elapse(const Duration(milliseconds: 4000));
    expect(s.outcomes.single.isTimeout, isTrue);
    // Practice shows feedback even on a timeout, so the session waits for
    // next() rather than auto-advancing (only a cadence or silent exam does
    // that, see `ActivitySession._onItemTimeout`).
    expect(running(s).awaitsNext, isTrue);
    s.next();
    expect(running(s).itemIndex, 1);
  });

  test('completes after every item and sums section accuracy', () {
    final s = session();
    s.start();
    for (var i = 0; i < 6; i++) {
      answerCorrectlyAndAdvance(s);
    }
    final f = finished(s);
    expect(f.result.reason, FinishReason.completed);
    expect(f.result.section.correct, 6);
    expect(f.result.section.accuracy, 1.0);
  });
}
