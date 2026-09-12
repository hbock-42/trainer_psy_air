// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lexical_field.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LexicalFieldBank {

 String get familyId; List<LexicalField> get fields;
/// Create a copy of LexicalFieldBank
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LexicalFieldBankCopyWith<LexicalFieldBank> get copyWith => _$LexicalFieldBankCopyWithImpl<LexicalFieldBank>(this as LexicalFieldBank, _$identity);

  /// Serializes this LexicalFieldBank to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LexicalFieldBank&&(identical(other.familyId, familyId) || other.familyId == familyId)&&const DeepCollectionEquality().equals(other.fields, fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,const DeepCollectionEquality().hash(fields));

@override
String toString() {
  return 'LexicalFieldBank(familyId: $familyId, fields: $fields)';
}


}

/// @nodoc
abstract mixin class $LexicalFieldBankCopyWith<$Res>  {
  factory $LexicalFieldBankCopyWith(LexicalFieldBank value, $Res Function(LexicalFieldBank) _then) = _$LexicalFieldBankCopyWithImpl;
@useResult
$Res call({
 String familyId, List<LexicalField> fields
});




}
/// @nodoc
class _$LexicalFieldBankCopyWithImpl<$Res>
    implements $LexicalFieldBankCopyWith<$Res> {
  _$LexicalFieldBankCopyWithImpl(this._self, this._then);

  final LexicalFieldBank _self;
  final $Res Function(LexicalFieldBank) _then;

/// Create a copy of LexicalFieldBank
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? familyId = null,Object? fields = null,}) {
  return _then(_self.copyWith(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<LexicalField>,
  ));
}

}


/// Adds pattern-matching-related methods to [LexicalFieldBank].
extension LexicalFieldBankPatterns on LexicalFieldBank {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LexicalFieldBank value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LexicalFieldBank() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LexicalFieldBank value)  $default,){
final _that = this;
switch (_that) {
case _LexicalFieldBank():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LexicalFieldBank value)?  $default,){
final _that = this;
switch (_that) {
case _LexicalFieldBank() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String familyId,  List<LexicalField> fields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LexicalFieldBank() when $default != null:
return $default(_that.familyId,_that.fields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String familyId,  List<LexicalField> fields)  $default,) {final _that = this;
switch (_that) {
case _LexicalFieldBank():
return $default(_that.familyId,_that.fields);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String familyId,  List<LexicalField> fields)?  $default,) {final _that = this;
switch (_that) {
case _LexicalFieldBank() when $default != null:
return $default(_that.familyId,_that.fields);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LexicalFieldBank implements LexicalFieldBank {
  const _LexicalFieldBank({required this.familyId, required final  List<LexicalField> fields}): _fields = fields;
  factory _LexicalFieldBank.fromJson(Map<String, dynamic> json) => _$LexicalFieldBankFromJson(json);

@override final  String familyId;
 final  List<LexicalField> _fields;
@override List<LexicalField> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}


/// Create a copy of LexicalFieldBank
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LexicalFieldBankCopyWith<_LexicalFieldBank> get copyWith => __$LexicalFieldBankCopyWithImpl<_LexicalFieldBank>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LexicalFieldBankToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LexicalFieldBank&&(identical(other.familyId, familyId) || other.familyId == familyId)&&const DeepCollectionEquality().equals(other._fields, _fields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,const DeepCollectionEquality().hash(_fields));

@override
String toString() {
  return 'LexicalFieldBank(familyId: $familyId, fields: $fields)';
}


}

/// @nodoc
abstract mixin class _$LexicalFieldBankCopyWith<$Res> implements $LexicalFieldBankCopyWith<$Res> {
  factory _$LexicalFieldBankCopyWith(_LexicalFieldBank value, $Res Function(_LexicalFieldBank) _then) = __$LexicalFieldBankCopyWithImpl;
@override @useResult
$Res call({
 String familyId, List<LexicalField> fields
});




}
/// @nodoc
class __$LexicalFieldBankCopyWithImpl<$Res>
    implements _$LexicalFieldBankCopyWith<$Res> {
  __$LexicalFieldBankCopyWithImpl(this._self, this._then);

  final _LexicalFieldBank _self;
  final $Res Function(_LexicalFieldBank) _then;

/// Create a copy of LexicalFieldBank
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? familyId = null,Object? fields = null,}) {
  return _then(_LexicalFieldBank(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<LexicalField>,
  ));
}


}


