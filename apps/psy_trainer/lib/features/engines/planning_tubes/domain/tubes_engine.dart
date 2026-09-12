import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'tubes_puzzle.dart';

/// `planning_tubes` (spec §2.4-B, US-035): three U-tubes of coloured balls;
/// enter the minimum number of moves from the start to the target
/// configuration (Tower-of-Hanoi family, no colour-matching constraint --
/// only the top ball of a tube moves, one ball per move, a tube can't
/// exceed its capacity).
///
/// Unlike `logic_dominos`/`arithmetic_grid` (which return a [GeneratedItem]
/// because their answer is not a plain number), the answer here *is* a
/// plain number: [generate] returns a real [NumericItem] so the default
/// [Scorer.scoreItem] (exact numeric match, `tolerance: null`) applies with
/// no [score] override. The puzzle itself (tube contents, optimal move
/// sequence) is therefore not carried by the item -- `NumericItem` has no
/// field for it -- but is deterministically recomputed from `(seed,
/// difficulty)` and the family's default [TubesParams] by
/// [TubesPuzzleGenerator.build] wherever it is needed again (the renderer's
/// diagrams and "Voir la solution" step-through, `tubes_renderer.dart`).
/// This assumes the generator always runs with the shipped default
/// `capacities`/`colourCount`/`ballCount` (true today: the one blueprint
/// entry only restates the default `capacities`) -- a future blueprint
/// overriding those would still score correctly (the numeric answer does
/// not depend on it) but would draw the wrong-shaped tubes; see the PR
/// report.
class TubesEngine extends ActivityEngine {
  const TubesEngine();

  @override
  String get familyId => 'planning_tubes';

  @override
  GeneratorId? get generatorId => GeneratorId.tubes;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final typed = params as TubesParams;
    final puzzle = TubesPuzzleGenerator.build(
      params: typed,
      seed: seed,
      difficulty: difficulty,
    );
    return Item.numeric(
      id: ActivityEngine.generatedItemId(GeneratorId.tubes, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['tubes'],
      stem: const LocalizedText(
        fr:
            'Trois éprouvettes contiennent des billes de couleur. Combien de '
            'déplacements au minimum faut-il pour passer de la '
            'configuration de départ à la configuration cible ?',
        en:
            'Three tubes hold coloured balls. What is the minimum number of '
            'moves from the start configuration to the target one?',
      ),
      expected: puzzle.distance,
      explanation: LocalizedText(
        fr: _explanationFr(puzzle.distance),
        en:
            '${puzzle.distance} move${puzzle.distance == 1 ? '' : 's'} '
            'minimum.',
      ),
      origin: ItemOrigin(
        generatorId: GeneratorId.tubes,
        seed: seed,
        runSeed: runSeed ?? seed,
        index: index,
      ),
      inputFormat: InputFormat.integer,
      decimals: 0,
    );
  }

  /// The puzzle a materialised `planning_tubes` [NumericItem] describes,
  /// recomputed from its `origin` (never stored on the item itself); used
  /// by the renderer. Falls back to the family's default [TubesParams]
  /// since `origin` carries no `params` (see the class doc).
  static TubesPuzzle puzzleOf(NumericItem item) {
    final origin = item.origin;
    final seed = origin?.seed ?? int.parse(item.id.split('.').last);
    return TubesPuzzleGenerator.build(
      params: GeneratorParams.defaultsFor(GeneratorId.tubes) as TubesParams,
      seed: seed,
      difficulty: item.difficulty,
    );
  }

  static String _explanationFr(int distance) =>
      distance <= 1 ? '$distance coup minimum.' : '$distance coups minimum.';
}
