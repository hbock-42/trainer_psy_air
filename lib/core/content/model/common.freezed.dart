// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'common.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocalizedText {

 String get fr; String? get en;
/// Create a copy of LocalizedText
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<LocalizedText> get copyWith => _$LocalizedTextCopyWithImpl<LocalizedText>(this as LocalizedText, _$identity);

  /// Serializes this LocalizedText to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalizedText&&(identical(other.fr, fr) || other.fr == fr)&&(identical(other.en, en) || other.en == en));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fr,en);

@override
String toString() {
  return 'LocalizedText(fr: $fr, en: $en)';
}


}

/// @nodoc
abstract mixin class $LocalizedTextCopyWith<$Res>  {
  factory $LocalizedTextCopyWith(LocalizedText value, $Res Function(LocalizedText) _then) = _$LocalizedTextCopyWithImpl;
@useResult
$Res call({
 String fr, String? en
});




}
/// @nodoc
class _$LocalizedTextCopyWithImpl<$Res>
    implements $LocalizedTextCopyWith<$Res> {
  _$LocalizedTextCopyWithImpl(this._self, this._then);

  final LocalizedText _self;
  final $Res Function(LocalizedText) _then;

/// Create a copy of LocalizedText
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fr = null,Object? en = freezed,}) {
  return _then(_self.copyWith(
fr: null == fr ? _self.fr : fr // ignore: cast_nullable_to_non_nullable
as String,en: freezed == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalizedText].
extension LocalizedTextPatterns on LocalizedText {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalizedText value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalizedText() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalizedText value)  $default,){
final _that = this;
switch (_that) {
case _LocalizedText():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalizedText value)?  $default,){
final _that = this;
switch (_that) {
case _LocalizedText() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fr,  String? en)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalizedText() when $default != null:
return $default(_that.fr,_that.en);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fr,  String? en)  $default,) {final _that = this;
switch (_that) {
case _LocalizedText():
return $default(_that.fr,_that.en);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fr,  String? en)?  $default,) {final _that = this;
switch (_that) {
case _LocalizedText() when $default != null:
return $default(_that.fr,_that.en);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocalizedText extends LocalizedText {
  const _LocalizedText({required this.fr, this.en}): super._();
  factory _LocalizedText.fromJson(Map<String, dynamic> json) => _$LocalizedTextFromJson(json);

@override final  String fr;
@override final  String? en;

/// Create a copy of LocalizedText
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalizedTextCopyWith<_LocalizedText> get copyWith => __$LocalizedTextCopyWithImpl<_LocalizedText>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocalizedTextToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalizedText&&(identical(other.fr, fr) || other.fr == fr)&&(identical(other.en, en) || other.en == en));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fr,en);

@override
String toString() {
  return 'LocalizedText(fr: $fr, en: $en)';
}


}

