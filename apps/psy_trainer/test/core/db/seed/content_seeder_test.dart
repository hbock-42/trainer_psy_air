import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/db/app_database.dart';
import 'package:psy_trainer/core/db/repositories/local_content_repository.dart';
import 'package:psy_trainer/core/db/repositories/local_progress_repository.dart';
import 'package:psy_trainer/core/db/seed/content_bundle_loader.dart';
import 'package:psy_trainer/core/db/seed/content_seeder.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';

import '../../../helpers/file_asset_reader.dart';
import '../example_content.dart';

/// Number of items declared in the bank files of [family], read straight
/// from the JSON so the expectation tracks the real bundle.
int bankItemCount(String family) {
  final dir = Directory('assets/content/psy0/$family/items');
  if (!dir.existsSync()) return 0;
  var count = 0;
  for (final file in dir.listSync().whereType<File>()) {
    final json = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
    count += (json['items']! as List<Object?>).length;
  }
  return count;
}

/// Items of every PSY0 bank file, as seeded.
int totalBankItemCount() => Directory('assets/content/psy0')
    .listSync()
    .whereType<Directory>()
    .map(
      (d) => bankItemCount(d.uri.pathSegments.lastWhere((s) => s.isNotEmpty)),
    )
    .fold(0, (sum, n) => sum + n);

/// A private copy of `assets/content/` under a temp directory, so a test can
/// mutate files (bump the version, corrupt a bank) without touching the repo.
class BundleCopy {
  BundleCopy._(this.root);

  final Directory root;

  static BundleCopy create() {
    final root = Directory.systemTemp.createTempSync('psy_bundle_');
    final source = Directory('assets/content');
    for (final entity in source.listSync(recursive: true)) {
      final relative = entity.path.substring(source.path.length + 1);
      if (relative.startsWith('examples')) continue;
      final target = '${root.path}/assets/content/$relative';
      if (entity is Directory) {
        Directory(target).createSync(recursive: true);
      } else if (entity is File) {
        File(target).createSync(recursive: true);
        entity.copySync(target);
      }
    }
    return BundleCopy._(root);
  }

  File file(String relative) => File('${root.path}/assets/content/$relative');

  void setContentVersion(int version) {
    final manifest = file('manifest.json');
    final json =
        jsonDecode(manifest.readAsStringSync()) as Map<String, Object?>;
    json['contentVersion'] = version;
    json['changelog'] = [
      {'contentVersion': version, 'date': '2026-09-12', 'summary': 'test bump'},
      ...json['changelog']! as List<Object?>,
    ];
    manifest.writeAsStringSync(jsonEncode(json));
  }

  FileAssetReader reader() => FileAssetReader(root: root.path);

  void dispose() => root.deleteSync(recursive: true);
}

