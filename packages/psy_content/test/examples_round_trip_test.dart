import 'dart:convert';
import 'dart:io';

import 'package:psy_content/psy_content.dart';
import 'package:test/test.dart';

import 'json_matchers.dart';

/// Every example file in `assets/content/examples/` and every real content
/// file shipped under `assets/content/psy0/` must decode into the Dart models
/// and re-serialise to the same JSON (key order aside). This is the
/// executable proof that the Dart types match the JSON schemas.
void main() {
  const parser = ContentBundleParser();

  List<File> jsonFiles(String dir) =>
      Directory(dir)
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  /// `<module>/<family>/family.json` for every family folder of the module.
  List<File> familyFiles(String module) =>
      Directory(module)
          .listSync()
          .whereType<Directory>()
          .map((d) => File('${d.path}/family.json'))
          .where((f) => f.existsSync())
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final examples = jsonFiles('../../apps/psy_trainer/assets/content/examples');
  final realFiles = [
    File('../../apps/psy_trainer/assets/content/manifest.json'),
    File('../../apps/psy_trainer/assets/content/psy0/module.json'),
    ...familyFiles('../../apps/psy_trainer/assets/content/psy0'),
    ...jsonFiles('../../apps/psy_trainer/assets/content/psy0/blueprints'),
    File('../../apps/psy_trainer/assets/content/psy1/module.json'),
    ...familyFiles('../../apps/psy_trainer/assets/content/psy1'),
    ...jsonFiles('../../apps/psy_trainer/assets/content/psy1/blueprints'),
  ];

  test('the content folders are where we expect them', () {
    expect(examples, isNotEmpty, reason: 'run tests from the package root');
    expect(realFiles, isNotEmpty);
  });

  for (final file in [...examples, ...realFiles]) {
    final name = file.path.split('../../apps/psy_trainer/assets/content/').last;
    test('$name round-trips through the Dart models', () {
      final source = file.readAsStringSync();
      final sourceJson = jsonDecode(source) as Map<String, Object?>;
      final kind = sourceJson['kind'];

      final (
        Object model,
        Map<String, Object?> output,
        Object reparsed,
      ) = switch (kind) {
        'manifest' => () {
          final m = parser.parseManifest(source, file: name);
          final json = m.toJson();
          return (m, json, ContentManifest.fromJson(json));
        }(),
        'module' => () {
          final m = parser.parseModule(source, file: name);
          final json = m.toJson();
          return (m, json, Module.fromJson(json));
        }(),
        'family' => () {
          final m = parser.parseFamily(source, file: name);
          final json = m.toJson();
          return (m, json, TestFamily.fromJson(json));
        }(),
        'bank' => () {
          final m = parser.parseBank(source, file: name);
          final json = m.toJson();
          return (m, json, ItemBank.fromJson(json));
        }(),
        'lesson' => () {
          final m = parser.parseLesson(source, file: name);
          final json = m.toJson();
          return (m, json, Lesson.fromJson(json));
        }(),
        'deck' => () {
          final m = parser.parseDeck(source, file: name);
          final json = m.toJson();
          return (m, json, Deck.fromJson(json));
        }(),
        'blueprint' => () {
          final m = parser.parseBlueprint(source, file: name);
          final json = m.toJson();
          return (m, json, ExamBlueprint.fromJson(json));
        }(),
        'lexical_fields' => () {
          final m = parser.parseLexicalFields(source, file: name);
          final json = m.toJson();
          return (m, json, LexicalFieldBank.fromJson(json));
        }(),
        _ => throw StateError('$name: unknown kind $kind'),
      };

      // Serialising through jsonEncode/jsonDecode normalises Dart-only
      // details (e.g. 1.0 vs 1) the same way a real file write would.
      final normalised = jsonDecode(jsonEncode(output)) as Map<String, Object?>;
      expectJsonRoundTrip(sourceJson, normalised);
      expect(reparsed, equals(model), reason: 'toJson -> fromJson identity');
    });
  }

  ItemBank bank(String file) => parser.parseBank(
    File(
      '../../apps/psy_trainer/assets/content/examples/$file',
    ).readAsStringSync(),
    file: file,
  );

  group('example content is decoded into the expected union cases', () {
    test('mcq.example.json items are McqItems and share the passage', () {
      final b = bank('mcq.example.json');
      expect(b.items, everyElement(isA<McqItem>()));
      expect(b.passages.single.id, 'english.reading.p001');
      final reading = b.items.whereType<McqItem>().where(
        (i) => i.passageId != null,
      );
      expect(
        reading.map((i) => i.passageId),
        everyElement('english.reading.p001'),
      );
      // Defaults applied when the file omits shuffleOptions / allowSkip.
      final first = b.items.whereType<McqItem>().first;
      expect(first.shuffleOptions, isTrue);
      expect(first.allowSkip, isFalse);
      expect(first.validAsOf, isNull);
    });

    test('culture.example.json decodes validAsOf, allowSkip and sources', () {
      final items = bank('culture.example.json').items.cast<McqItem>();
      expect(items, everyElement(isA<McqItem>()));
      expect(items[0].allowSkip, isTrue);
      expect(items[0].validAsOf, isNull);
      expect(items[1].validAsOf, DateTime.utc(2026, 9, 11));
      final source = items[1].meta!.sources!.single;
      expect(source.url, startsWith('https://corporate.airfrance.com/'));
      expect(source.accessedOn, DateTime.utc(2026, 9, 11));
      expect(items[0].meta!.sources!.single.url, isNull);
    });

    test(
      'numeric.example.json decodes tolerance, input format and a recipe',
      () {
        final items = bank('numeric.example.json').items;
        final numeric = items.whereType<NumericItem>().toList();
        expect(numeric, hasLength(4));
        expect(
          numeric[2].tolerance,
          const Tolerance(mode: ToleranceMode.absolute, value: 0.5),
        );
        expect(numeric[3].inputFormat, InputFormat.time);
        expect(numeric[0].decimals, 2);
        final recipe = items.last as GeneratedItem;
        expect(recipe.generatorId, GeneratorId.arithmeticGrid);
        expect(
          recipe.params,
          const GeneratorParams.arithmeticGrid(
            wrongMin: 1,
            wrongMax: 3,
            operations: [
              ArithmeticOperation.add,
              ArithmeticOperation.sub,
              ArithmeticOperation.mul,
              ArithmeticOperation.priority,
            ],
            maxOperand: 50,
          ),
        );
      },
    );

    test('sequence.example.json decodes the grid pattern', () {
      final pattern = bank('sequence.example.json').items.last as SequenceItem;
      expect(pattern.stimulusKind, StimulusKind.gridCells);
      expect(pattern.grid, const GridSize(rows: 4, cols: 4));
      expect(pattern.recallMode, RecallMode.anyOrder);
    });

    test('generated.example.json types params and fills defaults', () {
      final items = bank('generated.example.json').items.cast<GeneratedItem>();
      expect(items.map((i) => i.generatorId), everyElement(GeneratorId.nback));
      expect(items[0].seed, 1842);
      // Fully spelled-out params equal the real-test defaults.
      expect(items[0].params, const GeneratorParams.nback());
      // Partial params: the rest is defaulted.
      final digits = items[1].params as NbackParams;
      expect(digits.n, 3);
      expect(digits.stimulusKind, NbackStimulusKind.digit);
      expect(digits.paletteSize, 10);
      expect(digits.count, 42);
      // No params at all.
      expect(items[2].params, GeneratorParams.defaultsFor(GeneratorId.nback));
      // Serialised params carry no discriminator.
      final json = items[2].toJson()['params']! as Map<String, Object?>;
      expect(json.containsKey('generatorId'), isFalse);
      expect(json['n'], 2);
    });

    test('blueprint.example.json exercises every v2 section field', () {
      final blueprint = parser.parseBlueprint(
        File(
          '../../apps/psy_trainer/assets/content/examples/blueprint.example.json',
        ).readAsStringSync(),
        file: 'blueprint.example.json',
      );
      final s = blueprint.sections;
      expect(
        s[0].cadence,
        const Cadence(stimulusMs: 1000, answerWindowMs: 1500),
      );
      expect(s[0].sectionTimeSec, isNull);
      expect(s[0].briefing!.fr, contains('2,5 s'));
      expect(s[0].itemSelection, isA<GeneratedSelection>());
      final nback = (s[0].itemSelection as GeneratedSelection).params;
      expect(nback, isA<NbackParams>());
      expect((nback as NbackParams).paletteSize, 3);
      expect(s[1].liveFeedback, isTrue);
      expect(s[1].inputRequirement, InputRequirement.keyboard);
      expect(s[2].perItemTimeSec, 60);
      expect(s[2].breakAfterSec, 30);
      expect(s[2].scoringPolicy, const ScoringPolicy());
      expect(s[3].scoringPolicy, const ScoringPolicy(correct: 3, wrong: -1));
      expect(s[3].weight, 2);
      expect(
        (s[3].itemSelection as BankSelection).balanceByTagPrefix,
        'culture',
      );
      expect(s[4].weight, 0);
    });

    test('lexical_fields.example.json decodes fields and traps', () {
      final lexical = parser.parseLexicalFields(
        File(
          '../../apps/psy_trainer/assets/content/examples/lexical_fields.example.json',
        ).readAsStringSync(),
        file: 'lexical_fields.example.json',
      );
      expect(lexical.familyId, 'verbal_boxes');
      expect(lexical.fields, hasLength(3));
      final cuisine = lexical.fields.first;
      expect(cuisine.words, hasLength(15));
      expect(cuisine.traps.single.trapFor, 'verbal_boxes.field.aeronef');
      expect(cuisine.incompatibleWith, ['verbal_boxes.field.restaurant']);
      expect(cuisine.lang, ContentLang.fr);
      expect(lexical.fields.last.traps, isEmpty);
    });

    test('family.example.json resolves enums from their snake_case strings', () {
      final family = parser.parseFamily(
        File(
          '../../apps/psy_trainer/assets/content/examples/family.example.json',
        ).readAsStringSync(),
        file: 'family.example.json',
      );
      expect(family.engineType, EngineType.memoryNback);
      expect(family.generatorId, GeneratorId.nback);
      expect(family.answerFormat, AnswerFormat.keyPress);
      expect(family.confidence, Confidence.reported);
      expect(family.status, ContentStatus.published);
      expect(
        family.defaultCadence,
        const Cadence(stimulusMs: 1000, answerWindowMs: 1500),
      );
    });

    test('manifest.example.json decodes dates as UTC midnight', () {
      final manifest = parser.parseManifest(
        File(
          '../../apps/psy_trainer/assets/content/examples/manifest.example.json',
        ).readAsStringSync(),
        file: 'manifest.example.json',
      );
      expect(manifest.schemaVersion, 2);
      expect(manifest.updatedAt, DateTime.utc(2026, 9, 11));
      expect(manifest.modules, [ModuleId.psy0]);
      expect(manifest.changelog.first.contentVersion, 4);
    });
  });

  group('real PSY0 content', () {
    final families = familyFiles('../../apps/psy_trainer/assets/content/psy0')
        .map((f) => parser.parseFamily(f.readAsStringSync(), file: f.path))
        .toList();
    final module = parser.parseModule(
      File(
        '../../apps/psy_trainer/assets/content/psy0/module.json',
      ).readAsStringSync(),
      file: 'psy0/module.json',
    );

    test('one family file per family of the psy0 module, ids aligned', () {
      expect(families.map((f) => f.id).toSet(), module.familyIds.toSet());
      for (final family in families) {
        // engineType == family id, except the English bank which keeps the
        // `english` folder of US-082 and runs on the reading engine.
        final expectedEngine = family.id == 'english'
            ? 'english_reading'
            : family.id;
        expect(
          family.toJson()['engineType'],
          expectedEngine,
          reason: family.id,
        );
        expect(family.moduleId, ModuleId.psy0);
      }
      final orders = families.map((f) => f.order).toList()..sort();
      expect(orders, List.generate(families.length, (i) => i + 1));
    });

    test('generator-driven families name their generator', () {
      final generated = families.where((f) => f.generatorId != null);
      expect(generated.map((f) => f.generatorId!), hasLength(12));
      expect(
        generated.map((f) => f.generatorId!).toSet(),
        // The 12 PSY0 generators (EPIC-03); PSY1 (EPIC-10, US-101) adds 13
        // more `p1_*` ones, checked by the psy1 module tests below.
        GeneratorId.values.where((id) => !id.name.startsWith('p1')).toSet(),
      );
      final bankDriven = families.where((f) => f.generatorId == null);
      expect(
        bankDriven.map((f) => f.id),
        unorderedEquals([
          'culture_aero',
          'english',
          'english_listening',
          'english_speaking',
        ]),
      );
    });

    test('keyboard-native families are flagged', () {
      final keyboard = families
          .where((f) => f.inputRequirement == InputRequirement.keyboard)
          .map((f) => f.id);
      expect(
        keyboard,
        unorderedEquals(['attention_rules', 'multitask_psychomotor']),
      );
    });

    for (final name in ['psy0_full', 'psy0_short']) {
      test('$name.json references known families and generators', () {
        final blueprint = parser.parseBlueprint(
          File(
            '../../apps/psy_trainer/assets/content/psy0/blueprints/$name.json',
          ).readAsStringSync(),
          file: '$name.json',
        );
        final familyIds = families.map((f) => f.id).toSet();
        for (final section in blueprint.sections) {
          expect(familyIds, contains(section.familyId), reason: section.id);
          expect(section.hasTiming, isTrue, reason: section.id);
          final family = families.firstWhere((f) => f.id == section.familyId);
          switch (section.itemSelection) {
            case GeneratedSelection(:final generatorId):
              expect(generatorId, family.generatorId, reason: section.id);
            case BankSelection():
              expect(family.generatorId, isNull, reason: section.id);
          }
        }
      });
    }

    test('psy0_full.json follows the reported order of the real test', () {
      final blueprint = parser.parseBlueprint(
        File(
          '../../apps/psy_trainer/assets/content/psy0/blueprints/psy0_full.json',
        ).readAsStringSync(),
        file: 'psy0_full.json',
      );
      expect(blueprint.sections.map((s) => s.familyId), [
        'memory_nback',
        'planning_tubes',
        'attention_rules',
        'attention_parity',
        'spatial_overlay',
        'logic_dominos',
        'attention_airways',
        'verbal_boxes',
        'arithmetic_grid',
        'spatial_viewpoint',
        'spatial_cubes',
        'culture_aero',
        'multitask_psychomotor',
        'english',
        'english_listening',
        'english_speaking',
      ]);
      final culture = blueprint.sections[11];
      expect(culture.itemCount, 48);
      expect(culture.perItemTimeSec, 18);
      expect(culture.scoringPolicy, const ScoringPolicy());
      expect(blueprint.sections.last.weight, 0);
      final live = blueprint.sections
          .where((s) => s.liveFeedback)
          .map((s) => s.familyId);
      expect(
        live,
        unorderedEquals([
          'attention_rules',
          'attention_parity',
          'attention_airways',
        ]),
      );
    });
  });

  group('real PSY1 content (US-101)', () {
    final families = familyFiles('../../apps/psy_trainer/assets/content/psy1')
        .map((f) => parser.parseFamily(f.readAsStringSync(), file: f.path))
        .toList();
    final module = parser.parseModule(
      File(
        '../../apps/psy_trainer/assets/content/psy1/module.json',
      ).readAsStringSync(),
      file: 'psy1/module.json',
    );

    test('13 family files, ids aligned with the module and each other', () {
      expect(families, hasLength(13));
      expect(families.map((f) => f.id).toSet(), module.familyIds.toSet());
      for (final family in families) {
        expect(family.toJson()['engineType'], family.id, reason: family.id);
        expect(family.toJson()['generatorId'], family.id, reason: family.id);
        expect(family.moduleId, ModuleId.psy1);
      }
      final orders = families.map((f) => f.order).toList()..sort();
      expect(orders, List.generate(families.length, (i) => i + 1));
    });

    test('every family names one of the 13 p1_* generators, one each', () {
      final generated = families.map((f) => f.generatorId!).toSet();
      expect(
        generated,
        GeneratorId.values.where((id) => id.name.startsWith('p1')).toSet(),
      );
    });

    for (final name in ['psy1_full', 'psy1_short']) {
      test('$name.json references known families and generators', () {
        final blueprint = parser.parseBlueprint(
          File(
            '../../apps/psy_trainer/assets/content/psy1/blueprints/$name.json',
          ).readAsStringSync(),
          file: '$name.json',
        );
        final familyIds = families.map((f) => f.id).toSet();
        for (final section in blueprint.sections) {
          expect(familyIds, contains(section.familyId), reason: section.id);
          expect(section.hasTiming, isTrue, reason: section.id);
          final family = families.firstWhere((f) => f.id == section.familyId);
          switch (section.itemSelection) {
            case GeneratedSelection(:final generatorId):
              expect(generatorId, family.generatorId, reason: section.id);
            case BankSelection():
              expect(family.generatorId, isNull, reason: section.id);
          }
        }
      });
    }

    test('psy1_full.json follows the reported order of psy1-spec.md §4.1', () {
      final blueprint = parser.parseBlueprint(
        File(
          '../../apps/psy_trainer/assets/content/psy1/blueprints/psy1_full.json',
        ).readAsStringSync(),
        file: 'psy1_full.json',
      );
      expect(blueprint.sections, hasLength(13));
      expect(blueprint.sections.map((s) => s.familyId), [
        'p1_math_word_problems',
        'p1_tangram',
        'p1_attention_sustained',
        'p1_reading_fr',
        'p1_angles',
        'p1_general_efficiency',
        'p1_counters',
        'p1_cube_nets',
        'p1_wm_reverse_span',
        'p1_wm_calc_back',
        'p1_raven_matrices',
        'p1_mental_arithmetic',
        'p1_psychomotor',
      ]);
      // The psychomotor test is consistently reported as last, and needs
      // the joystick input abstraction of US-102, not yet built.
      expect(blueprint.sections.last.familyId, 'p1_psychomotor');
    });

    test('manifest.json lists both psy0 and psy1', () {
      final manifest = parser.parseManifest(
        File(
          '../../apps/psy_trainer/assets/content/manifest.json',
        ).readAsStringSync(),
        file: 'manifest.json',
      );
      expect(manifest.modules, containsAll([ModuleId.psy0, ModuleId.psy1]));
    });
  });
}
