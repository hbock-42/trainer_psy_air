// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItemBank {

 String get familyId; List<Item> get items; List<Passage> get passages;
/// Create a copy of ItemBank
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemBankCopyWith<ItemBank> get copyWith => _$ItemBankCopyWithImpl<ItemBank>(this as ItemBank, _$identity);

  /// Serializes this ItemBank to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemBank&&(identical(other.familyId, familyId) || other.familyId == familyId)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.passages, passages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(passages));

@override
String toString() {
  return 'ItemBank(familyId: $familyId, items: $items, passages: $passages)';
}


}

/// @nodoc
abstract mixin class $ItemBankCopyWith<$Res>  {
  factory $ItemBankCopyWith(ItemBank value, $Res Function(ItemBank) _then) = _$ItemBankCopyWithImpl;
@useResult
$Res call({
 String familyId, List<Item> items, List<Passage> passages
});




}
/// @nodoc
class _$ItemBankCopyWithImpl<$Res>
    implements $ItemBankCopyWith<$Res> {
  _$ItemBankCopyWithImpl(this._self, this._then);

  final ItemBank _self;
  final $Res Function(ItemBank) _then;

/// Create a copy of ItemBank
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? familyId = null,Object? items = null,Object? passages = null,}) {
  return _then(_self.copyWith(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Item>,passages: null == passages ? _self.passages : passages // ignore: cast_nullable_to_non_nullable
as List<Passage>,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemBank].
extension ItemBankPatterns on ItemBank {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemBank value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemBank() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemBank value)  $default,){
final _that = this;
switch (_that) {
case _ItemBank():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemBank value)?  $default,){
final _that = this;
switch (_that) {
case _ItemBank() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String familyId,  List<Item> items,  List<Passage> passages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemBank() when $default != null:
return $default(_that.familyId,_that.items,_that.passages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String familyId,  List<Item> items,  List<Passage> passages)  $default,) {final _that = this;
switch (_that) {
case _ItemBank():
return $default(_that.familyId,_that.items,_that.passages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String familyId,  List<Item> items,  List<Passage> passages)?  $default,) {final _that = this;
switch (_that) {
case _ItemBank() when $default != null:
return $default(_that.familyId,_that.items,_that.passages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemBank implements ItemBank {
  const _ItemBank({required this.familyId, required final  List<Item> items, final  List<Passage> passages = const <Passage>[]}): _items = items,_passages = passages;
  factory _ItemBank.fromJson(Map<String, dynamic> json) => _$ItemBankFromJson(json);

@override final  String familyId;
 final  List<Item> _items;
@override List<Item> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<Passage> _passages;
@override@JsonKey() List<Passage> get passages {
  if (_passages is EqualUnmodifiableListView) return _passages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_passages);
}


/// Create a copy of ItemBank
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemBankCopyWith<_ItemBank> get copyWith => __$ItemBankCopyWithImpl<_ItemBank>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemBankToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemBank&&(identical(other.familyId, familyId) || other.familyId == familyId)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._passages, _passages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_passages));

@override
String toString() {
  return 'ItemBank(familyId: $familyId, items: $items, passages: $passages)';
}


}

/// @nodoc
abstract mixin class _$ItemBankCopyWith<$Res> implements $ItemBankCopyWith<$Res> {
  factory _$ItemBankCopyWith(_ItemBank value, $Res Function(_ItemBank) _then) = __$ItemBankCopyWithImpl;
@override @useResult
$Res call({
 String familyId, List<Item> items, List<Passage> passages
});




}
/// @nodoc
class __$ItemBankCopyWithImpl<$Res>
    implements _$ItemBankCopyWith<$Res> {
  __$ItemBankCopyWithImpl(this._self, this._then);

  final _ItemBank _self;
  final $Res Function(_ItemBank) _then;

/// Create a copy of ItemBank
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? familyId = null,Object? items = null,Object? passages = null,}) {
  return _then(_ItemBank(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Item>,passages: null == passages ? _self._passages : passages // ignore: cast_nullable_to_non_nullable
as List<Passage>,
  ));
}


}


/// @nodoc
mixin _$Passage {

 String get id; LocalizedText get body; LocalizedText? get title; MediaRef? get media; ContentLang? get lang;
/// Create a copy of Passage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PassageCopyWith<Passage> get copyWith => _$PassageCopyWithImpl<Passage>(this as Passage, _$identity);

  /// Serializes this Passage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Passage&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body)&&(identical(other.title, title) || other.title == title)&&(identical(other.media, media) || other.media == media)&&(identical(other.lang, lang) || other.lang == lang));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,body,title,media,lang);

@override
String toString() {
  return 'Passage(id: $id, body: $body, title: $title, media: $media, lang: $lang)';
}


}

/// @nodoc
abstract mixin class $PassageCopyWith<$Res>  {
  factory $PassageCopyWith(Passage value, $Res Function(Passage) _then) = _$PassageCopyWithImpl;
@useResult
$Res call({
 String id, LocalizedText body, LocalizedText? title, MediaRef? media, ContentLang? lang
});


$LocalizedTextCopyWith<$Res> get body;$LocalizedTextCopyWith<$Res>? get title;$MediaRefCopyWith<$Res>? get media;

}
/// @nodoc
class _$PassageCopyWithImpl<$Res>
    implements $PassageCopyWith<$Res> {
  _$PassageCopyWithImpl(this._self, this._then);

  final Passage _self;
  final $Res Function(Passage) _then;

/// Create a copy of Passage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? body = null,Object? title = freezed,Object? media = freezed,Object? lang = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as LocalizedText,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as LocalizedText?,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as MediaRef?,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as ContentLang?,
  ));
}
/// Create a copy of Passage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get body {
  
  return $LocalizedTextCopyWith<$Res>(_self.body, (value) {
    return _then(_self.copyWith(body: value));
  });
}/// Create a copy of Passage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get title {
    if (_self.title == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.title!, (value) {
    return _then(_self.copyWith(title: value));
  });
}/// Create a copy of Passage
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
}
}


