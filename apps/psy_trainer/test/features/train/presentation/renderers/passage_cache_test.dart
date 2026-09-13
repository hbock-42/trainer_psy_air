import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/train/presentation/renderers/passage_cache.dart';

/// US-116 generalised this cache off `english` alone (was
/// `EnglishPassageCache`) so `p1_reading_fr` and any future passage-bank
/// family share it; ids stay namespaced per family so nothing collides.
void main() {
  test('caches passages and resolves them back by id', () {
    final cache = PassageCache();
    expect(cache.get('english.reading.p001'), isNull);

    const passage = Passage(
      id: 'english.reading.p001',
      body: LocalizedText(fr: 'Un texte.'),
    );
    cache.addAll([passage]);

    expect(cache.get('english.reading.p001'), passage);
    expect(cache.get('nope'), isNull);
  });

  test('addAll overwrites an existing id (a re-seeded bundle)', () {
    final cache = PassageCache();
    const v1 = Passage(
      id: 'p1',
      body: LocalizedText(fr: 'v1'),
    );
    const v2 = Passage(
      id: 'p1',
      body: LocalizedText(fr: 'v2'),
    );

    cache.addAll([v1]);
    cache.addAll([v2]);

    expect(cache.get('p1'), v2);
  });

  test('one cache instance resolves passages from different families', () {
    final cache = PassageCache();
    const english = Passage(
      id: 'english.reading.p001',
      body: LocalizedText(fr: 'v1'),
    );
    const readingFr = Passage(
      id: 'p1_reading_fr.reading.p001',
      body: LocalizedText(fr: 'v1'),
    );
    cache.addAll([english, readingFr]);

    expect(cache.get('english.reading.p001'), english);
    expect(cache.get('p1_reading_fr.reading.p001'), readingFr);
  });
}
