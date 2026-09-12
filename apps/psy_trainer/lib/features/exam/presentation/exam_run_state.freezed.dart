// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_run_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExamRunState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamRunState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExamRunState()';
}


}

/// @nodoc
class $ExamRunStateCopyWith<$Res>  {
$ExamRunStateCopyWith(ExamRunState _, $Res Function(ExamRunState) __);
}


/// Adds pattern-matching-related methods to [ExamRunState].
extension ExamRunStatePatterns on ExamRunState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ExamRunLoading value)?  loading,TResult Function( ExamRunRunning value)?  running,TResult Function( ExamRunOnBreak value)?  onBreak,TResult Function( ExamRunFinishing value)?  finishing,TResult Function( ExamRunDone value)?  done,TResult Function( ExamRunAborted value)?  aborted,TResult Function( ExamRunUnavailable value)?  unavailable,TResult Function( ExamRunError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ExamRunLoading() when loading != null:
return loading(_that);case ExamRunRunning() when running != null:
return running(_that);case ExamRunOnBreak() when onBreak != null:
return onBreak(_that);case ExamRunFinishing() when finishing != null:
return finishing(_that);case ExamRunDone() when done != null:
return done(_that);case ExamRunAborted() when aborted != null:
return aborted(_that);case ExamRunUnavailable() when unavailable != null:
return unavailable(_that);case ExamRunError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ExamRunLoading value)  loading,required TResult Function( ExamRunRunning value)  running,required TResult Function( ExamRunOnBreak value)  onBreak,required TResult Function( ExamRunFinishing value)  finishing,required TResult Function( ExamRunDone value)  done,required TResult Function( ExamRunAborted value)  aborted,required TResult Function( ExamRunUnavailable value)  unavailable,required TResult Function( ExamRunError value)  error,}){
final _that = this;
switch (_that) {
case ExamRunLoading():
return loading(_that);case ExamRunRunning():
return running(_that);case ExamRunOnBreak():
return onBreak(_that);case ExamRunFinishing():
return finishing(_that);case ExamRunDone():
return done(_that);case ExamRunAborted():
return aborted(_that);case ExamRunUnavailable():
return unavailable(_that);case ExamRunError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ExamRunLoading value)?  loading,TResult? Function( ExamRunRunning value)?  running,TResult? Function( ExamRunOnBreak value)?  onBreak,TResult? Function( ExamRunFinishing value)?  finishing,TResult? Function( ExamRunDone value)?  done,TResult? Function( ExamRunAborted value)?  aborted,TResult? Function( ExamRunUnavailable value)?  unavailable,TResult? Function( ExamRunError value)?  error,}){
final _that = this;
switch (_that) {
case ExamRunLoading() when loading != null:
return loading(_that);case ExamRunRunning() when running != null:
return running(_that);case ExamRunOnBreak() when onBreak != null:
return onBreak(_that);case ExamRunFinishing() when finishing != null:
return finishing(_that);case ExamRunDone() when done != null:
return done(_that);case ExamRunAborted() when aborted != null:
return aborted(_that);case ExamRunUnavailable() when unavailable != null:
return unavailable(_that);case ExamRunError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( int planIndex,  int totalSections,  ActivitySessionRequest request)?  running,TResult Function( int nextPlanIndex,  int totalSections)?  onBreak,TResult Function()?  finishing,TResult Function( String sessionId)?  done,TResult Function()?  aborted,TResult Function()?  unavailable,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ExamRunLoading() when loading != null:
return loading();case ExamRunRunning() when running != null:
return running(_that.planIndex,_that.totalSections,_that.request);case ExamRunOnBreak() when onBreak != null:
return onBreak(_that.nextPlanIndex,_that.totalSections);case ExamRunFinishing() when finishing != null:
return finishing();case ExamRunDone() when done != null:
return done(_that.sessionId);case ExamRunAborted() when aborted != null:
return aborted();case ExamRunUnavailable() when unavailable != null:
return unavailable();case ExamRunError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( int planIndex,  int totalSections,  ActivitySessionRequest request)  running,required TResult Function( int nextPlanIndex,  int totalSections)  onBreak,required TResult Function()  finishing,required TResult Function( String sessionId)  done,required TResult Function()  aborted,required TResult Function()  unavailable,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ExamRunLoading():
return loading();case ExamRunRunning():
return running(_that.planIndex,_that.totalSections,_that.request);case ExamRunOnBreak():
return onBreak(_that.nextPlanIndex,_that.totalSections);case ExamRunFinishing():
return finishing();case ExamRunDone():
return done(_that.sessionId);case ExamRunAborted():
return aborted();case ExamRunUnavailable():
return unavailable();case ExamRunError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( int planIndex,  int totalSections,  ActivitySessionRequest request)?  running,TResult? Function( int nextPlanIndex,  int totalSections)?  onBreak,TResult? Function()?  finishing,TResult? Function( String sessionId)?  done,TResult? Function()?  aborted,TResult? Function()?  unavailable,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ExamRunLoading() when loading != null:
return loading();case ExamRunRunning() when running != null:
return running(_that.planIndex,_that.totalSections,_that.request);case ExamRunOnBreak() when onBreak != null:
return onBreak(_that.nextPlanIndex,_that.totalSections);case ExamRunFinishing() when finishing != null:
return finishing();case ExamRunDone() when done != null:
return done(_that.sessionId);case ExamRunAborted() when aborted != null:
return aborted();case ExamRunUnavailable() when unavailable != null:
return unavailable();case ExamRunError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ExamRunLoading implements ExamRunState {
  const ExamRunLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamRunLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExamRunState.loading()';
}


}




/// @nodoc


class ExamRunRunning implements ExamRunState {
  const ExamRunRunning({required this.planIndex, required this.totalSections, required this.request});
  

 final  int planIndex;
 final  int totalSections;
 final  ActivitySessionRequest request;

/// Create a copy of ExamRunState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamRunRunningCopyWith<ExamRunRunning> get copyWith => _$ExamRunRunningCopyWithImpl<ExamRunRunning>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamRunRunning&&(identical(other.planIndex, planIndex) || other.planIndex == planIndex)&&(identical(other.totalSections, totalSections) || other.totalSections == totalSections)&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,planIndex,totalSections,request);

@override
String toString() {
  return 'ExamRunState.running(planIndex: $planIndex, totalSections: $totalSections, request: $request)';
}


}

/// @nodoc
abstract mixin class $ExamRunRunningCopyWith<$Res> implements $ExamRunStateCopyWith<$Res> {
  factory $ExamRunRunningCopyWith(ExamRunRunning value, $Res Function(ExamRunRunning) _then) = _$ExamRunRunningCopyWithImpl;
@useResult
$Res call({
 int planIndex, int totalSections, ActivitySessionRequest request
});


$ActivitySessionRequestCopyWith<$Res> get request;

}
/// @nodoc
class _$ExamRunRunningCopyWithImpl<$Res>
    implements $ExamRunRunningCopyWith<$Res> {
  _$ExamRunRunningCopyWithImpl(this._self, this._then);

  final ExamRunRunning _self;
  final $Res Function(ExamRunRunning) _then;

/// Create a copy of ExamRunState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? planIndex = null,Object? totalSections = null,Object? request = null,}) {
  return _then(ExamRunRunning(
planIndex: null == planIndex ? _self.planIndex : planIndex // ignore: cast_nullable_to_non_nullable
as int,totalSections: null == totalSections ? _self.totalSections : totalSections // ignore: cast_nullable_to_non_nullable
as int,request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as ActivitySessionRequest,
  ));
}

/// Create a copy of ExamRunState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivitySessionRequestCopyWith<$Res> get request {
  
  return $ActivitySessionRequestCopyWith<$Res>(_self.request, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

/// @nodoc


class ExamRunOnBreak implements ExamRunState {
  const ExamRunOnBreak({required this.nextPlanIndex, required this.totalSections});
  

 final  int nextPlanIndex;
 final  int totalSections;

/// Create a copy of ExamRunState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamRunOnBreakCopyWith<ExamRunOnBreak> get copyWith => _$ExamRunOnBreakCopyWithImpl<ExamRunOnBreak>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamRunOnBreak&&(identical(other.nextPlanIndex, nextPlanIndex) || other.nextPlanIndex == nextPlanIndex)&&(identical(other.totalSections, totalSections) || other.totalSections == totalSections));
}


@override
int get hashCode => Object.hash(runtimeType,nextPlanIndex,totalSections);

@override
String toString() {
  return 'ExamRunState.onBreak(nextPlanIndex: $nextPlanIndex, totalSections: $totalSections)';
}


}

/// @nodoc
abstract mixin class $ExamRunOnBreakCopyWith<$Res> implements $ExamRunStateCopyWith<$Res> {
  factory $ExamRunOnBreakCopyWith(ExamRunOnBreak value, $Res Function(ExamRunOnBreak) _then) = _$ExamRunOnBreakCopyWithImpl;
@useResult
$Res call({
 int nextPlanIndex, int totalSections
});




}
/// @nodoc
class _$ExamRunOnBreakCopyWithImpl<$Res>
    implements $ExamRunOnBreakCopyWith<$Res> {
  _$ExamRunOnBreakCopyWithImpl(this._self, this._then);

  final ExamRunOnBreak _self;
  final $Res Function(ExamRunOnBreak) _then;

/// Create a copy of ExamRunState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? nextPlanIndex = null,Object? totalSections = null,}) {
  return _then(ExamRunOnBreak(
nextPlanIndex: null == nextPlanIndex ? _self.nextPlanIndex : nextPlanIndex // ignore: cast_nullable_to_non_nullable
as int,totalSections: null == totalSections ? _self.totalSections : totalSections // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ExamRunFinishing implements ExamRunState {
  const ExamRunFinishing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamRunFinishing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExamRunState.finishing()';
}


}




/// @nodoc


class ExamRunDone implements ExamRunState {
  const ExamRunDone({required this.sessionId});
  

 final  String sessionId;

/// Create a copy of ExamRunState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamRunDoneCopyWith<ExamRunDone> get copyWith => _$ExamRunDoneCopyWithImpl<ExamRunDone>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamRunDone&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId);

@override
String toString() {
  return 'ExamRunState.done(sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class $ExamRunDoneCopyWith<$Res> implements $ExamRunStateCopyWith<$Res> {
  factory $ExamRunDoneCopyWith(ExamRunDone value, $Res Function(ExamRunDone) _then) = _$ExamRunDoneCopyWithImpl;
@useResult
$Res call({
 String sessionId
});




}
/// @nodoc
class _$ExamRunDoneCopyWithImpl<$Res>
    implements $ExamRunDoneCopyWith<$Res> {
  _$ExamRunDoneCopyWithImpl(this._self, this._then);

  final ExamRunDone _self;
  final $Res Function(ExamRunDone) _then;

/// Create a copy of ExamRunState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sessionId = null,}) {
  return _then(ExamRunDone(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ExamRunAborted implements ExamRunState {
  const ExamRunAborted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamRunAborted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExamRunState.aborted()';
}


}




/// @nodoc


class ExamRunUnavailable implements ExamRunState {
  const ExamRunUnavailable();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamRunUnavailable);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ExamRunState.unavailable()';
}


}




/// @nodoc


class ExamRunError implements ExamRunState {
  const ExamRunError(this.message);
  

 final  String message;

/// Create a copy of ExamRunState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamRunErrorCopyWith<ExamRunError> get copyWith => _$ExamRunErrorCopyWithImpl<ExamRunError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamRunError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ExamRunState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ExamRunErrorCopyWith<$Res> implements $ExamRunStateCopyWith<$Res> {
  factory $ExamRunErrorCopyWith(ExamRunError value, $Res Function(ExamRunError) _then) = _$ExamRunErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ExamRunErrorCopyWithImpl<$Res>
    implements $ExamRunErrorCopyWith<$Res> {
  _$ExamRunErrorCopyWithImpl(this._self, this._then);

  final ExamRunError _self;
  final $Res Function(ExamRunError) _then;

/// Create a copy of ExamRunState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ExamRunError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
