import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_attention_sustained/domain/attention_sustained_engine.dart';
import 'package:psy_trainer/features/engines/p1_attention_sustained/domain/attention_sustained_stimulus.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

/// Runs a real `p1_attention_sustained` section through `ActivitySession`
/// under a `ManualClock` (US-115), the same cadence-driven pattern
/// `memory_nback`/`attention_rules` use.
///
/// `sectionSeed = 13` with `itemsPerSeries: 3` (found by scanning seeds
/// against `AttentionSeries.build`, stable as long as the roll thresholds
/// don't change) draws the `conjunction` rule and rolls filler, lure,
/// target.
void main() {
  final start = DateTime.utc(2026, 9, 13, 9);
  const cadence = Cadence(stimulusMs: 500, answerWindowMs: 1000);
  const engine = AttentionSustainedEngine();
  const params = P1AttentionSustainedParams(itemsPerSeries: 3, seriesCount: 1);
  const sectionSeed = 13;

  late ManualClock clock;
  late InMemoryProgressRepository repo;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
  });

  ActivitySession session() {
    final s = ActivitySession(
      config: const ActivitySessionConfig(
        familyId: 'p1_attention_sustained',
        mode: SessionMode.exam,
        source: ItemSource.generator(
          generatorId: GeneratorId.p1AttentionSustained,
          seed: sectionSeed,
          params: params,
          count: 3,
        ),
        timing: TimingPolicy(cadence: cadence),
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

  test('roles of the section are filler, lure, target', () {
    final s = session();
    final roles = [
      for (final item in s.items)
        AttentionSustainedEngine.stimulusOf(item.item as GeneratedItem).role,
    ];
    expect(roles, [
      AttentionRole.filler,
      AttentionRole.lure,
      AttentionRole.target,
    ]);
  });

  test('the cadence shows the stimulus then the answer phase, per item', () {
    final s = session();
    s.start();
    var r = running(s);
    expect(r.itemIndex, 0);
    expect(r.phase, ItemPhase.stimulus);
    expect(r.itemDeadline, start.add(const Duration(milliseconds: 1500)));

    clock.elapse(const Duration(milliseconds: 500));
    r = running(s);
    expect(r.phase, ItemPhase.answer);

    s.answer(AttentionAnswer.notTarget);
    r = running(s);
    expect(r.phase, ItemPhase.answered);
    expect(r.feedback, isNull); // silent exam mode
    expect(s.outcomes.single.isCorrect, isTrue); // filler, correctly rejected

    clock.elapse(const Duration(milliseconds: 1000));
    r = running(s);
    expect(r.itemIndex, 1);
    expect(r.phase, ItemPhase.stimulus);
  });

  test('a correct rejection, a false alarm and a hit score the section', () {
    final s = session();
    s.start();

    // Item 0 (filler): correctly says "not target".
    clock.elapse(const Duration(milliseconds: 600));
    s.answer(AttentionAnswer.notTarget);
    clock.elapse(const Duration(milliseconds: 900)); // rest of the window

    // Item 1 (lure): wrongly says "target" -> false alarm.
    expect(running(s).itemIndex, 1);
    clock.elapse(const Duration(milliseconds: 600));
    s.answer(AttentionAnswer.target);
    clock.elapse(const Duration(milliseconds: 900));

    // Item 2 (target): correctly says "target" -> hit.
    expect(running(s).itemIndex, 2);
    clock.elapse(const Duration(milliseconds: 600));
    s.answer(AttentionAnswer.target);
    clock.elapse(const Duration(milliseconds: 900));

    final f = finished(s);
    expect(f.result.reason, FinishReason.completed);
    final section = f.result.section;
    expect(section.correct, 2);
    expect(section.wrong, 1);
    expect(section.timeouts, 0);
    expect(section.metricTotals[AttentionMetrics.correctRejections], 1);
    expect(section.metricTotals[AttentionMetrics.falseAlarms], 1);
    expect(section.metricTotals[AttentionMetrics.hits], 1);
    expect(section.metricTotals[AttentionMetrics.misses], 0);
  });

  test('a timed-out non-target is recorded as a timeout, not a correct '
      'rejection (documented deviation: TimeoutAnswer never reaches '
      '`score`, so silence cannot be reinterpreted)', () {
    final s = session();
    s.start();

    // Item 0 (filler): no answer at all -> timeout.
    clock.elapse(const Duration(milliseconds: 1500));
    expect(running(s).itemIndex, 1);

    // Item 1 (lure): correctly says "not target" -> the run's *only*
    // correct rejection -- if the timed-out item 0 had also been counted
    // as one, this total would be 2, not 1.
    s.answer(AttentionAnswer.notTarget);
    clock.elapse(const Duration(milliseconds: 1500));
    // Item 2 (target): correctly says "target" -> a hit.
    s.answer(AttentionAnswer.target);
    clock.elapse(const Duration(milliseconds: 1500));

    final section = finished(s).result.section;
    expect(section.timeouts, 1);
    expect(section.correct, 2); // item 1's rejection + item 2's hit only
    expect(
      section.metricTotals[AttentionMetrics.correctRejections],
      1,
      reason:
          'only item 1 (a real, answered non-target) should count -- '
          'the timed-out item 0 must not add a second',
    );
  });
}
