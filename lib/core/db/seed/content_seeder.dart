import 'package:flutter/foundation.dart' show compute;

import '../../content/content.dart';
import '../app_database.dart';
import '../content_rows.dart';
import '../daos/content_dao.dart';
import 'asset_reader.dart';
import 'content_bundle_loader.dart';

/// What [ContentSeeder.seedIfNeeded] did.
class SeedResult {
  const SeedResult({
    required this.seeded,
    required this.contentVersion,
    this.previousVersion,
    this.elapsed = Duration.zero,
    this.itemCount = 0,
    this.lessonCount = 0,
  });

  /// A result for a database that already mirrors [contentVersion].
  const SeedResult.upToDate(int contentVersion)
    : this(
        seeded: false,
        contentVersion: contentVersion,
        previousVersion: contentVersion,
      );

  /// Whether the mirrors were (re)written.
  final bool seeded;

  /// Bundled `contentVersion` (the one now in `content_meta`).
  final int contentVersion;

  /// `content_meta.contentVersion` before the call; null on first launch.
  final int? previousVersion;

  /// Wall time of the whole check (asset reads, parsing, transaction).
  final Duration elapsed;

  final int itemCount;
  final int lessonCount;

  @override
  String toString() => seeded
      ? 'SeedResult(seeded ${previousVersion ?? 'none'} -> $contentVersion: '
            '$itemCount items, $lessonCount lessons in '
            '${elapsed.inMilliseconds} ms)'
      : 'SeedResult(up to date at $contentVersion, '
            '${elapsed.inMilliseconds} ms)';
}

/// Mirrors the bundled content into the database (US-013).
///
/// [seedIfNeeded] compares the bundle's `manifest.contentVersion` with the
/// stored `content_meta.contentVersion` and, when the bundle is newer (or
/// nothing is stored yet), replaces every content table in **one
/// transaction** through [ContentDao.replaceAll]. User tables (`sessions`,
/// `attempts`, `item_stats`...) are never touched: their rows reference
/// content by id, and ids are permanent (AUTHORING.md §2).
///
/// A bundle *older* than the stored version (a downgraded build) is left
/// alone: the mirrors are always at least as new as the app expects.
///
/// Work is split by isolate: asset reads happen on the caller (they need the
/// platform channel), JSON decoding runs through [parse] (`compute`, i.e. a
/// short-lived isolate, unless a test injects an inline function), and the
/// SQL runs on the database isolate (`NativeDatabase.createInBackground`).
/// Errors are the parser's [ContentParseException] (file and entity named)
/// or the database's; both propagate to the caller unchanged.
class ContentSeeder {
  ContentSeeder({
    required AppDatabase database,
    required AssetReader assets,
    ContentBundleParser parser = const ContentBundleParser(),
    String root = contentBundleRoot,
    DateTime Function()? clock,
    Future<LoadedContentBundle> Function(RawContentBundle raw)? parse,
  }) : _dao = database.contentDao,
       _loader = ContentBundleLoader(
         assets: assets,
         parser: parser,
         root: root,
       ),
       _clock = clock ?? DateTime.now,
       _parse = parse ?? _parseInIsolate;

  final ContentDao _dao;
  final ContentBundleLoader _loader;
  final DateTime Function() _clock;
  final Future<LoadedContentBundle> Function(RawContentBundle raw) _parse;

  static Future<LoadedContentBundle> _parseInIsolate(RawContentBundle raw) =>
      compute(ContentBundleLoader.parse, raw, debugLabel: 'content parse');

  /// Seeds when the bundle is newer than the stored content (or when
  /// [force] is true), otherwise returns a [SeedResult.upToDate].
  Future<SeedResult> seedIfNeeded({bool force = false}) async {
    final stopwatch = Stopwatch()..start();
    final manifest = await _loader.readManifest();
    final stored = (await _dao.meta())?.contentVersion;
    if (!force && stored != null && stored >= manifest.contentVersion) {
      return SeedResult(
        seeded: false,
        contentVersion: stored,
        previousVersion: stored,
        elapsed: stopwatch.elapsed,
      );
    }

    final raw = await _loader.read(manifest: manifest);
    final bundle = await _parse(raw);
    final seededAt = _clock().toUtc();
    await _dao.replaceAll(
      meta: ContentRows.meta(bundle.manifest, seededAt: seededAt),
      modules: [
        for (final m in bundle.modules)
          ContentRows.module(m, seededAt: seededAt),
      ],
      families: [
        for (final f in bundle.families)
          ContentRows.family(f, seededAt: seededAt),
      ],
      items: [
        for (final i in bundle.items) ContentRows.item(i, seededAt: seededAt),
      ],
      lessons: [
        for (final l in bundle.lessons)
          ContentRows.lesson(l, seededAt: seededAt),
      ],
      decks: [
        for (final d in bundle.decks) ContentRows.deck(d, seededAt: seededAt),
      ],
      flashcards: [
        for (final d in bundle.decks)
          ...ContentRows.flashcards(d, seededAt: seededAt),
      ],
      blueprints: [
        for (final b in bundle.blueprints)
          ContentRows.blueprint(b, seededAt: seededAt),
      ],
    );
    return SeedResult(
      seeded: true,
      contentVersion: manifest.contentVersion,
      previousVersion: stored,
      elapsed: stopwatch.elapsed,
      itemCount: bundle.items.length,
      lessonCount: bundle.lessons.length,
    );
  }
}
