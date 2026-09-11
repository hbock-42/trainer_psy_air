import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../../tool/content_validator/content_validator.dart';
import '../../tool/content_validator/format.dart';

/// Tests of `tool/validate_content.dart` run through its library entry point
/// ([ContentValidator]) on the fixture bundles under `test/tool/fixtures/`.
void main() {
  const fixtures = 'test/tool/fixtures';
  const validBundle = '$fixtures/valid_bundle';
  late ContentValidator validator;

  setUpAll(() {
    expect(
      Directory(validBundle).existsSync(),
      isTrue,
      reason: 'run tests from the package root',
    );
    validator = ContentValidator.load();
  });

  group('schema registry', () {
    test('maps every file kind of docs/content/schema to a schema', () {
      expect(
        validator.schemas.kinds,
        containsAll([
          'manifest',
          'module',
          'family',
          'bank',
          'lesson',
          'deck',
          'blueprint',
        ]),
      );
    });

    test('accepts a conforming instance and rejects a broken one', () {
      final ok = validator.schemas.validate('manifest', {
        'kind': 'manifest',
        'schemaVersion': 1,
        'contentVersion': 1,
        'updatedAt': '2026-09-11',
        'modules': ['psy0'],
      });
      expect(ok, isEmpty);

      final bad = validator.schemas.validate('manifest', {
        'kind': 'manifest',
        'schemaVersion': 0,
        'contentVersion': 1,
        'updatedAt': '2026-09-11',
        'modules': ['psy9'],
        'extra': true,
      });
      expect(
        bad.map((v) => v.path),
        containsAll(['/schemaVersion', '/modules/0', '/extra']),
      );
      expect(
        bad.firstWhere((v) => v.path == '/modules/0').message,
        contains('"psy0", "psy1", "psy2"'),
      );
      expect(
        bad.firstWhere((v) => v.path == '/extra').message,
        'unexpected property',
      );
    });
  });

  group('valid bundle', () {
    late ValidationReport report;

    setUpAll(() => report = validator.validate([validBundle]));

    test('has no issue', () {
      expect(report.issues, isEmpty, reason: report.issues.join('\n'));
      expect(report.ok, isTrue);
      expect(report.filesScanned, 14);
      expect(report.bundles, [validBundle]);
      expect(report.looseFiles, 0);
    });

    test('summarises items per family, by difficulty and by type', () {
      final byId = {for (final f in report.families) f.familyId: f};
      expect(
        byId.keys,
        unorderedEquals(['english', 'mental_arithmetic', 'logic', 'memory']),
      );
      expect(byId.values.every((f) => f.declared), isTrue);
      expect(byId.values.every((f) => f.moduleId == 'psy0'), isTrue);

      final english = byId['english']!;
      expect(english.items, 3);
      expect(english.byDifficulty, {1: 0, 2: 2, 3: 1, 4: 0, 5: 0});
      expect(english.byType, {'mcq': 3});
      expect(english.passages, 1);
      expect(english.lessons, 1);
      expect(english.decks, 1);
      expect(english.cards, 2);

      expect(byId['memory']!.byType, {'sequence': 2});
      expect(byId['logic']!.byType, {'generated': 1});
      expect(byId['mental_arithmetic']!.byType, {'numeric': 2});
      expect(byId['mental_arithmetic']!.byDifficulty[4], 1);
    });

    test('renders a text report and a JSON report', () {
      final text = formatReport(report);
      expect(text, contains('english'));
      expect(text, contains('OK: 0 error(s), 0 warning(s) in 14 file(s)'));

      final quiet = formatReport(report, quiet: true);
      expect(quiet, isNot(contains('family')));
      expect(quiet, endsWith('OK: 0 error(s), 0 warning(s) in 14 file(s)'));

      final json =
          jsonDecode(jsonEncode(report.toJson())) as Map<String, Object?>;
      expect(json['ok'], isTrue);
      expect(json['errorCount'], 0);
      expect(json['families'], hasLength(4));
      final families = json['families'] as List<Object?>;
      final first = families.first as Map<String, Object?>;
      expect(
        first.keys,
        containsAll(['familyId', 'items', 'byDifficulty', 'byType']),
      );
    });
  });

  group('loose files', () {
    test('the authoring examples validate on their own', () {
      final report = validator.validate([ContentValidator.defaultContentDir]);
      expect(report.errors, isEmpty, reason: report.errors.join('\n'));
      expect(report.bundles, isEmpty);
      expect(report.looseFiles, greaterThanOrEqualTo(10));
      // Families of loose banks are listed but not declared.
      expect(report.families.map((f) => f.familyId), contains('english'));
      expect(
        report.families.firstWhere((f) => f.familyId == 'english').declared,
        isFalse,
      );
    });

    test('a folder named examples inside a bundle is not part of it', () {
      withBundleCopy((root) {
        final examples = Directory(p.join(root, 'examples'))..createSync();
        File(p.join(examples.path, 'mcq.example.json')).writeAsStringSync(
          File('assets/content/examples/mcq.example.json').readAsStringSync(),
        );
        final report = validator.validate([root]);
        expect(report.errors, isEmpty, reason: report.errors.join('\n'));
        expect(report.looseFiles, 1);
      });
    });

    test('a single file path is accepted', () {
      final report = validator.validate([
        '$validBundle/psy0/english/items/grammar-001.json',
      ]);
      expect(report.ok, isTrue);
      expect(report.filesScanned, 1);
      expect(report.looseFiles, 1);
    });

    test('a missing path is an error', () {
      final report = validator.validate(['does/not/exist']);
      expect(report.ok, isFalse);
      expect(report.errors.single.source, IssueSource.file);
    });
  });

  group('invalid fixture: broken_refs', () {
    late ValidationReport report;
    setUpAll(
      () => report = validator.validate(['$fixtures/invalid/broken_refs']),
    );

    test('reports every dangling reference', () {
      expect(report.ok, isFalse);
      final messages = report.errors.map((e) => e.toString()).toList();
      expect(
        messages,
        containsAll([
          contains('module "psy1" is listed in the manifest'),
          contains('family "spatial" is listed in familyIds'),
          contains('family "memory" is not listed in psy0/module.json'),
          contains('defaultBlueprintId "psy0.blueprint.full"'),
          contains('section familyId "verbal"'),
          contains('deckIds references unknown deck "english.deck.missing"'),
          contains('lesson file "english/lessons/01-tenses.en.md" not found'),
          contains('media file "english/media/runway-signs.svg" not found'),
        ]),
      );
      // One per media reference: item media, option media, card media.
      expect(
        report.errors.where((e) => e.message.contains('media file')).length,
        3,
      );
      expect(report.errors, hasLength(10), reason: messages.join('\n'));
    });

    test('names the file and the entity of each error', () {
      final media = report.errors.firstWhere(
        (e) => e.path == '/items/1/options/0/media/path',
      );
      expect(media.file, endsWith('psy0/english/items/grammar-001.json'));
      expect(media.entityId, 'english.vocab.0001');
      expect(media.source, IssueSource.semantic);
    });
  });

  group('invalid fixture: bad_items', () {
    late ValidationReport report;
    setUpAll(
      () => report = validator.validate(['$fixtures/invalid/bad_items']),
    );

    test('reports schema, Dart parser and semantic errors', () {
      expect(report.ok, isFalse);
      final messages = report.errors.map((e) => e.toString()).toList();
      expect(
        messages,
        containsAll([
          contains('/items/0/correctIndex: correctIndex 4 is out of range'),
          contains('/items/1/difficulty: maximum exceeded (7 > 5)'),
          contains(
            '/items/1/difficulty: difficulty must be an integer between 1 and 5',
          ),
          contains('/items/2: missing required property "explanation"'),
          contains(
            '/items/2/explanation: explanation is mandatory for mcq items',
          ),
          contains('duplicate id: this item id is already used in'),
          contains('grid cell "5,5" is outside the 3x3 grid'),
          contains('card deckId "english.deck.other" does not match'),
        ]),
      );
      expect(report.errors.map((e) => e.source).toSet(), {
        IssueSource.schema,
        IssueSource.parse,
        IssueSource.semantic,
      });
    });

    test('attributes errors to the offending item', () {
      final correct = report.errors.firstWhere(
        (e) => e.message.startsWith('correctIndex'),
      );
      expect(correct.entityId, 'english.grammar.0001');
      final duplicate = report.errors.firstWhere(
        (e) => e.message.startsWith('duplicate id'),
      );
      expect(duplicate.file, endsWith('psy0/logic/items/series-gen-001.json'));
      expect(duplicate.entityId, 'english.grammar.0001');
    });

    test('quiet text output lists errors only', () {
      final text = formatReport(report, quiet: true);
      expect(text, startsWith('ERRORS (${report.errors.length})'));
      expect(text, isNot(contains('WARNINGS')));
      expect(text, endsWith('in 14 file(s)'));
      expect(text, contains('FAILED: ${report.errors.length} error(s)'));
    });
  });

  group('mutations of the valid bundle', () {
    const bank = 'psy0/english/items/grammar-001.json';
    const lesson = 'psy0/english/lessons/01-tenses.json';
    const blueprint = 'psy0/blueprints/psy0_short.json';
    const memoryBank = 'psy0/memory/items/digit-span-001.json';

    List<Issue> errorsAfter(
      String file,
      void Function(Map<String, Object?>) mutate,
    ) {
      late List<Issue> errors;
      withBundleCopy((root) {
        editJson(p.join(root, file), mutate);
        errors = validator.validate([root]).errors;
      });
      return errors;
    }

    test('invalid JSON', () {
      withBundleCopy((root) {
        File(p.join(root, bank)).writeAsStringSync('{ "kind": "bank", ');
        final errors = validator.validate([root]).errors;
        expect(errors.single.message, startsWith('invalid JSON'));
        expect(errors.single.source, IssueSource.file);
      });
    });

    test('missing or unknown kind', () {
      final missing = errorsAfter(bank, (j) => j.remove('kind'));
      expect(missing.single.message, startsWith('missing "kind"'));
      final unknown = errorsAfter(bank, (j) => j['kind'] = 'quiz');
      expect(unknown.single.message, startsWith('unknown kind "quiz"'));
    });

    test('unexpected property inside a oneOf branch is located', () {
      final errors = errorsAfter(bank, (j) => item(j, 1)['bogus'] = 1);
      expect(errors, hasLength(1));
      expect(errors.single.path, '/items/1/bogus');
      expect(errors.single.message, 'unexpected property');
      expect(errors.single.entityId, 'english.vocab.0001');
    });

    test('wrong item type is reported with the allowed values', () {
      final errors = errorsAfter(bank, (j) => item(j, 0)['type'] = 'weird');
      final schema = errors.where((e) => e.source == IssueSource.schema);
      expect(schema.map((e) => e.path).toSet(), {'/items/0/type'});
      expect(
        schema.first.message,
        contains('"mcq", "numeric", "sequence", "generated"'),
      );
    });

    test('gridCells without grid explains the conditional requirement', () {
      final errors = errorsAfter(memoryBank, (j) => item(j, 1).remove('grid'));
      final schema = errors.firstWhere((e) => e.source == IssueSource.schema);
      expect(schema.path, '/items/1');
      expect(
        schema.message,
        'missing required property "grid" (required when stimulusKind is "gridCells")',
      );
      expect(errors.map((e) => e.source), contains(IssueSource.semantic));
    });

    test('blank French text', () {
      final errors = errorsAfter(
        bank,
        (j) => (item(j, 0)['stem']! as Map<String, Object?>)['fr'] = '   ',
      );
      expect(
        errors.map((e) => e.message),
        contains('French text ("fr") is missing or blank'),
      );
      expect(
        errors.firstWhere((e) => e.source == IssueSource.semantic).path,
        '/items/0/stem/fr',
      );
    });

    test('missing French text is a schema error too', () {
      final errors = errorsAfter(
        bank,
        (j) => (item(j, 0)['stem']! as Map<String, Object?>).remove('fr'),
      );
      expect(
        errors.map((e) => e.toString()),
        contains(contains('/items/0/stem: missing required property "fr"')),
      );
    });

    test('correctIndex out of range', () {
      final errors = errorsAfter(bank, (j) => item(j, 2)['correctIndex'] = 2);
      expect(
        errors.map((e) => e.message),
        contains(startsWith('correctIndex 2 is out of range')),
      );
    });

    test('blank explanation on a numeric item', () {
      final errors = errorsAfter(
        'psy0/mental_arithmetic/items/aviation-001.json',
        (j) => item(j, 0)['explanation'] = {'fr': ''},
      );
      expect(
        errors.map((e) => e.message),
        contains(startsWith('explanation is mandatory for numeric items')),
      );
    });

    test('difficulty outside 1-5 on a flashcard', () {
      final errors = errorsAfter(
        'psy0/english/decks/aviation-vocab.json',
        (j) => (j['cards']! as List<Object?>).first.asMap['difficulty'] = 0,
      );
      expect(errors.map((e) => e.path), contains('/cards/0/difficulty'));
      expect(
        errors.map((e) => e.message),
        contains(startsWith('difficulty must be an integer between 1 and 5')),
      );
    });

    test('unknown passageId', () {
      final errors = errorsAfter(
        bank,
        (j) => item(j, 2)['passageId'] = 'english.reading.p999',
      );
      expect(
        errors.map((e) => e.message),
        contains(contains('passageId "english.reading.p999" is not declared')),
      );
    });

    test('bank familyId must match its folder and an existing family', () {
      final errors = errorsAfter(bank, (j) {
        j['familyId'] = 'verbal';
        for (final it in (j['items']! as List<Object?>)) {
          it.asMap['familyId'] = 'verbal';
        }
      });
      expect(
        errors.map((e) => e.message),
        contains(
          contains(
            'familyId "verbal" does not match the family folder "english"',
          ),
        ),
      );
    });

    test('lesson with both body and file', () {
      final errors = errorsAfter(lesson, (j) => j['body'] = {'fr': 'inline'});
      expect(
        errors.map((e) => e.toString()),
        containsAll([
          contains('matches more than one alternative of oneOf (body | file)'),
          contains('a lesson needs exactly one of "body"'),
        ]),
      );
    });

    test('generated selection without generatorId', () {
      final errors = errorsAfter(blueprint, (j) {
        final section = (j['sections']! as List<Object?>).first.asMap;
        (section['itemSelection']! as Map<String, Object?>).remove(
          'generatorId',
        );
      });
      final schema = errors.firstWhere((e) => e.source == IssueSource.schema);
      expect(schema.path, '/sections/0/itemSelection');
      expect(schema.message, 'missing required property "generatorId"');
      expect(schema.entityId, 's01-arith');
    });

    test('blueprint difficulty range with min > max', () {
      final errors = errorsAfter(blueprint, (j) {
        final section = (j['sections']! as List<Object?>).first.asMap;
        (section['itemSelection']! as Map<String, Object?>)['difficulty'] = {
          'min': 4,
          'max': 2,
        };
      });
      expect(
        errors.map((e) => e.message),
        contains('difficulty range min (4) is greater than max (2)'),
      );
    });

    test('manifest changelog must start with the current contentVersion', () {
      final errors = errorsAfter(
        'manifest.json',
        (j) => j['contentVersion'] = 3,
      );
      expect(errors.single.path, '/changelog/0/contentVersion');
      expect(
        errors.single.message,
        contains('must describe the current contentVersion 3'),
      );
    });

    test('family id must match its folder', () {
      final errors = errorsAfter(
        'psy0/english/family.json',
        (j) => j['id'] = 'englsh',
      );
      expect(
        errors.map((e) => e.message),
        contains('family id "englsh" does not match its folder "english"'),
      );
    });

    test('a bank file in the wrong folder', () {
      withBundleCopy((root) {
        File(
          p.join(root, bank),
        ).renameSync(p.join(root, 'psy0/english/grammar-001.json'));
        final errors = validator.validate([root]).errors;
        expect(
          errors.map((e) => e.message),
          contains('a bank file must live at <module>/<family>/items/*.json'),
        );
      });
    });

    test('family lessons may be grouped under <module>/lessons/<family>/', () {
      withBundleCopy((root) {
        final from = p.join(root, 'psy0/english/lessons');
        final to = p.join(root, 'psy0/lessons/english');
        Directory(to).createSync(recursive: true);
        for (final name in [
          '01-tenses.json',
          '01-tenses.fr.md',
          '01-tenses.en.md',
        ]) {
          File(p.join(from, name)).renameSync(p.join(to, name));
        }
        editJson(p.join(to, '01-tenses.json'), (j) {
          j['file'] = {
            'fr': 'lessons/english/01-tenses.fr.md',
            'en': 'lessons/english/01-tenses.en.md',
          };
        });
        final report = validator.validate([root]);
        expect(report.errors, isEmpty, reason: report.errors.join('\n'));

        // ...but its familyId must still name an existing family.
        editJson(p.join(to, '01-tenses.json'), (j) => j['familyId'] = 'verbal');
        final errors = validator.validate([root]).errors;
        expect(
          errors.map((e) => e.message),
          contains(
            contains('familyId "verbal" does not reference an existing family'),
          ),
        );
      });
    });

    test('a Dart-only rule is reported as a parser error', () {
      // The schema allows any Id in deckId; only the models check it matches.
      final errors = errorsAfter(
        'psy0/english/decks/aviation-vocab.json',
        (j) => (j['cards']! as List<Object?>).first.asMap['deckId'] =
            'english.deck.other',
      );
      expect(errors.map((e) => e.source), contains(IssueSource.parse));
    });

    test('warnings do not fail the run', () {
      withBundleCopy((root) {
        editJson(p.join(root, bank), (j) => item(j, 2).remove('passageId'));
        final report = validator.validate([root]);
        expect(report.ok, isTrue);
        expect(
          report.warnings.single.message,
          contains('passage is not referenced'),
        );
        expect(report.warnings.single.entityId, 'english.reading.p001');
        expect(formatReport(report), contains('WARNINGS (1)'));
        expect(formatReport(report, quiet: true), isNot(contains('WARNINGS')));
      });
    });
  });
}

// -----------------------------------------------------------------------------
// Helpers.

/// Copies the valid bundle into a temporary folder, runs [body] on it and
/// deletes the copy.
void withBundleCopy(void Function(String root) body) {
  final temp = Directory.systemTemp.createTempSync('validate_content_');
  try {
    copyTree(Directory('test/tool/fixtures/valid_bundle'), temp);
    body(temp.path);
  } finally {
    temp.deleteSync(recursive: true);
  }
}

void copyTree(Directory from, Directory to) {
  for (final entity in from.listSync(recursive: true)) {
    final target = p.join(to.path, p.relative(entity.path, from: from.path));
    if (entity is Directory) {
      Directory(target).createSync(recursive: true);
    } else if (entity is File) {
      Directory(p.dirname(target)).createSync(recursive: true);
      entity.copySync(target);
    }
  }
}

void editJson(String path, void Function(Map<String, Object?>) mutate) {
  final file = File(path);
  final json = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
  mutate(json);
  file.writeAsStringSync(jsonEncode(json));
}

Map<String, Object?> item(Map<String, Object?> bank, int index) =>
    (bank['items']! as List<Object?>)[index].asMap;

extension on Object? {
  Map<String, Object?> get asMap => this! as Map<String, Object?>;
}
