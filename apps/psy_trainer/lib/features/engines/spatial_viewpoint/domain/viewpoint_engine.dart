import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'viewpoint_scene.dart';

/// `spatial_viewpoint` (spec §2.4-K, US-034): identify the one of 8 numbered
/// viewpoints around a 3-D scene it was "photographed" from.
///
/// [generate] does not bake the scene into the returned item: it returns the
/// `GeneratedItem` recipe itself (generatorId + seed + params), and [score]
/// (and the renderer) call [buildViewpointScene] again with that same
/// `(seed, params, difficulty)` to get the scene and the correct azimuth --
/// "engine-owned data derived again from the seed" (ARCHITECTURE.md
/// "Engine", step 1). The answer is the tapped azimuth's 0-based index
/// (`Answer.choice(azimuth - 1)`, matching the 1..8 numbering the renderer
/// shows).
class ViewpointEngine extends ActivityEngine {
  const ViewpointEngine();

  @override
  String get familyId => 'spatial_viewpoint';

  @override
  GeneratorId get generatorId => GeneratorId.viewpoint;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final viewpointParams = params as ViewpointParams;
    // Built once so a malformed recipe (an unsolvable/ambiguous scene) fails
    // fast instead of surfacing only when the item is displayed or scored.
    buildViewpointScene(
      seed: seed,
      params: viewpointParams,
      difficulty: difficulty,
    );
    return Item.generated(
      id: ActivityEngine.generatedItemId(GeneratorId.viewpoint, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['viewpoint'],
      generatorId: GeneratorId.viewpoint,
      seed: seed,
      params: viewpointParams,
      origin: ItemOrigin(generatorId: GeneratorId.viewpoint, seed: seed),
    );
  }

  @override
  ItemResult score(Item item, Answer answer) {
    final generated = item as GeneratedItem;
    final scene = buildViewpointScene(
      seed: generated.seed,
      params: generated.params as ViewpointParams,
      difficulty: generated.difficulty,
    );
    final correct =
        answer is ChoiceAnswer && answer.index == scene.correctAzimuth - 1;
    return ItemResult(correct: correct);
  }
}