/// Adds pattern-matching-related methods to [Passage].
extension PassagePatterns on Passage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Passage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Passage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Passage value)  $default,){
final _that = this;
switch (_that) {
case _Passage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Passage value)?  $default,){
final _that = this;
switch (_that) {
case _Passage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LocalizedText body,  LocalizedText? title,  MediaRef? media,  ContentLang? lang)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Passage() when $default != null:
return $default(_that.id,_that.body,_that.title,_that.media,_that.lang);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LocalizedText body,  LocalizedText? title,  MediaRef? media,  ContentLang? lang)  $default,) {final _that = this;
switch (_that) {
case _Passage():
return $default(_that.id,_that.body,_that.title,_that.media,_that.lang);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LocalizedText body,  LocalizedText? title,  MediaRef? media,  ContentLang? lang)?  $default,) {final _that = this;
switch (_that) {
case _Passage() when $default != null:
return $default(_that.id,_that.body,_that.title,_that.media,_that.lang);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Passage implements Passage {
  const _Passage({required this.id, required this.body, this.title, this.media, this.lang});
  factory _Passage.fromJson(Map<String, dynamic> json) => _$PassageFromJson(json);

@override final  String id;
@override final  LocalizedText body;
@override final  LocalizedText? title;
@override final  MediaRef? media;
@override final  ContentLang? lang;

/// Create a copy of Passage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PassageCopyWith<_Passage> get copyWith => __$PassageCopyWithImpl<_Passage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PassageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Passage&&(identical(other.id, id) || other.id == id)&&(identical(other.body, body) || other.body == body)&&(identical(other.title, title) || other.title == title)&&(identical(other.media, media) || other.media == media)&&(identical(other.lang, lang) || other.lang == lang));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,body,title,media,lang);

@override
String toString() {
  return 'Passage(id: $id, body: $body, title: $title, media: $media, lang: $lang)';
}


}

/// @nodoc
abstract mixin class _$PassageCopyWith<$Res> implements $PassageCopyWith<$Res> {
  factory _$PassageCopyWith(_Passage value, $Res Function(_Passage) _then) = __$PassageCopyWithImpl;
@override @useResult
$Res call({
 String id, LocalizedText body, LocalizedText? title, MediaRef? media, ContentLang? lang
});


@override $LocalizedTextCopyWith<$Res> get body;@override $LocalizedTextCopyWith<$Res>? get title;@override $MediaRefCopyWith<$Res>? get media;

}
/// @nodoc
class __$PassageCopyWithImpl<$Res>
    implements _$PassageCopyWith<$Res> {
  __$PassageCopyWithImpl(this._self, this._then);

  final _Passage _self;
  final $Res Function(_Passage) _then;

/// Create a copy of Passage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? body = null,Object? title = freezed,Object? media = freezed,Object? lang = freezed,}) {
  return _then(_Passage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as LocalizedText,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as LocalizedText?,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as MediaRef?,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as ContentLang?,
  ));
}

/// Create a copy of Passage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get body {
  
  return $LocalizedTextCopyWith<$Res>(_self.body, (value) {
    return _then(_self.copyWith(body: value));
  });
}/// Create a copy of Passage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get title {
    if (_self.title == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.title!, (value) {
    return _then(_self.copyWith(title: value));
  });
}/// Create a copy of Passage
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
}
}


/// @nodoc
mixin _$McqOption {

 LocalizedText? get text; MediaRef? get media;
/// Create a copy of McqOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$McqOptionCopyWith<McqOption> get copyWith => _$McqOptionCopyWithImpl<McqOption>(this as McqOption, _$identity);

  /// Serializes this McqOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is McqOption&&(identical(other.text, text) || other.text == text)&&(identical(other.media, media) || other.media == media));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,media);

@override
String toString() {
  return 'McqOption(text: $text, media: $media)';
}


}

/// @nodoc
abstract mixin class $McqOptionCopyWith<$Res>  {
  factory $McqOptionCopyWith(McqOption value, $Res Function(McqOption) _then) = _$McqOptionCopyWithImpl;
@useResult
$Res call({
 LocalizedText? text, MediaRef? media
});


$LocalizedTextCopyWith<$Res>? get text;$MediaRefCopyWith<$Res>? get media;

}
/// @nodoc
class _$McqOptionCopyWithImpl<$Res>
    implements $McqOptionCopyWith<$Res> {
  _$McqOptionCopyWithImpl(this._self, this._then);

  final McqOption _self;
  final $Res Function(McqOption) _then;

/// Create a copy of McqOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = freezed,Object? media = freezed,}) {
  return _then(_self.copyWith(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as LocalizedText?,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as MediaRef?,
  ));
}
/// Create a copy of McqOption
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get text {
    if (_self.text == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.text!, (value) {
    return _then(_self.copyWith(text: value));
  });
}/// Create a copy of McqOption
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
}
}


/// Adds pattern-matching-related methods to [McqOption].
extension McqOptionPatterns on McqOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _McqOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _McqOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _McqOption value)  $default,){
final _that = this;
switch (_that) {
case _McqOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _McqOption value)?  $default,){
final _that = this;
switch (_that) {
case _McqOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LocalizedText? text,  MediaRef? media)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _McqOption() when $default != null:
return $default(_that.text,_that.media);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LocalizedText? text,  MediaRef? media)  $default,) {final _that = this;
switch (_that) {
case _McqOption():
return $default(_that.text,_that.media);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LocalizedText? text,  MediaRef? media)?  $default,) {final _that = this;
switch (_that) {
case _McqOption() when $default != null:
return $default(_that.text,_that.media);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _McqOption implements McqOption {
  const _McqOption({this.text, this.media});
  factory _McqOption.fromJson(Map<String, dynamic> json) => _$McqOptionFromJson(json);

@override final  LocalizedText? text;
@override final  MediaRef? media;

/// Create a copy of McqOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$McqOptionCopyWith<_McqOption> get copyWith => __$McqOptionCopyWithImpl<_McqOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$McqOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _McqOption&&(identical(other.text, text) || other.text == text)&&(identical(other.media, media) || other.media == media));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,media);

@override
String toString() {
  return 'McqOption(text: $text, media: $media)';
}


}

/// @nodoc
abstract mixin class _$McqOptionCopyWith<$Res> implements $McqOptionCopyWith<$Res> {
  factory _$McqOptionCopyWith(_McqOption value, $Res Function(_McqOption) _then) = __$McqOptionCopyWithImpl;
@override @useResult
$Res call({
 LocalizedText? text, MediaRef? media
});


@override $LocalizedTextCopyWith<$Res>? get text;@override $MediaRefCopyWith<$Res>? get media;

}
/// @nodoc
class __$McqOptionCopyWithImpl<$Res>
    implements _$McqOptionCopyWith<$Res> {
  __$McqOptionCopyWithImpl(this._self, this._then);

  final _McqOption _self;
  final $Res Function(_McqOption) _then;

/// Create a copy of McqOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = freezed,Object? media = freezed,}) {
  return _then(_McqOption(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as LocalizedText?,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as MediaRef?,
  ));
}

/// Create a copy of McqOption
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get text {
    if (_self.text == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.text!, (value) {
    return _then(_self.copyWith(text: value));
  });
}/// Create a copy of McqOption
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
}
}


