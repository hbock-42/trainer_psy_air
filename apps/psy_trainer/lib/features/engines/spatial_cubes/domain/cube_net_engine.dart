import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'cube_net_puzzle.dart';

/// `spatial_cubes` (spec §2.4-L, US-025): rebuild a cube net.
///
/// [generate] returns a bare [GeneratedItem] recipe; the concrete puzzle
/// (which net shapes, which faces are missing, the tray) is engine-owned
/// data the renderer and [score] both recompute from `(seed, params,
/// difficulty)` via [buildCubeNetPuzzle] -- same pattern as
/// `logic_dominos`/`arithmetic_grid`.
///
/// The candidate answers with `Answer.raw({'slot_N': {'face': faceName,
/// 'mirrored': bool, 'rotation': int}})` (`N` the target cell index, and
/// `faceName` a [CubeFace]'s `.name`), one entry per
/// filled target slot: [score] checks each of [CubeNetPuzzle
/// .targetRequired]'s slots against the matching payload entry through
/// [CubeNetCellFace.matches] (face identity + rotation, computed by the
/// geometry core -- never by comparing drawn glyph strings), so a
/// mis-mirrored or mis-rotated tile is rejected even if its `value` string
/// happens to equal the expected one. `correctFaces` in the metrics is the
/// count of correctly filled slots, for partial-credit analytics; the item
/// is correct overall only when every slot is.
class CubeNetEngine extends ActivityEngine {
  const CubeNetEngine();

  @override
  String get familyId => 'spatial_cubes';

  @override
  GeneratorId? get generatorId => GeneratorId.cubeNet;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final cubeParams = params as CubeNetParams;
    // Fails fast on a malformed recipe (net folding, tray uniqueness)
    // instead of only when the item is displayed or scored.
    buildCubeNetPuzzle(seed: seed, params: cubeParams, difficulty: difficulty);
    return Item.generated(
      id: ActivityEngine.generatedItemId(GeneratorId.cubeNet, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['spatial', 'cube_net'],
      generatorId: GeneratorId.cubeNet,
      seed: seed,
      params: cubeParams,
      origin: ItemOrigin(generatorId: GeneratorId.cubeNet, seed: seed),
    );
  }

  @override
  ItemResult score(Item item, Answer answer) {
    if (answer.isTimeout) return ItemResult.timeout;
    if (answer.isSkip) return ItemResult.skip;
    final generated = item as GeneratedItem;
    final puzzle = buildCubeNetPuzzle(
      seed: generated.seed,
      params: generated.params as CubeNetParams,
      difficulty: generated.difficulty,
    );
    if (answer is! RawAnswer) return ItemResult.wrong;
    final payload = answer.payload;

    var correctFaces = 0;
    for (final entry in puzzle.targetRequired.entries) {
      final raw = payload['slot_${entry.key}'];
      if (raw is! Map) continue;
      final faceName = raw['face'] as String?;
      final mirrored = raw['mirrored'] == true;
      final rotation = (raw['rotation'] as num?)?.toInt() ?? -1;
      final placed = CubeNetCellFaceGuess(
        faceName: faceName,
        mirrored: mirrored,
        rotation: rotation,
      );
      if (placed.matches(entry.value)) correctFaces++;
    }
    final correct = correctFaces == puzzle.targetRequired.length;
    return ItemResult(
      correct: correct,
      metrics: {'correctFaces': correctFaces},
    );
  }
}

/// The candidate's raw placement for one slot, decoded from
/// `Answer.raw`'s JSON payload; compares against [CubeNetCellFace] by face
/// name (the JSON has no [CubeFace] values, only their `.name` strings).
class CubeNetCellFaceGuess {
  const CubeNetCellFaceGuess({
    required this.faceName,
    required this.mirrored,
    required this.rotation,
  });

  final String? faceName;
  final bool mirrored;
  final int rotation;

  bool matches(CubeNetCellFace required) =>
      !mirrored &&
      faceName == required.face.name &&
      rotation == required.rotation;
}
