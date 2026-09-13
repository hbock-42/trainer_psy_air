import 'dart:async';

import 'package:flutter/scheduler.dart';
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
import '../../../exam/presentation/providers/exam_blueprints_provider.dart';
import '../../domain/engine/engine.dart';
import '../providers/train_families_provider.dart';
import '../renderers/mcq_renderer.dart';
import '../renderers/passage_cache.dart';
import 'activity_renderer.dart';
// US-125 (deferred engines): `deferred as` so dart2js can split the 13 PSY1
// engines into their own `*.part.js` chunk instead of bundling them into
// `main.dart.js`. See `deferred/psy1_engines.dart` for why PSY1 (not some
// other split) and why this is loaded eagerly in the background rather than
// gated behind a launcher action.
import 'deferred/psy1_engines.dart' deferred as psy1;

// Composition root of the activity engines (EPIC-03). Each engine story adds
// its `ActivityEngine` to [engineRegistryProvider] and its
// `ActivityRenderer` to [rendererRegistryProvider]; nothing else in the
// runtime knows the concrete engines. Tests override both providers with a
// fake (see `test/helpers/fake_engine.dart`).
//
// Registration order does not matter; the registries key by family id.
//
// PSY1 engines/renderers are *not* imported here directly (US-125): they
// live behind the `psy1` deferred import above and are registered into
// these same, mutable registries by [deferredEnginesLoaderProvider] once
// that library has loaded (`EngineRegistry.register`/`RendererRegistry
// .register` are already public, mutable APIs — nothing in the runtime
// itself needed to change). Until then, `hasFamily('p1_angles')` etc.
// legitimately answers false; every screen that shows "Bientôt" already
// re-evaluates once seconds later (see [deferredEnginesLoaderProvider]).

/// The generators and scorers of every activity (except PSY1's — see
/// above). A plain, non-const list so [deferredEnginesLoaderProvider] can
/// register more into the *same* instance later.
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

/// The widgets of every activity (except PSY1's — see above).
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
          passageResolver: (id) => ref.read(passageCacheProvider).get(id),
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

/// Loads the `psy1` deferred library and registers its 13 engines/renderers
/// into [engineRegistryProvider]/[rendererRegistryProvider] (US-125). Read
/// once, as a side effect, from the app root (`PsyTrainerApp`, same pattern
/// as `reminderCoordinatorProvider`) inside a post-frame callback so the
/// download/parse of that chunk never delays the first frame. Screens that
/// already rendered PSY1 as "Bientôt" (`hasFamily` false before this loads)
/// pick up the change because this invalidates
/// [trainFamiliesProvider]/[examBlueprintsProvider] once done.
///
/// A plain `Provider<void>`, not a `FutureProvider`: nothing needs to await
/// it (deliberately — see `deferred/psy1_engines.dart` for why this is a
/// background load rather than a session-start gate), only trigger it once.
final Provider<void> deferredEnginesLoaderProvider = Provider<void>((ref) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    unawaited(_loadPsy1(ref));
  });
});

Future<void> _loadPsy1(Ref ref) async {
  await psy1.loadLibrary();
  final engines = ref.read(engineRegistryProvider);
  final renderers = ref.read(rendererRegistryProvider);
  for (final engine in psy1.psy1Engines()) {
    if (!engines.hasFamily(engine.familyId)) engines.register(engine);
  }
  for (final renderer in psy1.psy1Renderers(ref)) {
    if (!renderers.hasFamily(renderer.familyId)) renderers.register(renderer);
  }
  ref
    ..invalidate(trainFamiliesProvider)
    ..invalidate(examBlueprintsProvider);
}
