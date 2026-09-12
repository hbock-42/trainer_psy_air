import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/content/content.dart';
import 'package:psy_trainer/core/db/seed/asset_reader.dart';
import 'package:psy_trainer/core/db/seed/content_bundle_loader.dart';

/// [AssetReader] over a map of asset key -> text.
class MapAssetReader implements AssetReader {
  MapAssetReader(this.files);

  final Map<String, String> files;

  @override
  Future<List<String>> listAssets({required String prefix}) async =>
      files.keys.where((k) => k.startsWith(prefix)).toList();

  @override
  Future<String> readString(String path) async {
    final text = files[path];
    if (text == null) throw StateError('missing asset $path');
    return text;
  }
}

String json(Map<String, Object?> value) => jsonEncode(value);

Map<String, Object?> manifest({int contentVersion = 1}) => {
  'kind': 'manifest',
  'schemaVersion': 2,
  'contentVersion': contentVersion,
  'updatedAt': '2026-09-12',
  'modules': ['psy0'],
  'changelog': [
    {'contentVersion': contentVersion, 'date': '2026-09-12', 'summary': 's'},
  ],
};

Map<String, Object?> module({String status = 'published'}) => {
  'kind': 'module',
  'id': 'psy0',
  'version': 1,
  'order': 0,
  'name': {'fr': 'PSY0'},
  'description': {'fr': 'desc'},
  'familyIds': ['english'],
  'status': status,
};

Map<String, Object?> family() => {
  'kind': 'family',
  'id': 'english',
  'moduleId': 'psy0',
  'version': 1,
  'order': 1,
  'name': {'fr': 'Anglais'},
  'description': {'fr': 'desc'},
  'engineType': 'english_reading',
  'answerFormat': 'mcq',
  'defaultDurationSec': 600,
  'defaultItemCount': 10,
  'confidence': 'reported',
};

Map<String, Object?> bank(List<String> ids) => {
  'kind': 'bank',
  'familyId': 'english',
  'items': [
    for (final id in ids)
      {
        'id': id,
        'type': 'mcq',
        'version': 1,
        'familyId': 'english',
        'difficulty': 2,
        'tags': ['english.grammar'],
        'stem': {'fr': 'Q $id'},
        'options': [
          {
            'text': {'fr': 'a'},
          },
          {
            'text': {'fr': 'b'},
          },
        ],
        'correctIndex': 0,
        'explanation': {'fr': 'because'},
      },
  ],
};

Map<String, Object?> lesson({
  Map<String, String>? file,
  Map<String, String>? body,
}) => {
  'kind': 'lesson',
  'id': 'lesson.english.01',
  'version': 1,
  'moduleId': 'psy0',
  'familyId': 'english',
  'order': 1,
  'title': {'fr': 'Titre'},
  'tags': ['english'],
  'file': ?file,
  'body': ?body,
};

const root = 'assets/content';

Map<String, String> validBundle() => {
  '$root/manifest.json': json(manifest()),
  '$root/psy0/module.json': json(module()),
  '$root/psy0/english/family.json': json(family()),
  '$root/psy0/english/items/b-002.json': json(bank(['english.g.0003'])),
  '$root/psy0/english/items/a-001.json': json(
    bank(['english.g.0001', 'english.g.0002']),
  ),
  '$root/psy0/lessons/english/01.json': json(
    lesson(
      file: {
        'fr': 'lessons/english/01.fr.md',
        'en': 'lessons/english/01.en.md',
      },
    ),
  ),
  '$root/psy0/lessons/english/01.fr.md': '# Bonjour',
  '$root/psy0/lessons/english/01.en.md': '# Hello',
  '$root/psy0/english/media/figure.svg': '<svg/>',
};

ContentBundleLoader loader(Map<String, String> files) =>
    ContentBundleLoader(assets: MapAssetReader(files));

