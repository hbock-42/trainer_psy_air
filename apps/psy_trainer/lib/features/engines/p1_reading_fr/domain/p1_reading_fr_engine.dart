import '../../../train/domain/engine/engine.dart';

/// `p1_reading_fr` (US-116, spec §2.3 row 4 / §4.1 row 4): French-language
/// reading comprehension — the PSY1 counterpart of PSY0's `english` family,
/// same shape but in French. Passages with 3-5 linked MCQs, all authored as
/// plain `McqItem`s in the content bank (US-103, 16 passages / 64 MCQs).
///
/// Bank-driven like `english`: [generatorId] stays null and [generate] is
/// never called. The default [score] (`Scorer.scoreItem`, MCQ choice/skip)
/// is enough for every item this family has; the only thing this engine
/// adds over the runtime's default is its [familyId]. What the reading
/// items need beyond a plain `McqItem` — the passage panel — is a renderer
/// concern: see `McqRenderer(familyId: 'p1_reading_fr', passageResolver:
/// ...)` in `engine_registry_provider.dart` and `PassageCache`
/// (`train/presentation/renderers/passage_cache.dart`), plus
/// `passageAwareSampler` in `practice_session_builder.dart`'s
/// `itemSamplers` map so a passage's questions are never split across
/// sessions.
///
/// **Content/contract mismatch (reported, not fixed — non-negotiable #8):**
/// `assets/content/psy1/p1_reading_fr/family.json` sets `generatorId:
/// "p1_reading_fr"` and `blueprints/psy1_full.json`'s `s04-reading` section
/// uses `itemSelection.mode: "generated"`. Both make the practice
/// launcher's `buildActivitySessionConfig` take the *generator* path
/// (`family.generatorId != null` in `practice_session_builder.dart`) and
/// build an `ItemSource.adaptive` for `GeneratorId.p1ReadingFr` — which no
/// engine registers (this one deliberately doesn't), so `EngineRegistry
/// .byGenerator` throws `EngineNotFoundError` the moment a session actually
/// runs through the standard launcher or the full PSY1 exam blueprint. For
/// the bank content landed in US-103 to reach this engine, `family.json`'s
/// `generatorId` needs to be omitted/null and the blueprint section's
/// `itemSelection.mode` needs to be `bank` (see `culture_aero`/`english` for
/// the shape). Left untouched per this story's instructions; flagging here
/// and in the PR description instead of editing the content contract.
class P1ReadingFrEngine extends ActivityEngine {
  const P1ReadingFrEngine();

  @override
  String get familyId => 'p1_reading_fr';
}
