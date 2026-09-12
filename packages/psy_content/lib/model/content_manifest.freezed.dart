// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_manifest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContentManifest {

 int get schemaVersion; int get contentVersion;@DateOnlyConverter() DateTime get updatedAt; List<ModuleId> get modules; List<ChangelogEntry> get changelog;
/// Create a copy of ContentManifest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentManifestCopyWith<ContentManifest> get copyWith => _$ContentManifestCopyWithImpl<ContentManifest>(this as ContentManifest, _$identity);

  /// Serializes this ContentManifest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentManifest&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.contentVersion, contentVersion) || other.contentVersion == contentVersion)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.modules, modules)&&const DeepCollectionEquality().equals(other.changelog, changelog));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,contentVersion,updatedAt,const DeepCollectionEquality().hash(modules),const DeepCollectionEquality().hash(changelog));

@override
String toString() {
  return 'ContentManifest(schemaVersion: $schemaVersion, contentVersion: $contentVersion, updatedAt: $updatedAt, modules: $modules, changelog: $changelog)';
}


}

/// @nodoc
abstract mixin class $ContentManifestCopyWith<$Res>  {
  factory $ContentManifestCopyWith(ContentManifest value, $Res Function(ContentManifest) _then) = _$ContentManifestCopyWithImpl;
@useResult
$Res call({
 int schemaVersion, int contentVersion,@DateOnlyConverter() DateTime updatedAt, List<ModuleId> modules, List<ChangelogEntry> changelog
});




}
/// @nodoc
class _$ContentManifestCopyWithImpl<$Res>
    implements $ContentManifestCopyWith<$Res> {
  _$ContentManifestCopyWithImpl(this._self, this._then);

  final ContentManifest _self;
  final $Res Function(ContentManifest) _then;

/// Create a copy of ContentManifest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = null,Object? contentVersion = null,Object? updatedAt = null,Object? modules = null,Object? changelog = null,}) {
  return _then(_self.copyWith(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,contentVersion: null == contentVersion ? _self.contentVersion : contentVersion // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,modules: null == modules ? _self.modules : modules // ignore: cast_nullable_to_non_nullable
as List<ModuleId>,changelog: null == changelog ? _self.changelog : changelog // ignore: cast_nullable_to_non_nullable
as List<ChangelogEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [ContentManifest].
extension ContentManifestPatterns on ContentManifest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContentManifest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContentManifest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContentManifest value)  $default,){
final _that = this;
switch (_that) {
case _ContentManifest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContentManifest value)?  $default,){
final _that = this;
switch (_that) {
case _ContentManifest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int schemaVersion,  int contentVersion, @DateOnlyConverter()  DateTime updatedAt,  List<ModuleId> modules,  List<ChangelogEntry> changelog)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContentManifest() when $default != null:
return $default(_that.schemaVersion,_that.contentVersion,_that.updatedAt,_that.modules,_that.changelog);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int schemaVersion,  int contentVersion, @DateOnlyConverter()  DateTime updatedAt,  List<ModuleId> modules,  List<ChangelogEntry> changelog)  $default,) {final _that = this;
switch (_that) {
case _ContentManifest():
return $default(_that.schemaVersion,_that.contentVersion,_that.updatedAt,_that.modules,_that.changelog);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int schemaVersion,  int contentVersion, @DateOnlyConverter()  DateTime updatedAt,  List<ModuleId> modules,  List<ChangelogEntry> changelog)?  $default,) {final _that = this;
switch (_that) {
case _ContentManifest() when $default != null:
return $default(_that.schemaVersion,_that.contentVersion,_that.updatedAt,_that.modules,_that.changelog);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContentManifest implements ContentManifest {
  const _ContentManifest({required this.schemaVersion, required this.contentVersion, @DateOnlyConverter() required this.updatedAt, required final  List<ModuleId> modules, final  List<ChangelogEntry> changelog = const <ChangelogEntry>[]}): _modules = modules,_changelog = changelog;
  factory _ContentManifest.fromJson(Map<String, dynamic> json) => _$ContentManifestFromJson(json);

@override final  int schemaVersion;
@override final  int contentVersion;
@override@DateOnlyConverter() final  DateTime updatedAt;
 final  List<ModuleId> _modules;
@override List<ModuleId> get modules {
  if (_modules is EqualUnmodifiableListView) return _modules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modules);
}

 final  List<ChangelogEntry> _changelog;
@override@JsonKey() List<ChangelogEntry> get changelog {
  if (_changelog is EqualUnmodifiableListView) return _changelog;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_changelog);
}


/// Create a copy of ContentManifest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentManifestCopyWith<_ContentManifest> get copyWith => __$ContentManifestCopyWithImpl<_ContentManifest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContentManifestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentManifest&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.contentVersion, contentVersion) || other.contentVersion == contentVersion)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._modules, _modules)&&const DeepCollectionEquality().equals(other._changelog, _changelog));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,contentVersion,updatedAt,const DeepCollectionEquality().hash(_modules),const DeepCollectionEquality().hash(_changelog));

@override
String toString() {
  return 'ContentManifest(schemaVersion: $schemaVersion, contentVersion: $contentVersion, updatedAt: $updatedAt, modules: $modules, changelog: $changelog)';
}


}