/// @nodoc
mixin _$Tolerance {

 ToleranceMode get mode; num get value;
/// Create a copy of Tolerance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToleranceCopyWith<Tolerance> get copyWith => _$ToleranceCopyWithImpl<Tolerance>(this as Tolerance, _$identity);

  /// Serializes this Tolerance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tolerance&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,value);

@override
String toString() {
  return 'Tolerance(mode: $mode, value: $value)';
}


}

/// @nodoc
abstract mixin class $ToleranceCopyWith<$Res>  {
  factory $ToleranceCopyWith(Tolerance value, $Res Function(Tolerance) _then) = _$ToleranceCopyWithImpl;
@useResult
$Res call({
 ToleranceMode mode, num value
});




}
/// @nodoc
class _$ToleranceCopyWithImpl<$Res>
    implements $ToleranceCopyWith<$Res> {
  _$ToleranceCopyWithImpl(this._self, this._then);

  final Tolerance _self;
  final $Res Function(Tolerance) _then;

/// Create a copy of Tolerance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? value = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ToleranceMode,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [Tolerance].
extension TolerancePatterns on Tolerance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tolerance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tolerance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tolerance value)  $default,){
final _that = this;
switch (_that) {
case _Tolerance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tolerance value)?  $default,){
final _that = this;
switch (_that) {
case _Tolerance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ToleranceMode mode,  num value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tolerance() when $default != null:
return $default(_that.mode,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ToleranceMode mode,  num value)  $default,) {final _that = this;
switch (_that) {
case _Tolerance():
return $default(_that.mode,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ToleranceMode mode,  num value)?  $default,) {final _that = this;
switch (_that) {
case _Tolerance() when $default != null:
return $default(_that.mode,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Tolerance implements Tolerance {
  const _Tolerance({required this.mode, required this.value});
  factory _Tolerance.fromJson(Map<String, dynamic> json) => _$ToleranceFromJson(json);

@override final  ToleranceMode mode;
@override final  num value;

/// Create a copy of Tolerance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToleranceCopyWith<_Tolerance> get copyWith => __$ToleranceCopyWithImpl<_Tolerance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ToleranceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tolerance&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,value);

@override
String toString() {
  return 'Tolerance(mode: $mode, value: $value)';
}


}

/// @nodoc
abstract mixin class _$ToleranceCopyWith<$Res> implements $ToleranceCopyWith<$Res> {
  factory _$ToleranceCopyWith(_Tolerance value, $Res Function(_Tolerance) _then) = __$ToleranceCopyWithImpl;
@override @useResult
$Res call({
 ToleranceMode mode, num value
});




}
/// @nodoc
class __$ToleranceCopyWithImpl<$Res>
    implements _$ToleranceCopyWith<$Res> {
  __$ToleranceCopyWithImpl(this._self, this._then);

  final _Tolerance _self;
  final $Res Function(_Tolerance) _then;

/// Create a copy of Tolerance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? value = null,}) {
  return _then(_Tolerance(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ToleranceMode,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}


/// @nodoc
mixin _$ItemOrigin {

 GeneratorId get generatorId; int get seed; int? get runSeed; int? get index;
/// Create a copy of ItemOrigin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemOriginCopyWith<ItemOrigin> get copyWith => _$ItemOriginCopyWithImpl<ItemOrigin>(this as ItemOrigin, _$identity);

  /// Serializes this ItemOrigin to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemOrigin&&(identical(other.generatorId, generatorId) || other.generatorId == generatorId)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.runSeed, runSeed) || other.runSeed == runSeed)&&(identical(other.index, index) || other.index == index));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatorId,seed,runSeed,index);

@override
String toString() {
  return 'ItemOrigin(generatorId: $generatorId, seed: $seed, runSeed: $runSeed, index: $index)';
}


}

/// @nodoc
abstract mixin class $ItemOriginCopyWith<$Res>  {
  factory $ItemOriginCopyWith(ItemOrigin value, $Res Function(ItemOrigin) _then) = _$ItemOriginCopyWithImpl;
@useResult
$Res call({
 GeneratorId generatorId, int seed, int? runSeed, int? index
});




}
/// @nodoc
class _$ItemOriginCopyWithImpl<$Res>
    implements $ItemOriginCopyWith<$Res> {
  _$ItemOriginCopyWithImpl(this._self, this._then);

  final ItemOrigin _self;
  final $Res Function(ItemOrigin) _then;

/// Create a copy of ItemOrigin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? generatorId = null,Object? seed = null,Object? runSeed = freezed,Object? index = freezed,}) {
  return _then(_self.copyWith(
generatorId: null == generatorId ? _self.generatorId : generatorId // ignore: cast_nullable_to_non_nullable
as GeneratorId,seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,runSeed: freezed == runSeed ? _self.runSeed : runSeed // ignore: cast_nullable_to_non_nullable
as int?,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemOrigin].
extension ItemOriginPatterns on ItemOrigin {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemOrigin value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemOrigin() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemOrigin value)  $default,){
final _that = this;
switch (_that) {
case _ItemOrigin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemOrigin value)?  $default,){
final _that = this;
switch (_that) {
case _ItemOrigin() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GeneratorId generatorId,  int seed,  int? runSeed,  int? index)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemOrigin() when $default != null:
return $default(_that.generatorId,_that.seed,_that.runSeed,_that.index);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GeneratorId generatorId,  int seed,  int? runSeed,  int? index)  $default,) {final _that = this;
switch (_that) {
case _ItemOrigin():
return $default(_that.generatorId,_that.seed,_that.runSeed,_that.index);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GeneratorId generatorId,  int seed,  int? runSeed,  int? index)?  $default,) {final _that = this;
switch (_that) {
case _ItemOrigin() when $default != null:
return $default(_that.generatorId,_that.seed,_that.runSeed,_that.index);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemOrigin implements ItemOrigin {
  const _ItemOrigin({required this.generatorId, required this.seed, this.runSeed, this.index});
  factory _ItemOrigin.fromJson(Map<String, dynamic> json) => _$ItemOriginFromJson(json);

@override final  GeneratorId generatorId;
@override final  int seed;
@override final  int? runSeed;
@override final  int? index;

/// Create a copy of ItemOrigin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemOriginCopyWith<_ItemOrigin> get copyWith => __$ItemOriginCopyWithImpl<_ItemOrigin>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemOriginToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemOrigin&&(identical(other.generatorId, generatorId) || other.generatorId == generatorId)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.runSeed, runSeed) || other.runSeed == runSeed)&&(identical(other.index, index) || other.index == index));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatorId,seed,runSeed,index);

@override
String toString() {
  return 'ItemOrigin(generatorId: $generatorId, seed: $seed, runSeed: $runSeed, index: $index)';
}


}

/// @nodoc
abstract mixin class _$ItemOriginCopyWith<$Res> implements $ItemOriginCopyWith<$Res> {
  factory _$ItemOriginCopyWith(_ItemOrigin value, $Res Function(_ItemOrigin) _then) = __$ItemOriginCopyWithImpl;
@override @useResult
$Res call({
 GeneratorId generatorId, int seed, int? runSeed, int? index
});




}
/// @nodoc
class __$ItemOriginCopyWithImpl<$Res>
    implements _$ItemOriginCopyWith<$Res> {
  __$ItemOriginCopyWithImpl(this._self, this._then);

  final _ItemOrigin _self;
  final $Res Function(_ItemOrigin) _then;

/// Create a copy of ItemOrigin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? generatorId = null,Object? seed = null,Object? runSeed = freezed,Object? index = freezed,}) {
  return _then(_ItemOrigin(
generatorId: null == generatorId ? _self.generatorId : generatorId // ignore: cast_nullable_to_non_nullable
as GeneratorId,seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,runSeed: freezed == runSeed ? _self.runSeed : runSeed // ignore: cast_nullable_to_non_nullable
as int?,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

Item _$ItemFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'mcq':
          return McqItem.fromJson(
            json
          );
                case 'numeric':
          return NumericItem.fromJson(
            json
          );
                case 'sequence':
          return SequenceItem.fromJson(
            json
          );
                case 'generated':
          return GeneratedItem.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'Item',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$Item {

 String get id; int get version; String get familyId;@JsonKey(fromJson: difficultyFromJson) Difficulty get difficulty; List<String> get tags; ContentLang? get lang; ContentStatus get status; ItemOrigin? get origin; ContentMeta? get meta;
/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemCopyWith<Item> get copyWith => _$ItemCopyWithImpl<Item>(this as Item, _$identity);

  /// Serializes this Item to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Item&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.status, status) || other.status == status)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,familyId,difficulty,const DeepCollectionEquality().hash(tags),lang,status,origin,meta);

@override
String toString() {
  return 'Item(id: $id, version: $version, familyId: $familyId, difficulty: $difficulty, tags: $tags, lang: $lang, status: $status, origin: $origin, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $ItemCopyWith<$Res>  {
  factory $ItemCopyWith(Item value, $Res Function(Item) _then) = _$ItemCopyWithImpl;
@useResult
$Res call({
 String id, int version, String familyId,@JsonKey(fromJson: difficultyFromJson) int difficulty, List<String> tags, ContentLang? lang, ContentStatus status, ItemOrigin? origin, ContentMeta? meta
});


$ItemOriginCopyWith<$Res>? get origin;$ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class _$ItemCopyWithImpl<$Res>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._self, this._then);

  final Item _self;
  final $Res Function(Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? version = null,Object? familyId = null,Object? difficulty = null,Object? tags = null,Object? lang = freezed,Object? status = null,Object? origin = freezed,Object? meta = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as ContentLang?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as ItemOrigin?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}
/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemOriginCopyWith<$Res>? get origin {
    if (_self.origin == null) {
    return null;
  }

  return $ItemOriginCopyWith<$Res>(_self.origin!, (value) {
    return _then(_self.copyWith(origin: value));
  });
}/// Create a copy of Item
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


/// Adds pattern-matching-related methods to [Item].
extension ItemPatterns on Item {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( McqItem value)?  mcq,TResult Function( NumericItem value)?  numeric,TResult Function( SequenceItem value)?  sequence,TResult Function( GeneratedItem value)?  generated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case McqItem() when mcq != null:
return mcq(_that);case NumericItem() when numeric != null:
return numeric(_that);case SequenceItem() when sequence != null:
return sequence(_that);case GeneratedItem() when generated != null:
return generated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( McqItem value)  mcq,required TResult Function( NumericItem value)  numeric,required TResult Function( SequenceItem value)  sequence,required TResult Function( GeneratedItem value)  generated,}){
final _that = this;
switch (_that) {
case McqItem():
return mcq(_that);case NumericItem():
return numeric(_that);case SequenceItem():
return sequence(_that);case GeneratedItem():
return generated(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( McqItem value)?  mcq,TResult? Function( NumericItem value)?  numeric,TResult? Function( SequenceItem value)?  sequence,TResult? Function( GeneratedItem value)?  generated,}){
final _that = this;
switch (_that) {
case McqItem() when mcq != null:
return mcq(_that);case NumericItem() when numeric != null:
return numeric(_that);case SequenceItem() when sequence != null:
return sequence(_that);case GeneratedItem() when generated != null:
return generated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  int version,  String familyId, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  LocalizedText stem,  List<McqOption> options,  int correctIndex,  LocalizedText explanation,  ContentLang? lang,  ContentStatus status,  ItemOrigin? origin,  ContentMeta? meta,  MediaRef? media,  String? passageId,  bool shuffleOptions,  bool allowSkip, @DateOnlyConverter()  DateTime? validAsOf)?  mcq,TResult Function( String id,  int version,  String familyId, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  LocalizedText stem,  num expected,  LocalizedText explanation,  ContentLang? lang,  ContentStatus status,  ItemOrigin? origin,  ContentMeta? meta,  MediaRef? media,  Tolerance? tolerance,  String? unit,  InputFormat inputFormat,  int decimals)?  numeric,TResult Function( String id,  int version,  String familyId, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  StimulusKind stimulusKind,  List<String> stimulus,  RecallMode recallMode,  ContentLang? lang,  ContentStatus status,  ItemOrigin? origin,  ContentMeta? meta,  LocalizedText? instructions,  GridSize? grid,  int presentationMs,  int gapMs,  LocalizedText? explanation)?  sequence,TResult Function( String id,  int version,  String familyId, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  GeneratorId generatorId,  int seed, @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson)  GeneratorParams params,  ContentLang? lang,  ContentStatus status,  ItemOrigin? origin,  ContentMeta? meta)?  generated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case McqItem() when mcq != null:
return mcq(_that.id,_that.version,_that.familyId,_that.difficulty,_that.tags,_that.stem,_that.options,_that.correctIndex,_that.explanation,_that.lang,_that.status,_that.origin,_that.meta,_that.media,_that.passageId,_that.shuffleOptions,_that.allowSkip,_that.validAsOf);case NumericItem() when numeric != null:
return numeric(_that.id,_that.version,_that.familyId,_that.difficulty,_that.tags,_that.stem,_that.expected,_that.explanation,_that.lang,_that.status,_that.origin,_that.meta,_that.media,_that.tolerance,_that.unit,_that.inputFormat,_that.decimals);case SequenceItem() when sequence != null:
return sequence(_that.id,_that.version,_that.familyId,_that.difficulty,_that.tags,_that.stimulusKind,_that.stimulus,_that.recallMode,_that.lang,_that.status,_that.origin,_that.meta,_that.instructions,_that.grid,_that.presentationMs,_that.gapMs,_that.explanation);case GeneratedItem() when generated != null:
return generated(_that.id,_that.version,_that.familyId,_that.difficulty,_that.tags,_that.generatorId,_that.seed,_that.params,_that.lang,_that.status,_that.origin,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  int version,  String familyId, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  LocalizedText stem,  List<McqOption> options,  int correctIndex,  LocalizedText explanation,  ContentLang? lang,  ContentStatus status,  ItemOrigin? origin,  ContentMeta? meta,  MediaRef? media,  String? passageId,  bool shuffleOptions,  bool allowSkip, @DateOnlyConverter()  DateTime? validAsOf)  mcq,required TResult Function( String id,  int version,  String familyId, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  LocalizedText stem,  num expected,  LocalizedText explanation,  ContentLang? lang,  ContentStatus status,  ItemOrigin? origin,  ContentMeta? meta,  MediaRef? media,  Tolerance? tolerance,  String? unit,  InputFormat inputFormat,  int decimals)  numeric,required TResult Function( String id,  int version,  String familyId, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  StimulusKind stimulusKind,  List<String> stimulus,  RecallMode recallMode,  ContentLang? lang,  ContentStatus status,  ItemOrigin? origin,  ContentMeta? meta,  LocalizedText? instructions,  GridSize? grid,  int presentationMs,  int gapMs,  LocalizedText? explanation)  sequence,required TResult Function( String id,  int version,  String familyId, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  GeneratorId generatorId,  int seed, @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson)  GeneratorParams params,  ContentLang? lang,  ContentStatus status,  ItemOrigin? origin,  ContentMeta? meta)  generated,}) {final _that = this;
switch (_that) {
case McqItem():
return mcq(_that.id,_that.version,_that.familyId,_that.difficulty,_that.tags,_that.stem,_that.options,_that.correctIndex,_that.explanation,_that.lang,_that.status,_that.origin,_that.meta,_that.media,_that.passageId,_that.shuffleOptions,_that.allowSkip,_that.validAsOf);case NumericItem():
return numeric(_that.id,_that.version,_that.familyId,_that.difficulty,_that.tags,_that.stem,_that.expected,_that.explanation,_that.lang,_that.status,_that.origin,_that.meta,_that.media,_that.tolerance,_that.unit,_that.inputFormat,_that.decimals);case SequenceItem():
return sequence(_that.id,_that.version,_that.familyId,_that.difficulty,_that.tags,_that.stimulusKind,_that.stimulus,_that.recallMode,_that.lang,_that.status,_that.origin,_that.meta,_that.instructions,_that.grid,_that.presentationMs,_that.gapMs,_that.explanation);case GeneratedItem():
return generated(_that.id,_that.version,_that.familyId,_that.difficulty,_that.tags,_that.generatorId,_that.seed,_that.params,_that.lang,_that.status,_that.origin,_that.meta);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  int version,  String familyId, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  LocalizedText stem,  List<McqOption> options,  int correctIndex,  LocalizedText explanation,  ContentLang? lang,  ContentStatus status,  ItemOrigin? origin,  ContentMeta? meta,  MediaRef? media,  String? passageId,  bool shuffleOptions,  bool allowSkip, @DateOnlyConverter()  DateTime? validAsOf)?  mcq,TResult? Function( String id,  int version,  String familyId, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  LocalizedText stem,  num expected,  LocalizedText explanation,  ContentLang? lang,  ContentStatus status,  ItemOrigin? origin,  ContentMeta? meta,  MediaRef? media,  Tolerance? tolerance,  String? unit,  InputFormat inputFormat,  int decimals)?  numeric,TResult? Function( String id,  int version,  String familyId, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  StimulusKind stimulusKind,  List<String> stimulus,  RecallMode recallMode,  ContentLang? lang,  ContentStatus status,  ItemOrigin? origin,  ContentMeta? meta,  LocalizedText? instructions,  GridSize? grid,  int presentationMs,  int gapMs,  LocalizedText? explanation)?  sequence,TResult? Function( String id,  int version,  String familyId, @JsonKey(fromJson: difficultyFromJson)  Difficulty difficulty,  List<String> tags,  GeneratorId generatorId,  int seed, @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson)  GeneratorParams params,  ContentLang? lang,  ContentStatus status,  ItemOrigin? origin,  ContentMeta? meta)?  generated,}) {final _that = this;
switch (_that) {
case McqItem() when mcq != null:
return mcq(_that.id,_that.version,_that.familyId,_that.difficulty,_that.tags,_that.stem,_that.options,_that.correctIndex,_that.explanation,_that.lang,_that.status,_that.origin,_that.meta,_that.media,_that.passageId,_that.shuffleOptions,_that.allowSkip,_that.validAsOf);case NumericItem() when numeric != null:
return numeric(_that.id,_that.version,_that.familyId,_that.difficulty,_that.tags,_that.stem,_that.expected,_that.explanation,_that.lang,_that.status,_that.origin,_that.meta,_that.media,_that.tolerance,_that.unit,_that.inputFormat,_that.decimals);case SequenceItem() when sequence != null:
return sequence(_that.id,_that.version,_that.familyId,_that.difficulty,_that.tags,_that.stimulusKind,_that.stimulus,_that.recallMode,_that.lang,_that.status,_that.origin,_that.meta,_that.instructions,_that.grid,_that.presentationMs,_that.gapMs,_that.explanation);case GeneratedItem() when generated != null:
return generated(_that.id,_that.version,_that.familyId,_that.difficulty,_that.tags,_that.generatorId,_that.seed,_that.params,_that.lang,_that.status,_that.origin,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class McqItem implements Item {
  const McqItem({required this.id, required this.version, required this.familyId, @JsonKey(fromJson: difficultyFromJson) required this.difficulty, required final  List<String> tags, required this.stem, required final  List<McqOption> options, required this.correctIndex, required this.explanation, this.lang, this.status = ContentStatus.published, this.origin, this.meta, this.media, this.passageId, this.shuffleOptions = true, this.allowSkip = false, @DateOnlyConverter() this.validAsOf, final  String? $type}): assert(difficulty >= minDifficulty && difficulty <= maxDifficulty, 'difficulty must be 1..5'),assert(correctIndex >= 0 && correctIndex < options.length, 'correctIndex must index into options'),_tags = tags,_options = options,$type = $type ?? 'mcq';
  factory McqItem.fromJson(Map<String, dynamic> json) => _$McqItemFromJson(json);

@override final  String id;
@override final  int version;
@override final  String familyId;
@override@JsonKey(fromJson: difficultyFromJson) final  Difficulty difficulty;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  LocalizedText stem;
 final  List<McqOption> _options;
 List<McqOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

 final  int correctIndex;
 final  LocalizedText explanation;
@override final  ContentLang? lang;
@override@JsonKey() final  ContentStatus status;
@override final  ItemOrigin? origin;
@override final  ContentMeta? meta;
 final  MediaRef? media;
 final  String? passageId;
@JsonKey() final  bool shuffleOptions;
/// v2: offer an explicit "je ne sais pas" answer, scored with
/// `ScoringPolicy.skip`.
@JsonKey() final  bool allowSkip;
/// v2: date at which the correct answer was last checked (perishable
/// culture facts).
@DateOnlyConverter() final  DateTime? validAsOf;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$McqItemCopyWith<McqItem> get copyWith => _$McqItemCopyWithImpl<McqItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$McqItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is McqItem&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.stem, stem) || other.stem == stem)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.status, status) || other.status == status)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.media, media) || other.media == media)&&(identical(other.passageId, passageId) || other.passageId == passageId)&&(identical(other.shuffleOptions, shuffleOptions) || other.shuffleOptions == shuffleOptions)&&(identical(other.allowSkip, allowSkip) || other.allowSkip == allowSkip)&&(identical(other.validAsOf, validAsOf) || other.validAsOf == validAsOf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,familyId,difficulty,const DeepCollectionEquality().hash(_tags),stem,const DeepCollectionEquality().hash(_options),correctIndex,explanation,lang,status,origin,meta,media,passageId,shuffleOptions,allowSkip,validAsOf);

@override
String toString() {
  return 'Item.mcq(id: $id, version: $version, familyId: $familyId, difficulty: $difficulty, tags: $tags, stem: $stem, options: $options, correctIndex: $correctIndex, explanation: $explanation, lang: $lang, status: $status, origin: $origin, meta: $meta, media: $media, passageId: $passageId, shuffleOptions: $shuffleOptions, allowSkip: $allowSkip, validAsOf: $validAsOf)';
}


}

/// @nodoc
abstract mixin class $McqItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory $McqItemCopyWith(McqItem value, $Res Function(McqItem) _then) = _$McqItemCopyWithImpl;
@override @useResult
$Res call({
 String id, int version, String familyId,@JsonKey(fromJson: difficultyFromJson) Difficulty difficulty, List<String> tags, LocalizedText stem, List<McqOption> options, int correctIndex, LocalizedText explanation, ContentLang? lang, ContentStatus status, ItemOrigin? origin, ContentMeta? meta, MediaRef? media, String? passageId, bool shuffleOptions, bool allowSkip,@DateOnlyConverter() DateTime? validAsOf
});


$LocalizedTextCopyWith<$Res> get stem;$LocalizedTextCopyWith<$Res> get explanation;@override $ItemOriginCopyWith<$Res>? get origin;@override $ContentMetaCopyWith<$Res>? get meta;$MediaRefCopyWith<$Res>? get media;

}
/// @nodoc
class _$McqItemCopyWithImpl<$Res>
    implements $McqItemCopyWith<$Res> {
  _$McqItemCopyWithImpl(this._self, this._then);

  final McqItem _self;
  final $Res Function(McqItem) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? version = null,Object? familyId = null,Object? difficulty = null,Object? tags = null,Object? stem = null,Object? options = null,Object? correctIndex = null,Object? explanation = null,Object? lang = freezed,Object? status = null,Object? origin = freezed,Object? meta = freezed,Object? media = freezed,Object? passageId = freezed,Object? shuffleOptions = null,Object? allowSkip = null,Object? validAsOf = freezed,}) {
  return _then(McqItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,stem: null == stem ? _self.stem : stem // ignore: cast_nullable_to_non_nullable
as LocalizedText,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<McqOption>,correctIndex: null == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as LocalizedText,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as ContentLang?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as ItemOrigin?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as MediaRef?,passageId: freezed == passageId ? _self.passageId : passageId // ignore: cast_nullable_to_non_nullable
as String?,shuffleOptions: null == shuffleOptions ? _self.shuffleOptions : shuffleOptions // ignore: cast_nullable_to_non_nullable
as bool,allowSkip: null == allowSkip ? _self.allowSkip : allowSkip // ignore: cast_nullable_to_non_nullable
as bool,validAsOf: freezed == validAsOf ? _self.validAsOf : validAsOf // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get stem {
  
  return $LocalizedTextCopyWith<$Res>(_self.stem, (value) {
    return _then(_self.copyWith(stem: value));
  });
}/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get explanation {
  
  return $LocalizedTextCopyWith<$Res>(_self.explanation, (value) {
    return _then(_self.copyWith(explanation: value));
  });
}/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemOriginCopyWith<$Res>? get origin {
    if (_self.origin == null) {
    return null;
  }

  return $ItemOriginCopyWith<$Res>(_self.origin!, (value) {
    return _then(_self.copyWith(origin: value));
  });
}/// Create a copy of Item
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
}/// Create a copy of Item
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
}
}

/// @nodoc
@JsonSerializable()

class NumericItem implements Item {
  const NumericItem({required this.id, required this.version, required this.familyId, @JsonKey(fromJson: difficultyFromJson) required this.difficulty, required final  List<String> tags, required this.stem, required this.expected, required this.explanation, this.lang, this.status = ContentStatus.published, this.origin, this.meta, this.media, this.tolerance, this.unit, this.inputFormat = InputFormat.decimal, this.decimals = 2, final  String? $type}): assert(difficulty >= minDifficulty && difficulty <= maxDifficulty, 'difficulty must be 1..5'),_tags = tags,$type = $type ?? 'numeric';
  factory NumericItem.fromJson(Map<String, dynamic> json) => _$NumericItemFromJson(json);

@override final  String id;
@override final  int version;
@override final  String familyId;
@override@JsonKey(fromJson: difficultyFromJson) final  Difficulty difficulty;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  LocalizedText stem;
 final  num expected;
 final  LocalizedText explanation;
@override final  ContentLang? lang;
@override@JsonKey() final  ContentStatus status;
@override final  ItemOrigin? origin;
@override final  ContentMeta? meta;
 final  MediaRef? media;
 final  Tolerance? tolerance;
 final  String? unit;
@JsonKey() final  InputFormat inputFormat;
@JsonKey() final  int decimals;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NumericItemCopyWith<NumericItem> get copyWith => _$NumericItemCopyWithImpl<NumericItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NumericItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NumericItem&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.stem, stem) || other.stem == stem)&&(identical(other.expected, expected) || other.expected == expected)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.status, status) || other.status == status)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.media, media) || other.media == media)&&(identical(other.tolerance, tolerance) || other.tolerance == tolerance)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.inputFormat, inputFormat) || other.inputFormat == inputFormat)&&(identical(other.decimals, decimals) || other.decimals == decimals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,familyId,difficulty,const DeepCollectionEquality().hash(_tags),stem,expected,explanation,lang,status,origin,meta,media,tolerance,unit,inputFormat,decimals);

