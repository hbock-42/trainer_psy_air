import 'package:psy_content/psy_content.dart';
import 'package:test/test.dart';

Map<String, Object?> validGeneratedJson() => <String, Object?>{
  'id': 'logic_dominos.series.gen.0001',
  'type': 'generated',
  'version': 1,
  'familyId': 'logic_dominos',
  'difficulty': 2,
  'tags': ['logic.dominos'],
  'generatorId': 'dominos',
  'seed': 7,
};

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
        id: 'logic_dominos.series.gen.0001',
        version: 1,
        familyId: 'logic_dominos',
        difficulty: 2,
        tags: ['logic.dominos'],
        generatorId: GeneratorId.dominos,
        seed: 7,
        params: GeneratorParams.dominos(ruleCount: 2),
      );
      final json = item.toJson();
      expect(json['type'], 'generated');
      expect(json['generatorId'], 'dominos');
      expect(json['params'], {
        'length': 6,
        'layout': 'row',
        'ruleCount': 2,
        'answerMode': 'pick',
      });
      expect(json.containsKey('lang'), isFalse);
      expect(Item.fromJson(json), item);
    });

    test('decoded params always belong to the sibling generatorId', () {
      // A stray discriminator inside params never wins over the sibling.
      final json = validGeneratedJson()
        ..['params'] = {'generatorId': 'nback', 'ruleCount': 3};
      final item = Item.fromJson(json) as GeneratedItem;
      expect(item.generatorId, GeneratorId.dominos);
      expect(item.params, const GeneratorParams.dominos(ruleCount: 3));
      expect(item.params.generatorId, item.generatorId);
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

    test('generated selections carry typed params without a discriminator', () {
      const generated = ItemSelection.generated(
        generatorId: GeneratorId.airways,
        difficulty: DifficultyRange(min: 2, max: 4),
        params: GeneratorParams.airways(capacity: 5),
      );
      final json = generated.toJson();
      expect(json['mode'], 'generated');
      expect(json['generatorId'], 'airways');
      final params = json['params']! as Map<String, Object?>;
      expect(params['capacity'], 5);
      expect(params['blueCapacity'], 2);
      expect(params.containsKey('generatorId'), isFalse);
      expect(ItemSelection.fromJson(json), generated);
    });
  });

  group('GeneratorParams', () {
    test('every GeneratorId has defaults that round-trip', () {
      for (final id in GeneratorId.values) {
        final defaults = GeneratorParams.defaultsFor(id);
        expect(defaults.generatorId, id);
        final json = <String, Object?>{
          'generatorId': defaults.toJson()['generatorId'],
        };
        // fromJson with only the discriminator == the defaults.
        expect(GeneratorParams.fromJson(json), defaults, reason: '$id');
        expect(GeneratorParams.fromJson(defaults.toJson()), defaults);
      }
    });

    test('readGeneratorParams merges the sibling generatorId', () {
      final merged = readGeneratorParams({
        'generatorId': 'tubes',
        'params': {'ballCount': 6},
      }, 'params');
      expect(merged, {'ballCount': 6, 'generatorId': 'tubes'});
      expect(
        GeneratorParams.fromJson(merged! as Map<String, Object?>),
        const GeneratorParams.tubes(ballCount: 6),
      );
      // Missing params => only the discriminator.
      expect(readGeneratorParams({'generatorId': 'nback'}, 'params'), {
        'generatorId': 'nback',
      });
    });

    test('real-test defaults match the spec', () {
      const nback = NbackParams();
      expect(nback.n, 2);
      expect(nback.stimulusKind, NbackStimulusKind.colour);
      expect(nback.paletteSize, 3);
      expect(nback.count, 42);
      expect(nback.primers, 2);
      expect(nback.stimulusMs, 1000);
      expect(nback.answerWindowMs, 1500);
      expect(nback.targetRatio, 0.3);
      const grid = ArithmeticGridParams();
      expect(grid.grid, const GridSize(rows: 3, cols: 3));
      expect(grid.wrongMin, 0);
      expect(grid.wrongMax, 4);
      expect(const ParitySequenceParams().numberCount, 16);
      const airways = AirwaysParams();
      expect(airways.capacity, 4);
      expect(airways.blueCapacity, 2);
      expect(const TubesParams().capacities, [3, 2, 3]);
      expect(const MultitaskParams().durationSec, 300);
      expect(const ViewpointParams().viewpointCount, 8);
      expect(const StimulusResponseParams().answerWindowMs, 3000);
    });
  });

  group('Enum JSON values', () {
    test('EngineType uses snake_case strings', () {
      const family = TestFamily(
        id: 'culture_aero',
        moduleId: ModuleId.psy0,
        version: 1,
        order: 12,
        name: LocalizedText(fr: 'Culture aéro'),
        description: LocalizedText(fr: 'QCM'),
        engineType: EngineType.cultureAero,
        answerFormat: AnswerFormat.mcq,
        defaultDurationSec: 900,
        defaultItemCount: 48,
        confidence: Confidence.reported,
      );
      final json = family.toJson();
      expect(json['engineType'], 'culture_aero');
      expect(json['lang'], 'fr');
      expect(json['inputRequirement'], 'touch');
      expect(json['liveFeedback'], false);
      expect(json.containsKey('generatorId'), isFalse);
      expect(TestFamily.fromJson(json), family);
    });

    test('ExamSection fills the v2 defaults', () {
      const section = ExamSection(
        id: 's01',
        familyId: 'memory_nback',
        itemCount: 42,
        itemSelection: ItemSelection.generated(
          generatorId: GeneratorId.nback,
          difficulty: DifficultyRange(min: 3, max: 3),
          params: GeneratorParams.nback(),
        ),
        confidence: Confidence.reported,
        cadence: Cadence(stimulusMs: 1000, answerWindowMs: 1500),
      );
      final json = section.toJson();
      expect(json['scoringPolicy'], {'correct': 1, 'wrong': 0, 'skip': 0});
      expect(json['liveFeedback'], false);
      expect(json['inputRequirement'], 'touch');
      expect(json.containsKey('sectionTimeSec'), isFalse);
      expect(section.hasTiming, isTrue);
      expect(ExamSection.fromJson(json), section);
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
