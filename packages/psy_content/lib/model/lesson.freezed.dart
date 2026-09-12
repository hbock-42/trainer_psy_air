// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Lesson {

 String get id; int get version; ModuleId get moduleId; int get order; LocalizedText get title; List<String> get tags; String? get familyId; LocalizedText? get summary; LocalizedText? get body; LocalizedPath? get file; int? get estimatedReadMin;@JsonKey(fromJson: difficultyFromJsonNullable) Difficulty? get difficulty; List<String> get practiceTags; List<String> get deckIds; ContentStatus get status; ContentMeta? get meta;
/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonCopyWith<Lesson> get copyWith => _$LessonCopyWithImpl<Lesson>(this as Lesson, _$identity);

  /// Serializes this Lesson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.order, order) || other.order == order)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.body, body) || other.body == body)&&(identical(other.file, file) || other.file == file)&&(identical(other.estimatedReadMin, estimatedReadMin) || other.estimatedReadMin == estimatedReadMin)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other.practiceTags, practiceTags)&&const DeepCollectionEquality().equals(other.deckIds, deckIds)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,moduleId,order,title,const DeepCollectionEquality().hash(tags),familyId,summary,body,file,estimatedReadMin,difficulty,const DeepCollectionEquality().hash(practiceTags),const DeepCollectionEquality().hash(deckIds),status,meta);

