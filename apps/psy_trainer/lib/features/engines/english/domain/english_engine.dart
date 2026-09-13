import '../../../train/domain/engine/engine.dart';

/// `english` (spec §2.4-O, US-027): reading comprehension first — passages
/// with 3-5 linked MCQs — plus grammar/vocabulary gap-fill MCQs (tag
/// `english.grammar` / `english.vocab`), all authored as plain `McqItem`s in
/// the content bank (US-082). No generator: [generatorId] stays null and
/// [generate] is never called.
///
/// The default [score] (`Scorer.scoreItem`, MCQ choice/skip) is enough for
/// every item this family has; the only thing this engine adds over the
/// runtime's default is its [familyId]. What the reading items need beyond a
/// plain `McqItem` — the passage panel — is a renderer concern: see
/// `McqRenderer(familyId: 'english', passageResolver: ...)` in
/// `engine_registry_provider.dart` and `PassageCache`
/// (`train/presentation/renderers/passage_cache.dart`, generalised in
/// US-116 for every passage-bank family, not just `english`).
///
/// `english_listening` and `english_speaking` (spec §3.1 rows 14b/14c) are
/// out of scope here (stretch goals, no content authored yet): their family
/// files exist but are left untouched, see the story card.
class EnglishEngine extends ActivityEngine {
  const EnglishEngine();

  @override
  String get familyId => 'english';
}
