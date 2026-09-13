import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_channels.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_phase_schedule.dart';

void main() {
  test('exactly 6 phases are defined', () {
    expect(P1PsychomotorPhaseSchedule.phases, hasLength(6));
  });

  test('tasks layer in progressively over phases 1-3', () {
    final counts = [
      for (final phase in P1PsychomotorPhaseSchedule.phases.take(3))
        phase.activeChannels.length,
    ];
    expect(counts, [2, 3, 4]);
  });

  test('phases 3-6 all run every channel', () {
    for (final phase in P1PsychomotorPhaseSchedule.phases.skip(2)) {
      expect(phase.activeChannels, P1PsychomotorChannel.values.toSet());
    }
  });

  test('every phase weight set sums to 1', () {
    for (final phase in P1PsychomotorPhaseSchedule.phases) {
      final total = phase.weights.values.fold<double>(0, (a, b) => a + b);
      expect(total, closeTo(1.0, 1e-9));
    }
  });

  test('phase 5 (index 4) emphasises letters and arithmetic at 40%', () {
    final phase = P1PsychomotorPhaseSchedule.forIndex(4);
    expect(phase.weights[P1PsychomotorChannel.letters], 0.4);
    expect(phase.weights[P1PsychomotorChannel.arithmetic], 0.4);
  });

  test('forIndex clamps a run with fewer/more phases than documented', () {
    expect(
      P1PsychomotorPhaseSchedule.forIndex(0),
      P1PsychomotorPhaseSchedule.phases[0],
    );
    expect(
      P1PsychomotorPhaseSchedule.forIndex(99),
      P1PsychomotorPhaseSchedule.phases.last,
    );
  });
}