@override
String toString() {
  return 'Item.numeric(id: $id, version: $version, familyId: $familyId, difficulty: $difficulty, tags: $tags, stem: $stem, expected: $expected, explanation: $explanation, lang: $lang, status: $status, origin: $origin, meta: $meta, media: $media, tolerance: $tolerance, unit: $unit, inputFormat: $inputFormat, decimals: $decimals)';
}


}

/// @nodoc
abstract mixin class $NumericItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory $NumericItemCopyWith(NumericItem value, $Res Function(NumericItem) _then) = _$NumericItemCopyWithImpl;
@override @useResult
$Res call({
 String id, int version, String familyId,@JsonKey(fromJson: difficultyFromJson) Difficulty difficulty, List<String> tags, LocalizedText stem, num expected, LocalizedText explanation, ContentLang? lang, ContentStatus status, ItemOrigin? origin, ContentMeta? meta, MediaRef? media, Tolerance? tolerance, String? unit, InputFormat inputFormat, int decimals
});


$LocalizedTextCopyWith<$Res> get stem;$LocalizedTextCopyWith<$Res> get explanation;@override $ItemOriginCopyWith<$Res>? get origin;@override $ContentMetaCopyWith<$Res>? get meta;$MediaRefCopyWith<$Res>? get media;$ToleranceCopyWith<$Res>? get tolerance;

}
/// @nodoc
class _$NumericItemCopyWithImpl<$Res>
    implements $NumericItemCopyWith<$Res> {
  _$NumericItemCopyWithImpl(this._self, this._then);

  final NumericItem _self;
  final $Res Function(NumericItem) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? version = null,Object? familyId = null,Object? difficulty = null,Object? tags = null,Object? stem = null,Object? expected = null,Object? explanation = null,Object? lang = freezed,Object? status = null,Object? origin = freezed,Object? meta = freezed,Object? media = freezed,Object? tolerance = freezed,Object? unit = freezed,Object? inputFormat = null,Object? decimals = null,}) {
  return _then(NumericItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,stem: null == stem ? _self.stem : stem // ignore: cast_nullable_to_non_nullable
as LocalizedText,expected: null == expected ? _self.expected : expected // ignore: cast_nullable_to_non_nullable
as num,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as LocalizedText,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as ContentLang?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as ItemOrigin?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as MediaRef?,tolerance: freezed == tolerance ? _self.tolerance : tolerance // ignore: cast_nullable_to_non_nullable
as Tolerance?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,inputFormat: null == inputFormat ? _self.inputFormat : inputFormat // ignore: cast_nullable_to_non_nullable
as InputFormat,decimals: null == decimals ? _self.decimals : decimals // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get stem {
  
  return $LocalizedTextCopyWith<$Res>(_self.stem, (value) {
    return _then(_self.copyWith(stem: value));
  });
}/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get explanation {
  
  return $LocalizedTextCopyWith<$Res>(_self.explanation, (value) {
    return _then(_self.copyWith(explanation: value));
  });
}/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemOriginCopyWith<$Res>? get origin {
    if (_self.origin == null) {
    return null;
  }

  return $ItemOriginCopyWith<$Res>(_self.origin!, (value) {
    return _then(_self.copyWith(origin: value));
  });
}/// Create a copy of Item
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
}/// Create a copy of Item
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
}/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ToleranceCopyWith<$Res>? get tolerance {
    if (_self.tolerance == null) {
    return null;
  }

  return $ToleranceCopyWith<$Res>(_self.tolerance!, (value) {
    return _then(_self.copyWith(tolerance: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class SequenceItem implements Item {
  const SequenceItem({required this.id, required this.version, required this.familyId, @JsonKey(fromJson: difficultyFromJson) required this.difficulty, required final  List<String> tags, required this.stimulusKind, required final  List<String> stimulus, required this.recallMode, this.lang, this.status = ContentStatus.published, this.origin, this.meta, this.instructions, this.grid, this.presentationMs = 1000, this.gapMs = 250, this.explanation, final  String? $type}): assert(difficulty >= minDifficulty && difficulty <= maxDifficulty, 'difficulty must be 1..5'),assert(stimulusKind != StimulusKind.gridCells || grid != null, 'gridCells sequences require a grid'),_tags = tags,_stimulus = stimulus,$type = $type ?? 'sequence';
  factory SequenceItem.fromJson(Map<String, dynamic> json) => _$SequenceItemFromJson(json);

@override final  String id;
@override final  int version;
@override final  String familyId;
@override@JsonKey(fromJson: difficultyFromJson) final  Difficulty difficulty;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  StimulusKind stimulusKind;
 final  List<String> _stimulus;
 List<String> get stimulus {
  if (_stimulus is EqualUnmodifiableListView) return _stimulus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stimulus);
}

 final  RecallMode recallMode;
@override final  ContentLang? lang;
@override@JsonKey() final  ContentStatus status;
@override final  ItemOrigin? origin;
@override final  ContentMeta? meta;
 final  LocalizedText? instructions;
 final  GridSize? grid;
@JsonKey() final  int presentationMs;
@JsonKey() final  int gapMs;
 final  LocalizedText? explanation;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SequenceItemCopyWith<SequenceItem> get copyWith => _$SequenceItemCopyWithImpl<SequenceItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SequenceItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SequenceItem&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.stimulusKind, stimulusKind) || other.stimulusKind == stimulusKind)&&const DeepCollectionEquality().equals(other._stimulus, _stimulus)&&(identical(other.recallMode, recallMode) || other.recallMode == recallMode)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.status, status) || other.status == status)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.grid, grid) || other.grid == grid)&&(identical(other.presentationMs, presentationMs) || other.presentationMs == presentationMs)&&(identical(other.gapMs, gapMs) || other.gapMs == gapMs)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,familyId,difficulty,const DeepCollectionEquality().hash(_tags),stimulusKind,const DeepCollectionEquality().hash(_stimulus),recallMode,lang,status,origin,meta,instructions,grid,presentationMs,gapMs,explanation);

