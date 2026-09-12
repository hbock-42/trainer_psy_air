// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrainingSession {

 String get id; SessionMode get mode; DateTime get startedAt; SessionStatus get status; Map<String, Object?> get config;/// One family for practice sessions; null for exams.
 String? get familyId;/// The blueprint of an exam session; null for practice.
 String? get blueprintId; DateTime? get endedAt;/// Final score in the engine's own unit; null while in progress.
 double? get score;
/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrainingSessionCopyWith<TrainingSession> get copyWith => _$TrainingSessionCopyWithImpl<TrainingSession>(this as TrainingSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrainingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.config, config)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.blueprintId, blueprintId) || other.blueprintId == blueprintId)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.score, score) || other.score == score));
}


@override
int get hashCode => Object.hash(runtimeType,id,mode,startedAt,status,const DeepCollectionEquality().hash(config),familyId,blueprintId,endedAt,score);

@override
String toString() {
  return 'TrainingSession(id: $id, mode: $mode, startedAt: $startedAt, status: $status, config: $config, familyId: $familyId, blueprintId: $blueprintId, endedAt: $endedAt, score: $score)';
}


}

/// @nodoc
abstract mixin class $TrainingSessionCopyWith<$Res>  {
  factory $TrainingSessionCopyWith(TrainingSession value, $Res Function(TrainingSession) _then) = _$TrainingSessionCopyWithImpl;
@useResult
$Res call({
 String id, SessionMode mode, DateTime startedAt, SessionStatus status, Map<String, Object?> config, String? familyId, String? blueprintId, DateTime? endedAt, double? score
});




}
/// @nodoc
class _$TrainingSessionCopyWithImpl<$Res>
    implements $TrainingSessionCopyWith<$Res> {
  _$TrainingSessionCopyWithImpl(this._self, this._then);

  final TrainingSession _self;
  final $Res Function(TrainingSession) _then;

/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mode = null,Object? startedAt = null,Object? status = null,Object? config = null,Object? familyId = freezed,Object? blueprintId = freezed,Object? endedAt = freezed,Object? score = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionMode,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,blueprintId: freezed == blueprintId ? _self.blueprintId : blueprintId // ignore: cast_nullable_to_non_nullable
as String?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrainingSession].
extension TrainingSessionPatterns on TrainingSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrainingSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrainingSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrainingSession value)  $default,){
final _that = this;
switch (_that) {
case _TrainingSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrainingSession value)?  $default,){
final _that = this;
switch (_that) {
case _TrainingSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  SessionMode mode,  DateTime startedAt,  SessionStatus status,  Map<String, Object?> config,  String? familyId,  String? blueprintId,  DateTime? endedAt,  double? score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrainingSession() when $default != null:
return $default(_that.id,_that.mode,_that.startedAt,_that.status,_that.config,_that.familyId,_that.blueprintId,_that.endedAt,_that.score);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  SessionMode mode,  DateTime startedAt,  SessionStatus status,  Map<String, Object?> config,  String? familyId,  String? blueprintId,  DateTime? endedAt,  double? score)  $default,) {final _that = this;
switch (_that) {
case _TrainingSession():
return $default(_that.id,_that.mode,_that.startedAt,_that.status,_that.config,_that.familyId,_that.blueprintId,_that.endedAt,_that.score);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  SessionMode mode,  DateTime startedAt,  SessionStatus status,  Map<String, Object?> config,  String? familyId,  String? blueprintId,  DateTime? endedAt,  double? score)?  $default,) {final _that = this;
switch (_that) {
case _TrainingSession() when $default != null:
return $default(_that.id,_that.mode,_that.startedAt,_that.status,_that.config,_that.familyId,_that.blueprintId,_that.endedAt,_that.score);case _:
  return null;

}
}

}

/// @nodoc


class _TrainingSession extends TrainingSession {
  const _TrainingSession({required this.id, required this.mode, required this.startedAt, required this.status, required final  Map<String, Object?> config, this.familyId, this.blueprintId, this.endedAt, this.score}): _config = config,super._();
  

@override final  String id;
@override final  SessionMode mode;
@override final  DateTime startedAt;
@override final  SessionStatus status;
 final  Map<String, Object?> _config;
@override Map<String, Object?> get config {
  if (_config is EqualUnmodifiableMapView) return _config;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_config);
}

/// One family for practice sessions; null for exams.
@override final  String? familyId;
/// The blueprint of an exam session; null for practice.
@override final  String? blueprintId;
@override final  DateTime? endedAt;
/// Final score in the engine's own unit; null while in progress.
@override final  double? score;

/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrainingSessionCopyWith<_TrainingSession> get copyWith => __$TrainingSessionCopyWithImpl<_TrainingSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrainingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._config, _config)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.blueprintId, blueprintId) || other.blueprintId == blueprintId)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.score, score) || other.score == score));
}


@override
int get hashCode => Object.hash(runtimeType,id,mode,startedAt,status,const DeepCollectionEquality().hash(_config),familyId,blueprintId,endedAt,score);

@override
String toString() {
  return 'TrainingSession(id: $id, mode: $mode, startedAt: $startedAt, status: $status, config: $config, familyId: $familyId, blueprintId: $blueprintId, endedAt: $endedAt, score: $score)';
}


}

/// @nodoc
abstract mixin class _$TrainingSessionCopyWith<$Res> implements $TrainingSessionCopyWith<$Res> {
  factory _$TrainingSessionCopyWith(_TrainingSession value, $Res Function(_TrainingSession) _then) = __$TrainingSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, SessionMode mode, DateTime startedAt, SessionStatus status, Map<String, Object?> config, String? familyId, String? blueprintId, DateTime? endedAt, double? score
});




}
/// @nodoc
class __$TrainingSessionCopyWithImpl<$Res>
    implements _$TrainingSessionCopyWith<$Res> {
  __$TrainingSessionCopyWithImpl(this._self, this._then);

  final _TrainingSession _self;
  final $Res Function(_TrainingSession) _then;

/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mode = null,Object? startedAt = null,Object? status = null,Object? config = null,Object? familyId = freezed,Object? blueprintId = freezed,Object? endedAt = freezed,Object? score = freezed,}) {
  return _then(_TrainingSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionMode,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,config: null == config ? _self._config : config // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,familyId: freezed == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String?,blueprintId: freezed == blueprintId ? _self.blueprintId : blueprintId // ignore: cast_nullable_to_non_nullable
as String?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,score: freezed == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
