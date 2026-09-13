import '../../../train/domain/engine/engine.dart';

/// `p1_general_efficiency` ("EFG", US-116, spec §2.3 row 6 / §4.1 row 6):
/// broad, fast-paced reasoning mixing numeric, verbal, spatial and logic
/// items, all authored as plain `McqItem`s tagged `efg.numeric` /
/// `efg.verbal` / `efg.spatial` / `efg.logic` (US-103, 160 MCQs). The real
/// test's exact item type is an open question (see the family's own
/// `description`); MCQ is this content's stand-in, same call as PSY0's
/// `culture_aero`.
///
/// Bank-driven like `culture_aero`/`english`: [generatorId] stays null and
/// [generate] is never called. The default [score] (`Scorer.scoreItem`, MCQ
/// choice/skip) is enough for every item this family has; the only thing
/// this engine adds over the runtime's default is its [familyId]. Balancing
/// a session across the four EFG categories is a sampler concern, not this
/// engine's: `practice_session_builder.dart`'s default `balanceByTag` keys
/// off `tags.first`, which for this bank is always the generic `"efg"` tag
/// (every item also carries `"efg"` before its `efg.<category>` tag, e.g.
/// `["efg", "efg.numeric"]`) — so the default would bucket the whole bank
/// under one tag and never balance by category. `efgTagBalancedSampler`
/// (also in `practice_session_builder.dart`, registered in `itemSamplers`
/// under this family id) balances on the *first tag starting with `efg.`*
/// instead, to actually spread a session across
/// `efg.numeric|verbal|spatial|logic`.
///
/// **Content/contract mismatch (reported, not fixed — non-negotiable #8):**
/// `assets/content/psy1/p1_general_efficiency/family.json` sets
/// `generatorId: "p1_general_efficiency"` and `blueprints/psy1_full.json`'s
/// `s06-efg` section uses `itemSelection.mode: "generated"`. Both make the
/// practice launcher's `buildActivitySessionConfig` take the *generator*
/// path (`family.generatorId != null` in `practice_session_builder.dart`)
/// and build an `ItemSource.adaptive` for `GeneratorId.p1GeneralEfficiency`
/// — which no engine registers (this one deliberately doesn't), so
/// `EngineRegistry.byGenerator` throws `EngineNotFoundError` the moment a
/// session actually runs through the standard launcher or the full PSY1
/// exam blueprint. For the bank content landed in US-103 to reach this
/// engine, `family.json`'s `generatorId` needs to be omitted/null and the
/// blueprint section's `itemSelection.mode` needs to be `bank` (see
/// `culture_aero`/`english` for the shape). Left untouched per this story's
/// instructions; flagging here and in the PR description instead of
/// editing the content contract.
class P1GeneralEfficiencyEngine extends ActivityEngine {
  const P1GeneralEfficiencyEngine();

  @override
  String get familyId => 'p1_general_efficiency';
}