@override
String toString() {
  return 'Lesson(id: $id, version: $version, moduleId: $moduleId, order: $order, title: $title, tags: $tags, familyId: $familyId, summary: $summary, body: $body, file: $file, estimatedReadMin: $estimatedReadMin, difficulty: $difficulty, practiceTags: $practiceTags, deckIds: $deckIds, status: $status, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $LessonCopyWith<$Res>  {
  factory $LessonCopyWith(Lesson value, $Res Function(Lesson) _then) = _$LessonCopyWithImpl;
@useResult
$Res call({
 String id, int version, ModuleId moduleId, int order, LocalizedText title, List<String> tags, String? familyId, LocalizedText? summary, LocalizedText? body, LocalizedPath? file, int? estimatedReadMin,@JsonKey(fromJson: difficultyFromJsonNullable) Difficulty? difficulty, List<String> practiceTags, List<String> deckIds, ContentStatus status, ContentMeta? meta
});


$LocalizedTextCopyWith<$Res> get title;$LocalizedTextCopyWith<$Res>? get summary;$LocalizedTextCopyWith<$Res>? get body;$LocalizedPathCopyWith<$Res>? get file;$ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class _$LessonCopyWithImpl<$Res>
    implements $LessonCopyWith<$Res> {
  _$LessonCopyWithImpl(this._self, this._then);

  final Lesson _self;
  final $Res Function(Lesson) _then;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? version = null,Object? moduleId = null,Object? order = null,Object? title = null,Object? tags = null,Object? familyId = freezed,Object? summary = freezed,Object? body = freezed,Object? file = freezed,Object? estimatedReadMin = freezed,Object? difficulty = freezed,Object? practiceTags = null,Object? deckIds = null,Object? status = null,Object? meta = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,moduleId: null == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as ModuleId,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as LocalizedText,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as LocalizedText?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as LocalizedText?,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as LocalizedPath?,estimatedReadMin: freezed == estimatedReadMin ? _self.estimatedReadMin : estimatedReadMin // ignore: cast_nullable_to_non_nullable
as int?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty?,practiceTags: null == practiceTags ? _self.practiceTags : practiceTags // ignore: cast_nullable_to_non_nullable
as List<String>,deckIds: null == deckIds ? _self.deckIds : deckIds // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}
/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get title {
  
  return $LocalizedTextCopyWith<$Res>(_self.title, (value) {
    return _then(_self.copyWith(title: value));
  });
}/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get body {
    if (_self.body == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.body!, (value) {
    return _then(_self.copyWith(body: value));
  });
}/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedPathCopyWith<$Res>? get file {
    if (_self.file == null) {
    return null;
  }

  return $LocalizedPathCopyWith<$Res>(_self.file!, (value) {
    return _then(_self.copyWith(file: value));
  });
}/// Create a copy of Lesson
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


/// Adds pattern-matching-related methods to [Lesson].
extension LessonPatterns on Lesson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Lesson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Lesson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Lesson value)  $default,){
final _that = this;
switch (_that) {
case _Lesson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Lesson value)?  $default,){
final _that = this;
switch (_that) {
case _Lesson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int version,  ModuleId moduleId,  int order,  LocalizedText title,  List<String> tags,  String? familyId,  LocalizedText? summary,  LocalizedText? body,  LocalizedPath? file,  int? estimatedReadMin, @JsonKey(fromJson: difficultyFromJsonNullable)  Difficulty? difficulty,  List<String> practiceTags,  List<String> deckIds,  ContentStatus status,  ContentMeta? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.version,_that.moduleId,_that.order,_that.title,_that.tags,_that.familyId,_that.summary,_that.body,_that.file,_that.estimatedReadMin,_that.difficulty,_that.practiceTags,_that.deckIds,_that.status,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int version,  ModuleId moduleId,  int order,  LocalizedText title,  List<String> tags,  String? familyId,  LocalizedText? summary,  LocalizedText? body,  LocalizedPath? file,  int? estimatedReadMin, @JsonKey(fromJson: difficultyFromJsonNullable)  Difficulty? difficulty,  List<String> practiceTags,  List<String> deckIds,  ContentStatus status,  ContentMeta? meta)  $default,) {final _that = this;
switch (_that) {
case _Lesson():
return $default(_that.id,_that.version,_that.moduleId,_that.order,_that.title,_that.tags,_that.familyId,_that.summary,_that.body,_that.file,_that.estimatedReadMin,_that.difficulty,_that.practiceTags,_that.deckIds,_that.status,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int version,  ModuleId moduleId,  int order,  LocalizedText title,  List<String> tags,  String? familyId,  LocalizedText? summary,  LocalizedText? body,  LocalizedPath? file,  int? estimatedReadMin, @JsonKey(fromJson: difficultyFromJsonNullable)  Difficulty? difficulty,  List<String> practiceTags,  List<String> deckIds,  ContentStatus status,  ContentMeta? meta)?  $default,) {final _that = this;
switch (_that) {
case _Lesson() when $default != null:
return $default(_that.id,_that.version,_that.moduleId,_that.order,_that.title,_that.tags,_that.familyId,_that.summary,_that.body,_that.file,_that.estimatedReadMin,_that.difficulty,_that.practiceTags,_that.deckIds,_that.status,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Lesson implements Lesson {
  const _Lesson({required this.id, required this.version, required this.moduleId, required this.order, required this.title, required final  List<String> tags, this.familyId, this.summary, this.body, this.file, this.estimatedReadMin, @JsonKey(fromJson: difficultyFromJsonNullable) this.difficulty, final  List<String> practiceTags = const <String>[], final  List<String> deckIds = const <String>[], this.status = ContentStatus.published, this.meta}): assert((body == null) != (file == null), 'exactly one of body/file is set'),assert(difficulty == null || (difficulty >= minDifficulty && difficulty <= maxDifficulty), 'difficulty must be 1..5'),_tags = tags,_practiceTags = practiceTags,_deckIds = deckIds;
  factory _Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

@override final  String id;
@override final  int version;
@override final  ModuleId moduleId;
@override final  int order;
@override final  LocalizedText title;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String? familyId;
@override final  LocalizedText? summary;
@override final  LocalizedText? body;
@override final  LocalizedPath? file;
@override final  int? estimatedReadMin;
@override@JsonKey(fromJson: difficultyFromJsonNullable) final  Difficulty? difficulty;
 final  List<String> _practiceTags;
@override@JsonKey() List<String> get practiceTags {
  if (_practiceTags is EqualUnmodifiableListView) return _practiceTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_practiceTags);
}

 final  List<String> _deckIds;
@override@JsonKey() List<String> get deckIds {
  if (_deckIds is EqualUnmodifiableListView) return _deckIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deckIds);
}

@override@JsonKey() final  ContentStatus status;
@override final  ContentMeta? meta;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonCopyWith<_Lesson> get copyWith => __$LessonCopyWithImpl<_Lesson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lesson&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.order, order) || other.order == order)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.body, body) || other.body == body)&&(identical(other.file, file) || other.file == file)&&(identical(other.estimatedReadMin, estimatedReadMin) || other.estimatedReadMin == estimatedReadMin)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other._practiceTags, _practiceTags)&&const DeepCollectionEquality().equals(other._deckIds, _deckIds)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,moduleId,order,title,const DeepCollectionEquality().hash(_tags),familyId,summary,body,file,estimatedReadMin,difficulty,const DeepCollectionEquality().hash(_practiceTags),const DeepCollectionEquality().hash(_deckIds),status,meta);

