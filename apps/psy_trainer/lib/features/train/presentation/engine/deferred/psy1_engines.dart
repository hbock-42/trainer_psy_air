// US-125 (deferred engines): the 13 PSY1 engines/renderers, imported here
// (never directly from `engine_registry_provider.dart`, see there) so
// `import 'deferred/psy1_engines.dart' deferred as psy1;` is the *only* path
// from `main.dart.js` to this code — the precondition for dart2js to split
// it into its own `*.part.js` instead of bundling it into the initial
// download. PSY0/verbal/english/culture stay eager (registered directly by
// `engineRegistryProvider`): PSY0 is the default active module, so
// deferring it would only move the wait earlier, not remove it.
//
// Loaded once, in the background, shortly after the first frame (see
// `deferredEnginesLoaderProvider`) — not gated behind a launcher/exam action
// like the story card's reference design, a deliberate, documented scope cut
// (see the PR description): touching every session-start call site
// (practice launcher, exam planner, retry-mistakes builder) to await a
// per-family `ensureLoaded` would ripple through ~15 production call sites
// and ~50 tests that assume the registries are fully, synchronously
// populated. Background-loading everything right after first frame keeps
// that contract intact (by the time a user can reach a PSY1 family — an
// explicit module switch plus navigation — the group has almost always
// already loaded) while still moving the PSY1 engine code out of the
// initial JS payload and producing a real `*.part.js` chunk.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../engines/p1_angles/domain/p1_angles_engine.dart';
import '../../../../engines/p1_angles/presentation/p1_angles_renderer.dart';
import '../../../../engines/p1_attention_sustained/domain/attention_sustained_engine.dart';
import '../../../../engines/p1_attention_sustained/presentation/attention_sustained_renderer.dart';
import '../../../../engines/p1_counters/domain/p1_counters_engine.dart';
import '../../../../engines/p1_counters/presentation/p1_counters_renderer.dart';
import '../../../../engines/p1_cube_nets/domain/p1_cube_nets_engine.dart';
import '../../../../engines/p1_cube_nets/presentation/p1_cube_nets_renderer.dart';
import '../../../../engines/p1_general_efficiency/domain/p1_general_efficiency_engine.dart';
import '../../../../engines/p1_math_word_problems/domain/word_problems_engine.dart';
import '../../../../engines/p1_math_word_problems/presentation/word_problems_renderer.dart';
import '../../../../engines/p1_mental_arithmetic/domain/mental_arithmetic_engine.dart';
import '../../../../engines/p1_mental_arithmetic/presentation/mental_arithmetic_renderer.dart';
import '../../../../engines/p1_psychomotor/domain/p1_psychomotor_engine.dart';
import '../../../../engines/p1_psychomotor/presentation/p1_psychomotor_renderer.dart';
import '../../../../engines/p1_raven_matrices/domain/raven_matrices_engine.dart';
import '../../../../engines/p1_raven_matrices/presentation/raven_matrices_renderer.dart';
import '../../../../engines/p1_reading_fr/domain/p1_reading_fr_engine.dart';
import '../../../../engines/p1_tangram/domain/p1_tangram_engine.dart';
import '../../../../engines/p1_tangram/presentation/p1_tangram_renderer.dart';
import '../../../../engines/p1_wm_calc_back/domain/calc_back_engine.dart';
import '../../../../engines/p1_wm_calc_back/presentation/calc_back_renderer.dart';
import '../../../../engines/p1_wm_reverse_span/domain/reverse_span_engine.dart';
import '../../../../engines/p1_wm_reverse_span/presentation/reverse_span_renderer.dart';
import '../../../domain/engine/engine.dart';
import '../../renderers/mcq_renderer.dart';
import '../../renderers/passage_cache.dart';
import '../activity_renderer.dart';

/// Family ids of every engine [psy1Engines] registers — kept in sync by
/// hand (13 entries, checked against this list by
/// `test/features/train/presentation/engine/psy1_engines_test.dart`) since
/// it must be readable *before* this deferred library has loaded (see
/// `knownEngineFamilyIds` in `engine_registry_provider.dart`).
const List<String> psy1FamilyIds = [
  'p1_angles',
  'p1_attention_sustained',
  'p1_counters',
  'p1_cube_nets',
  'p1_general_efficiency',
  'p1_math_word_problems',
  'p1_mental_arithmetic',
  'p1_psychomotor',
  'p1_raven_matrices',
  'p1_reading_fr',
  'p1_tangram',
  'p1_wm_calc_back',
  'p1_wm_reverse_span',
];

List<ActivityEngine> psy1Engines() => const [
  P1AnglesEngine(),
  AttentionSustainedEngine(),
  CountersEngine(),
  P1CubeNetsEngine(),
  P1GeneralEfficiencyEngine(),
  MathWordProblemsEngine(),
  MentalArithmeticEngine(),
  P1PsychomotorEngine(),
  RavenMatricesEngine(),
  P1ReadingFrEngine(),
  TangramEngine(),
  CalcBackEngine(),
  ReverseSpanEngine(),
];

List<ActivityRenderer> psy1Renderers(Ref ref) => [
  const P1AnglesRenderer(),
  const AttentionSustainedRenderer(),
  const CountersRenderer(),
  const P1CubeNetsRenderer(),
  const McqRenderer(familyId: 'p1_general_efficiency'),
  const MathWordProblemsRenderer(),
  const MentalArithmeticRenderer(),
  const P1PsychomotorRenderer(),
  const RavenMatricesRenderer(),
  McqRenderer(
    familyId: 'p1_reading_fr',
    passageResolver: (id) => ref.read(passageCacheProvider).get(id),
  ),
  const TangramRenderer(),
  const CalcBackRenderer(),
  const ReverseSpanRenderer(),
];
