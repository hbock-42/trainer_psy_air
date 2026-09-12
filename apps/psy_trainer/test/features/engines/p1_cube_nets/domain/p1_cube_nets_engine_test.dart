import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_cube_nets/domain/p1_cube_net_puzzle.dart';
import 'package:psy_trainer/features/engines/p1_cube_nets/domain/p1_cube_nets_engine.dart';
import 'package:psy_trainer/features/engines/p1_cube_nets/domain/p1_cube_rotation_puzzle.dart';
import 'package:psy_trainer/features/engines/spatial_cubes/domain/cube_net_puzzle.dart'
    show CubeNetPuzzle;
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = P1CubeNetsEngine();

  test('familyId and generatorId', () {
    expect(engine.familyId, 'p1_cube_nets');
    expect(engine.generatorId, GeneratorId.p1CubeNets);
  });

  group('P1CubePhase.of', () {
    // Defaults: phaseCount 2, netsPerPhase 10.
    const params = P1CubeNetsParams();

    test('cycles alphabets across phases, net mode by default', () {
      final firstPhase = P1CubePhase.of(params, 0);
      expect(firstPhase.mode, P1CubeMode.net);
      expect(firstPhase.alphabet, CubeNetAlphabet.latin);

      final secondPhase = P1CubePhase.of(params, 10);
      expect(secondPhase.mode, P1CubeMode.net);
      expect(secondPhase.alphabet, CubeNetAlphabet.runic);
    });

    test('with includeRotationMatching, the last phase is rotation mode', () {
      // Defaults: phaseCount 2, netsPerPhase 10.
      const withRotation = P1CubeNetsParams(includeRotationMatching: true);
      expect(P1CubePhase.of(withRotation, 0).mode, P1CubeMode.net);
      expect(P1CubePhase.of(withRotation, 9).mode, P1CubeMode.net);
      expect(P1CubePhase.of(withRotation, 10).mode, P1CubeMode.rotation);
      expect(P1CubePhase.of(withRotation, 19).mode, P1CubeMode.rotation);
    });

    test('phaseCount 1 + includeRotationMatching is a pure rotation run', () {
      const pureRotation = P1CubeNetsParams(
        phaseCount: 1,
        netsPerPhase: 25,
        includeRotationMatching: true,
        alphabet: CubeNetAlphabet.runic,
      );
      for (final index in [0, 12, 24]) {
        final phase = P1CubePhase.of(pureRotation, index);
        expect(phase.mode, P1CubeMode.rotation);
        expect(phase.alphabet, CubeNetAlphabet.runic);
      }
    });

    test('cycles beyond phaseCount * netsPerPhase (index modulo)', () {
      final phase = P1CubePhase.of(params, 20);
      expect(phase.phaseIndex, 0);
      expect(phase.alphabet, CubeNetAlphabet.latin);
    });
  });

  group('generate', () {
    // Defaults: phaseCount 2, netsPerPhase 10.
    const params = P1CubeNetsParams();

    test('is deterministic: same inputs, same item', () {
      final a = engine.generate(params: params, seed: 7, difficulty: 2);
      final b = engine.generate(params: params, seed: 7, difficulty: 2);
      expect(a, b);
    });

    test('tags the item with its resolved mode', () {
      final netItem =
          engine.generate(params: params, seed: 1, difficulty: 2)
              as GeneratedItem;
      expect(netItem.tags, contains('net'));

      const withRotation = P1CubeNetsParams(
        phaseCount: 1,
        netsPerPhase: 5,
        includeRotationMatching: true,
      );
      final rotationItem =
          engine.generate(params: withRotation, seed: 1, difficulty: 2)
              as GeneratedItem;
      expect(rotationItem.tags, contains('rotation'));
    });

    test('carries origin.index and runSeed (US-037)', () {
      final item =
          engine.generate(
                params: params,
                seed: 1,
                difficulty: 2,
                index: 4,
                runSeed: 99,
              )
              as GeneratedItem;
      expect(item.origin?.index, 4);
      expect(item.origin?.runSeed, 99);
    });
  });

  group('score (net mode)', () {
    const params = P1CubeNetsParams(phaseCount: 1, netsPerPhase: 5);

    Map<String, Object?> correctPayload(CubeNetPuzzle puzzle) => {
      for (final entry in puzzle.targetRequired.entries)
        'slot_${entry.key}': {
          'face': entry.value.face.name,
          'mirrored': false,
          'rotation': entry.value.rotation,
        },
    };

    test('every slot filled correctly scores correct', () {
      final item =
          engine.generate(params: params, seed: 99, difficulty: 3)
              as GeneratedItem;
      final puzzle = buildP1CubeNetPuzzle(
        seed: 99,
        alphabet: params.alphabet,
        missingFaces: params.missingFaces,
      );
      final result = engine.score(item, Answer.raw(correctPayload(puzzle)));
      expect(result.correct, isTrue);
      expect(result.metrics['correctFaces'], puzzle.missingCellIndices.length);
    });

    test('a mirrored placement never scores correct', () {
      final item =
          engine.generate(params: params, seed: 99, difficulty: 3)
              as GeneratedItem;
      final puzzle = buildP1CubeNetPuzzle(
        seed: 99,
        alphabet: params.alphabet,
        missingFaces: params.missingFaces,
      );
      final payload = correctPayload(puzzle);
      final firstSlot = puzzle.missingCellIndices.first;
      (payload['slot_$firstSlot']! as Map)['mirrored'] = true;
      final result = engine.score(item, Answer.raw(payload));
      expect(result.correct, isFalse);
    });

    test('timeout and skip pass through', () {
      final item =
          engine.generate(params: params, seed: 1, difficulty: 2)
              as GeneratedItem;
      expect(engine.score(item, const Answer.timeout()).timedOut, isTrue);
      expect(engine.score(item, const Answer.skip()).skipped, isTrue);
    });
  });

  group('score (rotation mode)', () {
    const params = P1CubeNetsParams(
      phaseCount: 1,
      netsPerPhase: 25,
      includeRotationMatching: true,
    );

    test('answering in line with the ground truth scores correct', () {
      for (var seed = 0; seed < 20; seed++) {
        final item =
            engine.generate(params: params, seed: seed, difficulty: 2)
                as GeneratedItem;
        final puzzle = buildP1CubeRotationPuzzle(
          seed: seed,
          alphabet: params.alphabet,
        );
        final rightAnswer = Answer.choice(puzzle.isSameCube ? 1 : 0);
        final wrongAnswer = Answer.choice(puzzle.isSameCube ? 0 : 1);
        expect(engine.score(item, rightAnswer).correct, isTrue);
        expect(engine.score(item, wrongAnswer).correct, isFalse);
      }
    });

    test('a non-choice answer scores wrong', () {
      final item =
          engine.generate(params: params, seed: 1, difficulty: 2)
              as GeneratedItem;
      expect(engine.score(item, const Answer.raw({})).correct, isFalse);
    });
  });
}
