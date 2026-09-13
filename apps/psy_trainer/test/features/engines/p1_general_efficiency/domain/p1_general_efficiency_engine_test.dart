import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_general_efficiency/domain/p1_general_efficiency_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = P1GeneralEfficiencyEngine();

  test('familyId matches the family blueprint and there is no generator', () {
    expect(engine.familyId, 'p1_general_efficiency');
    expect(engine.generatorId, isNull);
  });

  test('generate is unsupported: p1_general_efficiency is bank-only', () {
    expect(
      () =>
          engine.generate(params: const NbackParams(), seed: 1, difficulty: 1),
      throwsUnsupportedError,
    );
  });

  test('the default scorer handles an EFG MCQ', () {
    final item = McqItem(
      id: 'efg.numeric.0001',
      version: 1,
      familyId: 'p1_general_efficiency',
      difficulty: 1,
      tags: const ['efg', 'efg.numeric'],
      stem: const LocalizedText(fr: 'stem'),
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
}
