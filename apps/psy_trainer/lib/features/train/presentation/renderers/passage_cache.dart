import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:psy_content/psy_content.dart';

/// Closes the `Passage` contract gap documented on `PassageResolver`
/// (`mcq_renderer.dart`, US-021/US-027): a running session only carries
/// `Item`s, never the passages an `McqItem.passageId` points to, and a
/// `PassageResolver` is synchronous. This cache is the "provider cache" side
/// of that fix: the launcher preloads the passages of a session's sampled
/// items (`buildActivitySessionConfig`'s `onPassagesLoaded`,
/// `practice_session_builder.dart`) into it before the session starts, and
/// any bank-driven family with passages reads it back synchronously through
/// [passageCacheProvider] (wired in `engine_registry_provider.dart`).
///
/// Module-agnostic on purpose (US-027 introduced it for `english` alone;
/// US-116 generalised it): passage ids are namespaced per family
/// (`english.reading.p001`, `p1_reading_fr.reading.p001`, ...), so one cache
/// shared by every passage-bank family across PSY0 and PSY1 cannot collide.
///
/// Deliberately dumb: an unbounded, ever-growing `Map`. Passages are a few
/// hundred bytes of text each and even a long bank (the `english`'s 26, or
/// `p1_reading_fr`'s 16) never adds up to enough to matter in a long-lived
/// app process; simplicity beats an eviction policy nothing needs yet.
class PassageCache {
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
final Provider<PassageCache> passageCacheProvider = Provider<PassageCache>(
  (ref) => PassageCache(),
);
