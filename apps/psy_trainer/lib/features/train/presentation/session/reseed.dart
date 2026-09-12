import 'dart:math';

import '../../domain/engine/engine.dart';

/// The same activity, ready to run again: generator sources draw a fresh
/// seed (a new random run every time, as the launcher does); bank sources
/// replay the same items (there is no larger pool to redraw from here).
/// Always clears [ActivitySessionConfig.sessionId] so "Recommencer" starts a
/// brand-new `TrainingSession` rather than attaching to the finished one.
ActivitySessionConfig reseeded(ActivitySessionConfig config, [Random? random]) {
  final rng = random ?? Random();
  final source = switch (config.source) {
    final GeneratorSource s => s.copyWith(seed: rng.nextInt(1 << 31)),
    final BankSource s => s,
  };
  return config.copyWith(source: source, sessionId: null);
}
