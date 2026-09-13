import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_channels.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_input.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_run_state.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_simulation.dart';

void main() {
  const allChannels = {
    P1PsychomotorChannel.gauges,
    P1PsychomotorChannel.tracking,
    P1PsychomotorChannel.letters,
    P1PsychomotorChannel.arithmetic,
  };

  P1PsychomotorSimulation buildSim({
    int runSeed = 1,
    int phaseDurationSec = 30,
  }) => P1PsychomotorSimulation.build(
    runSeed: runSeed,
    params: P1PsychomotorParams(
      phaseCount: 1,
      phaseDurationSec: phaseDurationSec,
    ),
    difficulty: 3,
  );

  group('red-zone zeroing rule', () {
    test('an untouched gauge eventually zeroes the whole run, permanently', () {
      final sim = buildSim(phaseDurationSec: 60);
      final state = P1PsychomotorRunState(sim);
      const dtMs = 100;
      var ms = 0;
      while (ms < sim.durationMs && state.redZoneTrigger == null) {
        ms += dtMs;
        state.tick(
          nowMs: ms,
          input: P1PsychomotorTickInput.none,
          activeChannels: allChannels,
        );
      }
      // Any of the 4 channels can be the first to trip (an inert run
      // starves letters/arithmetic just as fast as gauges drift) — the
      // rule under test is that *some* channel does, and once it does the
      // total is zero.
      expect(state.redZoneTrigger, isNotNull);
      expect(state.combinedScore, 0);

      // Even if the offending channel's raw score were to recover, the
      // trigger (and the zero) must never clear.
      final triggeredAtMs = state.redZoneTrigger!.atMs;
      state.tick(
        nowMs: ms + dtMs,
        input: const P1PsychomotorTickInput(leftStickY: 1),
        activeChannels: allChannels,
      );
      expect(state.redZoneTrigger!.atMs, triggeredAtMs);
      expect(state.combinedScore, 0);
    });

    test('attentively cycling and nulling every gauge keeps the run alive', () {
      // An attentive strategy: revisit each gauge often enough (every 6
      // ticks -> 300ms per gauge, a 1.2 s full cycle) and null whichever
      // one is selected by pushing the stick the same sign as its current
      // displacement (`P1PsychomotorControl.gaugeStep`'s law: `correction =
      // -stickY * rate`, so `stickY = displacement.sign` opposes the
      // displacement). This is the spec's own framing made concrete: a
      // candidate who keeps cycling attention across all 4 gauges should
      // never see the zeroing rule fire.
      final sim = buildSim(phaseDurationSec: 60);
      final state = P1PsychomotorRunState(sim);
      const dtMs = 50;
      const switchEveryTicks = 6;
      var ms = 0;
      var tick = 0;
      while (ms < sim.durationMs) {
        ms += dtMs;
        tick++;
        final displacement = state.gaugeDisplacement[state.selectedGauge];
        state.tick(
          nowMs: ms,
          input: P1PsychomotorTickInput(
            leftStickY: displacement.sign,
            selectNextGauge: tick % switchEveryTicks == 0,
          ),
          activeChannels: const {P1PsychomotorChannel.gauges},
        );
      }
      expect(state.redZoneTrigger, isNull);
    });
  });

  group('gauge selection', () {
    test('selectNextGauge/selectPrevGauge cycle within bounds', () {
      final sim = buildSim();
      final state = P1PsychomotorRunState(sim);
      expect(state.selectedGauge, 0);
      state.tick(
        nowMs: 10,
        input: const P1PsychomotorTickInput(selectNextGauge: true),
        activeChannels: const {P1PsychomotorChannel.gauges},
      );
      expect(state.selectedGauge, 1);
      state.tick(
        nowMs: 20,
        input: const P1PsychomotorTickInput(selectPrevGauge: true),
        activeChannels: const {P1PsychomotorChannel.gauges},
      );
      expect(state.selectedGauge, 0);
      state.tick(
        nowMs: 30,
        input: const P1PsychomotorTickInput(selectPrevGauge: true),
        activeChannels: const {P1PsychomotorChannel.gauges},
      );
      expect(state.selectedGauge, p1PsychomotorGaugeCount - 1);
    });
  });

  group('letters channel', () {
    test('cancelling every target position scores full accuracy', () {
      final sim = buildSim();
      final state = P1PsychomotorRunState(sim);
      state.tick(
        nowMs: 1,
        input: P1PsychomotorTickInput.none,
        activeChannels: const {P1PsychomotorChannel.letters},
      );
      final wave = sim.letterWaveAt(1);
      for (final position in wave.targetPositions) {
        state.registerLetterPress(position, 1);
      }
      expect(state.letterHits, wave.targetPositions.length);
      expect(state.letterMisses, 0);
      expect(state.letterFalseAlarms, 0);
      expect(state.scoreOf(P1PsychomotorChannel.letters), 100);
    });

    test('pressing a non-target position counts a false alarm', () {
      final sim = buildSim();
      final state = P1PsychomotorRunState(sim);
      state.tick(
        nowMs: 1,
        input: P1PsychomotorTickInput.none,
        activeChannels: const {P1PsychomotorChannel.letters},
      );
      final wave = sim.letterWaveAt(1);
      final nonTarget = List.generate(
        p1PsychomotorLetterCount,
        (i) => i,
      ).firstWhere((i) => !wave.targetPositions.contains(i));
      state.registerLetterPress(nonTarget, 1);
      expect(state.letterFalseAlarms, 1);
      expect(state.letterHits, 0);
    });
  });

  group('arithmetic channel', () {
    test('a correct submission is recorded as correct', () {
      final sim = buildSim();
      final state = P1PsychomotorRunState(sim);
      state.tick(
        nowMs: 1,
        input: P1PsychomotorTickInput.none,
        activeChannels: const {P1PsychomotorChannel.arithmetic},
      );
      final problem = sim.arithmeticProblemAt(1);
      state.submitArithmeticAnswer(problem.answer, 1);
      expect(state.arithmeticCorrect, 1);
      expect(state.arithmeticIncorrect, 0);
      expect(state.scoreOf(P1PsychomotorChannel.arithmetic), 100);
    });

    test('a wrong submission is recorded as incorrect', () {
      final sim = buildSim();
      final state = P1PsychomotorRunState(sim);
      state.tick(
        nowMs: 1,
        input: P1PsychomotorTickInput.none,
        activeChannels: const {P1PsychomotorChannel.arithmetic},
      );
      final problem = sim.arithmeticProblemAt(1);
      state.submitArithmeticAnswer(problem.answer + 1, 1);
      expect(state.arithmeticIncorrect, 1);
      expect(state.arithmeticCorrect, 0);
    });
  });
}
