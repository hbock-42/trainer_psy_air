import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/content/content.dart';

/// A minimal valid mcq item, mutated by the negative tests below.
Map<String, Object?> validMcq() => <String, Object?>{
  'id': 'english.grammar.0001',
  'type': 'mcq',
  'version': 1,
  'familyId': 'english',
  'difficulty': 2,
  'tags': ['english.grammar'],
  'stem': {'fr': 'Pick one'},
  'options': [
    {
      'text': {'fr': 'a'},
    },
    {
      'text': {'fr': 'b'},
    },
  ],
  'correctIndex': 1,
  'explanation': {'fr': 'Because.'},
};

Map<String, Object?> validBank({List<Map<String, Object?>>? items}) =>
    <String, Object?>{
      'kind': 'bank',
      'familyId': 'english',
      'items': items ?? [validMcq()],
    };

/// A minimal valid generated recipe (dominos, default params).
Map<String, Object?> validGenerated() => <String, Object?>{
  'id': 'logic_dominos.series.gen.0001',
  'type': 'generated',
  'version': 1,
  'familyId': 'logic_dominos',
  'difficulty': 2,
  'tags': ['logic.dominos'],
  'generatorId': 'dominos',
  'seed': 7,
};

/// A minimal valid blueprint around one [section].
Map<String, Object?> validBlueprint({required Map<String, Object?> section}) =>
    <String, Object?>{
      'kind': 'blueprint',
      'id': 'psy0.blueprint.x',
      'version': 1,
      'moduleId': 'psy0',
      'name': {'fr': 'X'},
      'description': {'fr': 'X'},
      'confidence': 'assumed',
      'tags': ['blueprint.x'],
      'sections': [section],
    };

Map<String, Object?> validField() => <String, Object?>{
  'id': 'verbal_boxes.field.cuisine',
  'version': 1,
  'familyId': 'verbal_boxes',
  'name': {'fr': 'La cuisine'},
  'difficulty': 1,
  'tags': ['verbal.boxes'],
  'words': ['casserole', 'poêle', 'louche', 'fouet', 'passoire'],
};

Map<String, Object?> validLexicalFields() => <String, Object?>{
  'kind': 'lexical_fields',
  'familyId': 'verbal_boxes',
  'fields': [validField()],
};

Matcher throwsContentParseException({
  String? file,
  String? entityId,
  String? messageContains,
}) => throwsA(
  isA<ContentParseException>()
      .having((e) => e.file, 'file', file ?? anything)
      .having((e) => e.entityId, 'entityId', entityId ?? anything)
      .having(
        (e) => e.message,
        'message',
        messageContains == null ? anything : contains(messageContains),
      ),
);

