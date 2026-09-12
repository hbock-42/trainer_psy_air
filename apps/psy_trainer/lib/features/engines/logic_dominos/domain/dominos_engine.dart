import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'domino_board.dart';

/// `logic_dominos` (spec §2.4-G, US-024): find the missing domino of a
/// series/arrangement that follows one or more modulo-7 laws.
///
/// [generate] does not bake the puzzle into the returned item: it returns
/// the `GeneratedItem` recipe itself (generatorId + seed + params), and
/// [score] (and the renderer) call [buildDominoBoard] again with that same
/// `(seed, params, difficulty)` to get the dominoes, the missing index, the
/// answer and the rule(s) -- "engine-owned data derived again from the
/// seed" (ARCHITECTURE.md "Engine", step 1). The answer is scored as an
/// `Answer.sequence([top, bottom])` of the two half values as strings (the
/// existing `Answer.sequence` shape fits without adding a new `Answer` case;
/// `RawAnswer` would work too but loses the "ordered pair of tokens" typing
/// `SequenceAnswer` already gives us).
class DominosEngine extends ActivityEngine {
  const DominosEngine();

  @override
  String get familyId => 'logic_dominos';

  @override
  GeneratorId get generatorId => GeneratorId.dominos;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
  }) {
    final dominosParams = params as DominosParams;
    // Built once so a malformed recipe fails fast (uniqueness check) instead
    // of surfacing only when the item is displayed or scored.
    buildDominoBoard(seed: seed, params: dominosParams, difficulty: difficulty);
    return Item.generated(
      id: ActivityEngine.generatedItemId(GeneratorId.dominos, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['dominos'],
      generatorId: GeneratorId.dominos,
      seed: seed,
      params: dominosParams,
      origin: ItemOrigin(generatorId: GeneratorId.dominos, seed: seed),
    );
  }

  @override
  ItemResult score(Item item, Answer answer) {
    final generated = item as GeneratedItem;
    final board = buildDominoBoard(
      seed: generated.seed,
      params: generated.params as DominosParams,
      difficulty: generated.difficulty,
    );
    final correct =
        answer is SequenceAnswer &&
        answer.values.length == 2 &&
        answer.values[0] == board.answer.top.toString() &&
        answer.values[1] == board.answer.bottom.toString();
    return ItemResult(correct: correct);
  }
}
