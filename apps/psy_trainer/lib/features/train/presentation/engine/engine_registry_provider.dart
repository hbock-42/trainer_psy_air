import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../engines/arithmetic_grid/domain/arithmetic_grid_engine.dart';
import '../../../engines/arithmetic_grid/presentation/arithmetic_grid_renderer.dart';
import '../../../engines/attention_parity/domain/attention_parity_engine.dart';
import '../../../engines/attention_parity/presentation/attention_parity_renderer.dart';
import '../../../engines/attention_rules/domain/attention_rules_engine.dart';
import '../../../engines/attention_rules/presentation/attention_rules_renderer.dart';
import '../../../engines/memory_nback/domain/nback_engine.dart';
import '../../../engines/memory_nback/presentation/nback_renderer.dart';
import '../../domain/engine/engine.dart';
import 'activity_renderer.dart';

// Composition root of the activity engines (EPIC-03). Each engine story adds
// its `ActivityEngine` to [engineRegistryProvider] and its
// `ActivityRenderer` to [rendererRegistryProvider]; nothing else in the
// runtime knows the concrete engines. Tests override both providers with a
// fake (see `test/helpers/fake_engine.dart`).
//
// Registration order does not matter; the registries key by family id.

/// The generators and scorers of every activity.
final Provider<EngineRegistry> engineRegistryProvider =
    Provider<EngineRegistry>(
      (ref) => EngineRegistry(const <ActivityEngine>[
        // US-021..036: add one line per engine (alphabetical by family id).
        ArithmeticGridEngine(),
        AttentionParityEngine(),
        AttentionRulesEngine(),
        NbackEngine(),
      ]),
    );

/// The widgets of every activity.
final Provider<RendererRegistry> rendererRegistryProvider =
    Provider<RendererRegistry>(
      (ref) => RendererRegistry(const <ActivityRenderer>[
        // US-021..036: add one line per engine (alphabetical by family id).
        ArithmeticGridRenderer(),
        AttentionParityRenderer(),
        AttentionRulesRenderer(),
        NbackRenderer(),
      ]),
    );

/// Time source of every session. Widget tests override it with a
/// `ManualClock` to step timers by hand.
final Provider<EngineClock> engineClockProvider = Provider<EngineClock>(
  (ref) => const SystemClock(),
);
