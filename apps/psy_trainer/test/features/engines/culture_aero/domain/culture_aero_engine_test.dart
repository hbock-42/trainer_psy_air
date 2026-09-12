import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/culture_aero/domain/culture_aero_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

McqItem _mcq({int correctIndex = 0}) => McqItem(
  id: 'cult.test.0001',
  version: 1,
  familyId: 'culture_aero',
  difficulty: 3,
  tags: const ['culture.history'],
  stem: const LocalizedText(fr: 'Question ?'),
  options: const [
    McqOption(text: LocalizedText(fr: 'A')),
    McqOption(text: LocalizedText(fr: 'B')),
    McqOption(text: LocalizedText(fr: 'C')),
    McqOption(text: LocalizedText(fr: 'D')),
  ],
  correctIndex: correctIndex,
  explanation: const LocalizedText(fr: 'Parce que.'),
  allowSkip: true,
);

void main() {
  const engine = CultureAeroEngine();

  test('familyId is culture_aero and it has no generator (bank-driven)', () {
    expect(engine.familyId, 'culture_aero');
    expect(engine.generatorId, isNull);
  });

  test('registers cleanly alongside the other engines', () {
    final registry = EngineRegistry(const [CultureAeroEngine()]);
    expect(registry.hasFamily('culture_aero'), isTrue);
    expect(registry.byFamily('culture_aero'), isA<CultureAeroEngine>());
  });

  test('materialise is the identity for a bank McqItem', () {
    final item = _mcq();
    expect(engine.materialise(item), same(item));
  });

  group('score (default Scorer.scoreItem)', () {
    test('the correct choice scores right', () {
      final result = engine.score(
        _mcq(correctIndex: 2),
        const Answer.choice(2),
      );
      expect(result.correct, isTrue);
    });

    test('a wrong choice scores wrong', () {
      final result = engine.score(
        _mcq(correctIndex: 2),
        const Answer.choice(0),
      );
      expect(result.correct, isFalse);
      expect(result.skipped, isFalse);
    });

    test('"je ne sais pas" (SkipAnswer) is scored as a skip, not wrong', () {
      final result = engine.score(_mcq(), const Answer.skip());
      expect(result.skipped, isTrue);
      expect(result.correct, isFalse);
      expect(result.timedOut, isFalse);
    });
  });
}