/// @nodoc
abstract mixin class _$ContentManifestCopyWith<$Res> implements $ContentManifestCopyWith<$Res> {
  factory _$ContentManifestCopyWith(_ContentManifest value, $Res Function(_ContentManifest) _then) = __$ContentManifestCopyWithImpl;
@override @useResult
$Res call({
 int schemaVersion, int contentVersion,@DateOnlyConverter() DateTime updatedAt, List<ModuleId> modules, List<ChangelogEntry> changelog
});




}
/// @nodoc
class __$ContentManifestCopyWithImpl<$Res>
    implements _$ContentManifestCopyWith<$Res> {
  __$ContentManifestCopyWithImpl(this._self, this._then);

  final _ContentManifest _self;
  final $Res Function(_ContentManifest) _then;

/// Create a copy of ContentManifest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = null,Object? contentVersion = null,Object? updatedAt = null,Object? modules = null,Object? changelog = null,}) {
  return _then(_ContentManifest(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,contentVersion: null == contentVersion ? _self.contentVersion : contentVersion // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,modules: null == modules ? _self._modules : modules // ignore: cast_nullable_to_non_nullable
as List<ModuleId>,changelog: null == changelog ? _self._changelog : changelog // ignore: cast_nullable_to_non_nullable
as List<ChangelogEntry>,
  ));
}


}


/// @nodoc
mixin _$ChangelogEntry {

 int get contentVersion;@DateOnlyConverter() DateTime get date; String get summary;
/// Create a copy of ChangelogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangelogEntryCopyWith<ChangelogEntry> get copyWith => _$ChangelogEntryCopyWithImpl<ChangelogEntry>(this as ChangelogEntry, _$identity);

  /// Serializes this ChangelogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangelogEntry&&(identical(other.contentVersion, contentVersion) || other.contentVersion == contentVersion)&&(identical(other.date, date) || other.date == date)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentVersion,date,summary);

@override
String toString() {
  return 'ChangelogEntry(contentVersion: $contentVersion, date: $date, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $ChangelogEntryCopyWith<$Res>  {
  factory $ChangelogEntryCopyWith(ChangelogEntry value, $Res Function(ChangelogEntry) _then) = _$ChangelogEntryCopyWithImpl;
@useResult
$Res call({
 int contentVersion,@DateOnlyConverter() DateTime date, String summary
});




}
/// @nodoc
class _$ChangelogEntryCopyWithImpl<$Res>
    implements $ChangelogEntryCopyWith<$Res> {
  _$ChangelogEntryCopyWithImpl(this._self, this._then);

  final ChangelogEntry _self;
  final $Res Function(ChangelogEntry) _then;

/// Create a copy of ChangelogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contentVersion = null,Object? date = null,Object? summary = null,}) {
  return _then(_self.copyWith(
contentVersion: null == contentVersion ? _self.contentVersion : contentVersion // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangelogEntry].
extension ChangelogEntryPatterns on ChangelogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChangelogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangelogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChangelogEntry value)  $default,){
final _that = this;
switch (_that) {
case _ChangelogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChangelogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ChangelogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int contentVersion, @DateOnlyConverter()  DateTime date,  String summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangelogEntry() when $default != null:
return $default(_that.contentVersion,_that.date,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int contentVersion, @DateOnlyConverter()  DateTime date,  String summary)  $default,) {final _that = this;
switch (_that) {
case _ChangelogEntry():
return $default(_that.contentVersion,_that.date,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int contentVersion, @DateOnlyConverter()  DateTime date,  String summary)?  $default,) {final _that = this;
switch (_that) {
case _ChangelogEntry() when $default != null:
return $default(_that.contentVersion,_that.date,_that.summary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChangelogEntry implements ChangelogEntry {
  const _ChangelogEntry({required this.contentVersion, @DateOnlyConverter() required this.date, required this.summary});
  factory _ChangelogEntry.fromJson(Map<String, dynamic> json) => _$ChangelogEntryFromJson(json);

@override final  int contentVersion;
@override@DateOnlyConverter() final  DateTime date;
@override final  String summary;

/// Create a copy of ChangelogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangelogEntryCopyWith<_ChangelogEntry> get copyWith => __$ChangelogEntryCopyWithImpl<_ChangelogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChangelogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangelogEntry&&(identical(other.contentVersion, contentVersion) || other.contentVersion == contentVersion)&&(identical(other.date, date) || other.date == date)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentVersion,date,summary);

@override
String toString() {
  return 'ChangelogEntry(contentVersion: $contentVersion, date: $date, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$ChangelogEntryCopyWith<$Res> implements $ChangelogEntryCopyWith<$Res> {
  factory _$ChangelogEntryCopyWith(_ChangelogEntry value, $Res Function(_ChangelogEntry) _then) = __$ChangelogEntryCopyWithImpl;
@override @useResult
$Res call({
 int contentVersion,@DateOnlyConverter() DateTime date, String summary
});




}
/// @nodoc
class __$ChangelogEntryCopyWithImpl<$Res>
    implements _$ChangelogEntryCopyWith<$Res> {
  __$ChangelogEntryCopyWithImpl(this._self, this._then);

  final _ChangelogEntry _self;
  final $Res Function(_ChangelogEntry) _then;

/// Create a copy of ChangelogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contentVersion = null,Object? date = null,Object? summary = null,}) {
  return _then(_ChangelogEntry(
contentVersion: null == contentVersion ? _self.contentVersion : contentVersion // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
