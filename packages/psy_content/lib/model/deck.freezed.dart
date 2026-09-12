// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deck.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Deck {

 String get id; int get version; ModuleId get moduleId; String get familyId; int get order; LocalizedText get name; List<String> get tags; List<Flashcard> get cards; LocalizedText? get description; ContentStatus get status; ContentMeta? get meta;
/// Create a copy of Deck
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeckCopyWith<Deck> get copyWith => _$DeckCopyWithImpl<Deck>(this as Deck, _$identity);

  /// Serializes this Deck to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Deck&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.order, order) || other.order == order)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.cards, cards)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,moduleId,familyId,order,name,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(cards),description,status,meta);

@override
String toString() {
  return 'Deck(id: $id, version: $version, moduleId: $moduleId, familyId: $familyId, order: $order, name: $name, tags: $tags, cards: $cards, description: $description, status: $status, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $DeckCopyWith<$Res>  {
  factory $DeckCopyWith(Deck value, $Res Function(Deck) _then) = _$DeckCopyWithImpl;
@useResult
$Res call({
 String id, int version, ModuleId moduleId, String familyId, int order, LocalizedText name, List<String> tags, List<Flashcard> cards, LocalizedText? description, ContentStatus status, ContentMeta? meta
});


$LocalizedTextCopyWith<$Res> get name;$LocalizedTextCopyWith<$Res>? get description;$ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class _$DeckCopyWithImpl<$Res>
    implements $DeckCopyWith<$Res> {
  _$DeckCopyWithImpl(this._self, this._then);

  final Deck _self;
  final $Res Function(Deck) _then;

/// Create a copy of Deck
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? version = null,Object? moduleId = null,Object? familyId = null,Object? order = null,Object? name = null,Object? tags = null,Object? cards = null,Object? description = freezed,Object? status = null,Object? meta = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,moduleId: null == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as ModuleId,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,cards: null == cards ? _self.cards : cards // ignore: cast_nullable_to_non_nullable
as List<Flashcard>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as LocalizedText?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}
/// Create a copy of Deck
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get name {
  
  return $LocalizedTextCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of Deck
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get description {
    if (_self.description == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.description!, (value) {
    return _then(_self.copyWith(description: value));
  });
}/// Create a copy of Deck
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $ContentMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [Deck].
extension DeckPatterns on Deck {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Deck value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Deck() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Deck value)  $default,){
final _that = this;
switch (_that) {
case _Deck():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Deck value)?  $default,){
final _that = this;
switch (_that) {
case _Deck() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int version,  ModuleId moduleId,  String familyId,  int order,  LocalizedText name,  List<String> tags,  List<Flashcard> cards,  LocalizedText? description,  ContentStatus status,  ContentMeta? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Deck() when $default != null:
return $default(_that.id,_that.version,_that.moduleId,_that.familyId,_that.order,_that.name,_that.tags,_that.cards,_that.description,_that.status,_that.meta);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int version,  ModuleId moduleId,  String familyId,  int order,  LocalizedText name,  List<String> tags,  List<Flashcard> cards,  LocalizedText? description,  ContentStatus status,  ContentMeta? meta)  $default,) {final _that = this;
switch (_that) {
case _Deck():
return $default(_that.id,_that.version,_that.moduleId,_that.familyId,_that.order,_that.name,_that.tags,_that.cards,_that.description,_that.status,_that.meta);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int version,  ModuleId moduleId,  String familyId,  int order,  LocalizedText name,  List<String> tags,  List<Flashcard> cards,  LocalizedText? description,  ContentStatus status,  ContentMeta? meta)?  $default,) {final _that = this;
switch (_that) {
case _Deck() when $default != null:
return $default(_that.id,_that.version,_that.moduleId,_that.familyId,_that.order,_that.name,_that.tags,_that.cards,_that.description,_that.status,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Deck implements Deck {
  const _Deck({required this.id, required this.version, required this.moduleId, required this.familyId, required this.order, required this.name, required final  List<String> tags, required final  List<Flashcard> cards, this.description, this.status = ContentStatus.published, this.meta}): _tags = tags,_cards = cards;
  factory _Deck.fromJson(Map<String, dynamic> json) => _$DeckFromJson(json);

@override final  String id;
@override final  int version;
@override final  ModuleId moduleId;
@override final  String familyId;
@override final  int order;
@override final  LocalizedText name;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<Flashcard> _cards;
@override List<Flashcard> get cards {
  if (_cards is EqualUnmodifiableListView) return _cards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cards);
}

@override final  LocalizedText? description;
@override@JsonKey() final  ContentStatus status;
@override final  ContentMeta? meta;

/// Create a copy of Deck
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeckCopyWith<_Deck> get copyWith => __$DeckCopyWithImpl<_Deck>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeckToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Deck&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.order, order) || other.order == order)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._cards, _cards)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,moduleId,familyId,order,name,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_cards),description,status,meta);

