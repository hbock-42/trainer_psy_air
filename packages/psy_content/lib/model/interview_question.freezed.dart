// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interview_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InterviewQuestionBank {

 String get familyId; List<InterviewQuestion> get questions;
/// Create a copy of InterviewQuestionBank
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterviewQuestionBankCopyWith<InterviewQuestionBank> get copyWith => _$InterviewQuestionBankCopyWithImpl<InterviewQuestionBank>(this as InterviewQuestionBank, _$identity);

  /// Serializes this InterviewQuestionBank to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterviewQuestionBank&&(identical(other.familyId, familyId) || other.familyId == familyId)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'InterviewQuestionBank(familyId: $familyId, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $InterviewQuestionBankCopyWith<$Res>  {
  factory $InterviewQuestionBankCopyWith(InterviewQuestionBank value, $Res Function(InterviewQuestionBank) _then) = _$InterviewQuestionBankCopyWithImpl;
@useResult
$Res call({
 String familyId, List<InterviewQuestion> questions
});




}
/// @nodoc
class _$InterviewQuestionBankCopyWithImpl<$Res>
    implements $InterviewQuestionBankCopyWith<$Res> {
  _$InterviewQuestionBankCopyWithImpl(this._self, this._then);

  final InterviewQuestionBank _self;
  final $Res Function(InterviewQuestionBank) _then;

/// Create a copy of InterviewQuestionBank
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? familyId = null,Object? questions = null,}) {
  return _then(_self.copyWith(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<InterviewQuestion>,
  ));
}

}


