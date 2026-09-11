import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/content/content.dart';

import 'json_matchers.dart';

/// Every example file in `assets/content/examples/` must decode into the Dart
/// models and re-serialise to the same JSON (key order aside). This is the
/// executable proof that the Dart types match the JSON schemas.
void main() {
  const parser = ContentBundleParser();
  final examplesDir = Directory('assets/content/examples');
  final examples =
      examplesDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  test('the examples folder is where we expect it', () {
    expect(examples, isNotEmpty, reason: 'run tests from the package root');
  });

  for (final file in examples) {
    final name = file.uri.pathSegments.last;
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
        _ => throw StateError('$name: unknown kind $kind'),
      };

      // Serialising through jsonEncode/jsonDecode normalises Dart-only
      // details (e.g. 1.0 vs 1) the same way a real file write would.
      final normalised = jsonDecode(jsonEncode(output)) as Map<String, Object?>;
      expectJsonRoundTrip(sourceJson, normalised);
      expect(reparsed, equals(model), reason: 'toJson -> fromJson identity');
    });
  }

  group('example content is decoded into the expected union cases', () {
    test('mcq.example.json items are McqItems and share the passage', () {
      final bank = parser.parseBank(
        File('assets/content/examples/mcq.example.json').readAsStringSync(),
        file: 'mcq.example.json',
      );
      expect(bank.items, everyElement(isA<McqItem>()));
      expect(bank.passages.single.id, 'english.reading.p001');
      final reading = bank.items.whereType<McqItem>().where(
        (i) => i.passageId != null,
      );
      expect(
        reading.map((i) => i.passageId),
        everyElement('english.reading.p001'),
      );
      // Default applied when the file omits shuffleOptions.
      expect(bank.items.whereType<McqItem>().first.shuffleOptions, isTrue);
    });

    test('numeric.example.json decodes tolerance and input format', () {
      final bank = parser.parseBank(
        File('assets/content/examples/numeric.example.json').readAsStringSync(),
        file: 'numeric.example.json',
      );
      final items = bank.items.whereType<NumericItem>().toList();
      expect(items, hasLength(4));
      expect(
        items[2].tolerance,
        const Tolerance(mode: ToleranceMode.relative, value: 0.02),
      );
      expect(items[3].inputFormat, InputFormat.time);
      expect(items[0].decimals, 2);
    });

    test('sequence.example.json decodes the grid pattern', () {
      final bank = parser.parseBank(
        File(
          'assets/content/examples/sequence.example.json',
        ).readAsStringSync(),
        file: 'sequence.example.json',
      );
      final pattern = bank.items.last as SequenceItem;
      expect(pattern.stimulusKind, StimulusKind.gridCells);
      expect(pattern.grid, const GridSize(rows: 4, cols: 4));
      expect(pattern.recallMode, RecallMode.anyOrder);
    });

    test('generated.example.json keeps generator params verbatim', () {
      final bank = parser.parseBank(
        File(
          'assets/content/examples/generated.example.json',
        ).readAsStringSync(),
        file: 'generated.example.json',
      );
      final first = bank.items.first as GeneratedItem;
      expect(first.generatorId, 'logic_series');
      expect(first.seed, 1842);
      expect(first.params, {
        'kind': 'arithmetic',
        'length': 5,
        'answerFormat': 'mcq',
      });
    });

    test('psy0_short.example.json mixes bank and generated selections', () {
      final blueprint = parser.parseBlueprint(
        File(
          'assets/content/examples/psy0_short.example.json',
        ).readAsStringSync(),
        file: 'psy0_short.example.json',
      );
      final selections = blueprint.sections
          .map((s) => s.itemSelection)
          .toList();
      expect(selections[0], isA<GeneratedSelection>());
      expect(selections[2], isA<BankSelection>());
      expect((selections[2] as BankSelection).balanceByTagPrefix, 'english');
      expect(blueprint.sections.last.weight, 0.5);
      expect(blueprint.sections.first.breakAfterSec, 30);
    });

    test(
      'family.example.json resolves enums from their snake_case strings',
      () {
        final family = parser.parseFamily(
          File(
            'assets/content/examples/family.example.json',
          ).readAsStringSync(),
          file: 'family.example.json',
        );
        expect(family.engineType, EngineType.mentalArithmetic);
        expect(family.answerFormat, AnswerFormat.numeric);
        expect(family.confidence, Confidence.assumed);
        expect(family.status, ContentStatus.published);
      },
    );

    test('manifest.example.json decodes dates as UTC midnight', () {
      final manifest = parser.parseManifest(
        File(
          'assets/content/examples/manifest.example.json',
        ).readAsStringSync(),
        file: 'manifest.example.json',
      );
      expect(manifest.updatedAt, DateTime.utc(2026, 9, 11));
      expect(manifest.modules, [ModuleId.psy0]);
      expect(manifest.changelog.first.contentVersion, 3);
    });
  });
}
