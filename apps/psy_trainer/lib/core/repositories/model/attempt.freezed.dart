// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attempt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttemptOrigin {

 String get generatorId; int get seed; Map<String, Object?> get params; int get difficulty;
/// Create a copy of AttemptOrigin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttemptOriginCopyWith<AttemptOrigin> get copyWith => _$AttemptOriginCopyWithImpl<AttemptOrigin>(this as AttemptOrigin, _$identity);

  /// Serializes this AttemptOrigin to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttemptOrigin&&(identical(other.generatorId, generatorId) || other.generatorId == generatorId)&&(identical(other.seed, seed) || other.seed == seed)&&const DeepCollectionEquality().equals(other.params, params)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatorId,seed,const DeepCollectionEquality().hash(params),difficulty);

@override
String toString() {
  return 'AttemptOrigin(generatorId: $generatorId, seed: $seed, params: $params, difficulty: $difficulty)';
}


}

/// @nodoc
abstract mixin class $AttemptOriginCopyWith<$Res>  {
  factory $AttemptOriginCopyWith(AttemptOrigin value, $Res Function(AttemptOrigin) _then) = _$AttemptOriginCopyWithImpl;
@useResult
$Res call({
 String generatorId, int seed, Map<String, Object?> params, int difficulty
});




}
/// @nodoc
class _$AttemptOriginCopyWithImpl<$Res>
    implements $AttemptOriginCopyWith<$Res> {
  _$AttemptOriginCopyWithImpl(this._self, this._then);

  final AttemptOrigin _self;
  final $Res Function(AttemptOrigin) _then;

/// Create a copy of AttemptOrigin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? generatorId = null,Object? seed = null,Object? params = null,Object? difficulty = null,}) {
  return _then(_self.copyWith(
generatorId: null == generatorId ? _self.generatorId : generatorId // ignore: cast_nullable_to_non_nullable
as String,seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,params: null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AttemptOrigin].
extension AttemptOriginPatterns on AttemptOrigin {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttemptOrigin value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttemptOrigin() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttemptOrigin value)  $default,){
final _that = this;
switch (_that) {
case _AttemptOrigin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttemptOrigin value)?  $default,){
final _that = this;
switch (_that) {
case _AttemptOrigin() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String generatorId,  int seed,  Map<String, Object?> params,  int difficulty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttemptOrigin() when $default != null:
return $default(_that.generatorId,_that.seed,_that.params,_that.difficulty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String generatorId,  int seed,  Map<String, Object?> params,  int difficulty)  $default,) {final _that = this;
switch (_that) {
case _AttemptOrigin():
return $default(_that.generatorId,_that.seed,_that.params,_that.difficulty);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String generatorId,  int seed,  Map<String, Object?> params,  int difficulty)?  $default,) {final _that = this;
switch (_that) {
case _AttemptOrigin() when $default != null:
return $default(_that.generatorId,_that.seed,_that.params,_that.difficulty);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttemptOrigin implements AttemptOrigin {
  const _AttemptOrigin({required this.generatorId, required this.seed, final  Map<String, Object?> params = const <String, Object?>{}, this.difficulty = 3}): _params = params;
  factory _AttemptOrigin.fromJson(Map<String, dynamic> json) => _$AttemptOriginFromJson(json);

@override final  String generatorId;
@override final  int seed;
 final  Map<String, Object?> _params;
@override@JsonKey() Map<String, Object?> get params {
  if (_params is EqualUnmodifiableMapView) return _params;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_params);
}

@override@JsonKey() final  int difficulty;

/// Create a copy of AttemptOrigin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttemptOriginCopyWith<_AttemptOrigin> get copyWith => __$AttemptOriginCopyWithImpl<_AttemptOrigin>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttemptOriginToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttemptOrigin&&(identical(other.generatorId, generatorId) || other.generatorId == generatorId)&&(identical(other.seed, seed) || other.seed == seed)&&const DeepCollectionEquality().equals(other._params, _params)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatorId,seed,const DeepCollectionEquality().hash(_params),difficulty);

@override
String toString() {
  return 'AttemptOrigin(generatorId: $generatorId, seed: $seed, params: $params, difficulty: $difficulty)';
}


}

/// @nodoc
abstract mixin class _$AttemptOriginCopyWith<$Res> implements $AttemptOriginCopyWith<$Res> {
  factory _$AttemptOriginCopyWith(_AttemptOrigin value, $Res Function(_AttemptOrigin) _then) = __$AttemptOriginCopyWithImpl;
@override @useResult
$Res call({
 String generatorId, int seed, Map<String, Object?> params, int difficulty
});




}
/// @nodoc
class __$AttemptOriginCopyWithImpl<$Res>
    implements _$AttemptOriginCopyWith<$Res> {
  __$AttemptOriginCopyWithImpl(this._self, this._then);

  final _AttemptOrigin _self;
  final $Res Function(_AttemptOrigin) _then;

/// Create a copy of AttemptOrigin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? generatorId = null,Object? seed = null,Object? params = null,Object? difficulty = null,}) {
  return _then(_AttemptOrigin(
generatorId: null == generatorId ? _self.generatorId : generatorId // ignore: cast_nullable_to_non_nullable
as String,seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,params: null == params ? _self._params : params // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$NewAttempt {

 String get sessionId; String get familyId; bool get isCorrect; int get responseMs;/// 0-based rank of the stimulus within the session. Cadence-driven
/// activities fire many attempts per second; this, not the timestamp,
/// defines the order.
 int get position; String? get itemId; AttemptOrigin? get origin;/// Engine-specific answer payload; null when no answer was given.
 Map<String, Object?>? get answer;/// Exam sessions: index of the blueprint section.
 int? get sectionIndex;/// Defaults to "now" when omitted.
 DateTime? get answeredAt;
/// Create a copy of NewAttempt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewAttemptCopyWith<NewAttempt> get copyWith => _$NewAttemptCopyWithImpl<NewAttempt>(this as NewAttempt, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewAttempt&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.responseMs, responseMs) || other.responseMs == responseMs)&&(identical(other.position, position) || other.position == position)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.origin, origin) || other.origin == origin)&&const DeepCollectionEquality().equals(other.answer, answer)&&(identical(other.sectionIndex, sectionIndex) || other.sectionIndex == sectionIndex)&&(identical(other.answeredAt, answeredAt) || other.answeredAt == answeredAt));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,familyId,isCorrect,responseMs,position,itemId,origin,const DeepCollectionEquality().hash(answer),sectionIndex,answeredAt);

@override
String toString() {
  return 'NewAttempt(sessionId: $sessionId, familyId: $familyId, isCorrect: $isCorrect, responseMs: $responseMs, position: $position, itemId: $itemId, origin: $origin, answer: $answer, sectionIndex: $sectionIndex, answeredAt: $answeredAt)';
}


}

/// @nodoc
abstract mixin class $NewAttemptCopyWith<$Res>  {
  factory $NewAttemptCopyWith(NewAttempt value, $Res Function(NewAttempt) _then) = _$NewAttemptCopyWithImpl;
@useResult
$Res call({
 String sessionId, String familyId, bool isCorrect, int responseMs, int position, String? itemId, AttemptOrigin? origin, Map<String, Object?>? answer, int? sectionIndex, DateTime? answeredAt
});


$AttemptOriginCopyWith<$Res>? get origin;

}
/// @nodoc
class _$NewAttemptCopyWithImpl<$Res>
    implements $NewAttemptCopyWith<$Res> {
  _$NewAttemptCopyWithImpl(this._self, this._then);

  final NewAttempt _self;
  final $Res Function(NewAttempt) _then;

/// Create a copy of NewAttempt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? familyId = null,Object? isCorrect = null,Object? responseMs = null,Object? position = null,Object? itemId = freezed,Object? origin = freezed,Object? answer = freezed,Object? sectionIndex = freezed,Object? answeredAt = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,responseMs: null == responseMs ? _self.responseMs : responseMs // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as AttemptOrigin?,answer: freezed == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,sectionIndex: freezed == sectionIndex ? _self.sectionIndex : sectionIndex // ignore: cast_nullable_to_non_nullable
as int?,answeredAt: freezed == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of NewAttempt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttemptOriginCopyWith<$Res>? get origin {
    if (_self.origin == null) {
    return null;
  }

  return $AttemptOriginCopyWith<$Res>(_self.origin!, (value) {
    return _then(_self.copyWith(origin: value));
  });
}
}


/// Adds pattern-matching-related methods to [NewAttempt].
extension NewAttemptPatterns on NewAttempt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewAttempt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewAttempt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewAttempt value)  $default,){
final _that = this;
switch (_that) {
case _NewAttempt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewAttempt value)?  $default,){
final _that = this;
switch (_that) {
case _NewAttempt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  String familyId,  bool isCorrect,  int responseMs,  int position,  String? itemId,  AttemptOrigin? origin,  Map<String, Object?>? answer,  int? sectionIndex,  DateTime? answeredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewAttempt() when $default != null:
return $default(_that.sessionId,_that.familyId,_that.isCorrect,_that.responseMs,_that.position,_that.itemId,_that.origin,_that.answer,_that.sectionIndex,_that.answeredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  String familyId,  bool isCorrect,  int responseMs,  int position,  String? itemId,  AttemptOrigin? origin,  Map<String, Object?>? answer,  int? sectionIndex,  DateTime? answeredAt)  $default,) {final _that = this;
switch (_that) {
case _NewAttempt():
return $default(_that.sessionId,_that.familyId,_that.isCorrect,_that.responseMs,_that.position,_that.itemId,_that.origin,_that.answer,_that.sectionIndex,_that.answeredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  String familyId,  bool isCorrect,  int responseMs,  int position,  String? itemId,  AttemptOrigin? origin,  Map<String, Object?>? answer,  int? sectionIndex,  DateTime? answeredAt)?  $default,) {final _that = this;
switch (_that) {
case _NewAttempt() when $default != null:
return $default(_that.sessionId,_that.familyId,_that.isCorrect,_that.responseMs,_that.position,_that.itemId,_that.origin,_that.answer,_that.sectionIndex,_that.answeredAt);case _:
  return null;

}
}

}

/// @nodoc


class _NewAttempt implements NewAttempt {
  const _NewAttempt({required this.sessionId, required this.familyId, required this.isCorrect, required this.responseMs, required this.position, this.itemId, this.origin, final  Map<String, Object?>? answer, this.sectionIndex, this.answeredAt}): assert((itemId == null) != (origin == null), 'exactly one of itemId/origin is set'),_answer = answer;
  

@override final  String sessionId;
@override final  String familyId;
@override final  bool isCorrect;
@override final  int responseMs;
/// 0-based rank of the stimulus within the session. Cadence-driven
/// activities fire many attempts per second; this, not the timestamp,
/// defines the order.
@override final  int position;
@override final  String? itemId;
@override final  AttemptOrigin? origin;
/// Engine-specific answer payload; null when no answer was given.
 final  Map<String, Object?>? _answer;
/// Engine-specific answer payload; null when no answer was given.
@override Map<String, Object?>? get answer {
  final value = _answer;
  if (value == null) return null;
  if (_answer is EqualUnmodifiableMapView) return _answer;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// Exam sessions: index of the blueprint section.
@override final  int? sectionIndex;
/// Defaults to "now" when omitted.
@override final  DateTime? answeredAt;

/// Create a copy of NewAttempt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewAttemptCopyWith<_NewAttempt> get copyWith => __$NewAttemptCopyWithImpl<_NewAttempt>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewAttempt&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.responseMs, responseMs) || other.responseMs == responseMs)&&(identical(other.position, position) || other.position == position)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.origin, origin) || other.origin == origin)&&const DeepCollectionEquality().equals(other._answer, _answer)&&(identical(other.sectionIndex, sectionIndex) || other.sectionIndex == sectionIndex)&&(identical(other.answeredAt, answeredAt) || other.answeredAt == answeredAt));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,familyId,isCorrect,responseMs,position,itemId,origin,const DeepCollectionEquality().hash(_answer),sectionIndex,answeredAt);

@override
String toString() {
  return 'NewAttempt(sessionId: $sessionId, familyId: $familyId, isCorrect: $isCorrect, responseMs: $responseMs, position: $position, itemId: $itemId, origin: $origin, answer: $answer, sectionIndex: $sectionIndex, answeredAt: $answeredAt)';
}


}

/// @nodoc
abstract mixin class _$NewAttemptCopyWith<$Res> implements $NewAttemptCopyWith<$Res> {
  factory _$NewAttemptCopyWith(_NewAttempt value, $Res Function(_NewAttempt) _then) = __$NewAttemptCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String familyId, bool isCorrect, int responseMs, int position, String? itemId, AttemptOrigin? origin, Map<String, Object?>? answer, int? sectionIndex, DateTime? answeredAt
});


@override $AttemptOriginCopyWith<$Res>? get origin;

}
/// @nodoc
class __$NewAttemptCopyWithImpl<$Res>
    implements _$NewAttemptCopyWith<$Res> {
  __$NewAttemptCopyWithImpl(this._self, this._then);

  final _NewAttempt _self;
  final $Res Function(_NewAttempt) _then;

/// Create a copy of NewAttempt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? familyId = null,Object? isCorrect = null,Object? responseMs = null,Object? position = null,Object? itemId = freezed,Object? origin = freezed,Object? answer = freezed,Object? sectionIndex = freezed,Object? answeredAt = freezed,}) {
  return _then(_NewAttempt(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,responseMs: null == responseMs ? _self.responseMs : responseMs // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as AttemptOrigin?,answer: freezed == answer ? _self._answer : answer // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,sectionIndex: freezed == sectionIndex ? _self.sectionIndex : sectionIndex // ignore: cast_nullable_to_non_nullable
as int?,answeredAt: freezed == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of NewAttempt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttemptOriginCopyWith<$Res>? get origin {
    if (_self.origin == null) {
    return null;
  }

  return $AttemptOriginCopyWith<$Res>(_self.origin!, (value) {
    return _then(_self.copyWith(origin: value));
  });
}
}

/// @nodoc
mixin _$Attempt {

 String get id; String get sessionId; String get familyId; bool get isCorrect; int get responseMs; int get position; DateTime get answeredAt; String? get itemId; AttemptOrigin? get origin; Map<String, Object?>? get answer; int? get sectionIndex;
/// Create a copy of Attempt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttemptCopyWith<Attempt> get copyWith => _$AttemptCopyWithImpl<Attempt>(this as Attempt, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Attempt&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.responseMs, responseMs) || other.responseMs == responseMs)&&(identical(other.position, position) || other.position == position)&&(identical(other.answeredAt, answeredAt) || other.answeredAt == answeredAt)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.origin, origin) || other.origin == origin)&&const DeepCollectionEquality().equals(other.answer, answer)&&(identical(other.sectionIndex, sectionIndex) || other.sectionIndex == sectionIndex));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,familyId,isCorrect,responseMs,position,answeredAt,itemId,origin,const DeepCollectionEquality().hash(answer),sectionIndex);

@override
String toString() {
  return 'Attempt(id: $id, sessionId: $sessionId, familyId: $familyId, isCorrect: $isCorrect, responseMs: $responseMs, position: $position, answeredAt: $answeredAt, itemId: $itemId, origin: $origin, answer: $answer, sectionIndex: $sectionIndex)';
}


}

/// @nodoc
abstract mixin class $AttemptCopyWith<$Res>  {
  factory $AttemptCopyWith(Attempt value, $Res Function(Attempt) _then) = _$AttemptCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, String familyId, bool isCorrect, int responseMs, int position, DateTime answeredAt, String? itemId, AttemptOrigin? origin, Map<String, Object?>? answer, int? sectionIndex
});


$AttemptOriginCopyWith<$Res>? get origin;

}
/// @nodoc
class _$AttemptCopyWithImpl<$Res>
    implements $AttemptCopyWith<$Res> {
  _$AttemptCopyWithImpl(this._self, this._then);

  final Attempt _self;
  final $Res Function(Attempt) _then;

/// Create a copy of Attempt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? familyId = null,Object? isCorrect = null,Object? responseMs = null,Object? position = null,Object? answeredAt = null,Object? itemId = freezed,Object? origin = freezed,Object? answer = freezed,Object? sectionIndex = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,responseMs: null == responseMs ? _self.responseMs : responseMs // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,answeredAt: null == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as AttemptOrigin?,answer: freezed == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,sectionIndex: freezed == sectionIndex ? _self.sectionIndex : sectionIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of Attempt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttemptOriginCopyWith<$Res>? get origin {
    if (_self.origin == null) {
    return null;
  }

  return $AttemptOriginCopyWith<$Res>(_self.origin!, (value) {
    return _then(_self.copyWith(origin: value));
  });
}
}


/// Adds pattern-matching-related methods to [Attempt].
extension AttemptPatterns on Attempt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Attempt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Attempt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Attempt value)  $default,){
final _that = this;
switch (_that) {
case _Attempt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Attempt value)?  $default,){
final _that = this;
switch (_that) {
case _Attempt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  String familyId,  bool isCorrect,  int responseMs,  int position,  DateTime answeredAt,  String? itemId,  AttemptOrigin? origin,  Map<String, Object?>? answer,  int? sectionIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Attempt() when $default != null:
return $default(_that.id,_that.sessionId,_that.familyId,_that.isCorrect,_that.responseMs,_that.position,_that.answeredAt,_that.itemId,_that.origin,_that.answer,_that.sectionIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  String familyId,  bool isCorrect,  int responseMs,  int position,  DateTime answeredAt,  String? itemId,  AttemptOrigin? origin,  Map<String, Object?>? answer,  int? sectionIndex)  $default,) {final _that = this;
switch (_that) {
case _Attempt():
return $default(_that.id,_that.sessionId,_that.familyId,_that.isCorrect,_that.responseMs,_that.position,_that.answeredAt,_that.itemId,_that.origin,_that.answer,_that.sectionIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  String familyId,  bool isCorrect,  int responseMs,  int position,  DateTime answeredAt,  String? itemId,  AttemptOrigin? origin,  Map<String, Object?>? answer,  int? sectionIndex)?  $default,) {final _that = this;
switch (_that) {
case _Attempt() when $default != null:
return $default(_that.id,_that.sessionId,_that.familyId,_that.isCorrect,_that.responseMs,_that.position,_that.answeredAt,_that.itemId,_that.origin,_that.answer,_that.sectionIndex);case _:
  return null;

}
}

}

/// @nodoc


class _Attempt extends Attempt {
  const _Attempt({required this.id, required this.sessionId, required this.familyId, required this.isCorrect, required this.responseMs, required this.position, required this.answeredAt, this.itemId, this.origin, final  Map<String, Object?>? answer, this.sectionIndex}): _answer = answer,super._();
  

@override final  String id;
@override final  String sessionId;
@override final  String familyId;
@override final  bool isCorrect;
@override final  int responseMs;
@override final  int position;
@override final  DateTime answeredAt;
@override final  String? itemId;
@override final  AttemptOrigin? origin;
 final  Map<String, Object?>? _answer;
@override Map<String, Object?>? get answer {
  final value = _answer;
  if (value == null) return null;
  if (_answer is EqualUnmodifiableMapView) return _answer;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  int? sectionIndex;

/// Create a copy of Attempt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttemptCopyWith<_Attempt> get copyWith => __$AttemptCopyWithImpl<_Attempt>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Attempt&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.responseMs, responseMs) || other.responseMs == responseMs)&&(identical(other.position, position) || other.position == position)&&(identical(other.answeredAt, answeredAt) || other.answeredAt == answeredAt)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.origin, origin) || other.origin == origin)&&const DeepCollectionEquality().equals(other._answer, _answer)&&(identical(other.sectionIndex, sectionIndex) || other.sectionIndex == sectionIndex));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,familyId,isCorrect,responseMs,position,answeredAt,itemId,origin,const DeepCollectionEquality().hash(_answer),sectionIndex);

@override
String toString() {
  return 'Attempt(id: $id, sessionId: $sessionId, familyId: $familyId, isCorrect: $isCorrect, responseMs: $responseMs, position: $position, answeredAt: $answeredAt, itemId: $itemId, origin: $origin, answer: $answer, sectionIndex: $sectionIndex)';
}


}

/// @nodoc
abstract mixin class _$AttemptCopyWith<$Res> implements $AttemptCopyWith<$Res> {
  factory _$AttemptCopyWith(_Attempt value, $Res Function(_Attempt) _then) = __$AttemptCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, String familyId, bool isCorrect, int responseMs, int position, DateTime answeredAt, String? itemId, AttemptOrigin? origin, Map<String, Object?>? answer, int? sectionIndex
});


@override $AttemptOriginCopyWith<$Res>? get origin;

}
/// @nodoc
class __$AttemptCopyWithImpl<$Res>
    implements _$AttemptCopyWith<$Res> {
  __$AttemptCopyWithImpl(this._self, this._then);

  final _Attempt _self;
  final $Res Function(_Attempt) _then;

/// Create a copy of Attempt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? familyId = null,Object? isCorrect = null,Object? responseMs = null,Object? position = null,Object? answeredAt = null,Object? itemId = freezed,Object? origin = freezed,Object? answer = freezed,Object? sectionIndex = freezed,}) {
  return _then(_Attempt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,responseMs: null == responseMs ? _self.responseMs : responseMs // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,answeredAt: null == answeredAt ? _self.answeredAt : answeredAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as AttemptOrigin?,answer: freezed == answer ? _self._answer : answer // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,sectionIndex: freezed == sectionIndex ? _self.sectionIndex : sectionIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of Attempt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttemptOriginCopyWith<$Res>? get origin {
    if (_self.origin == null) {
    return null;
  }

  return $AttemptOriginCopyWith<$Res>(_self.origin!, (value) {
    return _then(_self.copyWith(origin: value));
  });
}
}

// dart format on