/// @nodoc
mixin _$LexicalField {

 String get id; int get version; String get familyId; LocalizedText get name;@JsonKey(fromJson: difficultyFromJson) Difficulty get difficulty; List<String> get tags; List<String> get words; ContentLang get lang;/// Words that belong to this field but look like they belong to
/// [LexicalTrap.trapFor] (near misses).
 List<LexicalTrap> get traps;/// Fields that must never share a series with this one.
 List<String> get incompatibleWith; ContentStatus get status; ContentMeta? get meta;
/// Create a copy of LexicalField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LexicalFieldCopyWith<LexicalField> get copyWith => _$LexicalFieldCopyWithImpl<LexicalField>(this as LexicalField, _$identity);

  /// Serializes this LexicalField to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LexicalField&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.words, words)&&(identical(other.lang, lang) || other.lang == lang)&&const DeepCollectionEquality().equals(other.traps, traps)&&const DeepCollectionEquality().equals(other.incompatibleWith, incompatibleWith)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,familyId,name,difficulty,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(words),lang,const DeepCollectionEquality().hash(traps),const DeepCollectionEquality().hash(incompatibleWith),status,meta);

@override
String toString() {
  return 'LexicalField(id: $id, version: $version, familyId: $familyId, name: $name, difficulty: $difficulty, tags: $tags, words: $words, lang: $lang, traps: $traps, incompatibleWith: $incompatibleWith, status: $status, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $LexicalFieldCopyWith<$Res>  {
  factory $LexicalFieldCopyWith(LexicalField value, $Res Function(LexicalField) _then) = _$LexicalFieldCopyWithImpl;
@useResult
$Res call({
 String id, int version, String familyId, LocalizedText name,@JsonKey(fromJson: difficultyFromJson) Difficulty difficulty, List<String> tags, List<String> words, ContentLang lang, List<LexicalTrap> traps, List<String> incompatibleWith, ContentStatus status, ContentMeta? meta
});


$LocalizedTextCopyWith<$Res> get name;$ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class _$LexicalFieldCopyWithImpl<$Res>
    implements $LexicalFieldCopyWith<$Res> {
  _$LexicalFieldCopyWithImpl(this._self, this._then);

  final LexicalField _self;
  final $Res Function(LexicalField) _then;

/// Create a copy of LexicalField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? version = null,Object? familyId = null,Object? name = null,Object? difficulty = null,Object? tags = null,Object? words = null,Object? lang = null,Object? traps = null,Object? incompatibleWith = null,Object? status = null,Object? meta = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as List<String>,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as ContentLang,traps: null == traps ? _self.traps : traps // ignore: cast_nullable_to_non_nullable
as List<LexicalTrap>,incompatibleWith: null == incompatibleWith ? _self.incompatibleWith : incompatibleWith // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}
/// Create a copy of LexicalField
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get name {
  
  return $LocalizedTextCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of LexicalField
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


/// Adds pattern-matching-related methods to [LexicalField].
extension LexicalFieldPatterns on LexicalField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LexicalField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LexicalField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LexicalField value)  $default,){
final _that = this;
switch (_that) {
case _LexicalField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LexicalField value)?  $default,){
final _that = this;
switch (_that) {
case _LexicalField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int version,  String familyId,  LocalizedText name, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  List<String> words,  ContentLang lang,  List<LexicalTrap> traps,  List<String> incompatibleWith,  ContentStatus status,  ContentMeta? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LexicalField() when $default != null:
return $default(_that.id,_that.version,_that.familyId,_that.name,_that.difficulty,_that.tags,_that.words,_that.lang,_that.traps,_that.incompatibleWith,_that.status,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int version,  String familyId,  LocalizedText name, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  List<String> words,  ContentLang lang,  List<LexicalTrap> traps,  List<String> incompatibleWith,  ContentStatus status,  ContentMeta? meta)  $default,) {final _that = this;
switch (_that) {
case _LexicalField():
return $default(_that.id,_that.version,_that.familyId,_that.name,_that.difficulty,_that.tags,_that.words,_that.lang,_that.traps,_that.incompatibleWith,_that.status,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int version,  String familyId,  LocalizedText name, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  List<String> words,  ContentLang lang,  List<LexicalTrap> traps,  List<String> incompatibleWith,  ContentStatus status,  ContentMeta? meta)?  $default,) {final _that = this;
switch (_that) {
case _LexicalField() when $default != null:
return $default(_that.id,_that.version,_that.familyId,_that.name,_that.difficulty,_that.tags,_that.words,_that.lang,_that.traps,_that.incompatibleWith,_that.status,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LexicalField implements LexicalField {
  const _LexicalField({required this.id, required this.version, required this.familyId, required this.name, @JsonKey(fromJson: difficultyFromJson) required this.difficulty, required final  List<String> tags, required final  List<String> words, this.lang = ContentLang.fr, final  List<LexicalTrap> traps = const <LexicalTrap>[], final  List<String> incompatibleWith = const <String>[], this.status = ContentStatus.published, this.meta}): assert(difficulty >= minDifficulty && difficulty <= maxDifficulty, 'difficulty must be 1..5'),_tags = tags,_words = words,_traps = traps,_incompatibleWith = incompatibleWith;
  factory _LexicalField.fromJson(Map<String, dynamic> json) => _$LexicalFieldFromJson(json);

@override final  String id;
@override final  int version;
@override final  String familyId;
@override final  LocalizedText name;
@override@JsonKey(fromJson: difficultyFromJson) final  Difficulty difficulty;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<String> _words;
@override List<String> get words {
  if (_words is EqualUnmodifiableListView) return _words;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_words);
}

@override@JsonKey() final  ContentLang lang;
/// Words that belong to this field but look like they belong to
/// [LexicalTrap.trapFor] (near misses).
 final  List<LexicalTrap> _traps;
/// Words that belong to this field but look like they belong to
/// [LexicalTrap.trapFor] (near misses).
@override@JsonKey() List<LexicalTrap> get traps {
  if (_traps is EqualUnmodifiableListView) return _traps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_traps);
}

/// Fields that must never share a series with this one.
 final  List<String> _incompatibleWith;
/// Fields that must never share a series with this one.
@override@JsonKey() List<String> get incompatibleWith {
  if (_incompatibleWith is EqualUnmodifiableListView) return _incompatibleWith;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_incompatibleWith);
}

@override@JsonKey() final  ContentStatus status;
@override final  ContentMeta? meta;

/// Create a copy of LexicalField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LexicalFieldCopyWith<_LexicalField> get copyWith => __$LexicalFieldCopyWithImpl<_LexicalField>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LexicalFieldToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LexicalField&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._words, _words)&&(identical(other.lang, lang) || other.lang == lang)&&const DeepCollectionEquality().equals(other._traps, _traps)&&const DeepCollectionEquality().equals(other._incompatibleWith, _incompatibleWith)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,familyId,name,difficulty,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_words),lang,const DeepCollectionEquality().hash(_traps),const DeepCollectionEquality().hash(_incompatibleWith),status,meta);

@override
String toString() {
  return 'LexicalField(id: $id, version: $version, familyId: $familyId, name: $name, difficulty: $difficulty, tags: $tags, words: $words, lang: $lang, traps: $traps, incompatibleWith: $incompatibleWith, status: $status, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$LexicalFieldCopyWith<$Res> implements $LexicalFieldCopyWith<$Res> {
  factory _$LexicalFieldCopyWith(_LexicalField value, $Res Function(_LexicalField) _then) = __$LexicalFieldCopyWithImpl;
@override @useResult
$Res call({
 String id, int version, String familyId, LocalizedText name,@JsonKey(fromJson: difficultyFromJson) Difficulty difficulty, List<String> tags, List<String> words, ContentLang lang, List<LexicalTrap> traps, List<String> incompatibleWith, ContentStatus status, ContentMeta? meta
});


@override $LocalizedTextCopyWith<$Res> get name;@override $ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class __$LexicalFieldCopyWithImpl<$Res>
    implements _$LexicalFieldCopyWith<$Res> {
  __$LexicalFieldCopyWithImpl(this._self, this._then);

  final _LexicalField _self;
  final $Res Function(_LexicalField) _then;

/// Create a copy of LexicalField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? version = null,Object? familyId = null,Object? name = null,Object? difficulty = null,Object? tags = null,Object? words = null,Object? lang = null,Object? traps = null,Object? incompatibleWith = null,Object? status = null,Object? meta = freezed,}) {
  return _then(_LexicalField(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,words: null == words ? _self._words : words // ignore: cast_nullable_to_non_nullable
as List<String>,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as ContentLang,traps: null == traps ? _self._traps : traps // ignore: cast_nullable_to_non_nullable
as List<LexicalTrap>,incompatibleWith: null == incompatibleWith ? _self._incompatibleWith : incompatibleWith // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}

/// Create a copy of LexicalField
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get name {
  
  return $LocalizedTextCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of LexicalField
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
mixin _$LexicalTrap {

 String get word; String get trapFor;
/// Create a copy of LexicalTrap
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LexicalTrapCopyWith<LexicalTrap> get copyWith => _$LexicalTrapCopyWithImpl<LexicalTrap>(this as LexicalTrap, _$identity);

  /// Serializes this LexicalTrap to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LexicalTrap&&(identical(other.word, word) || other.word == word)&&(identical(other.trapFor, trapFor) || other.trapFor == trapFor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,trapFor);

@override
String toString() {
  return 'LexicalTrap(word: $word, trapFor: $trapFor)';
}


}

/// @nodoc
abstract mixin class $LexicalTrapCopyWith<$Res>  {
  factory $LexicalTrapCopyWith(LexicalTrap value, $Res Function(LexicalTrap) _then) = _$LexicalTrapCopyWithImpl;
@useResult
$Res call({
 String word, String trapFor
});




}
/// @nodoc
class _$LexicalTrapCopyWithImpl<$Res>
    implements $LexicalTrapCopyWith<$Res> {
  _$LexicalTrapCopyWithImpl(this._self, this._then);

  final LexicalTrap _self;
  final $Res Function(LexicalTrap) _then;

/// Create a copy of LexicalTrap
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? word = null,Object? trapFor = null,}) {
  return _then(_self.copyWith(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,trapFor: null == trapFor ? _self.trapFor : trapFor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LexicalTrap].
extension LexicalTrapPatterns on LexicalTrap {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LexicalTrap value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LexicalTrap() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LexicalTrap value)  $default,){
final _that = this;
switch (_that) {
case _LexicalTrap():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LexicalTrap value)?  $default,){
final _that = this;
switch (_that) {
case _LexicalTrap() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String word,  String trapFor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LexicalTrap() when $default != null:
return $default(_that.word,_that.trapFor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String word,  String trapFor)  $default,) {final _that = this;
switch (_that) {
case _LexicalTrap():
return $default(_that.word,_that.trapFor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String word,  String trapFor)?  $default,) {final _that = this;
switch (_that) {
case _LexicalTrap() when $default != null:
return $default(_that.word,_that.trapFor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LexicalTrap implements LexicalTrap {
  const _LexicalTrap({required this.word, required this.trapFor});
  factory _LexicalTrap.fromJson(Map<String, dynamic> json) => _$LexicalTrapFromJson(json);

@override final  String word;
@override final  String trapFor;

/// Create a copy of LexicalTrap
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LexicalTrapCopyWith<_LexicalTrap> get copyWith => __$LexicalTrapCopyWithImpl<_LexicalTrap>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LexicalTrapToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LexicalTrap&&(identical(other.word, word) || other.word == word)&&(identical(other.trapFor, trapFor) || other.trapFor == trapFor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,trapFor);

@override
String toString() {
  return 'LexicalTrap(word: $word, trapFor: $trapFor)';
}


}

/// @nodoc
abstract mixin class _$LexicalTrapCopyWith<$Res> implements $LexicalTrapCopyWith<$Res> {
  factory _$LexicalTrapCopyWith(_LexicalTrap value, $Res Function(_LexicalTrap) _then) = __$LexicalTrapCopyWithImpl;
@override @useResult
$Res call({
 String word, String trapFor
});




}
/// @nodoc
class __$LexicalTrapCopyWithImpl<$Res>
    implements _$LexicalTrapCopyWith<$Res> {
  __$LexicalTrapCopyWithImpl(this._self, this._then);

  final _LexicalTrap _self;
  final $Res Function(_LexicalTrap) _then;

/// Create a copy of LexicalTrap
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? word = null,Object? trapFor = null,}) {
  return _then(_LexicalTrap(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,trapFor: null == trapFor ? _self.trapFor : trapFor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
