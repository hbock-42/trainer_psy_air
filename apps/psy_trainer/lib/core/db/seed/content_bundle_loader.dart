import 'dart:convert';

import 'package:psy_content/psy_content.dart';
import 'asset_reader.dart';

/// Root asset directory of the content bundle (`pubspec.yaml`).
const String contentBundleRoot = 'assets/content';

/// The text of every file of the bundle, keyed by path relative to
/// [contentBundleRoot] (`manifest.json`, `psy0/module.json`,
/// `psy0/lessons/english/01-anglais.fr.md`...).
///
/// Plain strings only, so the whole thing can be handed to another isolate
/// for parsing ([ContentBundleLoader.parse]).
class RawContentBundle {
  const RawContentBundle({
    required this.manifest,
    required this.files,
    Set<String>? modules,
  }) : _modules = modules;

  /// The manifest, already parsed (it is read first to decide whether the
  /// rest of the bundle is needed at all).
  final ContentManifest manifest;

  /// Every `.json` and `.md` file under the declared module folders.
  final Map<String, String> files;

  final Set<String>? _modules;

  /// Module names actually present in [files] (US-125: a lazy/per-module
  /// read only fetches the active module's files, not every module the full
  /// manifest declares — see [ContentBundleLoader.read]'s `onlyModules`).
  /// Defaults to every module of [manifest].
  Set<String> get modules =>
      _modules ?? manifest.modules.map((m) => m.name).toSet();
}

/// The bundle decoded into the US-010 models, drafts removed, lesson bodies
/// resolved. What the seeder turns into rows.
class LoadedContentBundle {
  const LoadedContentBundle({
    required this.manifest,
    required this.modules,
    required this.families,
    required this.items,
    required this.passages,
    required this.lessons,
    required this.decks,
    required this.blueprints,
    required this.lexicalFields,
    required this.interviewQuestions,
  });

  final ContentManifest manifest;
  final List<Module> modules;
  final List<TestFamily> families;

  /// Every published bank item of every family, bank files in path order.
  final List<Item> items;

  /// Every reading passage inlined in a bank file (`ItemBank.passages`),
  /// bank files in path order. An `McqItem.passageId` resolves into this
  /// list (US-027); passage ids are unique across the whole bundle by
  /// authoring convention.
  final List<Passage> passages;

  /// Lessons with their markdown inlined in `body` (`file` is null).
  final List<Lesson> lessons;
  final List<Deck> decks;
  final List<ExamBlueprint> blueprints;

  /// The *Boîte à mots* semantic categories (US-030/US-085), mirrored into
  /// the `lexical_fields` table so `ContentRepository.lexicalFields`/
  /// `lexicalField` can serve them to the `word_boxes` generator.
  final List<LexicalField> lexicalFields;

  /// The PSY2 interview practice bank (US-111), mirrored into the
  /// `interview_questions` table so `ContentRepository.interviewQuestions`/
  /// `interviewQuestion` can serve them to the interview practice screen.
  final List<InterviewQuestion> interviewQuestions;

  int get flashcardCount =>
      decks.fold(0, (sum, deck) => sum + deck.cards.length);
}

/// Reads the content bundle through an [AssetReader] and decodes it with
/// [ContentBundleParser].
///
/// Two steps so the expensive one can run off the UI thread:
///
/// 1. [readManifest] / [read]: asynchronous asset reads on the calling
///    isolate (`rootBundle` needs the platform channel).
/// 2. [parse]: a pure, static function over the raw strings, safe to run
///    through `compute` / `Isolate.run`.
///
/// Files are dispatched on their `kind` field (AUTHORING.md §1), not on their
/// folder: the validator (US-014, run in CI) is the one enforcing the
/// layout. Media (`*.svg`, `*.png`...) is never read: it stays in the asset
/// bundle and widgets load it by its module-relative path.
class ContentBundleLoader {
  const ContentBundleLoader({
    required this.assets,
    this.parser = const ContentBundleParser(),
    this.root = contentBundleRoot,
  });

  final AssetReader assets;
  final ContentBundleParser parser;

  /// Asset directory of the bundle, without trailing slash.
  final String root;

  static const String manifestFile = 'manifest.json';

  Future<ContentManifest> readManifest() async {
    final path = '$root/$manifestFile';
    return parser.parseManifest(await assets.readString(path), file: path);
  }