void main() {
  const parser = ContentBundleParser();

  group('ContentBundleParser rejects', () {
    test('malformed JSON, naming the file', () {
      expect(
        () => parser.parseBank('{ not json', file: 'items/broken.json'),
        throwsContentParseException(
          file: 'items/broken.json',
          messageContains: 'invalid JSON',
        ),
      );
    });

    test('a top-level array', () {
      expect(
        () => parser.parseBank('[]', file: 'f.json'),
        throwsContentParseException(messageContains: 'JSON object'),
      );
    });

    test('a file whose kind does not match the parser method', () {
      final json = validBank()..['kind'] = 'deck';
      expect(
        () => parser.parseBank(jsonEncode(json), file: 'f.json'),
        throwsContentParseException(messageContains: '"kind": "bank"'),
      );
      expect(
        () => parser.parseDeck(jsonEncode(validBank()), file: 'f.json'),
        throwsContentParseException(messageContains: '"kind": "deck"'),
      );
    });

    test('an item with an unknown type, naming the item', () {
      final item = validMcq()..['type'] = 'essay';
      expect(
        () => parser.parseBank(
          jsonEncode(validBank(items: [item])),
          file: 'items/grammar-001.json',
        ),
        throwsContentParseException(
          file: 'items/grammar-001.json',
          entityId: 'english.grammar.0001',
          messageContains: 'essay',
        ),
      );
    });

    test('an item without a type', () {
      final item = validMcq()..remove('type');
      expect(
        () => parser.parseBank(jsonEncode(validBank(items: [item])), file: 'f'),
        throwsContentParseException(entityId: 'english.grammar.0001'),
      );
    });

    test('a LocalizedText without fr', () {
      final item = validMcq()..['stem'] = {'en': 'Only English'};
      expect(
        () => parser.parseBank(jsonEncode(validBank(items: [item])), file: 'f'),
        throwsContentParseException(
          entityId: 'english.grammar.0001',
          messageContains: 'fr',
        ),
      );
    });

    test('difficulty 0 and 6 (out of the 1..5 range)', () {
      for (final bad in [0, 6, -1]) {
        final item = validMcq()..['difficulty'] = bad;
        expect(
          () =>
              parser.parseBank(jsonEncode(validBank(items: [item])), file: 'f'),
          throwsContentParseException(
            entityId: 'english.grammar.0001',
            messageContains: 'difficulty',
          ),
          reason: 'difficulty $bad',
        );
      }
    });

    test('a non-integer difficulty', () {
      final item = validMcq()..['difficulty'] = '3';
      expect(
        () => parser.parseBank(jsonEncode(validBank(items: [item])), file: 'f'),
        throwsContentParseException(messageContains: 'difficulty'),
      );
    });

    test('a correctIndex outside the options', () {
      final item = validMcq()..['correctIndex'] = 2;
      expect(
        () => parser.parseBank(jsonEncode(validBank(items: [item])), file: 'f'),
        throwsContentParseException(
          entityId: 'english.grammar.0001',
          messageContains: 'correctIndex',
        ),
      );
    });

    test('a gridCells sequence without a grid', () {
      final item = <String, Object?>{
        'id': 'memory.pattern.0001',
        'type': 'sequence',
        'version': 1,
        'familyId': 'memory',
        'difficulty': 3,
        'tags': ['memory.pattern'],
        'stimulusKind': 'gridCells',
        'stimulus': ['0,0'],
        'recallMode': 'anyOrder',
      };
      final bank = validBank(items: [item])..['familyId'] = 'memory';
      expect(
        () => parser.parseBank(jsonEncode(bank), file: 'f'),
        throwsContentParseException(
          entityId: 'memory.pattern.0001',
          messageContains: 'grid',
        ),
      );
    });

    test('an unknown enum value (engineType)', () {
      final family = <String, Object?>{
        'kind': 'family',
        'id': 'english',
        'moduleId': 'psy0',
        'version': 1,
        'order': 0,
        'name': {'fr': 'Anglais'},
        'description': {'fr': 'QCM.'},
        'engineType': 'crossword',
        'answerFormat': 'mcq',
        'defaultDurationSec': 600,
        'defaultItemCount': 30,
        'confidence': 'assumed',
      };
      expect(
        () => parser.parseFamily(jsonEncode(family), file: 'family.json'),
        throwsContentParseException(
          file: 'family.json',
          messageContains: 'engineType',
        ),
      );
    });

    test('an item whose familyId differs from the bank', () {
      final item = validMcq()..['familyId'] = 'verbal';
      expect(
        () => parser.parseBank(jsonEncode(validBank(items: [item])), file: 'f'),
        throwsContentParseException(
          entityId: 'english.grammar.0001',
          messageContains: 'familyId',
        ),
      );
    });

    test('an item referencing a passage the bank does not declare', () {
      final item = validMcq()..['passageId'] = 'english.reading.p999';
      expect(
        () => parser.parseBank(jsonEncode(validBank(items: [item])), file: 'f'),
        throwsContentParseException(
          entityId: 'english.grammar.0001',
          messageContains: 'passageId',
        ),
      );
    });

    test('duplicate item ids in one bank', () {
      expect(
        () => parser.parseBank(
          jsonEncode(validBank(items: [validMcq(), validMcq()])),
          file: 'f',
        ),
        throwsContentParseException(
          entityId: 'english.grammar.0001',
          messageContains: 'duplicate',
        ),
      );
    });

    test('a lesson with both body and file, or neither', () {
      final lesson = <String, Object?>{
        'kind': 'lesson',
        'id': 'english.lesson.01-tenses',
        'version': 1,
        'moduleId': 'psy0',
        'order': 1,
        'title': {'fr': 'Temps'},
        'tags': ['english.grammar'],
      };
      expect(
        () => parser.parseLesson(jsonEncode(lesson), file: 'l.json'),
        throwsContentParseException(
          entityId: 'english.lesson.01-tenses',
          messageContains: 'body',
        ),
      );
      lesson['body'] = {'fr': 'x'};
      lesson['file'] = {'fr': 'english/lessons/01.fr.md'};
      expect(
        () => parser.parseLesson(jsonEncode(lesson), file: 'l.json'),
        throwsContentParseException(messageContains: 'body'),
      );
    });

    test('a flashcard whose deckId does not match its deck', () {
      final deck = <String, Object?>{
        'kind': 'deck',
        'id': 'english.deck.a',
        'version': 1,
        'moduleId': 'psy0',
        'familyId': 'english',
        'order': 0,
        'name': {'fr': 'A'},
        'tags': ['english'],
        'cards': [
          {
            'id': 'english.deck.b.0001',
            'version': 1,
            'deckId': 'english.deck.b',
            'front': {'fr': 'f'},
            'back': {'fr': 'b'},
            'difficulty': 1,
            'tags': ['english'],
          },
        ],
      };
      expect(
        () => parser.parseDeck(jsonEncode(deck), file: 'd.json'),
        throwsContentParseException(
          entityId: 'english.deck.b.0001',
          messageContains: 'deckId',
        ),
      );
    });

    test('an item selection with an unknown mode', () {
      final blueprint = <String, Object?>{
        'kind': 'blueprint',
        'id': 'psy0.blueprint.x',
        'version': 1,
        'moduleId': 'psy0',
        'name': {'fr': 'X'},
        'description': {'fr': 'X'},
        'confidence': 'assumed',
        'tags': ['blueprint.x'],
        'sections': [
          {
            'id': 's01',
            'familyId': 'english',
            'sectionTimeSec': 60,
            'itemCount': 5,
            'itemSelection': {'mode': 'random'},
            'confidence': 'assumed',
          },
        ],
      };
      expect(
        () => parser.parseBlueprint(jsonEncode(blueprint), file: 'b.json'),
        throwsContentParseException(entityId: 's01', messageContains: 'random'),
      );
    });

    test('a section without any timing policy', () {
      final blueprint = validBlueprint(
        section: {
          'id': 's01',
          'familyId': 'culture_aero',
          'itemCount': 5,
          'itemSelection': {'mode': 'bank'},
          'confidence': 'assumed',
        },
      );
      expect(
        () => parser.parseBlueprint(jsonEncode(blueprint), file: 'b.json'),
        throwsContentParseException(
          entityId: 's01',
          messageContains: 'sectionTimeSec',
        ),
      );
    });

    test(
      'a generated selection with an unknown generator, naming the section',
      () {
        final blueprint = validBlueprint(
          section: {
            'id': 's01',
            'familyId': 'logic',
            'sectionTimeSec': 60,
            'itemCount': 5,
            'itemSelection': {
              'mode': 'generated',
              'generatorId': 'logic_series',
              'difficulty': {'min': 2, 'max': 4},
            },
            'confidence': 'assumed',
          },
        );
        expect(
          () => parser.parseBlueprint(jsonEncode(blueprint), file: 'b.json'),
          throwsContentParseException(
            entityId: 's01',
            messageContains: 'logic_series',
          ),
        );
      },
    );

    test('a generated item with a mistyped param, naming the item', () {
      final item = validGenerated()..['params'] = {'ruleCount': 'two'};
      expect(
        () => parser.parseBank(
          jsonEncode(validBank(items: [item])..['familyId'] = 'logic_dominos'),
          file: 'f',
        ),
        throwsContentParseException(
          entityId: 'logic_dominos.series.gen.0001',
          messageContains: 'ruleCount',
        ),
      );
    });

    test('a generated item without generatorId', () {
      final item = validGenerated()..remove('generatorId');
      expect(
        () => parser.parseBank(
          jsonEncode(validBank(items: [item])..['familyId'] = 'logic_dominos'),
          file: 'f',
        ),
        throwsContentParseException(
          entityId: 'logic_dominos.series.gen.0001',
          messageContains: 'generatorId',
        ),
      );
    });

    test('an mcq item with a malformed validAsOf', () {
      final item = validMcq()..['validAsOf'] = '11/09/2026';
      expect(
        () => parser.parseBank(jsonEncode(validBank(items: [item])), file: 'f'),
        throwsContentParseException(
          entityId: 'english.grammar.0001',
          messageContains: 'validAsOf',
        ),
      );
    });

    group('a lexical field bank with', () {
      test('a field of another family', () {
        final bank = validLexicalFields()
          ..['fields'] = [validField()..['familyId'] = 'english_reading'];
        expect(
          () => parser.parseLexicalFields(jsonEncode(bank), file: 'lf.json'),
          throwsContentParseException(
            file: 'lf.json',
            entityId: 'verbal_boxes.field.cuisine',
            messageContains: 'familyId',
          ),
        );
      });

      test('duplicate field ids', () {
        final bank = validLexicalFields()
          ..['fields'] = [validField(), validField()];
        expect(
          () => parser.parseLexicalFields(jsonEncode(bank), file: 'lf.json'),
          throwsContentParseException(messageContains: 'duplicate'),
        );
      });

      test('a trap for its own field', () {
        final bank = validLexicalFields()
          ..['fields'] = [
            validField()
              ..['traps'] = [
                {'word': 'balance', 'trapFor': 'verbal_boxes.field.cuisine'},
              ],
          ];
        expect(
          () => parser.parseLexicalFields(jsonEncode(bank), file: 'lf.json'),
          throwsContentParseException(messageContains: 'own field'),
        );
      });

      test('a trap word also listed in words', () {
        final bank = validLexicalFields()
          ..['fields'] = [
            validField()
              ..['traps'] = [
                {'word': 'louche', 'trapFor': 'verbal_boxes.field.marine'},
              ],
          ];
        expect(
          () => parser.parseLexicalFields(jsonEncode(bank), file: 'lf.json'),
          throwsContentParseException(messageContains: 'louche'),
        );
      });

      test('a trap without trapFor, naming the field', () {
        final bank = validLexicalFields()
          ..['fields'] = [
            validField()
              ..['traps'] = [
                {'word': 'balance'},
              ],
          ];
        expect(
          () => parser.parseLexicalFields(jsonEncode(bank), file: 'lf.json'),
          throwsContentParseException(
            entityId: 'verbal_boxes.field.cuisine',
            messageContains: 'trapFor',
          ),
        );
      });

      test('the wrong kind', () {
        expect(
          () => parser.parseLexicalFields(jsonEncode(validBank()), file: 'f'),
          throwsContentParseException(messageContains: 'lexical_fields'),
        );
      });
    });

    test('an invalid date in the manifest', () {
      final manifest = <String, Object?>{
        'kind': 'manifest',
        'schemaVersion': 1,
        'contentVersion': 1,
        'updatedAt': '2026-13-40',
        'modules': ['psy0'],
      };
      expect(
        () => parser.parseManifest(jsonEncode(manifest), file: 'manifest.json'),
        throwsContentParseException(
          file: 'manifest.json',
          messageContains: 'updatedAt',
        ),
      );
    });
  });

  group('ContentBundleParser tolerates', () {
    test('unknown keys (additive fields never bump schemaVersion)', () {
      final item = validMcq()..['futureField'] = 42;
      final bank = validBank(items: [item])..['somethingNew'] = true;
      final parsed = parser.parseBank(jsonEncode(bank), file: 'f');
      expect(parsed.items.single, isA<McqItem>());
    });

    test(r'the $schema editor hint', () {
      final bank = validBank()..[r'$schema'] = '../schema/bank.schema.json';
      expect(parser.parseBank(jsonEncode(bank), file: 'f').items, hasLength(1));
    });

    test('a generated recipe without params (real-test defaults apply)', () {
      final bank = validBank(items: [validGenerated()])
        ..['familyId'] = 'logic_dominos';
      final item =
          parser.parseBank(jsonEncode(bank), file: 'f').items.single
              as GeneratedItem;
      expect(item.generatorId, GeneratorId.dominos);
      expect(item.params, const GeneratorParams.dominos());
    });

    test('a valid lexical field bank', () {
      final bank = parser.parseLexicalFields(
        jsonEncode(validLexicalFields()),
        file: 'lf.json',
      );
      expect(bank.fields.single.words, hasLength(5));
      expect(bank.fields.single.traps, isEmpty);
    });
  });

  test('ContentParseException.toString names file and entity', () {
    const e = ContentParseException(
      file: 'items/a.json',
      entityId: 'english.grammar.0001',
      message: 'boom',
    );
    expect(
      e.toString(),
      'ContentParseException: items/a.json [english.grammar.0001]: boom',
    );
  });
}
