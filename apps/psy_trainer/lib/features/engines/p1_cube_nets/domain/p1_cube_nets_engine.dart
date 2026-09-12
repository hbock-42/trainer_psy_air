import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'p1_cube_net_puzzle.dart';
import 'p1_cube_rotation_puzzle.dart';

/// The two shapes a `p1_cube_nets` item can take, decided purely from the
/// item's [index] within its run -- see [P1CubePhase.of].
enum P1CubeMode { net, rotation }

/// Which of [P1CubeNetsParams.phaseCount] phases item [index] of a run
/// belongs to, and what that phase means.
///
/// The contract (`packages/psy_content/lib/model/generator.dart`) has no
/// separate `p1_cube_rotation` generator/family -- `docs/content
/// /psy1-spec.md` §2.3 row 8 describes net-folding (with two alphabets)
/// and rotation-matching as two variants of the *same* "Patrons de cubes"
/// family, and `P1CubeNetsParams` already models this as `phaseCount` /
/// `netsPerPhase` / `alphabet` / `includeRotationMatching` on one params
/// case. This engine implements rotation-matching as a `mode` derived from
/// those fields rather than adding a new generator: with
/// `includeRotationMatching == false` every phase is net-folding, cycling
/// [CubeNetAlphabet.values] starting at `params.alphabet` (default
/// `phaseCount: 2` reproduces the family description's "latin, then
/// runic"); with it `true`, the *last* phase becomes rotation-matching
/// (still drawing that phase's cycled alphabet on the two cubes it shows),
/// so `phaseCount: 1, includeRotationMatching: true` is a pure
/// rotation-matching session (~25 items / 8-10 min, scored `-0.25` per
/// wrong by the runtime's `scoringPolicy` -- never by this engine).
class P1CubePhase {
  const P1CubePhase({
    required this.mode,
    required this.alphabet,
    required this.phaseIndex,
  });

  final P1CubeMode mode;
  final CubeNetAlphabet alphabet;
  final int phaseIndex;

  static P1CubePhase of(P1CubeNetsParams params, int index) {
    final netsPerPhase = params.netsPerPhase < 1 ? 1 : params.netsPerPhase;
    final phaseCount = params.phaseCount < 1 ? 1 : params.phaseCount;
    final phaseIndex = (index ~/ netsPerPhase) % phaseCount;

    const alphabets = CubeNetAlphabet.values;
    final startIndex = alphabets.indexOf(params.alphabet);
    final alphabet = phaseCount <= 1
        ? params.alphabet
        : alphabets[(startIndex + phaseIndex) % alphabets.length];

    final mode = params.includeRotationMatching && phaseIndex == phaseCount - 1
        ? P1CubeMode.rotation
        : P1CubeMode.net;

    return P1CubePhase(mode: mode, alphabet: alphabet, phaseIndex: phaseIndex);
  }
}

/// `p1_cube_nets` (spec §2.3/§4.1 row 8, US-108): net-folding (extending
/// PSY0's `spatial_cubes` with a `latin`/`runic` alphabet param) and
/// rotation matching (a candidate cube judged same-rotated vs altered),
/// both derived from one params case -- see [P1CubePhase].
///
/// [generate] stores the resolved [P1CubePhase.mode] as a tag (`'net'` or
/// `'rotation'`) on the returned item so the renderer and [score] agree on
/// which puzzle `(seed, params, difficulty, index)` describes without
/// recomputing `P1CubePhase.of` from a stale `index` (the item itself
/// carries its own `origin.index`, US-037).
///
/// **Rotation answer shape.** One `GeneratedItem` = one candidate judged
/// against the reference cube (`Answer.choice(1)` "même cube, tourné",
/// `Answer.choice(0)` "modifié"), not one item bundling every candidate of
/// a set behind a single `MultiSelectAnswer`. The spec's own wording --
/// "judge each candidate" -- reads as a per-candidate judgement, and a
/// single yes/no keeps the `-0.25`-per-wrong scoring policy (already a
/// per-item concern the runtime applies uniformly) meaningful per
/// candidate rather than per whole-set guess.
class P1CubeNetsEngine extends ActivityEngine {
  const P1CubeNetsEngine();

  @override
  String get familyId => 'p1_cube_nets';

  @override
  GeneratorId? get generatorId => GeneratorId.p1CubeNets;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final cubeParams = params as P1CubeNetsParams;
    final phase = P1CubePhase.of(cubeParams, index);
    // Fails fast on a malformed recipe instead of only when displayed.
    switch (phase.mode) {
      case P1CubeMode.net:
        buildP1CubeNetPuzzle(
          seed: seed,
          alphabet: phase.alphabet,
          missingFaces: cubeParams.missingFaces,
        );
      case P1CubeMode.rotation:
        buildP1CubeRotationPuzzle(seed: seed, alphabet: phase.alphabet);
    }
    return Item.generated(
      id: ActivityEngine.generatedItemId(GeneratorId.p1CubeNets, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: ['spatial', 'cube_net', phase.mode.name],
      generatorId: GeneratorId.p1CubeNets,
      seed: seed,
      params: cubeParams,
      origin: ItemOrigin(
        generatorId: GeneratorId.p1CubeNets,
        seed: seed,
        runSeed: runSeed ?? seed,
        index: index,
      ),
    );
  }

  @override
  ItemResult score(Item item, Answer answer) {
    if (answer.isTimeout) return ItemResult.timeout;
    if (answer.isSkip) return ItemResult.skip;
    final generated = item as GeneratedItem;
    final params = generated.params as P1CubeNetsParams;
    final index = generated.origin?.index ?? 0;
    final phase = P1CubePhase.of(params, index);

    return switch (phase.mode) {
      P1CubeMode.net => _scoreNet(generated, params, phase, answer),
      P1CubeMode.rotation => _scoreRotation(generated, phase, answer),
    };
  }

  ItemResult _scoreNet(
    GeneratedItem item,
    P1CubeNetsParams params,
    P1CubePhase phase,
    Answer answer,
  ) {
    final puzzle = buildP1CubeNetPuzzle(
      seed: item.seed,
      alphabet: phase.alphabet,
      missingFaces: params.missingFaces,
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
      final matches =
          !mirrored &&
          faceName == entry.value.face.name &&
          rotation == entry.value.rotation;
      if (matches) correctFaces++;
    }
    final correct = correctFaces == puzzle.targetRequired.length;
    return ItemResult(
      correct: correct,
      metrics: {'correctFaces': correctFaces},
    );
  }

  ItemResult _scoreRotation(
    GeneratedItem item,
    P1CubePhase phase,
    Answer answer,
  ) {
    final puzzle = buildP1CubeRotationPuzzle(
      seed: item.seed,
      alphabet: phase.alphabet,
    );
    if (answer is! ChoiceAnswer) return ItemResult.wrong;
    final answeredSame = answer.index == 1;
    return ItemResult(correct: answeredSame == puzzle.isSameCube);
  }
}