  /// Path of the pre-bundled JSON of [module] (US-125), one document per
  /// module holding every `.json`/`.md` file of it (`.md` lesson bodies
  /// inlined) — see `tools/bundle_content.dart`. Generated, not part of the
  /// authored tree.
  String bundleFilePath(ModuleId module) => '$root/bundles/${module.name}.json';

  /// Reads the manifest and every `.json` / `.md` file of [onlyModules]
  /// (default: every module the manifest declares). A module listed but
  /// absent from the assets is reported as a [ContentParseException] on the
  /// manifest.
  ///
  /// Each module is read from its pre-bundled document
  /// ([bundleFilePath]) when present (one asset read instead of one per
  /// file); otherwise (that file missing — the common case in tests, which
  /// read the authored tree directly) every `.json`/`.md` file under the
  /// module's folder is listed and read individually, exactly as before
  /// US-125.
  Future<RawContentBundle> read({
    ContentManifest? manifest,
    Set<ModuleId>? onlyModules,
  }) async {
    manifest ??= await readManifest();
    final wanted = onlyModules == null
        ? manifest.modules
        : manifest.modules.where(onlyModules.contains);
    final files = <String, String>{};
    for (final module in wanted) {
      final bundled = await _readBundleFile(module);
      if (bundled != null) {
        files.addAll(bundled);
        continue;
      }
      final prefix = '$root/${module.name}/';
      final keys = await assets.listAssets(prefix: prefix);
      if (keys.isEmpty) {
        throw ContentParseException(
          file: '$root/$manifestFile',
          entityId: module.name,
          message:
              'module "${module.name}" is declared but "$prefix" holds no '
              'asset (is the folder registered in pubspec.yaml?)',
        );
      }
      for (final key in keys) {
        if (!key.endsWith('.json') && !key.endsWith('.md')) continue;
        files[key.substring(root.length + 1)] = await assets.readString(key);
      }
    }
    return RawContentBundle(
      manifest: manifest,
      files: files,
      modules: wanted.map((m) => m.name).toSet(),
    );
  }

  /// The `{"files": {...}}` document at [bundleFilePath] for [module], or
  /// null when it doesn't exist (no bundle was built — [read] falls back to
  /// the authored tree) or is malformed (same fallback: a bad pre-bundle
  /// must never break the app, only miss the perf win).
  Future<Map<String, String>?> _readBundleFile(ModuleId module) async {
    final String raw;
    try {
      raw = await assets.readString(bundleFilePath(module));
    } on Object {
      return null;
    }
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException {
      return null;
    }
    if (decoded is! Map<String, Object?>) return null;
    final map = decoded['files'];
    if (map is! Map) return null;
    return {
      for (final entry in map.entries)
        entry.key as String: entry.value as String,
    };
  }

  /// [read] then [parse], the latter through [run] (defaults to inline; the
  /// seeder passes `compute`).
  Future<LoadedContentBundle> load({
    Set<ModuleId>? onlyModules,
    Future<LoadedContentBundle> Function(RawContentBundle raw)? run,
  }) async {
    final raw = await read(onlyModules: onlyModules);
    return run == null ? parse(raw) : await run(raw);
  }

  /// Decodes [raw] into models. Pure and static so it can run in another
  /// isolate; any failure surfaces as a [ContentParseException] naming the
  /// file (and entity) at fault, with its cause folded into the message so
  /// the exception is always sendable across isolates.
  static LoadedContentBundle parse(RawContentBundle raw) {
    try {
      return _Parser(raw).run();
    } on ContentParseException catch (e) {
      if (e.cause == null) rethrow;
      throw ContentParseException(
        file: e.file,
        entityId: e.entityId,
        message: '${e.message} (${e.cause})',
      );
    }
  }
}

class _Parser {
  _Parser(this.raw);

  final RawContentBundle raw;
  final ContentBundleParser parser = const ContentBundleParser();

  final List<Module> modules = [];
  final List<TestFamily> families = [];
  final List<Item> items = [];
  final List<Passage> passages = [];
  final List<Lesson> lessons = [];
  final List<Deck> decks = [];
  final List<ExamBlueprint> blueprints = [];
  final List<LexicalField> lexicalFields = [];
  final List<InterviewQuestion> interviewQuestions = [];

