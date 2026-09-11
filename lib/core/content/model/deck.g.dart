// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Deck _$DeckFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_Deck', json, ($checkedConvert) {
  final val = _Deck(
    id: $checkedConvert('id', (v) => v as String),
    version: $checkedConvert('version', (v) => (v as num).toInt()),
    moduleId: $checkedConvert(
      'moduleId',
      (v) => $enumDecode(_$ModuleIdEnumMap, v),
    ),
    familyId: $checkedConvert('familyId', (v) => v as String),
    order: $checkedConvert('order', (v) => (v as num).toInt()),
    name: $checkedConvert(
      'name',
      (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
    ),
    tags: $checkedConvert(
      'tags',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
    cards: $checkedConvert(
      'cards',
      (v) => (v as List<dynamic>)
          .map((e) => Flashcard.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    description: $checkedConvert(
      'description',
      (v) =>
          v == null ? null : LocalizedText.fromJson(v as Map<String, dynamic>),
    ),
    status: $checkedConvert(
      'status',
      (v) =>
          $enumDecodeNullable(_$ContentStatusEnumMap, v) ??
          ContentStatus.published,
    ),
    meta: $checkedConvert(
      'meta',
      (v) => v == null ? null : ContentMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$DeckToJson(_Deck instance) => <String, dynamic>{
  'id': instance.id,
  'version': instance.version,
  'moduleId': _$ModuleIdEnumMap[instance.moduleId]!,
  'familyId': instance.familyId,
  'order': instance.order,
  'name': instance.name.toJson(),
  'tags': instance.tags,
  'cards': instance.cards.map((e) => e.toJson()).toList(),
  'description': ?instance.description?.toJson(),
  'status': _$ContentStatusEnumMap[instance.status]!,
  'meta': ?instance.meta?.toJson(),
};

const _$ModuleIdEnumMap = {
  ModuleId.psy0: 'psy0',
  ModuleId.psy1: 'psy1',
  ModuleId.psy2: 'psy2',
};

const _$ContentStatusEnumMap = {
  ContentStatus.draft: 'draft',
  ContentStatus.published: 'published',
};

_Flashcard _$FlashcardFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_Flashcard',
  json,
  ($checkedConvert) {
    final val = _Flashcard(
      id: $checkedConvert('id', (v) => v as String),
      version: $checkedConvert('version', (v) => (v as num).toInt()),
      deckId: $checkedConvert('deckId', (v) => v as String),
      front: $checkedConvert(
        'front',
        (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
      ),
      back: $checkedConvert(
        'back',
        (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
      ),
      difficulty: $checkedConvert('difficulty', (v) => difficultyFromJson(v)),
      tags: $checkedConvert(
        'tags',
        (v) => (v as List<dynamic>).map((e) => e as String).toList(),
      ),
      media: $checkedConvert(
        'media',
        (v) => v == null ? null : MediaRef.fromJson(v as Map<String, dynamic>),
      ),
      status: $checkedConvert(
        'status',
        (v) =>
            $enumDecodeNullable(_$ContentStatusEnumMap, v) ??
            ContentStatus.published,
      ),
      meta: $checkedConvert(
        'meta',
        (v) =>
            v == null ? null : ContentMeta.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$FlashcardToJson(_Flashcard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'deckId': instance.deckId,
      'front': instance.front.toJson(),
      'back': instance.back.toJson(),
      'difficulty': instance.difficulty,
      'tags': instance.tags,
      'media': ?instance.media?.toJson(),
      'status': _$ContentStatusEnumMap[instance.status]!,
      'meta': ?instance.meta?.toJson(),
    };
