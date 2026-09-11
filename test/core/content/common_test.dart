import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/content/content.dart';

void main() {
  group('LocalizedText.resolve', () {
    const both = LocalizedText(fr: 'Bonjour', en: 'Hello');
    const frOnly = LocalizedText(fr: 'Bonjour');

    test('returns en for an English UI locale', () {
      expect(both.resolve('en'), 'Hello');
      expect(both.resolve('en_US'), 'Hello');
      expect(both.resolve('en-GB'), 'Hello');
    });

    test('returns fr for French and unknown locales', () {
      expect(both.resolve('fr'), 'Bonjour');
      expect(both.resolve('fr_CA'), 'Bonjour');
      expect(both.resolve('de'), 'Bonjour');
      expect(both.resolve(''), 'Bonjour');
    });

    test('falls back to fr when en is missing', () {
      expect(frOnly.resolve('en'), 'Bonjour');
    });

    test('serialises without an en key when en is null', () {
      expect(frOnly.toJson(), {'fr': 'Bonjour'});
      expect(both.toJson(), {'fr': 'Bonjour', 'en': 'Hello'});
    });

    test('fromJson requires fr', () {
      expect(() => LocalizedText.fromJson({'en': 'Hello'}), throwsA(anything));
    });
  });

  group('LocalizedPath.resolve', () {
    test('mirrors LocalizedText', () {
      const path = LocalizedPath(fr: 'a.fr.md', en: 'a.en.md');
      expect(path.resolve('en'), 'a.en.md');
      expect(path.resolve('fr'), 'a.fr.md');
      expect(const LocalizedPath(fr: 'a.fr.md').resolve('en'), 'a.fr.md');
    });
  });

  group('DateOnlyConverter', () {
    const converter = DateOnlyConverter();

    test('parses YYYY-MM-DD to UTC midnight', () {
      expect(converter.fromJson('2026-09-11'), DateTime.utc(2026, 9, 11));
    });

    test('formats back to YYYY-MM-DD', () {
      expect(converter.toJson(DateTime.utc(2026, 9, 3)), '2026-09-03');
      expect(converter.toJson(DateTime.utc(999, 12, 2)), '0999-12-02');
    });

    test('rejects other shapes and impossible dates', () {
      expect(() => converter.fromJson('2026-9-1'), throwsFormatException);
      expect(
        () => converter.fromJson('2026-09-11T00:00:00Z'),
        throwsFormatException,
      );
      expect(() => converter.fromJson('2026-02-30'), throwsFormatException);
    });
  });

  group('difficultyFromJson', () {
    test('accepts 1..5', () {
      for (var d = minDifficulty; d <= maxDifficulty; d++) {
        expect(difficultyFromJson(d), d);
      }
    });

    test('rejects out-of-range and non-integer values', () {
      expect(() => difficultyFromJson(0), throwsFormatException);
      expect(() => difficultyFromJson(6), throwsFormatException);
      expect(() => difficultyFromJson(2.5), throwsFormatException);
      expect(() => difficultyFromJson('3'), throwsFormatException);
      expect(() => difficultyFromJson(null), throwsFormatException);
    });

    test('nullable variant passes null through', () {
      expect(difficultyFromJsonNullable(null), isNull);
      expect(difficultyFromJsonNullable(4), 4);
    });
  });

  group('Item union', () {
    test('toJson writes the type discriminator', () {
      const item = Item.generated(
        id: 'logic.series.gen.0001',
        version: 1,
        familyId: 'logic',
        difficulty: 2,
        tags: ['logic.series'],
        generatorId: 'logic_series',
        seed: 7,
      );
      final json = item.toJson();
      expect(json['type'], 'generated');
      expect(json['params'], isEmpty);
      expect(json.containsKey('lang'), isFalse);
      expect(Item.fromJson(json), item);
    });

    test('shared fields are readable on the sealed type', () {
      const Item item = Item.numeric(
        id: 'mental_arithmetic.aviation.0001',
        version: 2,
        familyId: 'mental_arithmetic',
        difficulty: 3,
        tags: ['arith'],
        stem: LocalizedText(fr: '2 + 2 ?'),
        expected: 4,
        explanation: LocalizedText(fr: 'Because.'),
      );
      expect(item.version, 2);
      expect(item.status, ContentStatus.published);
      expect(switch (item) {
        McqItem() => 'mcq',
        NumericItem() => 'numeric',
        SequenceItem() => 'sequence',
        GeneratedItem() => 'generated',
      }, 'numeric');
    });
  });

  group('ItemSelection union', () {
    test('toJson writes the mode discriminator', () {
      const bank = ItemSelection.bank(tags: ['english.grammar']);
      expect(bank.toJson(), {
        'mode': 'bank',
        'tags': ['english.grammar'],
        'avoidRecentSessions': 3,
      });
      expect(ItemSelection.fromJson(bank.toJson()), bank);
    });
  });

  group('Enum JSON values', () {
    test('EngineType uses snake_case strings', () {
      const family = TestFamily(
        id: 'english',
        moduleId: ModuleId.psy0,
        version: 1,
        order: 0,
        name: LocalizedText(fr: 'Anglais'),
        description: LocalizedText(fr: 'QCM'),
        engineType: EngineType.mcqBank,
        answerFormat: AnswerFormat.mcq,
        defaultDurationSec: 600,
        defaultItemCount: 30,
        confidence: Confidence.reported,
      );
      final json = family.toJson();
      expect(json['engineType'], 'mcq_bank');
      expect(json['lang'], 'fr');
      expect(TestFamily.fromJson(json), family);
    });

    test('StimulusKind.gridCells keeps its camelCase string', () {
      const item = Item.sequence(
        id: 'memory.pattern.0001',
        version: 1,
        familyId: 'memory',
        difficulty: 1,
        tags: ['memory.pattern'],
        stimulusKind: StimulusKind.gridCells,
        stimulus: ['0,0'],
        recallMode: RecallMode.anyOrder,
        grid: GridSize(rows: 2, cols: 2),
      );
      expect(item.toJson()['stimulusKind'], 'gridCells');
      expect(item.toJson()['recallMode'], 'anyOrder');
    });
  });
}