/// Adds pattern-matching-related methods to [InterviewQuestionBank].
extension InterviewQuestionBankPatterns on InterviewQuestionBank {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InterviewQuestionBank value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InterviewQuestionBank() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InterviewQuestionBank value)  $default,){
final _that = this;
switch (_that) {
case _InterviewQuestionBank():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InterviewQuestionBank value)?  $default,){
final _that = this;
switch (_that) {
case _InterviewQuestionBank() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String familyId,  List<InterviewQuestion> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InterviewQuestionBank() when $default != null:
return $default(_that.familyId,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String familyId,  List<InterviewQuestion> questions)  $default,) {final _that = this;
switch (_that) {
case _InterviewQuestionBank():
return $default(_that.familyId,_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String familyId,  List<InterviewQuestion> questions)?  $default,) {final _that = this;
switch (_that) {
case _InterviewQuestionBank() when $default != null:
return $default(_that.familyId,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InterviewQuestionBank implements InterviewQuestionBank {
  const _InterviewQuestionBank({required this.familyId, required final  List<InterviewQuestion> questions}): _questions = questions;
  factory _InterviewQuestionBank.fromJson(Map<String, dynamic> json) => _$InterviewQuestionBankFromJson(json);

@override final  String familyId;
 final  List<InterviewQuestion> _questions;
@override List<InterviewQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of InterviewQuestionBank
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InterviewQuestionBankCopyWith<_InterviewQuestionBank> get copyWith => __$InterviewQuestionBankCopyWithImpl<_InterviewQuestionBank>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InterviewQuestionBankToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InterviewQuestionBank&&(identical(other.familyId, familyId) || other.familyId == familyId)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'InterviewQuestionBank(familyId: $familyId, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$InterviewQuestionBankCopyWith<$Res> implements $InterviewQuestionBankCopyWith<$Res> {
  factory _$InterviewQuestionBankCopyWith(_InterviewQuestionBank value, $Res Function(_InterviewQuestionBank) _then) = __$InterviewQuestionBankCopyWithImpl;
@override @useResult
$Res call({
 String familyId, List<InterviewQuestion> questions
});




}
/// @nodoc
class __$InterviewQuestionBankCopyWithImpl<$Res>
    implements _$InterviewQuestionBankCopyWith<$Res> {
  __$InterviewQuestionBankCopyWithImpl(this._self, this._then);

  final _InterviewQuestionBank _self;
  final $Res Function(_InterviewQuestionBank) _then;

/// Create a copy of InterviewQuestionBank
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? familyId = null,Object? questions = null,}) {
  return _then(_InterviewQuestionBank(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<InterviewQuestion>,
  ));
}


}


/// @nodoc
mixin _$InterviewQuestion {

 String get id; int get version; String get familyId; InterviewTheme get theme; LocalizedText get question;/// What a strong answer covers; may be shared across every question of
/// [theme] (the spec gives guidance per theme, not per question).
 LocalizedText get guidance;/// A structural skeleton (e.g. "situation -> action -> result -> what
/// I'd repeat/change"), never a written-out answer.
 LocalizedText get modelAnswerSkeleton; List<String> get tags; ContentStatus get status; ContentMeta? get meta;
/// Create a copy of InterviewQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterviewQuestionCopyWith<InterviewQuestion> get copyWith => _$InterviewQuestionCopyWithImpl<InterviewQuestion>(this as InterviewQuestion, _$identity);

  /// Serializes this InterviewQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterviewQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.question, question) || other.question == question)&&(identical(other.guidance, guidance) || other.guidance == guidance)&&(identical(other.modelAnswerSkeleton, modelAnswerSkeleton) || other.modelAnswerSkeleton == modelAnswerSkeleton)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,familyId,theme,question,guidance,modelAnswerSkeleton,const DeepCollectionEquality().hash(tags),status,meta);

@override
String toString() {
  return 'InterviewQuestion(id: $id, version: $version, familyId: $familyId, theme: $theme, question: $question, guidance: $guidance, modelAnswerSkeleton: $modelAnswerSkeleton, tags: $tags, status: $status, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $InterviewQuestionCopyWith<$Res>  {
  factory $InterviewQuestionCopyWith(InterviewQuestion value, $Res Function(InterviewQuestion) _then) = _$InterviewQuestionCopyWithImpl;
@useResult
$Res call({
 String id, int version, String familyId, InterviewTheme theme, LocalizedText question, LocalizedText guidance, LocalizedText modelAnswerSkeleton, List<String> tags, ContentStatus status, ContentMeta? meta
});


$LocalizedTextCopyWith<$Res> get question;$LocalizedTextCopyWith<$Res> get guidance;$LocalizedTextCopyWith<$Res> get modelAnswerSkeleton;$ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class _$InterviewQuestionCopyWithImpl<$Res>
    implements $InterviewQuestionCopyWith<$Res> {
  _$InterviewQuestionCopyWithImpl(this._self, this._then);

  final InterviewQuestion _self;
  final $Res Function(InterviewQuestion) _then;

/// Create a copy of InterviewQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? version = null,Object? familyId = null,Object? theme = null,Object? question = null,Object? guidance = null,Object? modelAnswerSkeleton = null,Object? tags = null,Object? status = null,Object? meta = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as InterviewTheme,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as LocalizedText,guidance: null == guidance ? _self.guidance : guidance // ignore: cast_nullable_to_non_nullable
as LocalizedText,modelAnswerSkeleton: null == modelAnswerSkeleton ? _self.modelAnswerSkeleton : modelAnswerSkeleton // ignore: cast_nullable_to_non_nullable
as LocalizedText,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}
/// Create a copy of InterviewQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get question {
  
  return $LocalizedTextCopyWith<$Res>(_self.question, (value) {
    return _then(_self.copyWith(question: value));
  });
}/// Create a copy of InterviewQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get guidance {
  
  return $LocalizedTextCopyWith<$Res>(_self.guidance, (value) {
    return _then(_self.copyWith(guidance: value));
  });
}/// Create a copy of InterviewQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get modelAnswerSkeleton {
  
  return $LocalizedTextCopyWith<$Res>(_self.modelAnswerSkeleton, (value) {
    return _then(_self.copyWith(modelAnswerSkeleton: value));
  });
}/// Create a copy of InterviewQuestion
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


/// Adds pattern-matching-related methods to [InterviewQuestion].
extension InterviewQuestionPatterns on InterviewQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InterviewQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InterviewQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InterviewQuestion value)  $default,){
final _that = this;
switch (_that) {
case _InterviewQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InterviewQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _InterviewQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int version,  String familyId,  InterviewTheme theme,  LocalizedText question,  LocalizedText guidance,  LocalizedText modelAnswerSkeleton,  List<String> tags,  ContentStatus status,  ContentMeta? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InterviewQuestion() when $default != null:
return $default(_that.id,_that.version,_that.familyId,_that.theme,_that.question,_that.guidance,_that.modelAnswerSkeleton,_that.tags,_that.status,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int version,  String familyId,  InterviewTheme theme,  LocalizedText question,  LocalizedText guidance,  LocalizedText modelAnswerSkeleton,  List<String> tags,  ContentStatus status,  ContentMeta? meta)  $default,) {final _that = this;
switch (_that) {
case _InterviewQuestion():
return $default(_that.id,_that.version,_that.familyId,_that.theme,_that.question,_that.guidance,_that.modelAnswerSkeleton,_that.tags,_that.status,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int version,  String familyId,  InterviewTheme theme,  LocalizedText question,  LocalizedText guidance,  LocalizedText modelAnswerSkeleton,  List<String> tags,  ContentStatus status,  ContentMeta? meta)?  $default,) {final _that = this;
switch (_that) {
case _InterviewQuestion() when $default != null:
return $default(_that.id,_that.version,_that.familyId,_that.theme,_that.question,_that.guidance,_that.modelAnswerSkeleton,_that.tags,_that.status,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InterviewQuestion implements InterviewQuestion {
  const _InterviewQuestion({required this.id, required this.version, required this.familyId, required this.theme, required this.question, required this.guidance, required this.modelAnswerSkeleton, final  List<String> tags = const <String>[], this.status = ContentStatus.published, this.meta}): _tags = tags;
  factory _InterviewQuestion.fromJson(Map<String, dynamic> json) => _$InterviewQuestionFromJson(json);

@override final  String id;
@override final  int version;
@override final  String familyId;
@override final  InterviewTheme theme;
@override final  LocalizedText question;
/// What a strong answer covers; may be shared across every question of
/// [theme] (the spec gives guidance per theme, not per question).
@override final  LocalizedText guidance;
/// A structural skeleton (e.g. "situation -> action -> result -> what
/// I'd repeat/change"), never a written-out answer.
@override final  LocalizedText modelAnswerSkeleton;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  ContentStatus status;
@override final  ContentMeta? meta;

/// Create a copy of InterviewQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InterviewQuestionCopyWith<_InterviewQuestion> get copyWith => __$InterviewQuestionCopyWithImpl<_InterviewQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InterviewQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InterviewQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.question, question) || other.question == question)&&(identical(other.guidance, guidance) || other.guidance == guidance)&&(identical(other.modelAnswerSkeleton, modelAnswerSkeleton) || other.modelAnswerSkeleton == modelAnswerSkeleton)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,familyId,theme,question,guidance,modelAnswerSkeleton,const DeepCollectionEquality().hash(_tags),status,meta);

@override
String toString() {
  return 'InterviewQuestion(id: $id, version: $version, familyId: $familyId, theme: $theme, question: $question, guidance: $guidance, modelAnswerSkeleton: $modelAnswerSkeleton, tags: $tags, status: $status, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$InterviewQuestionCopyWith<$Res> implements $InterviewQuestionCopyWith<$Res> {
  factory _$InterviewQuestionCopyWith(_InterviewQuestion value, $Res Function(_InterviewQuestion) _then) = __$InterviewQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, int version, String familyId, InterviewTheme theme, LocalizedText question, LocalizedText guidance, LocalizedText modelAnswerSkeleton, List<String> tags, ContentStatus status, ContentMeta? meta
});


@override $LocalizedTextCopyWith<$Res> get question;@override $LocalizedTextCopyWith<$Res> get guidance;@override $LocalizedTextCopyWith<$Res> get modelAnswerSkeleton;@override $ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class __$InterviewQuestionCopyWithImpl<$Res>
    implements _$InterviewQuestionCopyWith<$Res> {
  __$InterviewQuestionCopyWithImpl(this._self, this._then);

  final _InterviewQuestion _self;
  final $Res Function(_InterviewQuestion) _then;

/// Create a copy of InterviewQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? version = null,Object? familyId = null,Object? theme = null,Object? question = null,Object? guidance = null,Object? modelAnswerSkeleton = null,Object? tags = null,Object? status = null,Object? meta = freezed,}) {
  return _then(_InterviewQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as InterviewTheme,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as LocalizedText,guidance: null == guidance ? _self.guidance : guidance // ignore: cast_nullable_to_non_nullable
as LocalizedText,modelAnswerSkeleton: null == modelAnswerSkeleton ? _self.modelAnswerSkeleton : modelAnswerSkeleton // ignore: cast_nullable_to_non_nullable
as LocalizedText,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}

/// Create a copy of InterviewQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get question {
  
  return $LocalizedTextCopyWith<$Res>(_self.question, (value) {
    return _then(_self.copyWith(question: value));
  });
}/// Create a copy of InterviewQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get guidance {
  
  return $LocalizedTextCopyWith<$Res>(_self.guidance, (value) {
    return _then(_self.copyWith(guidance: value));
  });
}/// Create a copy of InterviewQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get modelAnswerSkeleton {
  
  return $LocalizedTextCopyWith<$Res>(_self.modelAnswerSkeleton, (value) {
    return _then(_self.copyWith(modelAnswerSkeleton: value));
  });
}/// Create a copy of InterviewQuestion
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
