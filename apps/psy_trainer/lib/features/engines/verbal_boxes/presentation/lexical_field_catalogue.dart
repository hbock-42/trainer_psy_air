import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/repositories/repository_providers.dart';
import '../domain/word_boxes_engine.dart';

/// The `word_boxes` generator's [LexicalFieldSource]: unlike `english`'s
/// `EnglishPassageCache` (which the launcher fills per session,
/// `practice_session_builder.dart`'s `onPassagesLoaded`), this engine needs
/// the *whole* bank at generation time -- which fields a series draws from
/// is decided inside `WordBoxSeries.build`, so there is no per-session
/// subset to preload ahead of it.
///
/// [lexicalFieldCatalogueProvider] therefore loads lazily instead: building
/// it (e.g. as part of `engineRegistryProvider`) does not touch the
/// database, only reading [all] does, the first time (subsequent reads
/// return the same cached list until it resolves). In practice that first
/// read happens when a `verbal_boxes` session materialises its items
/// (`ActivitySession`'s constructor calls `generate` synchronously), by
/// which point `contentReadyProvider` has already gated every screen the
/// user could reach, so the content mirrors exist and the read is a fast
/// local-DB query.
///
/// Caveat (documented rather than solved, see the PR description): [all]
/// can still be empty for the brief window between the first read starting
/// the load and its future resolving -- nothing in this engine's own folder
/// can force a stricter ordering (that would mean an explicit preload hook
/// in `practice_session_builder.dart`, outside its scope). `WordBoxSeries
/// .build` fails loudly ("not enough fields") rather than silently emitting
/// an empty series when that happens.
class LexicalFieldCatalogue implements LexicalFieldSource {
  LexicalFieldCatalogue(this._load);

  final Future<List<LexicalField>> Function() _load;
  List<LexicalField> _fields = const [];
  bool _loading = false;

  @override
  List<LexicalField> get all {
    if (!_loading) {
      _loading = true;
      unawaited(_load().then((fields) => _fields = fields));
    }
    return _fields;
  }
}

/// One cache for the app's lifetime (not `autoDispose`).
final Provider<LexicalFieldCatalogue> lexicalFieldCatalogueProvider =
    Provider<LexicalFieldCatalogue>(
      (ref) => LexicalFieldCatalogue(
        () => ref
            .read(contentRepositoryProvider)
            .lexicalFields(familyId: 'verbal_boxes'),
      ),
    );
