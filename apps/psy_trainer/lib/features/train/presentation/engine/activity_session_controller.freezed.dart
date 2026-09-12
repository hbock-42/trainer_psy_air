// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_session_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivitySessionRequest {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivitySessionRequest);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActivitySessionRequest()';
}


}

/// @nodoc
class $ActivitySessionRequestCopyWith<$Res>  {
$ActivitySessionRequestCopyWith(ActivitySessionRequest _, $Res Function(ActivitySessionRequest) __);
}


/// Adds pattern-matching-related methods to [ActivitySessionRequest].
extension ActivitySessionRequestPatterns on ActivitySessionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FreshSessionRequest value)?  fresh,TResult Function( ResumeSessionRequest value)?  resume,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FreshSessionRequest() when fresh != null:
return fresh(_that);case ResumeSessionRequest() when resume != null:
return resume(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FreshSessionRequest value)  fresh,required TResult Function( ResumeSessionRequest value)  resume,}){
final _that = this;
switch (_that) {
case FreshSessionRequest():
return fresh(_that);case ResumeSessionRequest():
return resume(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FreshSessionRequest value)?  fresh,TResult? Function( ResumeSessionRequest value)?  resume,}){
final _that = this;
switch (_that) {
case FreshSessionRequest() when fresh != null:
return fresh(_that);case ResumeSessionRequest() when resume != null:
return resume(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ActivitySessionConfig config)?  fresh,TResult Function( TrainingSession session,  List<Attempt> attempts)?  resume,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FreshSessionRequest() when fresh != null:
return fresh(_that.config);case ResumeSessionRequest() when resume != null:
return resume(_that.session,_that.attempts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ActivitySessionConfig config)  fresh,required TResult Function( TrainingSession session,  List<Attempt> attempts)  resume,}) {final _that = this;
switch (_that) {
case FreshSessionRequest():
return fresh(_that.config);case ResumeSessionRequest():
return resume(_that.session,_that.attempts);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ActivitySessionConfig config)?  fresh,TResult? Function( TrainingSession session,  List<Attempt> attempts)?  resume,}) {final _that = this;
switch (_that) {
case FreshSessionRequest() when fresh != null:
return fresh(_that.config);case ResumeSessionRequest() when resume != null:
return resume(_that.session,_that.attempts);case _:
  return null;

}
}

}

/// @nodoc


class FreshSessionRequest implements ActivitySessionRequest {
  const FreshSessionRequest(this.config);
  

 final  ActivitySessionConfig config;

/// Create a copy of ActivitySessionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FreshSessionRequestCopyWith<FreshSessionRequest> get copyWith => _$FreshSessionRequestCopyWithImpl<FreshSessionRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FreshSessionRequest&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,config);

@override
String toString() {
  return 'ActivitySessionRequest.fresh(config: $config)';
}


}

/// @nodoc
abstract mixin class $FreshSessionRequestCopyWith<$Res> implements $ActivitySessionRequestCopyWith<$Res> {
  factory $FreshSessionRequestCopyWith(FreshSessionRequest value, $Res Function(FreshSessionRequest) _then) = _$FreshSessionRequestCopyWithImpl;
@useResult
$Res call({
 ActivitySessionConfig config
});


$ActivitySessionConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$FreshSessionRequestCopyWithImpl<$Res>
    implements $FreshSessionRequestCopyWith<$Res> {
  _$FreshSessionRequestCopyWithImpl(this._self, this._then);

  final FreshSessionRequest _self;
  final $Res Function(FreshSessionRequest) _then;

/// Create a copy of ActivitySessionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? config = null,}) {
  return _then(FreshSessionRequest(
null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as ActivitySessionConfig,
  ));
}

/// Create a copy of ActivitySessionRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivitySessionConfigCopyWith<$Res> get config {
  
  return $ActivitySessionConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

/// @nodoc


class ResumeSessionRequest implements ActivitySessionRequest {
  const ResumeSessionRequest({required this.session, required final  List<Attempt> attempts}): _attempts = attempts;
  

 final  TrainingSession session;
 final  List<Attempt> _attempts;
 List<Attempt> get attempts {
  if (_attempts is EqualUnmodifiableListView) return _attempts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attempts);
}


/// Create a copy of ActivitySessionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResumeSessionRequestCopyWith<ResumeSessionRequest> get copyWith => _$ResumeSessionRequestCopyWithImpl<ResumeSessionRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResumeSessionRequest&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other._attempts, _attempts));
}


@override
int get hashCode => Object.hash(runtimeType,session,const DeepCollectionEquality().hash(_attempts));

@override
String toString() {
  return 'ActivitySessionRequest.resume(session: $session, attempts: $attempts)';
}


}

/// @nodoc
abstract mixin class $ResumeSessionRequestCopyWith<$Res> implements $ActivitySessionRequestCopyWith<$Res> {
  factory $ResumeSessionRequestCopyWith(ResumeSessionRequest value, $Res Function(ResumeSessionRequest) _then) = _$ResumeSessionRequestCopyWithImpl;
@useResult
$Res call({
 TrainingSession session, List<Attempt> attempts
});


$TrainingSessionCopyWith<$Res> get session;

}
/// @nodoc
class _$ResumeSessionRequestCopyWithImpl<$Res>
    implements $ResumeSessionRequestCopyWith<$Res> {
  _$ResumeSessionRequestCopyWithImpl(this._self, this._then);

  final ResumeSessionRequest _self;
  final $Res Function(ResumeSessionRequest) _then;

/// Create a copy of ActivitySessionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? session = null,Object? attempts = null,}) {
  return _then(ResumeSessionRequest(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as TrainingSession,attempts: null == attempts ? _self._attempts : attempts // ignore: cast_nullable_to_non_nullable
as List<Attempt>,
  ));
}

/// Create a copy of ActivitySessionRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrainingSessionCopyWith<$Res> get session {
  
  return $TrainingSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}

// dart format on
