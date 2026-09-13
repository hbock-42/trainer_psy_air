import '../domain/p1_psychomotor_run_state.dart';
import '../domain/p1_psychomotor_simulation.dart';

/// Keeps one [P1PsychomotorRunState] alive across the run's 6 phase-item
/// widget rebuilds (`ActivityRenderer`'s `ValueKey(item.id)` convention
/// gives each phase item a fresh `State`, but the gauges/cursor/hit-counts
/// must persist between phases — see `P1PsychomotorEngine`'s class doc).
///
/// Keyed by `runSeed`; [release] must be called once the run's last phase
/// finishes (or is abandoned) so a later run does not inherit stale state.
/// A tiny amount of process-wide mutable state, the same trade-off
/// `EnglishPassageCache` makes for a different reason (avoiding a re-fetch)
/// — acceptable here because at most one psychomotor run plays at a time.
abstract final class P1PsychomotorRunCache {
  static final Map<int, P1PsychomotorRunState> _states = {};

  static P1PsychomotorRunState of(
    int runSeed,
    P1PsychomotorSimulation simulation,
  ) => _states.putIfAbsent(runSeed, () => P1PsychomotorRunState(simulation));

  static void release(int runSeed) {
    _states.remove(runSeed);
  }
}