  LoadedContentBundle run() {
    // Path order: bank files are seeded alphabetically (AUTHORING.md §1) and
    // every list below keeps that order, which `ORDER BY` columns refine.
    final paths = raw.files.keys.where((p) => p.endsWith('.json')).toList()
      ..sort();
    for (final path in paths) {
      _parseFile(path, raw.files[path]!);
    }
    final declared = raw.modules;
    for (final module in declared) {
      if (!modules.any((m) => m.id.name == module)) {
        throw ContentParseException(
          file: '$module/module.json',
          entityId: module,
          message: 'module "$module" has no (published) module.json',
        );
      }
    }
    return LoadedContentBundle(
      manifest: raw.manifest,
      modules: modules,
      families: families,
      items: items,
      passages: passages,
      lessons: lessons,
      decks: decks,
      blueprints: blueprints,
      lexicalFields: lexicalFields,
      interviewQuestions: interviewQuestions,
    );
  }

  void _parseFile(String path, String source) {
    final file = '$contentBundleRoot/$path';
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException catch (e) {
      throw ContentParseException(
        file: file,
        message: 'invalid JSON: ${e.message}',
      );
    }
    if (decoded is! Map<String, Object?>) {
      throw ContentParseException(
        file: file,
        message: 'expected a JSON object at the top level',
      );
    }
    final kind = decoded['kind'];
    switch (kind) {
      case 'manifest':
        // Only the root manifest is meaningful; one inside a module is an
        // authoring mistake the validator reports.
        break;
      case 'module':
        final module = parser.moduleFromJson(decoded, file: file);
        if (module.status == ContentStatus.published) modules.add(module);
      case 'family':
        final family = parser.familyFromJson(decoded, file: file);
        if (family.status == ContentStatus.published) families.add(family);
      case 'bank':
        final bank = parser.bankFromJson(decoded, file: file);
        items.addAll(
          bank.items.where((i) => i.status == ContentStatus.published),
        );
        passages.addAll(bank.passages);
      case 'lesson':
        final lesson = parser.lessonFromJson(decoded, file: file);
        if (lesson.status == ContentStatus.published) {
          lessons.add(_inlineBody(lesson, path: path, file: file));
        }
      case 'deck':
        final deck = parser.deckFromJson(decoded, file: file);
        if (deck.status == ContentStatus.published) {
          decks.add(
            deck.copyWith(
              cards: [
                for (final card in deck.cards)
                  if (card.status == ContentStatus.published) card,
              ],
            ),
          );
        }
      case 'blueprint':
        final blueprint = parser.blueprintFromJson(decoded, file: file);
        if (blueprint.status == ContentStatus.published) {
          blueprints.add(blueprint);
        }
      case 'lexical_fields':
        lexicalFields.addAll(
          parser.lexicalFieldsFromJson(decoded, file: file).fields,
        );
      case 'interview_questions':
        interviewQuestions.addAll(
          parser
              .interviewQuestionsFromJson(decoded, file: file)
              .questions
              .where((q) => q.status == ContentStatus.published),
        );
      default:
        throw ContentParseException(
          file: file,
          message: 'unknown "kind": ${jsonEncode(kind)}',
        );
    }
  }

  /// Replaces a lesson's `file` reference with the markdown it points to
  /// (module-relative paths, e.g. `lessons/english/01-anglais.fr.md`), so
  /// the stored row is self-contained and the viewer (US-041) never touches
  /// the asset bundle.
  Lesson _inlineBody(
    Lesson lesson, {
    required String path,
    required String file,
  }) {
    final reference = lesson.file;
    if (reference == null) return lesson;
    final module = path.split('/').first;
    String readMarkdown(String relative) {
      final key = '$module/$relative';
      final markdown = raw.files[key];
      if (markdown == null) {
        throw ContentParseException(
          file: file,
          entityId: lesson.id,
          message:
              'lesson file "$relative" not found under "$module/" (is its '
              'folder registered in pubspec.yaml?)',
        );
      }
      return markdown;
    }

    final en = reference.en;
    return lesson.copyWith(
      file: null,
      body: LocalizedText(
        fr: readMarkdown(reference.fr),
        en: en == null ? null : readMarkdown(en),
      ),
    );
  }
}