@override
String toString() {
  return 'Deck(id: $id, version: $version, moduleId: $moduleId, familyId: $familyId, order: $order, name: $name, tags: $tags, cards: $cards, description: $description, status: $status, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$DeckCopyWith<$Res> implements $DeckCopyWith<$Res> {
  factory _$DeckCopyWith(_Deck value, $Res Function(_Deck) _then) = __$DeckCopyWithImpl;
@override @useResult
$Res call({
 String id, int version, ModuleId moduleId, String familyId, int order, LocalizedText name, List<String> tags, List<Flashcard> cards, LocalizedText? description, ContentStatus status, ContentMeta? meta
});


@override $LocalizedTextCopyWith<$Res> get name;@override $LocalizedTextCopyWith<$Res>? get description;@override $ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class __$DeckCopyWithImpl<$Res>
    implements _$DeckCopyWith<$Res> {
  __$DeckCopyWithImpl(this._self, this._then);

  final _Deck _self;
  final $Res Function(_Deck) _then;

/// Create a copy of Deck
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? version = null,Object? moduleId = null,Object? familyId = null,Object? order = null,Object? name = null,Object? tags = null,Object? cards = null,Object? description = freezed,Object? status = null,Object? meta = freezed,}) {
  return _then(_Deck(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,moduleId: null == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as ModuleId,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,cards: null == cards ? _self._cards : cards // ignore: cast_nullable_to_non_nullable
as List<Flashcard>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as LocalizedText?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}

/// Create a copy of Deck
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get name {
  
  return $LocalizedTextCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of Deck
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get description {
    if (_self.description == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.description!, (value) {
    return _then(_self.copyWith(description: value));
  });
}/// Create a copy of Deck
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $ContentMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$Flashcard {

 String get id; int get version; String get deckId; LocalizedText get front; LocalizedText get back;@JsonKey(fromJson: difficultyFromJson) Difficulty get difficulty; List<String> get tags; MediaRef? get media; ContentStatus get status; ContentMeta? get meta;
/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlashcardCopyWith<Flashcard> get copyWith => _$FlashcardCopyWithImpl<Flashcard>(this as Flashcard, _$identity);

  /// Serializes this Flashcard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Flashcard&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.deckId, deckId) || other.deckId == deckId)&&(identical(other.front, front) || other.front == front)&&(identical(other.back, back) || other.back == back)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.media, media) || other.media == media)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,deckId,front,back,difficulty,const DeepCollectionEquality().hash(tags),media,status,meta);

@override
String toString() {
  return 'Flashcard(id: $id, version: $version, deckId: $deckId, front: $front, back: $back, difficulty: $difficulty, tags: $tags, media: $media, status: $status, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $FlashcardCopyWith<$Res>  {
  factory $FlashcardCopyWith(Flashcard value, $Res Function(Flashcard) _then) = _$FlashcardCopyWithImpl;
@useResult
$Res call({
 String id, int version, String deckId, LocalizedText front, LocalizedText back,@JsonKey(fromJson: difficultyFromJson) Difficulty difficulty, List<String> tags, MediaRef? media, ContentStatus status, ContentMeta? meta
});


$LocalizedTextCopyWith<$Res> get front;$LocalizedTextCopyWith<$Res> get back;$MediaRefCopyWith<$Res>? get media;$ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class _$FlashcardCopyWithImpl<$Res>
    implements $FlashcardCopyWith<$Res> {
  _$FlashcardCopyWithImpl(this._self, this._then);

  final Flashcard _self;
  final $Res Function(Flashcard) _then;

/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? version = null,Object? deckId = null,Object? front = null,Object? back = null,Object? difficulty = null,Object? tags = null,Object? media = freezed,Object? status = null,Object? meta = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,deckId: null == deckId ? _self.deckId : deckId // ignore: cast_nullable_to_non_nullable
as String,front: null == front ? _self.front : front // ignore: cast_nullable_to_non_nullable
as LocalizedText,back: null == back ? _self.back : back // ignore: cast_nullable_to_non_nullable
as LocalizedText,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as MediaRef?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}
/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get front {
  
  return $LocalizedTextCopyWith<$Res>(_self.front, (value) {
    return _then(_self.copyWith(front: value));
  });
}/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get back {
  
  return $LocalizedTextCopyWith<$Res>(_self.back, (value) {
    return _then(_self.copyWith(back: value));
  });
}/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaRefCopyWith<$Res>? get media {
    if (_self.media == null) {
    return null;
  }

  return $MediaRefCopyWith<$Res>(_self.media!, (value) {
    return _then(_self.copyWith(media: value));
  });
}/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $ContentMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [Flashcard].
extension FlashcardPatterns on Flashcard {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Flashcard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Flashcard() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Flashcard value)  $default,){
final _that = this;
switch (_that) {
case _Flashcard():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Flashcard value)?  $default,){
final _that = this;
switch (_that) {
case _Flashcard() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int version,  String deckId,  LocalizedText front,  LocalizedText back, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  MediaRef? media,  ContentStatus status,  ContentMeta? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Flashcard() when $default != null:
return $default(_that.id,_that.version,_that.deckId,_that.front,_that.back,_that.difficulty,_that.tags,_that.media,_that.status,_that.meta);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int version,  String deckId,  LocalizedText front,  LocalizedText back, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  MediaRef? media,  ContentStatus status,  ContentMeta? meta)  $default,) {final _that = this;
switch (_that) {
case _Flashcard():
return $default(_that.id,_that.version,_that.deckId,_that.front,_that.back,_that.difficulty,_that.tags,_that.media,_that.status,_that.meta);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int version,  String deckId,  LocalizedText front,  LocalizedText back, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  MediaRef? media,  ContentStatus status,  ContentMeta? meta)?  $default,) {final _that = this;
switch (_that) {
case _Flashcard() when $default != null:
return $default(_that.id,_that.version,_that.deckId,_that.front,_that.back,_that.difficulty,_that.tags,_that.media,_that.status,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Flashcard implements Flashcard {
  const _Flashcard({required this.id, required this.version, required this.deckId, required this.front, required this.back, @JsonKey(fromJson: difficultyFromJson) required this.difficulty, required final  List<String> tags, this.media, this.status = ContentStatus.published, this.meta}): assert(difficulty >= minDifficulty && difficulty <= maxDifficulty, 'difficulty must be 1..5'),_tags = tags;
  factory _Flashcard.fromJson(Map<String, dynamic> json) => _$FlashcardFromJson(json);

@override final  String id;
@override final  int version;
@override final  String deckId;
@override final  LocalizedText front;
@override final  LocalizedText back;
@override@JsonKey(fromJson: difficultyFromJson) final  Difficulty difficulty;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  MediaRef? media;
@override@JsonKey() final  ContentStatus status;
@override final  ContentMeta? meta;

/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlashcardCopyWith<_Flashcard> get copyWith => __$FlashcardCopyWithImpl<_Flashcard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlashcardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Flashcard&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.deckId, deckId) || other.deckId == deckId)&&(identical(other.front, front) || other.front == front)&&(identical(other.back, back) || other.back == back)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.media, media) || other.media == media)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,deckId,front,back,difficulty,const DeepCollectionEquality().hash(_tags),media,status,meta);

@override
String toString() {
  return 'Flashcard(id: $id, version: $version, deckId: $deckId, front: $front, back: $back, difficulty: $difficulty, tags: $tags, media: $media, status: $status, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$FlashcardCopyWith<$Res> implements $FlashcardCopyWith<$Res> {
  factory _$FlashcardCopyWith(_Flashcard value, $Res Function(_Flashcard) _then) = __$FlashcardCopyWithImpl;
@override @useResult
$Res call({
 String id, int version, String deckId, LocalizedText front, LocalizedText back,@JsonKey(fromJson: difficultyFromJson) Difficulty difficulty, List<String> tags, MediaRef? media, ContentStatus status, ContentMeta? meta
});


@override $LocalizedTextCopyWith<$Res> get front;@override $LocalizedTextCopyWith<$Res> get back;@override $MediaRefCopyWith<$Res>? get media;@override $ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class __$FlashcardCopyWithImpl<$Res>
    implements _$FlashcardCopyWith<$Res> {
  __$FlashcardCopyWithImpl(this._self, this._then);

  final _Flashcard _self;
  final $Res Function(_Flashcard) _then;

/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? version = null,Object? deckId = null,Object? front = null,Object? back = null,Object? difficulty = null,Object? tags = null,Object? media = freezed,Object? status = null,Object? meta = freezed,}) {
  return _then(_Flashcard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,deckId: null == deckId ? _self.deckId : deckId // ignore: cast_nullable_to_non_nullable
as String,front: null == front ? _self.front : front // ignore: cast_nullable_to_non_nullable
as LocalizedText,back: null == back ? _self.back : back // ignore: cast_nullable_to_non_nullable
as LocalizedText,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as MediaRef?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}

/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get front {
  
  return $LocalizedTextCopyWith<$Res>(_self.front, (value) {
    return _then(_self.copyWith(front: value));
  });
}/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get back {
  
  return $LocalizedTextCopyWith<$Res>(_self.back, (value) {
    return _then(_self.copyWith(back: value));
  });
}/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaRefCopyWith<$Res>? get media {
    if (_self.media == null) {
    return null;
  }

  return $MediaRefCopyWith<$Res>(_self.media!, (value) {
    return _then(_self.copyWith(media: value));
  });
}/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $ContentMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