@override
String toString() {
  return 'Item.sequence(id: $id, version: $version, familyId: $familyId, difficulty: $difficulty, tags: $tags, stimulusKind: $stimulusKind, stimulus: $stimulus, recallMode: $recallMode, lang: $lang, status: $status, origin: $origin, meta: $meta, instructions: $instructions, grid: $grid, presentationMs: $presentationMs, gapMs: $gapMs, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class $SequenceItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory $SequenceItemCopyWith(SequenceItem value, $Res Function(SequenceItem) _then) = _$SequenceItemCopyWithImpl;
@override @useResult
$Res call({
 String id, int version, String familyId,@JsonKey(fromJson: difficultyFromJson) Difficulty difficulty, List<String> tags, StimulusKind stimulusKind, List<String> stimulus, RecallMode recallMode, ContentLang? lang, ContentStatus status, ItemOrigin? origin, ContentMeta? meta, LocalizedText? instructions, GridSize? grid, int presentationMs, int gapMs, LocalizedText? explanation
});


@override $ItemOriginCopyWith<$Res>? get origin;@override $ContentMetaCopyWith<$Res>? get meta;$LocalizedTextCopyWith<$Res>? get instructions;$GridSizeCopyWith<$Res>? get grid;$LocalizedTextCopyWith<$Res>? get explanation;

}
/// @nodoc
class _$SequenceItemCopyWithImpl<$Res>
    implements $SequenceItemCopyWith<$Res> {
  _$SequenceItemCopyWithImpl(this._self, this._then);

  final SequenceItem _self;
  final $Res Function(SequenceItem) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? version = null,Object? familyId = null,Object? difficulty = null,Object? tags = null,Object? stimulusKind = null,Object? stimulus = null,Object? recallMode = null,Object? lang = freezed,Object? status = null,Object? origin = freezed,Object? meta = freezed,Object? instructions = freezed,Object? grid = freezed,Object? presentationMs = null,Object? gapMs = null,Object? explanation = freezed,}) {
  return _then(SequenceItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,stimulusKind: null == stimulusKind ? _self.stimulusKind : stimulusKind // ignore: cast_nullable_to_non_nullable
as StimulusKind,stimulus: null == stimulus ? _self._stimulus : stimulus // ignore: cast_nullable_to_non_nullable
as List<String>,recallMode: null == recallMode ? _self.recallMode : recallMode // ignore: cast_nullable_to_non_nullable
as RecallMode,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as ContentLang?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as ItemOrigin?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as LocalizedText?,grid: freezed == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as GridSize?,presentationMs: null == presentationMs ? _self.presentationMs : presentationMs // ignore: cast_nullable_to_non_nullable
as int,gapMs: null == gapMs ? _self.gapMs : gapMs // ignore: cast_nullable_to_non_nullable
as int,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as LocalizedText?,
  ));
}

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemOriginCopyWith<$Res>? get origin {
    if (_self.origin == null) {
    return null;
  }

  return $ItemOriginCopyWith<$Res>(_self.origin!, (value) {
    return _then(_self.copyWith(origin: value));
  });
}/// Create a copy of Item
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
}/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get instructions {
    if (_self.instructions == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.instructions!, (value) {
    return _then(_self.copyWith(instructions: value));
  });
}/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GridSizeCopyWith<$Res>? get grid {
    if (_self.grid == null) {
    return null;
  }

  return $GridSizeCopyWith<$Res>(_self.grid!, (value) {
    return _then(_self.copyWith(grid: value));
  });
}/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get explanation {
    if (_self.explanation == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.explanation!, (value) {
    return _then(_self.copyWith(explanation: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class GeneratedItem implements Item {
  const GeneratedItem({required this.id, required this.version, required this.familyId, @JsonKey(fromJson: difficultyFromJson) required this.difficulty, required final  List<String> tags, required this.generatorId, required this.seed, @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson) required this.params, this.lang, this.status = ContentStatus.published, this.origin, this.meta, final  String? $type}): assert(difficulty >= minDifficulty && difficulty <= maxDifficulty, 'difficulty must be 1..5'),_tags = tags,$type = $type ?? 'generated';
  factory GeneratedItem.fromJson(Map<String, dynamic> json) => _$GeneratedItemFromJson(json);

@override final  String id;
@override final  int version;
@override final  String familyId;
@override@JsonKey(fromJson: difficultyFromJson) final  Difficulty difficulty;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  GeneratorId generatorId;
 final  int seed;
@JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson) final  GeneratorParams params;
@override final  ContentLang? lang;
@override@JsonKey() final  ContentStatus status;
@override final  ItemOrigin? origin;
@override final  ContentMeta? meta;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneratedItemCopyWith<GeneratedItem> get copyWith => _$GeneratedItemCopyWithImpl<GeneratedItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeneratedItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneratedItem&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.generatorId, generatorId) || other.generatorId == generatorId)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.params, params) || other.params == params)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.status, status) || other.status == status)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,familyId,difficulty,const DeepCollectionEquality().hash(_tags),generatorId,seed,params,lang,status,origin,meta);

