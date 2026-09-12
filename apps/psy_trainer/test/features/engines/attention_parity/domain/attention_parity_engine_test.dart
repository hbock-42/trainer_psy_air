import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/attention_parity/domain/attention_parity_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = AttentionParityEngine();
  const params = ParitySequenceParams();

  test('familyId and generatorId match the family blueprint', () {
    expect(engine.familyId, 'attention_parity');
    expect(engine.generatorId, GeneratorId.paritySequence);
  });

  test('generate is deterministic and returns a plain GeneratedItem', () {
    final a = engine.generate(params: params, seed: 5, difficulty: 3);
    final b = engine.generate(params: params, seed: 5, difficulty: 3);
    expect(a, isA<GeneratedItem>());
    expect(a, b);
    expect((a as GeneratedItem).id, 'gen.parity_sequence.5');
    expect(
      a.origin,
      const ItemOrigin(generatorId: GeneratorId.paritySequence, seed: 5),
    );
  });

  group('score', () {
    late GeneratedItem item;
    late List<String> expectedPath;

    setUp(() {
      item =
          engine.generate(params: params, seed: 11, difficulty: 3)
              as GeneratedItem;
      expectedPath = AttentionParityEngine.layoutOf(item).pathTokens;
    });

    test('the exact expected path is correct', () {
      final result = engine.score(
        item,
        Answer.raw({
          'path': expectedPath,
          'restarts': 0,
          'totalTaps': expectedPath.length,
        }),
      );
      expect(result.correct, isTrue);
      expect(result.metrics['restarts'], 0);
      expect(result.metrics['totalTaps'], expectedPath.length);
    });

    test(
      'restarts and totalTaps are carried into the metrics even when correct',
      () {
        final result = engine.score(
          item,
          Answer.raw({
            'path': expectedPath,
            'restarts': 3,
            'totalTaps': expectedPath.length + 6,
          }),
        );
        expect(result.correct, isTrue);
        expect(result.metrics['restarts'], 3);
        expect(result.metrics['totalTaps'], expectedPath.length + 6);
      },
    );

    test('a reordered path is wrong', () {
      final shuffled = expectedPath.reversed.toList();
      final result = engine.score(
        item,
        Answer.raw({'path': shuffled, 'restarts': 1, 'totalTaps': 20}),
      );
      expect(result.correct, isFalse);
    });

    test('a short path is wrong', () {
      final result = engine.score(
        item,
        Answer.raw({
          'path': expectedPath.take(expectedPath.length - 1).toList(),
          'restarts': 0,
          'totalTaps': expectedPath.length - 1,
        }),
      );
      expect(result.correct, isFalse);
    });

    test('any other answer kind is wrong', () {
      final result = engine.score(item, const Answer.sequence(['1', '2']));
      expect(result.correct, isFalse);
    });
  });
}
