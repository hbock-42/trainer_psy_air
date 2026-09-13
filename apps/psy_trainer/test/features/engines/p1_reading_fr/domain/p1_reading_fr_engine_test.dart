import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_reading_fr/domain/p1_reading_fr_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = P1ReadingFrEngine();

  test('familyId matches the family blueprint and there is no generator', () {
    expect(engine.familyId, 'p1_reading_fr');
    expect(engine.generatorId, isNull);
  });

  test('generate is unsupported: p1_reading_fr is bank-only', () {
    expect(
      () =>
          engine.generate(params: const NbackParams(), seed: 1, difficulty: 1),
      throwsUnsupportedError,
    );
  });

  test('the default scorer handles a reading MCQ tied to a passage', () {
    final item = McqItem(
      id: 'p1_reading_fr.reading.0001',
      version: 1,
      familyId: 'p1_reading_fr',
      difficulty: 2,
      tags: const ['p1_reading_fr', 'p1_reading_fr.comprehension'],
      passageId: 'p1_reading_fr.reading.p001',
      stem: const LocalizedText(fr: 'question about the text'),
      options: const [
        McqOption(text: LocalizedText(fr: 'a')),
        McqOption(text: LocalizedText(fr: 'b')),
      ],
      correctIndex: 0,
      explanation: const LocalizedText(fr: 'why'),
    );

    expect(engine.score(item, const Answer.choice(0)).correct, isTrue);
    expect(engine.score(item, const Answer.choice(1)).correct, isFalse);
  });

  test('a skip answer scores as incorrect via the default scorer', () {
    final item = McqItem(
      id: 'p1_reading_fr.reading.0002',
      version: 1,
      familyId: 'p1_reading_fr',
      difficulty: 2,
      tags: const ['p1_reading_fr'],
      passageId: 'p1_reading_fr.reading.p001',
      stem: const LocalizedText(fr: 'question'),
      options: const [
        McqOption(text: LocalizedText(fr: 'a')),
        McqOption(text: LocalizedText(fr: 'b')),
      ],
      correctIndex: 0,
      explanation: const LocalizedText(fr: 'why'),
      allowSkip: true,
    );

    expect(engine.score(item, const Answer.skip()).correct, isFalse);
  });
}
