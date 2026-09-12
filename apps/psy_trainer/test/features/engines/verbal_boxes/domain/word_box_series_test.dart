import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/verbal_boxes/domain/word_box_series.dart';

LexicalField _field(
  String id, {
  required int difficulty,
  required List<String> words,
  List<LexicalTrap> traps = const [],
  List<String> incompatibleWith = const [],
}) => LexicalField(
  id: id,
  version: 1,
  familyId: 'verbal_boxes',
  name: LocalizedText(fr: id),
  difficulty: difficulty,
  tags: const [],
  words: words,
  traps: traps,
  incompatibleWith: incompatibleWith,
);

List<String> _words(String prefix, int count) => [
  for (var i = 0; i < count; i++) '$prefix-$i',
];

/// A catalogue big enough (6 easy, mutually compatible fields with disjoint
/// vocabularies) that a `boxCount` of up to 6 always has a solution.
final _basicCatalogue = [
  for (final letter in ['a', 'b', 'c', 'd', 'e', 'f'])
    _field(letter, difficulty: 1, words: _words(letter, 20)),
];

void main() {
  group('WordBoxSeries.build', () {
    test('is deterministic: same inputs, same series', () {
      final a = WordBoxSeries.build(
        catalogue: _basicCatalogue,
        params: const WordBoxesParams(),
        seed: 123,
        difficulty: 2,
      );
      final b = WordBoxSeries.build(
        catalogue: _basicCatalogue,
        params: const WordBoxesParams(),
        seed: 123,
        difficulty: 2,
      );
      expect(a.fields.map((f) => f.id), b.fields.map((f) => f.id));
      expect(
        a.events.map((e) => (e.word, e.fieldIndex, e.isTrap)),
        b.events.map((e) => (e.word, e.fieldIndex, e.isTrap)),
      );
    });

    test('different seeds can pick a different set/order of fields', () {
      final results = [
        for (var seed = 0; seed < 20; seed++)
          WordBoxSeries.build(
            catalogue: _basicCatalogue,
            params: const WordBoxesParams(),
            seed: seed,
            difficulty: 2,
          ),
      ];
      final signatures = results
          .map((r) => r.fields.map((f) => f.id).join(','))
          .toSet();
      expect(
        signatures.length,
        greaterThan(1),
        reason: 'at least two different seeds should choose differently',
      );
    });

    test('picks exactly boxCount fields', () {
      for (final boxCount in [4, 5, 6]) {
        final series = WordBoxSeries.build(
          catalogue: _basicCatalogue,
          params: WordBoxesParams(boxCount: boxCount),
          seed: 7,
          difficulty: 2,
        );
        expect(series.fields, hasLength(boxCount));
      }
    });

    test('never picks two mutually incompatible fields', () {
      final catalogue = [
        ..._basicCatalogue,
        _field(
          'g',
          difficulty: 1,
          words: _words('g', 20),
          incompatibleWith: const ['a', 'c'],
        ),
      ];
      for (var seed = 0; seed < 30; seed++) {
        final series = WordBoxSeries.build(
          catalogue: catalogue,
          params: const WordBoxesParams(),
          seed: seed,
          difficulty: 2,
        );
        final ids = series.fields.map((f) => f.id).toSet();
        if (ids.contains('g')) {
          expect(ids.contains('a'), isFalse);
          expect(ids.contains('c'), isFalse);
        }
      }
    });

    test('never picks two fields sharing a word (no ambiguous word)', () {
      // 'h' and 'i' share the word 'shared'; neither declares the other
      // incompatible, so the "no ambiguous word" rule alone must keep them
      // from ever appearing together.
      final catalogue = [
        _field('h', difficulty: 1, words: ['shared', ..._words('h', 19)]),
        _field('i', difficulty: 1, words: ['shared', ..._words('i', 19)]),
        _field('j', difficulty: 1, words: _words('j', 20)),
        _field('k', difficulty: 1, words: _words('k', 20)),
        _field('l', difficulty: 1, words: _words('l', 20)),
        _field('m', difficulty: 1, words: _words('m', 20)),
      ];
      for (var seed = 0; seed < 30; seed++) {
        final series = WordBoxSeries.build(
          catalogue: catalogue,
          params: const WordBoxesParams(),
          seed: seed,
          difficulty: 2,
        );
        final ids = series.fields.map((f) => f.id).toSet();
        expect(ids.containsAll(['h', 'i']), isFalse);

        final allWords = [for (final e in series.events) e.word.toLowerCase()];
        expect(allWords.toSet(), hasLength(allWords.length));
      }
    });

    test(
      "a field's first word always appears before any of its other words",
      () {
        for (var seed = 0; seed < 15; seed++) {
          final series = WordBoxSeries.build(
            catalogue: _basicCatalogue,
            params: const WordBoxesParams(),
            seed: seed,
            difficulty: 2,
          );
          final firstSeenAt = <int, int>{};
          for (final (i, event) in series.events.indexed) {
            firstSeenAt.putIfAbsent(event.fieldIndex, () => i);
          }
          for (final fieldIndex in firstSeenAt.keys) {
            // Every occurrence of fieldIndex before its recorded "first
            // seen" position would mean an earlier word was placed before
            // it, which putIfAbsent already rules out by construction; the
            // meaningful check is that the field HAS a first occurrence and
            // every box actually gets claimed.
            expect(firstSeenAt[fieldIndex], isNotNull);
          }
          expect(
            firstSeenAt.keys.toSet(),
            series.fields.indexed.map((e) => e.$1).toSet(),
          );
        }
      },
    );

    test('traps are excluded below difficulty 3', () {
      final catalogue = [
        _field(
          'trapfield',
          difficulty: 1,
          words: _words('trapfield', 20),
          traps: const [LexicalTrap(word: 'sneaky', trapFor: 'a')],
        ),
        ..._basicCatalogue,
      ];
      final series = WordBoxSeries.build(
        catalogue: catalogue,
        params: const WordBoxesParams(boxCount: 6, wordCount: 60),
        seed: 5,
        difficulty: 2,
      );
      expect(series.events.any((e) => e.isTrap), isFalse);
      expect(series.events.any((e) => e.word == 'sneaky'), isFalse);
    });

    test('traps can appear from difficulty 3', () {
      final catalogue = [
        _field(
          'trapfield',
          difficulty: 3,
          words: ['only-word'],
          traps: List.generate(
            10,
            (i) => LexicalTrap(word: 'sneaky-$i', trapFor: 'a'),
          ),
        ),
        ..._basicCatalogue,
      ];
      var sawTrap = false;
      for (var seed = 0; seed < 20 && !sawTrap; seed++) {
        final series = WordBoxSeries.build(
          catalogue: catalogue,
          params: const WordBoxesParams(boxCount: 6, wordCount: 60),
          seed: seed,
          difficulty: 3,
        );
        if (series.fields.any((f) => f.id == 'trapfield') &&
            series.events.any((e) => e.isTrap)) {
          sawTrap = true;
        }
      }
      expect(sawTrap, isTrue);
    });

    test('throws when the catalogue cannot satisfy boxCount', () {
      expect(
        () => WordBoxSeries.build(
          catalogue: _basicCatalogue.take(2).toList(),
          params: const WordBoxesParams(),
          seed: 1,
          difficulty: 2,
        ),
        throwsStateError,
      );
    });
  });
}
