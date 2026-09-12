import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_angles/domain/p1_angles_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = P1AnglesEngine();
  const params = GeneratorParams.p1Angles();

  test('familyId and generatorId match the registry contract', () {
    expect(engine.familyId, 'p1_angles');
    expect(engine.generatorId, GeneratorId.p1Angles);
  });

  test('generate is deterministic and returns a GeneratedItem with '
      'engine-owned data (nothing about the board baked into the item)', () {
    final a = engine.generate(params: params, seed: 7, difficulty: 3);
    final b = engine.generate(params: params, seed: 7, difficulty: 3);
    expect(a, isA<GeneratedItem>());
    expect(a.id, b.id);
    expect((a as GeneratedItem).seed, (b as GeneratedItem).seed);
    expect(a.params, b.params);
  });

  test('score: exact correct set is scored correct with perfect metrics', () {
    final item = engine.generate(params: params, seed: 3, difficulty: 3);
    final board = P1AnglesEngine.boardOf(item as GeneratedItem);

    final result = engine.score(
      item,
      Answer.multiSelect(board.correctIndices.toList()..sort()),
    );

    expect(result.correct, isTrue);
    expect(result.metrics['precision'], 1.0);
    expect(result.metrics['recall'], 1.0);
  });

  test('score: an empty selection is wrong and has zero recall', () {
    final item = engine.generate(params: params, seed: 3, difficulty: 3);
    final result = engine.score(item, const Answer.multiSelect([]));

    expect(result.correct, isFalse);
    expect(result.metrics['precision'], 1.0);
    expect(result.metrics['recall'], 0.0);
  });

  test('score: a wrong selection reports partial precision/recall', () {
    final item = engine.generate(params: params, seed: 3, difficulty: 3);
    final board = P1AnglesEngine.boardOf(item as GeneratedItem);
    final correct = board.correctIndices.toList()..sort();
    final wrongCandidate = List.generate(
      board.candidates.length,
      (i) => i,
    ).firstWhere((i) => !board.correctIndices.contains(i));

    final result = engine.score(
      item,
      Answer.multiSelect(<int>[correct.first, wrongCandidate]),
    );

    expect(result.correct, isFalse);
    expect(result.metrics['precision'], 0.5);
  });

  test('score: timeout and skip pass through unchanged', () {
    final item = engine.generate(params: params, seed: 3, difficulty: 3);
    expect(engine.score(item, const Answer.timeout()).timedOut, isTrue);
    expect(engine.score(item, const Answer.skip()).skipped, isTrue);
  });
}
