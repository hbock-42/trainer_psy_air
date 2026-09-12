import 'dart:io';

import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/db/app_database.dart';
import 'package:psy_trainer/core/db/content_rows.dart';
import 'package:psy_trainer/core/db/open_database.dart';

/// The example bundle in `assets/content/examples/` decoded once, as a
/// fixture for content DAO/repository tests. Contents (see the JSON files):
/// module `psy0`, family `memory_nback`, five banks (`english` and
/// `culture_aero` mcq — `english` also carries one reading [Passage] — ,
/// `arithmetic_grid` numeric + one generated recipe, `memory_nback` sequence
/// and generated), one lesson, one deck with three
/// cards (both `arithmetic_grid`) and the `psy0.blueprint.example-custom`
/// blueprint. The `lexical_fields` example has no table yet and is skipped.
class ExampleContent {
  ExampleContent._({
    required this.manifest,
    required this.modules,
    required this.families,
    required this.banks,
    required this.lessons,
    required this.decks,
    required this.blueprints,
  });

  factory ExampleContent.load() {
    const parser = ContentBundleParser();
    final dir = Directory('assets/content/examples');
    ContentManifest? manifest;
    final modules = <Module>[];
    final families = <TestFamily>[];
    final banks = <ItemBank>[];
    final lessons = <Lesson>[];
    final decks = <Deck>[];
    final blueprints = <ExamBlueprint>[];
    final files = dir.listSync().whereType<File>().toList()
      ..sort((a, b) => a.path.compareTo(b.path));
    for (final file in files) {
      if (!file.path.endsWith('.json')) continue;
      final name = file.uri.pathSegments.last;
      final source = file.readAsStringSync();
      final kind = RegExp(r'"kind":\s*"(\w+)"').firstMatch(source)!.group(1);
      switch (kind) {
        case 'manifest':
          manifest = parser.parseManifest(source, file: name);
        case 'module':
          modules.add(parser.parseModule(source, file: name));
        case 'family':
          families.add(parser.parseFamily(source, file: name));
        case 'bank':
          banks.add(parser.parseBank(source, file: name));
        case 'lesson':
          lessons.add(parser.parseLesson(source, file: name));
        case 'deck':
          decks.add(parser.parseDeck(source, file: name));
        case 'blueprint':
          blueprints.add(parser.parseBlueprint(source, file: name));
      }
    }
    return ExampleContent._(
      manifest: manifest!,
      modules: modules,
      families: families,
      banks: banks,
      lessons: lessons,
      decks: decks,
      blueprints: blueprints,
    );
  }

  final ContentManifest manifest;
  final List<Module> modules;
  final List<TestFamily> families;
  final List<ItemBank> banks;
  final List<Lesson> lessons;
  final List<Deck> decks;
  final List<ExamBlueprint> blueprints;

  List<Item> get items => [for (final bank in banks) ...bank.items];

  List<Passage> get passages => [for (final bank in banks) ...bank.passages];

  /// Writes the fixture into [db] the way the seeder (US-013) will.
  Future<void> seed(AppDatabase db, {DateTime? seededAt}) {
    final at = seededAt ?? DateTime.utc(2026, 9);
    return db.contentDao.replaceAll(
      meta: ContentRows.meta(manifest, seededAt: at),
      modules: [for (final m in modules) ContentRows.module(m, seededAt: at)],
      families: [for (final f in families) ContentRows.family(f, seededAt: at)],
      items: [for (final i in items) ContentRows.item(i, seededAt: at)],
      passages: [
        for (final p in passages) ContentRows.passage(p, seededAt: at),
      ],
      lessons: [for (final l in lessons) ContentRows.lesson(l, seededAt: at)],
      decks: [for (final d in decks) ContentRows.deck(d, seededAt: at)],
      flashcards: [
        for (final d in decks) ...ContentRows.flashcards(d, seededAt: at),
      ],
      blueprints: [
        for (final b in blueprints) ContentRows.blueprint(b, seededAt: at),
      ],
    );
  }
}

/// A fresh in-memory database; close it in `tearDown`.
AppDatabase openTestDatabase() => AppDatabase(openInMemoryExecutor());
