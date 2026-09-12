import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/english/domain/english_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = EnglishEngine();

  test('familyId matches the family blueprint and there is no generator', () {
    expect(engine.familyId, 'english');
    expect(engine.generatorId, isNull);
  });

  test('generate is unsupported: english is bank-only', () {
    expect(
      () =>
          engine.generate(params: const NbackParams(), seed: 1, difficulty: 1),
      throwsUnsupportedError,
    );
  });

  test('the default scorer handles a grammar/vocab MCQ', () {
    final item = McqItem(
      id: 'english.grammar.0001',
      version: 1,
      familyId: 'english',
      difficulty: 2,
      tags: const ['english.grammar'],
      stem: const LocalizedText(fr: 'gap'),
      options: const [
        McqOption(text: LocalizedText(fr: 'a')),
        McqOption(text: LocalizedText(fr: 'b')),
      ],
      correctIndex: 1,
      explanation: const LocalizedText(fr: 'why'),
    );

    expect(engine.score(item, const Answer.choice(1)).correct, isTrue);
    expect(engine.score(item, const Answer.choice(0)).correct, isFalse);
  });

  test('the default scorer handles a reading MCQ tied to a passage', () {
    final item = McqItem(
      id: 'english.reading.0001',
      version: 1,
      familyId: 'english',
      difficulty: 2,
      tags: const ['english.reading'],
      passageId: 'english.reading.p001',
      stem: const LocalizedText(fr: 'question about the text'),
      options: const [
        McqOption(text: LocalizedText(fr: 'a')),
        McqOption(text: LocalizedText(fr: 'b')),
      ],
      correctIndex: 0,
      explanation: const LocalizedText(fr: 'why'),
    );

    expect(engine.score(item, const Answer.choice(0)).correct, isTrue);
  });
}
