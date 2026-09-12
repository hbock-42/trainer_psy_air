import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/arithmetic_grid/domain/arithmetic_grid_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = ArithmeticGridEngine();
  const params = GeneratorParams.arithmeticGrid(wrongMin: 2, wrongMax: 2);

  test('familyId and generatorId', () {
    expect(engine.familyId, 'arithmetic_grid');
    expect(engine.generatorId, GeneratorId.arithmeticGrid);
  });

  test('generate is deterministic and returns a GeneratedItem', () {
    final a = engine.generate(params: params, seed: 7, difficulty: 3);
    final b = engine.generate(params: params, seed: 7, difficulty: 3);
    expect(a, isA<GeneratedItem>());
    expect(a, b);
    expect(a.id, ActivityEngine.generatedItemId(GeneratorId.arithmeticGrid, 7));
    expect((a as GeneratedItem).origin, const ItemOrigin(generatorId: GeneratorId.arithmeticGrid, seed: 7));
  });

  test('selecting exactly the wrong set scores correct with perfect metrics', () {
    final item = engine.generate(params: params, seed: 7, difficulty: 3) as GeneratedItem;
    final wrong = ArithmeticGridEngine.gridOf(item).wrongIndices.toList()..sort();

    final result = engine.score(item, Answer.multiSelect(wrong));

    expect(result.correct, isTrue);
    expect(result.metrics['precision'], 1.0);
    expect(result.metrics['recall'], 1.0);
    expect(result.metrics['selectedCount'], wrong.length.toDouble());
  });

  test('selecting nothing when nothing is wrong scores correct', () {
    const emptyParams = GeneratorParams.arithmeticGrid(wrongMin: 0, wrongMax: 0);
    final item = engine.generate(params: emptyParams, seed: 3, difficulty: 2) as GeneratedItem;

    final result = engine.score(item, const Answer.multiSelect([]));

    expect(result.correct, isTrue);
    expect(result.metrics['precision'], 1.0);
    expect(result.metrics['recall'], 1.0);
    expect(result.metrics['selectedCount'], 0.0);
  });

  test('a wrong selection scores incorrect with partial precision/recall', () {
    final item = engine.generate(params: params, seed: 7, difficulty: 3) as GeneratedItem;
    final wrong = ArithmeticGridEngine.gridOf(item).wrongIndices.toList()..sort();
    expect(wrong.length, 2);

    // Select one true wrong cell plus one cell that is actually correct.
    final allIndices = List<int>.generate(9, (i) => i);
    final aCorrectCell = allIndices.firstWhere((i) => !wrong.contains(i));
    final selection = [wrong.first, aCorrectCell];

    final result = engine.score(item, Answer.multiSelect(selection));

    expect(result.correct, isFalse);
    expect(result.metrics['precision'], 0.5);
    expect(result.metrics['recall'], 0.5);
    expect(result.metrics['selectedCount'], 2.0);
  });

  test('selecting none of the wrong cells scores zero recall', () {
    final item = engine.generate(params: params, seed: 7, difficulty: 3) as GeneratedItem;
    final wrong = ArithmeticGridEngine.gridOf(item).wrongIndices;
    final correctOnly = List<int>.generate(
      9,
      (i) => i,
    ).where((i) => !wrong.contains(i)).take(2).toList();

    final result = engine.score(item, Answer.multiSelect(correctOnly));

    expect(result.correct, isFalse);
    expect(result.metrics['precision'], 0.0);
    expect(result.metrics['recall'], 0.0);
  });

  test('a timeout answer is a timeout, never scored as a grid', () {
    final item = engine.generate(params: params, seed: 7, difficulty: 3) as GeneratedItem;
    final result = engine.score(item, const Answer.timeout());
    expect(result.timedOut, isTrue);
    expect(result.correct, isFalse);
  });

  test('an answer of the wrong kind is simply wrong', () {
    final item = engine.generate(params: params, seed: 7, difficulty: 3) as GeneratedItem;
    final result = engine.score(item, const Answer.choice(0));
    expect(result.correct, isFalse);
  });
}
