import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:psy_content/psy_content.dart';

/// Closes the `Passage` contract gap documented on `PassageResolver`
/// (`presentation/renderers/mcq_renderer.dart`, US-021/US-027): a running
/// session only carries `Item`s, never the passages an `McqItem.passageId`
/// points to, and a `PassageResolver` is synchronous. This cache is the
/// "provider cache" side of that fix: the launcher preloads the passages of
/// a session's sampled items (`buildActivitySessionConfig`'s
/// `onPassagesLoaded`, `practice_session_builder.dart`) into it before the
/// session starts, and `english`'s `McqRenderer` reads it back
/// synchronously through [englishPassageCacheProvider] (wired in
/// `engine_registry_provider.dart`).
///
/// Deliberately dumb: an unbounded, ever-growing `Map`. Passages are a few
/// hundred bytes of text each and the whole `english` bank has 26 of them, so
/// even a long-lived app process never holds enough to matter; simplicity
/// beats an eviction policy nothing needs yet.
class EnglishPassageCache {
  final Map<String, Passage> _byId = {};

  /// Adds every passage in [passages] (existing ids are overwritten, in case
  /// the content bundle changed).
  void addAll(Iterable<Passage> passages) {
    for (final passage in passages) {
      _byId[passage.id] = passage;
    }
  }

  /// The cached passage, or null when nothing has loaded it yet (a session
  /// resumed without going through the launcher, or a stale/unknown id).
  Passage? get(String id) => _byId[id];
}

/// One cache for the app's lifetime (not `autoDispose`): a session started
/// from the launcher populates it, `SessionHost`'s `McqRenderer` reads it
/// while that session (and any later one) is showing.
final Provider<EnglishPassageCache> englishPassageCacheProvider =
    Provider<EnglishPassageCache>((ref) => EnglishPassageCache());
