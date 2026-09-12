import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../engines/arithmetic_grid/domain/arithmetic_grid_engine.dart';
import '../../../engines/arithmetic_grid/presentation/arithmetic_grid_renderer.dart';
import '../../../engines/attention_parity/domain/attention_parity_engine.dart';
import '../../../engines/attention_parity/presentation/attention_parity_renderer.dart';
import '../../../engines/attention_rules/domain/attention_rules_engine.dart';
import '../../../engines/attention_rules/presentation/attention_rules_renderer.dart';
import '../../../engines/culture_aero/domain/culture_aero_engine.dart';
import '../../../engines/culture_aero/presentation/culture_aero_explanation.dart';
import '../../../engines/english/domain/english_engine.dart';
import '../../../engines/english/presentation/english_passage_cache.dart';
import '../../../engines/logic_dominos/domain/dominos_engine.dart';
import '../../../engines/logic_dominos/presentation/dominos_renderer.dart';
import '../../../engines/memory_nback/domain/nback_engine.dart';
import '../../../engines/memory_nback/presentation/nback_renderer.dart';
import '../../domain/engine/engine.dart';
import '../renderers/mcq_renderer.dart';
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
        CultureAeroEngine(),
        DominosEngine(),
        EnglishEngine(),
        NbackEngine(),
      ]),
    );

/// The widgets of every activity.
final Provider<RendererRegistry> rendererRegistryProvider =
    Provider<RendererRegistry>(
      (ref) => RendererRegistry(<ActivityRenderer>[
        // US-021..036: add one line per engine (alphabetical by family id).
        const ArithmeticGridRenderer(),
        const AttentionParityRenderer(),
        const AttentionRulesRenderer(),
        const DominosRenderer(),
        const McqRenderer(
          familyId: 'culture_aero',
          explanationFooter: cultureAeroExplanationFooter,
        ),
        McqRenderer(
          familyId: 'english',
          passageResolver: (id) =>
              ref.read(englishPassageCacheProvider).get(id),
        ),
        const NbackRenderer(),
      ]),
    );

/// Time source of every session. Widget tests override it with a
/// `ManualClock` to step timers by hand.
final Provider<EngineClock> engineClockProvider = Provider<EngineClock>(
  (ref) => const SystemClock(),
);