@override
String toString() {
  return 'Item.generated(id: $id, version: $version, familyId: $familyId, difficulty: $difficulty, tags: $tags, generatorId: $generatorId, seed: $seed, params: $params, lang: $lang, status: $status, origin: $origin, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $GeneratedItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory $GeneratedItemCopyWith(GeneratedItem value, $Res Function(GeneratedItem) _then) = _$GeneratedItemCopyWithImpl;
@override @useResult
$Res call({
 String id, int version, String familyId,@JsonKey(fromJson: difficultyFromJson) Difficulty difficulty, List<String> tags, GeneratorId generatorId, int seed,@JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson) GeneratorParams params, ContentLang? lang, ContentStatus status, ItemOrigin? origin, ContentMeta? meta
});


$GeneratorParamsCopyWith<$Res> get params;@override $ItemOriginCopyWith<$Res>? get origin;@override $ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class _$GeneratedItemCopyWithImpl<$Res>
    implements $GeneratedItemCopyWith<$Res> {
  _$GeneratedItemCopyWithImpl(this._self, this._then);

  final GeneratedItem _self;
  final $Res Function(GeneratedItem) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? version = null,Object? familyId = null,Object? difficulty = null,Object? tags = null,Object? generatorId = null,Object? seed = null,Object? params = null,Object? lang = freezed,Object? status = null,Object? origin = freezed,Object? meta = freezed,}) {
  return _then(GeneratedItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,generatorId: null == generatorId ? _self.generatorId : generatorId // ignore: cast_nullable_to_non_nullable
as GeneratorId,seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,params: null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as GeneratorParams,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as ContentLang?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as ItemOrigin?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeneratorParamsCopyWith<$Res> get params {
  
  return $GeneratorParamsCopyWith<$Res>(_self.params, (value) {
    return _then(_self.copyWith(params: value));
  });
}/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemOriginCopyWith<$Res>? get origin {
    if (_self.origin == null) {
    return null;
  }

  return $ItemOriginCopyWith<$Res>(_self.origin!, (value) {
    return _then(_self.copyWith(origin: value));
  });
}/// Create a copy of Item
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
