import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_wm_calc_back/domain/calc_back_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

/// Runs a real `p1_wm_calc_back` section through `ActivitySession` under a
/// `ManualClock`, as a fixed `ItemSource.generator` run the way an exam
/// section plays it (`blueprints/psy1_full.json`'s `s10-wm-calc`): a whole
/// continuous chain of 80 calculations (4 stages x 20), each item's expected
/// answer chained from the result `stage` items back.
///
/// Silent exam mode (no `liveFeedback`) auto-advances the moment `answer()`
/// is called (`ActivitySession._afterAnswer`: `showsFeedback` is false, so
/// it calls `_advance()` immediately rather than waiting for `next()`); an
/// answered item's own timer is cancelled at the same time, so `clock
/// .elapse()` is only used here to let an *unanswered* item's per-item
/// limit actually expire (the timeout tests below), never after an answer
/// that already moved the session on.
void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  const engine = CalcBackEngine();
  const params = P1WmCalcBackParams(calcsPerStage: 5);
  const sectionSeed = 7;

  late ManualClock clock;
  late InMemoryProgressRepository repo;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
  });

  ActivitySession session({int count = 20}) {
    final s = ActivitySession(
      config: ActivitySessionConfig(
        familyId: 'p1_wm_calc_back',
        mode: SessionMode.exam,
        source: ItemSource.generator(
          generatorId: GeneratorId.p1WmCalcBack,
          seed: sectionSeed,
          params: params,
          count: count,
        ),
        timing: const TimingPolicy(perItemMs: 11250),
        blueprintId: 'psy1_full',
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

  /// Answers every current item correctly (chained result), relying on
  /// silent exam mode's immediate auto-advance -- no `clock.elapse()`
  /// needed between answers.
  void answerAllCorrectly(ActivitySession s, int count) {
    for (var i = 0; i < count; i++) {
      final step = CalcBackEngine.stepOf(currentItem(s));
      s.answer(Answer.numeric(step.result));
    }
  }

  test('items materialise the same chain ItemSource.generator draws', () {
    final s = session();
    // Under ItemSource.generator every item is materialised up front from
    // one Random(seed) draw per item (see `ItemSource._generate`); the
    // engine itself still recomputes the chain from `origin.runSeed`
    // (= the section seed) and `origin.index`, so what the session shows
    // must match `CalcBackChain.build` decoded directly.
    final chain = CalcBackChain.build(params, sectionSeed, upTo: 20);
    for (var i = 0; i < s.items.length; i++) {
      final step = CalcBackEngine.stepOf(s.items[i].item as GeneratedItem);
      expect(step.result, chain.steps[i].result);
      expect(step.stage, chain.steps[i].stage);
    }
  });

  test('silent exam mode: correct/wrong chained answers score exactly', () {
    final s = session();
    s.start();

    // Item 0: stage 1, chained from baseline 0.
    final step0 = CalcBackEngine.stepOf(currentItem(s));
    expect(step0.stage, 1);
    s.answer(Answer.numeric(step0.result));
    expect(s.outcomes.single.isCorrect, isTrue);
    // Silent exam: no live verdict, but the session already moved to item 1
    // (auto-advance, see class doc).
    expect(running(s).feedback, isNull);
    expect(running(s).itemIndex, 1);

    final step1 = CalcBackEngine.stepOf(currentItem(s));
    s.answer(Answer.numeric(step1.result + 1));
    expect(s.outcomes.last.isCorrect, isFalse);
  });

  test(
    'crossing into stage 2 still chains correctly (index >= calcsPerStage)',
    () {
      final s = session(count: 6);
      s.start();
      answerAllCorrectly(s, 5);
      // Item index 5 is the first of stage 2 (calcsPerStage: 5).
      final step5 = CalcBackEngine.stepOf(currentItem(s));
      expect(step5.stage, 2);
      expect(step5.backIndex, 3);
      s.answer(Answer.numeric(step5.result));
      expect(s.outcomes.last.isCorrect, isTrue);
    },
  );

  test('an unanswered item times out at the per-item limit', () {
    final s = session(count: 2);
    s.start();
    final step0 = CalcBackEngine.stepOf(currentItem(s));
    s.answer(Answer.numeric(step0.result));
    expect(running(s).itemIndex, 1);

    // Item 1: no answer at all -- the per-item limit expires.
    clock.elapse(const Duration(milliseconds: 11250));

    final f = finished(s);
    expect(f.result.reason, FinishReason.completed);
    expect(f.result.section.correct, 1);
    expect(f.result.section.timeouts, 1);
  });

  test('metrics are summed per stage across the section', () {
    final s = session(count: 10);
    s.start();
    for (var i = 0; i < 10; i++) {
      final step = CalcBackEngine.stepOf(currentItem(s));
      // Answer stage 1 items correctly, everything else wrong, so the
      // per-stage breakdown is checkable.
      final answer = step.stage == 1 ? step.result : step.result + 1;
      s.answer(Answer.numeric(answer));
    }
    final f = finished(s);
    final totals = f.result.section.metricTotals;
    expect(totals[CalcBackMetrics.attemptsAtStage(1)], 5);
    expect(totals[CalcBackMetrics.correctAtStage(1)], 5);
    expect(totals[CalcBackMetrics.attemptsAtStage(2)], 5);
    expect(totals[CalcBackMetrics.correctAtStage(2)], isNull);
  });
}
