import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';

part 'deck.freezed.dart';
part 'deck.g.dart';

/// A flashcard deck and its cards. File:
/// `assets/content/<module>/<family>/decks/<slug>.json` (`deck.schema.json`).
@freezed
abstract class Deck with _$Deck {
  const factory Deck({
    required String id,
    required int version,
    required ModuleId moduleId,
    required String familyId,
    required int order,
    required LocalizedText name,
    required List<String> tags,
    required List<Flashcard> cards,
    LocalizedText? description,
    @Default(ContentStatus.published) ContentStatus status,
    ContentMeta? meta,
  }) = _Deck;

  factory Deck.fromJson(Map<String, Object?> json) => _$DeckFromJson(json);
}

/// One two-sided card, always authored inside a [Deck]
/// (`flashcard.schema.json`).
@freezed
abstract class Flashcard with _$Flashcard {
  @Assert(
    'difficulty >= minDifficulty && difficulty <= maxDifficulty',
    'difficulty must be 1..5',
  )
  const factory Flashcard({
    required String id,
    required int version,
    required String deckId,
    required LocalizedText front,
    required LocalizedText back,
    @JsonKey(fromJson: difficultyFromJson) required Difficulty difficulty,
    required List<String> tags,
    MediaRef? media,
    @Default(ContentStatus.published) ContentStatus status,
    ContentMeta? meta,
  }) = _Flashcard;

  factory Flashcard.fromJson(Map<String, Object?> json) =>
      _$FlashcardFromJson(json);
}