void main() {
  test('reads only json and markdown files of the declared modules', () async {
    final raw = await loader({
      ...validBundle(),
      '$root/psy1/module.json': json(module()),
    }).read();

    expect(raw.manifest.contentVersion, 1);
    expect(raw.files.keys, isNot(contains('psy0/english/media/figure.svg')));
    expect(raw.files.keys, isNot(contains(startsWith('psy1/'))));
    expect(raw.files.keys, contains('psy0/lessons/english/01.fr.md'));
  });

  test('parses every kind, keeps bank files in path order and inlines '
      'lesson bodies', () async {
    final bundle = await loader(validBundle()).load();

    expect(bundle.modules.map((m) => m.id), [ModuleId.psy0]);
    expect(bundle.families.map((f) => f.id), ['english']);
    expect(bundle.items.map((i) => i.id), [
      'english.g.0001',
      'english.g.0002',
      'english.g.0003',
    ]);
    final lesson = bundle.lessons.single;
    expect(lesson.file, isNull);
    expect(lesson.body, const LocalizedText(fr: '# Bonjour', en: '# Hello'));
    expect(bundle.blueprints, isEmpty);
    expect(bundle.lexicalFields, isEmpty);
  });

  test('load runs the parse step through the given function', () async {
    var calls = 0;
    await loader(validBundle()).load(
      run: (raw) async {
        calls++;
        return ContentBundleLoader.parse(raw);
      },
    );
    expect(calls, 1);
  });

  test('an inline lesson body is kept as is', () async {
    final files = validBundle()
      ..['$root/psy0/lessons/english/01.json'] = json(
        lesson(body: {'fr': 'court'}),
      );
    final bundle = await loader(files).load();
    expect(bundle.lessons.single.body?.fr, 'court');
  });

  test('a module declared without assets is a manifest error', () async {
    final files = validBundle()
      ..['$root/manifest.json'] = json({
        ...manifest(),
        'modules': ['psy0', 'psy1'],
      });

    await expectLater(
      loader(files).read(),
      throwsA(
        isA<ContentParseException>()
            .having((e) => e.file, 'file', '$root/manifest.json')
            .having((e) => e.entityId, 'entityId', 'psy1')
            .having((e) => e.message, 'message', contains('pubspec.yaml')),
      ),
    );
  });

  test('a module folder without module.json is an error', () async {
    final files = validBundle()..remove('$root/psy0/module.json');

    await expectLater(
      loader(files).load(),
      throwsA(
        isA<ContentParseException>().having(
          (e) => e.message,
          'message',
          contains('no (published) module.json'),
        ),
      ),
    );
  });

  test('an unknown kind is an error naming the file', () async {
    final files = validBundle()
      ..['$root/psy0/english/items/weird.json'] = json({'kind': 'quiz'});

    await expectLater(
      loader(files).load(),
      throwsA(
        isA<ContentParseException>()
            .having((e) => e.file, 'file', endsWith('weird.json'))
            .having((e) => e.message, 'message', contains('"quiz"')),
      ),
    );
  });

  test('a non-object top level is an error', () async {
    final files = validBundle()..['$root/psy0/english/items/list.json'] = '[]';

    await expectLater(
      loader(files).load(),
      throwsA(
        isA<ContentParseException>().having(
          (e) => e.message,
          'message',
          contains('JSON object'),
        ),
      ),
    );
  });

  test('parse folds the cause into the message so the error crosses '
      'isolates', () {
    final files = validBundle()
      ..['$root/psy0/english/family.json'] = json({
        ...family(),
        'defaultDurationSec': 'ten',
      });
    final raw = RawContentBundle(
      manifest: ContentManifest.fromJson(manifest()),
      files: {
        for (final entry in files.entries)
          if (entry.key.endsWith('.json') || entry.key.endsWith('.md'))
            entry.key.substring(root.length + 1): entry.value,
      },
    );

    expect(
      () => ContentBundleLoader.parse(raw),
      throwsA(
        isA<ContentParseException>()
            .having((e) => e.cause, 'cause', isNull)
            .having((e) => e.file, 'file', endsWith('english/family.json')),
      ),
    );
  });

  test('a manifest inside a module is ignored', () async {
    final files = validBundle()
      ..['$root/psy0/manifest.json'] = json(manifest(contentVersion: 9));
    final bundle = await loader(files).load();
    expect(bundle.manifest.contentVersion, 1);
  });

  test('draft modules, families and lessons are skipped', () async {
    final files = validBundle()
      ..['$root/psy0/module.json'] = json(module(status: 'draft'));

    await expectLater(
      loader(files).load(),
      throwsA(isA<ContentParseException>()),
      reason: 'a draft module leaves the declared module without module.json',
    );

    final files2 = validBundle()
      ..['$root/psy0/english/family.json'] = json({
        ...family(),
        'status': 'draft',
      })
      ..['$root/psy0/lessons/english/01.json'] = json({
        ...lesson(body: {'fr': 'x'}),
        'status': 'draft',
      });
    final bundle = await loader(files2).load();
    expect(bundle.families, isEmpty);
    expect(bundle.lessons, isEmpty);
  });
}
