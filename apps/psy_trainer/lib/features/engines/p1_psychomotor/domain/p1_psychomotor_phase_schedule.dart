import 'p1_psychomotor_channels.dart';

/// One phase's task layering + attention-weighting guidance.
///
/// [activeChannels] gates which channels actually run this phase (spec:
/// "tasks layer in progressively over phases 1-3"); [weights] is HUD-only
/// guidance on which channel(s) the phase wants the candidate to
/// prioritise (spec: "phase 5 emphasises letters+calcs at 40%") — it does
/// **not** change any channel's event rate or difficulty in this engine, a
/// deliberate MVP simplification flagged in the story's final report,
/// since `P1PsychomotorParams` (CONTRACT.md) carries no per-phase weight
/// data to derive it from otherwise.
class P1PsychomotorPhaseSpec {
  const P1PsychomotorPhaseSpec({
    required this.activeChannels,
    required this.weights,
  });

  final Set<P1PsychomotorChannel> activeChannels;
  final Map<P1PsychomotorChannel, double> weights;

  bool isActive(P1PsychomotorChannel channel) =>
      activeChannels.contains(channel);
}

/// The 6-phase schedule (spec §2.3 row 13: "six 3-min phases, tasks layer
/// in progressively over phases 1-3 ... through phases 4-6"). Not spec'd
/// beyond that prose and the phase-5 example weighting quoted above: this
/// exact composition is this engine's own reasonable reading of it
/// (**[estimated]**, matching the confidence tag `family.json` already
/// carries for `p1_psychomotor`), analogous to `MultitaskSimulation`'s own
/// documented difficulty-scale assumption. A run shorter than 6 phases
/// (e.g. `psy1_short`'s 1-phase practice section) reuses phase 1's spec.
abstract final class P1PsychomotorPhaseSchedule {
  static const Map<P1PsychomotorChannel, double> _quarter = {
    P1PsychomotorChannel.gauges: 0.25,
    P1PsychomotorChannel.tracking: 0.25,
    P1PsychomotorChannel.letters: 0.25,
    P1PsychomotorChannel.arithmetic: 0.25,
  };

  static final List<P1PsychomotorPhaseSpec> phases = [
    // Phase 1: the two continuous "physical" channels start first.
    const P1PsychomotorPhaseSpec(
      activeChannels: {
        P1PsychomotorChannel.gauges,
        P1PsychomotorChannel.tracking,
      },
      weights: {
        P1PsychomotorChannel.gauges: 0.5,
        P1PsychomotorChannel.tracking: 0.5,
      },
    ),
    // Phase 2: letters join.
    const P1PsychomotorPhaseSpec(
      activeChannels: {
        P1PsychomotorChannel.gauges,
        P1PsychomotorChannel.tracking,
        P1PsychomotorChannel.letters,
      },
      weights: {
        P1PsychomotorChannel.gauges: 0.3,
        P1PsychomotorChannel.tracking: 0.3,
        P1PsychomotorChannel.letters: 0.4,
      },
    ),
    // Phase 3: arithmetic joins — all 4 channels active from here on.
    P1PsychomotorPhaseSpec(
      activeChannels: P1PsychomotorChannel.values.toSet(),
      weights: Map.of(_quarter),
    ),
    // Phase 4: all 4, equal weight.
    P1PsychomotorPhaseSpec(
      activeChannels: P1PsychomotorChannel.values.toSet(),
      weights: Map.of(_quarter),
    ),
    // Phase 5 (spec's own example): letters + arithmetic emphasised at 40%
    // each, gauges + tracking at 10% each.
    const P1PsychomotorPhaseSpec(
      activeChannels: {
        P1PsychomotorChannel.gauges,
        P1PsychomotorChannel.tracking,
        P1PsychomotorChannel.letters,
        P1PsychomotorChannel.arithmetic,
      },
      weights: {
        P1PsychomotorChannel.gauges: 0.1,
        P1PsychomotorChannel.tracking: 0.1,
        P1PsychomotorChannel.letters: 0.4,
        P1PsychomotorChannel.arithmetic: 0.4,
      },
    ),
    // Phase 6: all 4, equal weight, final phase.
    P1PsychomotorPhaseSpec(
      activeChannels: P1PsychomotorChannel.values.toSet(),
      weights: Map.of(_quarter),
    ),
  ];

  /// The spec for phase [index] (0-based), clamped to the last defined
  /// phase for a run with more phases than [phases] documents.
  static P1PsychomotorPhaseSpec forIndex(int index) =>
      phases[index.clamp(0, phases.length - 1)];
}
