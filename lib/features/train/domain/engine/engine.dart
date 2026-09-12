/// The generic activity engine runtime (US-020): pure Dart, no Flutter.
///
/// Import this barrel from engine `domain/` code and from the runners; the
/// widget half lives in `features/train/presentation/engine/`. See
/// `docs/ARCHITECTURE.md#engine`.
library;

export 'activity_engine.dart';
export 'activity_session.dart';
export 'activity_session_config.dart';
export 'activity_session_state.dart';
export 'answer.dart';
export 'engine_clock.dart';
export 'item_result.dart';
export 'item_source.dart';
export 'scorer.dart';
export 'session_result.dart';
export 'timing_policy.dart';
