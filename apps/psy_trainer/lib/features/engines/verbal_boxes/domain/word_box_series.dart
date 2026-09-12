import 'dart:math';

import 'package:psy_content/psy_content.dart';

/// One word of a [WordBoxSeries]'s stream: [word] belongs to the field at
/// [fieldIndex] of [WordBoxSeries.fields] (its claim order / box index),
/// whether or not [isTrap] (a near-miss authored on that field, allowed only
/// from difficulty 3, spec §2.4-I).
class WordBoxEvent {
  const WordBoxEvent({
    required this.word,
    required this.fieldIndex,
    required this.isTrap,
  });

  final String word;
  final int fieldIndex;
  final bool isTrap;
}

/// One materialised *Boîte à mots* series (spec §2.4-I, US-030): the
/// [fields] chosen for this run, in **claim order** (the order their boxes
/// get labelled -- `fields[i]` is "box `i`"), and the [events] word stream to
/// show one at a time.
///
/// Built by [WordBoxSeries.build] from `(catalogue, params, seed,
/// difficulty)` alone, so the engine, the scorer and the renderer always
/// agree on the same series without the item carrying the words itself
/// (ARCHITECTURE.md "Engine" step 1, same trick as `buildDominoBoard`).
class WordBoxSeries {
  const WordBoxSeries({required this.fields, required this.events});

  final List<LexicalField> fields;
  final List<WordBoxEvent> events;

  /// Builds the series deterministically: same `(catalogue, params, seed,
  /// difficulty)`, same series (regardless of the catalogue's own order,
  /// since only fields with a stable [LexicalField.id] participate and the
  /// candidate list is re-sorted by id before shuffling).
  ///
  /// 1. Candidates are the published fields at or below [difficulty]
  ///    (falling back to the whole catalogue when that pool is smaller than
  ///    `params.boxCount`, so a run never fails just because a run seed
  ///    drew a shallow difficulty).
  /// 2. `Random(seed)` shuffles the candidates once; the first
  ///    `params.boxCount` that are mutually compatible (no
  ///    [LexicalField.incompatibleWith] conflict, either direction, and no
  ///    two chosen fields sharing a word, case-insensitively -- the
  ///    "no ambiguous word" rule of the acceptance criteria) are kept, in
  ///    the order they were accepted: that acceptance order **is** the
  ///    claim order (box 0, box 1, ...).
  /// 3. Each chosen field's word pool ([LexicalField.words] plus its
  ///    [LexicalField.traps] words when `difficulty >= 3`) is shuffled with
  ///    the same `Random`; its first word is reserved (it will claim the
  ///    box) and the rest is capped so the whole series totals about
  ///    `params.wordCount` words, split evenly across fields.
  /// 4. The per-field word queues (first word at the front, in queue order)
  ///    are merged by repeatedly drawing a uniformly random still-nonempty
  ///    queue: a field's own queue order guarantees its first word is
  ///    always emitted before any of its later words, satisfying "the first
  ///    word of a field claims a free box" without needing to special-case
  ///    the start of the stream.
  factory WordBoxSeries.build({
    required List<LexicalField> catalogue,
    required WordBoxesParams params,
    required int seed,
    required int difficulty,
  }) {
    final rng = Random(seed);
    final published = catalogue
        .where((f) => f.status == ContentStatus.published)
        .toList();
    var candidates = published
        .where((f) => f.difficulty <= difficulty)
        .toList();
    if (candidates.length < params.boxCount) candidates = published;
    if (candidates.length < params.boxCount) {
      throw StateError(
        'word_boxes: catalogue has only ${candidates.length} fields, '
        'need ${params.boxCount}',
      );
    }
    candidates.sort((a, b) => a.id.compareTo(b.id));
    candidates.shuffle(rng);

    final chosen = <LexicalField>[];
    final chosenWords = <String>{};
    for (final field in candidates) {
      if (chosen.length == params.boxCount) break;
      final incompatible = chosen.any(
        (c) =>
            c.incompatibleWith.contains(field.id) ||
            field.incompatibleWith.contains(c.id),
      );
      if (incompatible) continue;
      final fieldWords = {
        for (final w in field.words) w.toLowerCase(),
        if (difficulty >= 3)
          for (final t in field.traps) t.word.toLowerCase(),
      };
      if (fieldWords.any(chosenWords.contains)) continue;
      chosen.add(field);
      chosenWords.addAll(fieldWords);
    }
    if (chosen.length < params.boxCount) {
      throw StateError(
        'word_boxes: could not find ${params.boxCount} mutually compatible, '
        'unambiguous fields (found ${chosen.length})',
      );
    }

    final restBudget = max(0, params.wordCount - chosen.length);
    final base = restBudget ~/ chosen.length;
    final extra = restBudget % chosen.length;
    final queues = <List<WordBoxEvent>>[];
    for (final (index, field) in chosen.indexed) {
      final pool = <WordBoxEvent>[
        for (final w in field.words)
          WordBoxEvent(word: w, fieldIndex: index, isTrap: false),
        if (difficulty >= 3)
          for (final t in field.traps)
            WordBoxEvent(word: t.word, fieldIndex: index, isTrap: true),
      ]..shuffle(rng);
      final first = pool.removeAt(0);
      final restCount = min(base + (index < extra ? 1 : 0), pool.length);
      queues.add([first, ...pool.take(restCount)]);
    }

    final events = <WordBoxEvent>[];
    final cursors = List<int>.filled(chosen.length, 0);
    var remaining = queues.fold<int>(0, (sum, q) => sum + q.length);
    while (remaining > 0) {
      final active = [
        for (var i = 0; i < queues.length; i++)
          if (cursors[i] < queues[i].length) i,
      ];
      final pick = active[rng.nextInt(active.length)];
      events.add(queues[pick][cursors[pick]]);
      cursors[pick]++;
      remaining--;
    }

    return WordBoxSeries(fields: chosen, events: events);
  }
}
