import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/verbal_boxes/domain/word_box_series.dart';
import 'package:psy_trainer/features/engines/verbal_boxes/domain/word_boxes_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

LexicalField _field(String id, {required List<String> words}) => LexicalField(
  id: id,
  version: 1,
  familyId: 'verbal_boxes',
  name: LocalizedText(fr: id),
  difficulty: 1,
  tags: const [],
  words: words,
);

final _catalogue = [
  for (final letter in ['a', 'b', 'c', 'd', 'e', 'f'])
    _field(letter, words: [for (var i = 0; i < 20; i++) '$letter-$i']),
];

void main() {
  final engine = WordBoxesEngine(FixedLexicalFieldSource(_catalogue));
  const params = WordBoxesParams();

  test('familyId and generatorId', () {
    expect(engine.familyId, 'verbal_boxes');
    expect(engine.generatorId, GeneratorId.wordBoxes);
  });

  group('generate', () {
    test('returns a GeneratedItem recipe, not the materialised series', () {
      final item = engine.generate(
        params: params,
        seed: 42,
        difficulty: 2,
        index: 1,
        runSeed: 99,
      );
      expect(item, isA<GeneratedItem>());
      final generated = item as GeneratedItem;
      expect(generated.id, 'gen.word_boxes.42');
      expect(generated.familyId, 'verbal_boxes');
      expect(generated.generatorId, GeneratorId.wordBoxes);
      expect(generated.seed, 42);
      expect(generated.difficulty, 2);
      expect(generated.params, params);
      expect(
        generated.origin,
        const ItemOrigin(
          generatorId: GeneratorId.wordBoxes,
          seed: 42,
          runSeed: 99,
          index: 1,
        ),
      );
    });

    test('is deterministic: same inputs, same item', () {
      final a = engine.generate(params: params, seed: 7, difficulty: 2);
      final b = engine.generate(params: params, seed: 7, difficulty: 2);
      expect(a, b);
    });

    test('falls back to runSeed = seed, index = 0 with no runSeed given', () {
      final item =
          engine.generate(params: params, seed: 5, difficulty: 1)
              as GeneratedItem;
      expect(item.origin!.runSeed, 5);
      expect(item.origin!.index, 0);
    });
  });

  group('score', () {
    WordBoxSeries seriesFor(GeneratedItem item) => WordBoxSeries.build(
      catalogue: _catalogue,
      params: item.params as WordBoxesParams,
      seed: item.seed,
      difficulty: item.difficulty,
    );

    test('every placement correct scores correct with zero errors', () {
      final item =
          engine.generate(params: params, seed: 3, difficulty: 2)
              as GeneratedItem;
      final series = seriesFor(item);
      final answer = Answer.sequence([
        for (final e in series.events) '${e.fieldIndex}',
      ]);
      final result = engine.score(item, answer);
      expect(result.correct, isTrue);
      expect(result.metrics['errors'], 0);
      expect(result.metrics['wordCount'], series.events.length);
    });

    test('one wrong placement scores wrong with one error', () {
      final item =
          engine.generate(params: params, seed: 3, difficulty: 2)
              as GeneratedItem;
      final series = seriesFor(item);
      final values = [for (final e in series.events) '${e.fieldIndex}'];
      final wrongIndex =
          (series.events.first.fieldIndex + 1) % series.fields.length;
      values[0] = '$wrongIndex';
      final result = engine.score(item, Answer.sequence(values));
      expect(result.correct, isFalse);
      expect(result.metrics['errors'], 1);
    });

    test('an answer of the wrong kind scores fully wrong', () {
      final item =
          engine.generate(params: params, seed: 3, difficulty: 2)
              as GeneratedItem;
      final series = seriesFor(item);
      final result = engine.score(item, const Answer.choice(0));
      expect(result.correct, isFalse);
      expect(result.metrics['errors'], series.events.length);
    });
  });
}