void main() {
  late AppDatabase db;
  final now = DateTime.utc(2026, 9, 12, 10);

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  ContentSeeder seeder({
    FileAssetReader? assets,
    bool inline = false,
    DateTime? clock,
  }) => ContentSeeder(
    database: db,
    assets: assets ?? FileAssetReader(),
    clock: () => clock ?? now,
    // The isolate path (compute) is exercised by the real-bundle test; the
    // others parse inline to keep them fast and their errors synchronous.
    parse: inline ? (raw) async => ContentBundleLoader.parse(raw) : null,
  );

  group('ContentSeeder with the real bundle', () {
    test('seeds every family, item, lesson and blueprint in one go', () async {
      final result = await seeder().seedIfNeeded();
      // Printed on purpose: the acceptance criterion is a seeding time under
      // two seconds for the whole bundle (US-013).
      // ignore: avoid_print
      print('Seeded the real bundle: $result');

      expect(result.seeded, isTrue);
      expect(result.previousVersion, isNull);
      expect(result.contentVersion, 3);
      expect(
        result.elapsed,
        lessThan(const Duration(seconds: 2)),
        reason: 'seeding must stay under 2 s (US-013 acceptance criterion)',
      );

      final content = LocalContentRepository(db);
      final info = await content.contentInfo();
      expect(info?.contentVersion, 3);
      expect(info?.schemaVersion, 2);
      expect(info?.seededAt, now);

      final modules = await content.modules();
      expect(modules.map((m) => m.id), [ModuleId.psy0]);

      final families = await content.families(moduleId: ModuleId.psy0);
      expect(families, hasLength(16));
      expect(
        families.map((f) => f.id),
        containsAll(['memory_nback', 'english', 'culture_aero']),
      );
      // Ordered by `order`, not by folder name.
      expect(families.first.id, modules.first.familyIds.first);

      final english = await content.items(familyId: 'english', shuffle: false);
      expect(english, hasLength(bankItemCount('english')));
      expect(english.map((i) => i.familyId).toSet(), {'english'});
      final culture = await content.items(familyId: 'culture_aero');
      expect(culture, hasLength(bankItemCount('culture_aero')));
      expect(result.itemCount, totalBankItemCount());
      expect(await content.items(familyId: 'english_speaking'), isEmpty);

      final lessons = await content.lessons(moduleId: ModuleId.psy0);
      expect(lessons, hasLength(result.lessonCount));
      expect(lessons.length, greaterThanOrEqualTo(16));
      final nback = await content.lessons(familyId: 'memory_nback');
      expect(nback, hasLength(1));
      // Markdown bodies are inlined at seeding time (see ARCHITECTURE.md).
      expect(nback.single.file, isNull);
      expect(nback.single.body?.fr, startsWith('#'));
      expect(nback.single.body?.fr, contains('N-back'));

      final blueprints = await content.blueprints(moduleId: ModuleId.psy0);
      expect(blueprints.map((b) => b.id), [
        'psy0.blueprint.full',
        'psy0.blueprint.short',
      ]);
      expect(blueprints.first.sections, isNotEmpty);
    });

    test('is a no-op when the stored version equals the bundle', () async {
      await seeder(inline: true).seedIfNeeded();
      final later = now.add(const Duration(days: 1));

      final again = await seeder(inline: true, clock: later).seedIfNeeded();

      expect(again.seeded, isFalse);
      expect(again.previousVersion, 3);
      expect(again.contentVersion, 3);
      final info = await LocalContentRepository(db).contentInfo();
      expect(info?.seededAt, now, reason: 'nothing was rewritten');
    });

    test('force re-seeds even when the versions are equal', () async {
      await seeder(inline: true).seedIfNeeded();
      final later = now.add(const Duration(days: 1));

      final again = await seeder(
        inline: true,
        clock: later,
      ).seedIfNeeded(force: true);

      expect(again.seeded, isTrue);
      final info = await LocalContentRepository(db).contentInfo();
      expect(info?.seededAt, later);
    });
  });

  group('ContentSeeder with a modified bundle copy', () {
    late BundleCopy copy;

    setUp(() => copy = BundleCopy.create());
    tearDown(() => copy.dispose());

    test('a version bump re-seeds and keeps sessions and attempts', () async {
      await seeder(inline: true).seedIfNeeded();
      final progress = LocalProgressRepository(db, clock: () => now);
      final session = await progress.startSession(
        mode: SessionMode.practice,
        familyId: 'english',
      );
      final english = await LocalContentRepository(
        db,
      ).items(familyId: 'english', count: 1, shuffle: false);
      await progress.recordAttempt(
        NewAttempt(
          sessionId: session.id,
          familyId: 'english',
          itemId: english.single.id,
          isCorrect: true,
          responseMs: 1200,
          position: 0,
        ),
      );
      await progress.markLessonRead('lesson.memory_nback.01');

      copy.setContentVersion(4);
      final later = now.add(const Duration(days: 30));
      final result = await seeder(
        assets: copy.reader(),
        inline: true,
        clock: later,
      ).seedIfNeeded();

      expect(result.seeded, isTrue);
      expect(result.previousVersion, 3);
      expect(result.contentVersion, 4);
      final content = LocalContentRepository(db);
      final info = await content.contentInfo();
      expect(info?.contentVersion, 4);
      expect(info?.seededAt, later);
      expect(await content.families(), hasLength(16));
      expect(await content.itemById(english.single.id), isNotNull);

      // User data survived the re-seed.
      expect(await progress.sessionById(session.id), isNotNull);
      expect(await progress.attemptsForSession(session.id), hasLength(1));
      expect((await progress.itemStat(english.single.id))?.seen, 1);
      expect(await progress.lessonsRead(), hasLength(1));
    });

    test('an older bundle than the stored content is left alone', () async {
      copy.setContentVersion(5);
      await seeder(assets: copy.reader(), inline: true).seedIfNeeded();

      final result = await seeder(inline: true).seedIfNeeded();

      expect(result.seeded, isFalse);
      expect(result.contentVersion, 5);
      final info = await LocalContentRepository(db).contentInfo();
      expect(info?.contentVersion, 5);
    });

    test(
      'a corrupt bank file fails with a clear error and seeds nothing',
      () async {
        copy
            .file('psy0/english/items/grammar-001.json')
            .writeAsStringSync('{"kind": "bank", "familyId": "english", ');

        await expectLater(
          seeder(assets: copy.reader(), inline: true).seedIfNeeded(),
          throwsA(
            isA<ContentParseException>()
                .having(
                  (e) => e.file,
                  'file',
                  'assets/content/psy0/english/items/grammar-001.json',
                )
                .having((e) => e.message, 'message', contains('invalid JSON')),
          ),
        );
        expect(await LocalContentRepository(db).contentInfo(), isNull);
        expect(await LocalContentRepository(db).families(), isEmpty);
      },
    );

    test('an invalid item is reported with its id', () async {
      final bank = copy.file('psy0/english/items/vocab-001.json');
      final json = jsonDecode(bank.readAsStringSync()) as Map<String, Object?>;
      final items = json['items']! as List<Object?>;
      (items.first! as Map<String, Object?>)['difficulty'] = 9;
      bank.writeAsStringSync(jsonEncode(json));

      await expectLater(
        seeder(assets: copy.reader(), inline: true).seedIfNeeded(),
        throwsA(
          isA<ContentParseException>()
              .having((e) => e.file, 'file', endsWith('vocab-001.json'))
              .having((e) => e.entityId, 'entityId', startsWith('english.')),
        ),
      );
    });

    test('a missing lesson markdown file is reported on the lesson', () async {
      copy.file('psy0/lessons/english/01-anglais.fr.md').deleteSync();

      await expectLater(
        seeder(assets: copy.reader(), inline: true).seedIfNeeded(),
        throwsA(
          isA<ContentParseException>()
              .having((e) => e.file, 'file', endsWith('01-anglais.json'))
              .having((e) => e.message, 'message', contains('not found')),
        ),
      );
    });

    test('the isolate path reports parse errors too', () async {
      copy.file('psy0/module.json').writeAsStringSync('not json');

      await expectLater(
        seeder(assets: copy.reader()).seedIfNeeded(),
        throwsA(
          isA<ContentParseException>().having(
            (e) => e.file,
            'file',
            'assets/content/psy0/module.json',
          ),
        ),
      );
    });

    test('draft entities are not seeded', () async {
      final bank = copy.file('psy0/english/items/vocab-001.json');
      final json = jsonDecode(bank.readAsStringSync()) as Map<String, Object?>;
      final items = json['items']! as List<Object?>;
      final draft = items.first! as Map<String, Object?>;
      draft['status'] = 'draft';
      bank.writeAsStringSync(jsonEncode(json));

      await seeder(assets: copy.reader(), inline: true).seedIfNeeded();

      final content = LocalContentRepository(db);
      expect(await content.itemById(draft['id']! as String), isNull);
      expect(
        await content.items(familyId: 'english'),
        hasLength(bankItemCount('english') - 1),
      );
    });
  });
}
