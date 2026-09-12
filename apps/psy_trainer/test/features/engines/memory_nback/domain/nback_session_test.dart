import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/memory_nback/domain/nback_engine.dart';
import 'package:psy_trainer/features/engines/memory_nback/domain/nback_stimulus.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

/// Runs a real `memory_nback` section through `ActivitySession` under a
/// `ManualClock`, exactly as the real test's cadence works (spec §2.4-A:
/// ~1 s stimulus, 1.5 s to answer, a missing answer is an error).
///
/// With `sectionSeed = 777` and `NbackParams(count: 3, primers: 0)`,
/// `ItemSource.generator`'s per-item draw (`Random(777)`, replicated in
/// the story's report) yields, in order: a filler, a target, a filler —
/// stable as long as `NbackStimulus`'s roll thresholds do not change.
void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  const cadence = Cadence(stimulusMs: 1000, answerWindowMs: 1500);
  const engine = NbackEngine();
  const params = NbackParams(count: 3, primers: 0);
  const sectionSeed = 777;

  late ManualClock clock;
  late InMemoryProgressRepository repo;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
  });

  ActivitySession session() {
    final s = ActivitySession(
      config: const ActivitySessionConfig(
        familyId: 'memory_nback',
        mode: SessionMode.exam,
        source: ItemSource.generator(
          generatorId: GeneratorId.nback,
          seed: sectionSeed,
          params: params,
          count: 3,
        ),
        timing: TimingPolicy(cadence: cadence),
        blueprintId: 'psy0_short',
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

  test('roles of the section are filler, target, filler', () {
    final s = session();
    final roles = [
      for (final item in s.items)
        NbackEngine.stimulusOf(item.item as GeneratedItem).role,
    ];
    expect(roles, [NbackRole.filler, NbackRole.target, NbackRole.filler]);
  });

  test('the cadence shows the stimulus then the answer phase, per item', () {
    final s = session();
    s.start();
    var r = running(s);
    expect(r.itemIndex, 0);
    expect(r.phase, ItemPhase.stimulus);
    expect(r.itemDeadline, start.add(const Duration(milliseconds: 2500)));

    clock.elapse(const Duration(milliseconds: 1000));
    r = running(s);
    expect(r.phase, ItemPhase.answer);

    // A correct rejection on the filler.
    s.answer(NbackAnswer.no);
    r = running(s);
    expect(r.phase, ItemPhase.answered);
    // Silent exam mode: no feedback shown, but the outcome is recorded.
    expect(r.feedback, isNull);
    expect(s.outcomes.single.isCorrect, isTrue);

    // The rhythm does not slip: the next item starts exactly at the end
    // of this one's cadence window, whether or not it was answered early.
    clock.elapse(const Duration(milliseconds: 1500));
    r = running(s);
    expect(r.itemIndex, 1);
    expect(r.phase, ItemPhase.stimulus);
    expect(r.itemStartedAt, start.add(const Duration(milliseconds: 2500)));
  });

  test('a hit, a correct rejection and a missed timeout score correctly', () {
    final s = session();
    s.start();

    // Item 0 (filler): answer "no" during the answer phase -> correct
    // rejection.
    clock.elapse(const Duration(milliseconds: 1200));
    s.answer(NbackAnswer.no);
    clock.elapse(const Duration(milliseconds: 1300)); // rest of the window

    // Item 1 (target): answer "yes" -> hit.
    expect(running(s).itemIndex, 1);
    clock.elapse(const Duration(milliseconds: 1200));
    s.answer(NbackAnswer.yes);
    clock.elapse(const Duration(milliseconds: 1300));

    // Item 2 (filler): no answer at all -> timeout, and the section ends
    // (it was the last item).
    expect(running(s).itemIndex, 2);
    clock.elapse(const Duration(milliseconds: 2500));

    final f = finished(s);
    expect(f.result.reason, FinishReason.completed);
    final section = f.result.section;
    expect(section.correct, 2);
    expect(section.timeouts, 1);
    expect(section.metricTotals[NbackMetrics.correctRejections], 1);
    expect(section.metricTotals[NbackMetrics.hits], 1);
    expect(section.metricTotals[NbackMetrics.misses], 0);
    expect(section.metricTotals[NbackMetrics.falseAlarms], 0);
    expect(
      nbackSensitivity(
        hits: section.metricTotals[NbackMetrics.hits]!.toInt(),
        misses: section.metricTotals[NbackMetrics.misses]!.toInt(),
        falseAlarms: section.metricTotals[NbackMetrics.falseAlarms]!.toInt(),
        correctRejections: section.metricTotals[NbackMetrics.correctRejections]!
            .toInt(),
      ),
      greaterThan(0),
    );
  });
}
