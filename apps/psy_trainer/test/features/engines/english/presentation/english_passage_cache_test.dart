import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/english/presentation/english_passage_cache.dart';

void main() {
  test('caches passages and resolves them back by id', () {
    final cache = EnglishPassageCache();
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
    final cache = EnglishPassageCache();
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
}
