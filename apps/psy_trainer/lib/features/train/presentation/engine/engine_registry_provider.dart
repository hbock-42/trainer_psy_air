import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../engines/arithmetic_grid/domain/arithmetic_grid_engine.dart';
import '../../../engines/arithmetic_grid/presentation/arithmetic_grid_renderer.dart';
import '../../../engines/attention_airways/domain/airways_engine.dart';
import '../../../engines/attention_airways/presentation/airways_renderer.dart';
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
import '../../../engines/multitask_psychomotor/domain/multitask_engine.dart';
import '../../../engines/multitask_psychomotor/presentation/multitask_renderer.dart';
import '../../../engines/planning_tubes/domain/tubes_engine.dart';
import '../../../engines/planning_tubes/presentation/tubes_renderer.dart';
import '../../../engines/spatial_cubes/domain/cube_net_engine.dart';
import '../../../engines/spatial_cubes/presentation/cube_net_renderer.dart';
import '../../../engines/spatial_overlay/domain/overlay_grid_engine.dart';
import '../../../engines/spatial_overlay/presentation/overlay_grid_renderer.dart';
import '../../../engines/spatial_viewpoint/domain/viewpoint_engine.dart';
import '../../../engines/spatial_viewpoint/presentation/viewpoint_renderer.dart';
import '../../../engines/verbal_boxes/domain/word_boxes_engine.dart';
import '../../../engines/verbal_boxes/presentation/lexical_field_catalogue.dart';
import '../../../engines/verbal_boxes/presentation/word_boxes_renderer.dart';
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
      (ref) => EngineRegistry(<ActivityEngine>[
        // US-021..036: add one line per engine (alphabetical by family id).
        const AirwaysEngine(),
        const ArithmeticGridEngine(),
        const AttentionParityEngine(),
        const AttentionRulesEngine(),
        const CubeNetEngine(),
        const CultureAeroEngine(),
        const DominosEngine(),
        const EnglishEngine(),
        const MultitaskEngine(),
        const NbackEngine(),
        const OverlayGridEngine(),
        const TubesEngine(),
        const ViewpointEngine(),
        WordBoxesEngine(ref.read(lexicalFieldCatalogueProvider)),
      ]),
    );

/// The widgets of every activity.
final Provider<RendererRegistry> rendererRegistryProvider =
    Provider<RendererRegistry>(
      (ref) => RendererRegistry(<ActivityRenderer>[
        // US-021..036: add one line per engine (alphabetical by family id).
        const AirwaysRenderer(),
        const ArithmeticGridRenderer(),
        const AttentionParityRenderer(),
        const AttentionRulesRenderer(),
        const CubeNetRenderer(),
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
        const MultitaskRenderer(),
        const NbackRenderer(),
        const OverlayGridRenderer(),
        const TubesRenderer(),
        const ViewpointRenderer(),
        WordBoxesRenderer(ref.read(lexicalFieldCatalogueProvider)),
      ]),
    );

/// Time source of every session. Widget tests override it with a
/// `ManualClock` to step timers by hand.
final Provider<EngineClock> engineClockProvider = Provider<EngineClock>(
  (ref) => const SystemClock(),
);