@override
String toString() {
  return 'Lesson(id: $id, version: $version, moduleId: $moduleId, order: $order, title: $title, tags: $tags, familyId: $familyId, summary: $summary, body: $body, file: $file, estimatedReadMin: $estimatedReadMin, difficulty: $difficulty, practiceTags: $practiceTags, deckIds: $deckIds, status: $status, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$LessonCopyWith<$Res> implements $LessonCopyWith<$Res> {
  factory _$LessonCopyWith(_Lesson value, $Res Function(_Lesson) _then) = __$LessonCopyWithImpl;
@override @useResult
$Res call({
 String id, int version, ModuleId moduleId, int order, LocalizedText title, List<String> tags, String? familyId, LocalizedText? summary, LocalizedText? body, LocalizedPath? file, int? estimatedReadMin,@JsonKey(fromJson: difficultyFromJsonNullable) Difficulty? difficulty, List<String> practiceTags, List<String> deckIds, ContentStatus status, ContentMeta? meta
});


@override $LocalizedTextCopyWith<$Res> get title;@override $LocalizedTextCopyWith<$Res>? get summary;@override $LocalizedTextCopyWith<$Res>? get body;@override $LocalizedPathCopyWith<$Res>? get file;@override $ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class __$LessonCopyWithImpl<$Res>
    implements _$LessonCopyWith<$Res> {
  __$LessonCopyWithImpl(this._self, this._then);

  final _Lesson _self;
  final $Res Function(_Lesson) _then;

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? version = null,Object? moduleId = null,Object? order = null,Object? title = null,Object? tags = null,Object? familyId = freezed,Object? summary = freezed,Object? body = freezed,Object? file = freezed,Object? estimatedReadMin = freezed,Object? difficulty = freezed,Object? practiceTags = null,Object? deckIds = null,Object? status = null,Object? meta = freezed,}) {
  return _then(_Lesson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,moduleId: null == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as ModuleId,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as LocalizedText,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as LocalizedText?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as LocalizedText?,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as LocalizedPath?,estimatedReadMin: freezed == estimatedReadMin ? _self.estimatedReadMin : estimatedReadMin // ignore: cast_nullable_to_non_nullable
as int?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as Difficulty?,practiceTags: null == practiceTags ? _self._practiceTags : practiceTags // ignore: cast_nullable_to_non_nullable
as List<String>,deckIds: null == deckIds ? _self._deckIds : deckIds // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}

/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get title {
  
  return $LocalizedTextCopyWith<$Res>(_self.title, (value) {
    return _then(_self.copyWith(title: value));
  });
}/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get summary {
    if (_self.summary == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.summary!, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get body {
    if (_self.body == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.body!, (value) {
    return _then(_self.copyWith(body: value));
  });
}/// Create a copy of Lesson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedPathCopyWith<$Res>? get file {
    if (_self.file == null) {
    return null;
  }

  return $LocalizedPathCopyWith<$Res>(_self.file!, (value) {
    return _then(_self.copyWith(file: value));
  });
}/// Create a copy of Lesson
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