/// @nodoc
abstract mixin class _$LocalizedTextCopyWith<$Res> implements $LocalizedTextCopyWith<$Res> {
  factory _$LocalizedTextCopyWith(_LocalizedText value, $Res Function(_LocalizedText) _then) = __$LocalizedTextCopyWithImpl;
@override @useResult
$Res call({
 String fr, String? en
});




}
/// @nodoc
class __$LocalizedTextCopyWithImpl<$Res>
    implements _$LocalizedTextCopyWith<$Res> {
  __$LocalizedTextCopyWithImpl(this._self, this._then);

  final _LocalizedText _self;
  final $Res Function(_LocalizedText) _then;

/// Create a copy of LocalizedText
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fr = null,Object? en = freezed,}) {
  return _then(_LocalizedText(
fr: null == fr ? _self.fr : fr // ignore: cast_nullable_to_non_nullable
as String,en: freezed == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LocalizedPath {

 String get fr; String? get en;
/// Create a copy of LocalizedPath
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalizedPathCopyWith<LocalizedPath> get copyWith => _$LocalizedPathCopyWithImpl<LocalizedPath>(this as LocalizedPath, _$identity);

  /// Serializes this LocalizedPath to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalizedPath&&(identical(other.fr, fr) || other.fr == fr)&&(identical(other.en, en) || other.en == en));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fr,en);

@override
String toString() {
  return 'LocalizedPath(fr: $fr, en: $en)';
}


}

/// @nodoc
abstract mixin class $LocalizedPathCopyWith<$Res>  {
  factory $LocalizedPathCopyWith(LocalizedPath value, $Res Function(LocalizedPath) _then) = _$LocalizedPathCopyWithImpl;
@useResult
$Res call({
 String fr, String? en
});




}
/// @nodoc
class _$LocalizedPathCopyWithImpl<$Res>
    implements $LocalizedPathCopyWith<$Res> {
  _$LocalizedPathCopyWithImpl(this._self, this._then);

  final LocalizedPath _self;
  final $Res Function(LocalizedPath) _then;

/// Create a copy of LocalizedPath
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fr = null,Object? en = freezed,}) {
  return _then(_self.copyWith(
fr: null == fr ? _self.fr : fr // ignore: cast_nullable_to_non_nullable
as String,en: freezed == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalizedPath].
extension LocalizedPathPatterns on LocalizedPath {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalizedPath value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalizedPath() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalizedPath value)  $default,){
final _that = this;
switch (_that) {
case _LocalizedPath():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalizedPath value)?  $default,){
final _that = this;
switch (_that) {
case _LocalizedPath() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fr,  String? en)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalizedPath() when $default != null:
return $default(_that.fr,_that.en);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fr,  String? en)  $default,) {final _that = this;
switch (_that) {
case _LocalizedPath():
return $default(_that.fr,_that.en);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fr,  String? en)?  $default,) {final _that = this;
switch (_that) {
case _LocalizedPath() when $default != null:
return $default(_that.fr,_that.en);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocalizedPath extends LocalizedPath {
  const _LocalizedPath({required this.fr, this.en}): super._();
  factory _LocalizedPath.fromJson(Map<String, dynamic> json) => _$LocalizedPathFromJson(json);

@override final  String fr;
@override final  String? en;

/// Create a copy of LocalizedPath
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalizedPathCopyWith<_LocalizedPath> get copyWith => __$LocalizedPathCopyWithImpl<_LocalizedPath>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocalizedPathToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalizedPath&&(identical(other.fr, fr) || other.fr == fr)&&(identical(other.en, en) || other.en == en));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fr,en);

@override
String toString() {
  return 'LocalizedPath(fr: $fr, en: $en)';
}


}

/// @nodoc
abstract mixin class _$LocalizedPathCopyWith<$Res> implements $LocalizedPathCopyWith<$Res> {
  factory _$LocalizedPathCopyWith(_LocalizedPath value, $Res Function(_LocalizedPath) _then) = __$LocalizedPathCopyWithImpl;
@override @useResult
$Res call({
 String fr, String? en
});




}
/// @nodoc
class __$LocalizedPathCopyWithImpl<$Res>
    implements _$LocalizedPathCopyWith<$Res> {
  __$LocalizedPathCopyWithImpl(this._self, this._then);

  final _LocalizedPath _self;
  final $Res Function(_LocalizedPath) _then;

/// Create a copy of LocalizedPath
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fr = null,Object? en = freezed,}) {
  return _then(_LocalizedPath(
fr: null == fr ? _self.fr : fr // ignore: cast_nullable_to_non_nullable
as String,en: freezed == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MediaRef {

 MediaKind get kind; String get path; LocalizedText? get alt; int? get width; int? get height; int? get durationMs;
/// Create a copy of MediaRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaRefCopyWith<MediaRef> get copyWith => _$MediaRefCopyWithImpl<MediaRef>(this as MediaRef, _$identity);

  /// Serializes this MediaRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaRef&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.path, path) || other.path == path)&&(identical(other.alt, alt) || other.alt == alt)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,path,alt,width,height,durationMs);

@override
String toString() {
  return 'MediaRef(kind: $kind, path: $path, alt: $alt, width: $width, height: $height, durationMs: $durationMs)';
}


}

/// @nodoc
abstract mixin class $MediaRefCopyWith<$Res>  {
  factory $MediaRefCopyWith(MediaRef value, $Res Function(MediaRef) _then) = _$MediaRefCopyWithImpl;
@useResult
$Res call({
 MediaKind kind, String path, LocalizedText? alt, int? width, int? height, int? durationMs
});


$LocalizedTextCopyWith<$Res>? get alt;

}
/// @nodoc
class _$MediaRefCopyWithImpl<$Res>
    implements $MediaRefCopyWith<$Res> {
  _$MediaRefCopyWithImpl(this._self, this._then);

  final MediaRef _self;
  final $Res Function(MediaRef) _then;

/// Create a copy of MediaRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? path = null,Object? alt = freezed,Object? width = freezed,Object? height = freezed,Object? durationMs = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MediaKind,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,alt: freezed == alt ? _self.alt : alt // ignore: cast_nullable_to_non_nullable
as LocalizedText?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of MediaRef
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get alt {
    if (_self.alt == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.alt!, (value) {
    return _then(_self.copyWith(alt: value));
  });
}
}


/// Adds pattern-matching-related methods to [MediaRef].
extension MediaRefPatterns on MediaRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaRef value)  $default,){
final _that = this;
switch (_that) {
case _MediaRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaRef value)?  $default,){
final _that = this;
switch (_that) {
case _MediaRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MediaKind kind,  String path,  LocalizedText? alt,  int? width,  int? height,  int? durationMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaRef() when $default != null:
return $default(_that.kind,_that.path,_that.alt,_that.width,_that.height,_that.durationMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MediaKind kind,  String path,  LocalizedText? alt,  int? width,  int? height,  int? durationMs)  $default,) {final _that = this;
switch (_that) {
case _MediaRef():
return $default(_that.kind,_that.path,_that.alt,_that.width,_that.height,_that.durationMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MediaKind kind,  String path,  LocalizedText? alt,  int? width,  int? height,  int? durationMs)?  $default,) {final _that = this;
switch (_that) {
case _MediaRef() when $default != null:
return $default(_that.kind,_that.path,_that.alt,_that.width,_that.height,_that.durationMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaRef implements MediaRef {
  const _MediaRef({required this.kind, required this.path, this.alt, this.width, this.height, this.durationMs});
  factory _MediaRef.fromJson(Map<String, dynamic> json) => _$MediaRefFromJson(json);

@override final  MediaKind kind;
@override final  String path;
@override final  LocalizedText? alt;
@override final  int? width;
@override final  int? height;
@override final  int? durationMs;

/// Create a copy of MediaRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaRefCopyWith<_MediaRef> get copyWith => __$MediaRefCopyWithImpl<_MediaRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaRef&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.path, path) || other.path == path)&&(identical(other.alt, alt) || other.alt == alt)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,path,alt,width,height,durationMs);

@override
String toString() {
  return 'MediaRef(kind: $kind, path: $path, alt: $alt, width: $width, height: $height, durationMs: $durationMs)';
}


}

/// @nodoc
abstract mixin class _$MediaRefCopyWith<$Res> implements $MediaRefCopyWith<$Res> {
  factory _$MediaRefCopyWith(_MediaRef value, $Res Function(_MediaRef) _then) = __$MediaRefCopyWithImpl;
@override @useResult
$Res call({
 MediaKind kind, String path, LocalizedText? alt, int? width, int? height, int? durationMs
});


@override $LocalizedTextCopyWith<$Res>? get alt;

}
/// @nodoc
class __$MediaRefCopyWithImpl<$Res>
    implements _$MediaRefCopyWith<$Res> {
  __$MediaRefCopyWithImpl(this._self, this._then);

  final _MediaRef _self;
  final $Res Function(_MediaRef) _then;

/// Create a copy of MediaRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? path = null,Object? alt = freezed,Object? width = freezed,Object? height = freezed,Object? durationMs = freezed,}) {
  return _then(_MediaRef(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as MediaKind,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,alt: freezed == alt ? _self.alt : alt // ignore: cast_nullable_to_non_nullable
as LocalizedText?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of MediaRef
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get alt {
    if (_self.alt == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.alt!, (value) {
    return _then(_self.copyWith(alt: value));
  });
}
}


/// @nodoc
mixin _$ContentMeta {

 String? get author; String? get source; String? get reviewedBy;@DateOnlyConverter() DateTime? get reviewedAt; String? get notes;
/// Create a copy of ContentMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentMetaCopyWith<ContentMeta> get copyWith => _$ContentMetaCopyWithImpl<ContentMeta>(this as ContentMeta, _$identity);

  /// Serializes this ContentMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentMeta&&(identical(other.author, author) || other.author == author)&&(identical(other.source, source) || other.source == source)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,author,source,reviewedBy,reviewedAt,notes);

@override
String toString() {
  return 'ContentMeta(author: $author, source: $source, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $ContentMetaCopyWith<$Res>  {
  factory $ContentMetaCopyWith(ContentMeta value, $Res Function(ContentMeta) _then) = _$ContentMetaCopyWithImpl;
@useResult
$Res call({
 String? author, String? source, String? reviewedBy,@DateOnlyConverter() DateTime? reviewedAt, String? notes
});




}
/// @nodoc
class _$ContentMetaCopyWithImpl<$Res>
    implements $ContentMetaCopyWith<$Res> {
  _$ContentMetaCopyWithImpl(this._self, this._then);

  final ContentMeta _self;
  final $Res Function(ContentMeta) _then;

/// Create a copy of ContentMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? author = freezed,Object? source = freezed,Object? reviewedBy = freezed,Object? reviewedAt = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContentMeta].
extension ContentMetaPatterns on ContentMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContentMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContentMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContentMeta value)  $default,){
final _that = this;
switch (_that) {
case _ContentMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContentMeta value)?  $default,){
final _that = this;
switch (_that) {
case _ContentMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? author,  String? source,  String? reviewedBy, @DateOnlyConverter()  DateTime? reviewedAt,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContentMeta() when $default != null:
return $default(_that.author,_that.source,_that.reviewedBy,_that.reviewedAt,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? author,  String? source,  String? reviewedBy, @DateOnlyConverter()  DateTime? reviewedAt,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _ContentMeta():
return $default(_that.author,_that.source,_that.reviewedBy,_that.reviewedAt,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? author,  String? source,  String? reviewedBy, @DateOnlyConverter()  DateTime? reviewedAt,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _ContentMeta() when $default != null:
return $default(_that.author,_that.source,_that.reviewedBy,_that.reviewedAt,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContentMeta implements ContentMeta {
  const _ContentMeta({this.author, this.source, this.reviewedBy, @DateOnlyConverter() this.reviewedAt, this.notes});
  factory _ContentMeta.fromJson(Map<String, dynamic> json) => _$ContentMetaFromJson(json);

@override final  String? author;
@override final  String? source;
@override final  String? reviewedBy;
@override@DateOnlyConverter() final  DateTime? reviewedAt;
@override final  String? notes;

/// Create a copy of ContentMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentMetaCopyWith<_ContentMeta> get copyWith => __$ContentMetaCopyWithImpl<_ContentMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContentMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentMeta&&(identical(other.author, author) || other.author == author)&&(identical(other.source, source) || other.source == source)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,author,source,reviewedBy,reviewedAt,notes);

@override
String toString() {
  return 'ContentMeta(author: $author, source: $source, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ContentMetaCopyWith<$Res> implements $ContentMetaCopyWith<$Res> {
  factory _$ContentMetaCopyWith(_ContentMeta value, $Res Function(_ContentMeta) _then) = __$ContentMetaCopyWithImpl;
@override @useResult
$Res call({
 String? author, String? source, String? reviewedBy,@DateOnlyConverter() DateTime? reviewedAt, String? notes
});




}
/// @nodoc
class __$ContentMetaCopyWithImpl<$Res>
    implements _$ContentMetaCopyWith<$Res> {
  __$ContentMetaCopyWithImpl(this._self, this._then);

  final _ContentMeta _self;
  final $Res Function(_ContentMeta) _then;

/// Create a copy of ContentMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? author = freezed,Object? source = freezed,Object? reviewedBy = freezed,Object? reviewedAt = freezed,Object? notes = freezed,}) {
  return _then(_ContentMeta(
author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
