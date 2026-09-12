import 'package:psy_trainer/core/content/content.dart';

/// A small deck fixture for [familyId] with [count] cards (US-042 tests).
///
/// Front/back are simple, deterministic strings so tests can assert on them
/// without depending on the real content bundle.
Deck flashcardsDeckFixture({required String familyId, int count = 3}) => Deck(
  id: '$familyId.deck.test',
  version: 1,
  moduleId: ModuleId.psy0,
  familyId: familyId,
  order: 1,
  name: const LocalizedText(fr: 'Paquet de test'),
  tags: const [],
  cards: [
    for (var i = 1; i <= count; i++)
      Flashcard(
        id: '$familyId.deck.test.${i.toString().padLeft(4, '0')}',
        version: 1,
        deckId: '$familyId.deck.test',
        front: LocalizedText(fr: 'Recto $i'),
        back: LocalizedText(fr: 'Verso $i'),
        difficulty: 1,
        tags: const [],
      ),
  ],
);
