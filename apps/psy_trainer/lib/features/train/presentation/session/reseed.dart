import 'dart:math';

import '../../domain/engine/engine.dart';

/// The same activity, ready to run again: generator and adaptive sources
/// draw a fresh seed (a new random run every time, as the launcher does) —
/// an adaptive source restarts at its original [AdaptiveSource
/// .initialDifficulty], not wherever the previous run's adaptation left it;
/// bank sources and replay sources (US-054 "retry my mistakes") replay the
/// same items — there is no larger pool to redraw from here.
/// Always clears [ActivitySessionConfig.sessionId] so "Recommencer" starts a
/// brand-new `TrainingSession` rather than attaching to the finished one.
ActivitySessionConfig reseeded(ActivitySessionConfig config, [Random? random]) {
  final rng = random ?? Random();
  final source = switch (config.source) {
    final GeneratorSource s => s.copyWith(seed: rng.nextInt(1 << 31)),
    final AdaptiveSource s => s.copyWith(runSeed: rng.nextInt(1 << 31)),
    final BankSource s => s,
    final ReplaySource s => s,
  };
  return config.copyWith(source: source, sessionId: null);
}
