import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'word_box_series.dart';

/// Read access to the *Boîte à mots* lexical-field bank the engine needs
/// synchronously at generation time (`WordBoxSeries.build` runs inside
/// `generate`, which is not async -- see `ActivitySession`, whose
/// constructor materialises every item of a run up front). The
/// presentation-layer `LexicalFieldCatalogue` (`presentation/
/// lexical_field_catalogue.dart`) is the concrete implementation wired
/// through `engineRegistryProvider`; tests can pass a plain list.
abstract interface class LexicalFieldSource {
  List<LexicalField> get all;
}

/// A fixed, already-loaded list -- what tests and the fallback case use.
class FixedLexicalFieldSource implements LexicalFieldSource {
  const FixedLexicalFieldSource(this.all);

  @override
  final List<LexicalField> all;
}

/// `verbal_boxes` (spec §2.4-I, US-030): fast French semantic
/// categorisation. `generate` does not bake the series into the returned
/// item: like `DominosEngine`, it returns the `GeneratedItem` recipe, and
/// [buildSeries] (called again by [score] and by the renderer) rebuilds the
/// same [WordBoxSeries] from `(seed, params, difficulty)` plus the field
/// catalogue -- see `WordBoxSeries.build` for the algorithm.
///
/// The answer is one `Answer.sequence` of box-index strings, one per word of
/// the series in stream order, submitted once the whole series has been
/// placed (`SequenceAnswer` already fits "an ordered list of tokens", like
/// `DominosEngine`'s two halves).
class WordBoxesEngine extends ActivityEngine {
  const WordBoxesEngine(this._fields);

  final LexicalFieldSource _fields;

  @override
  String get familyId => 'verbal_boxes';

  @override
  GeneratorId get generatorId => GeneratorId.wordBoxes;

  /// Rebuilds the series a materialised item describes. Public so the
  /// renderer can call it with the same `(seed, params, difficulty)` the
  /// item carries.
  WordBoxSeries buildSeries({
    required int seed,
    required WordBoxesParams params,
    required int difficulty,
  }) => WordBoxSeries.build(
    catalogue: _fields.all,
    params: params,
    seed: seed,
    difficulty: difficulty,
  );

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final wordBoxesParams = params as WordBoxesParams;
    // Built once so a catalogue that cannot satisfy the recipe (too few
    // compatible fields) fails fast rather than at render/score time.
    buildSeries(seed: seed, params: wordBoxesParams, difficulty: difficulty);
    return Item.generated(
      id: ActivityEngine.generatedItemId(GeneratorId.wordBoxes, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['verbal'],
      generatorId: GeneratorId.wordBoxes,
      seed: seed,
      params: wordBoxesParams,
      origin: ItemOrigin(
        generatorId: GeneratorId.wordBoxes,
        seed: seed,
        runSeed: runSeed ?? seed,
        index: index,
      ),
    );
  }

  @override
  ItemResult score(Item item, Answer answer) {
    final generated = item as GeneratedItem;
    final series = buildSeries(
      seed: generated.seed,
      params: generated.params as WordBoxesParams,
      difficulty: generated.difficulty,
    );
    final placements = answer is SequenceAnswer
        ? answer.values
        : const <String>[];
    var errors = 0;
    for (var i = 0; i < series.events.length; i++) {
      final expected = series.events[i].fieldIndex.toString();
      final actual = i < placements.length ? placements[i] : null;
      if (actual != expected) errors++;
    }
    return ItemResult(
      correct: errors == 0,
      metrics: <String, num>{
        'errors': errors,
        'wordCount': series.events.length,
      },
    );
  }
}
