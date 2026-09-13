import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../train/domain/engine/engine_clock.dart';

/// Time source for the PSY2 practice timers (interview prep/answer
/// countdowns). Reuses the activity runtime's `EngineClock` abstraction
/// (`ManualClock`/`SystemClock`) directly, without depending on the engine
/// registry -- PSY2 has no registered engine (spec ethics note: no timed
/// exercise). Defaults to [SystemClock]; widget tests override this
/// provider with a [ManualClock] to drive the countdown deterministically.
final Provider<EngineClock> psy2ClockProvider = Provider<EngineClock>(
  (ref) => const SystemClock(),
);
