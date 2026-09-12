// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActivitySessionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivitySessionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActivitySessionState()';
}


}

/// @nodoc
class $ActivitySessionStateCopyWith<$Res>  {
$ActivitySessionStateCopyWith(ActivitySessionState _, $Res Function(ActivitySessionState) __);
}


/// Adds pattern-matching-related methods to [ActivitySessionState].
extension ActivitySessionStatePatterns on ActivitySessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ActivityBriefing value)?  briefing,TResult Function( ActivityRunning value)?  running,TResult Function( ActivityPaused value)?  paused,TResult Function( ActivityFinished value)?  finished,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ActivityBriefing() when briefing != null:
return briefing(_that);case ActivityRunning() when running != null:
return running(_that);case ActivityPaused() when paused != null:
return paused(_that);case ActivityFinished() when finished != null:
return finished(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ActivityBriefing value)  briefing,required TResult Function( ActivityRunning value)  running,required TResult Function( ActivityPaused value)  paused,required TResult Function( ActivityFinished value)  finished,}){
final _that = this;
switch (_that) {
case ActivityBriefing():
return briefing(_that);case ActivityRunning():
return running(_that);case ActivityPaused():
return paused(_that);case ActivityFinished():
return finished(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ActivityBriefing value)?  briefing,TResult? Function( ActivityRunning value)?  running,TResult? Function( ActivityPaused value)?  paused,TResult? Function( ActivityFinished value)?  finished,}){
final _that = this;
switch (_that) {
case ActivityBriefing() when briefing != null:
return briefing(_that);case ActivityRunning() when running != null:
return running(_that);case ActivityPaused() when paused != null:
return paused(_that);case ActivityFinished() when finished != null:
return finished(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int itemCount,  int startIndex)?  briefing,TResult Function( int itemIndex,  int itemCount,  Item item,  ItemPhase phase,  DateTime itemStartedAt,  DateTime? itemDeadline,  DateTime? sectionDeadline,  ItemResult? feedback,  bool awaitsNext)?  running,TResult Function( ActivityRunning snapshot,  Duration? itemRemaining,  Duration? sectionRemaining)?  paused,TResult Function( SessionResult result)?  finished,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ActivityBriefing() when briefing != null:
return briefing(_that.itemCount,_that.startIndex);case ActivityRunning() when running != null:
return running(_that.itemIndex,_that.itemCount,_that.item,_that.phase,_that.itemStartedAt,_that.itemDeadline,_that.sectionDeadline,_that.feedback,_that.awaitsNext);case ActivityPaused() when paused != null:
return paused(_that.snapshot,_that.itemRemaining,_that.sectionRemaining);case ActivityFinished() when finished != null:
return finished(_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int itemCount,  int startIndex)  briefing,required TResult Function( int itemIndex,  int itemCount,  Item item,  ItemPhase phase,  DateTime itemStartedAt,  DateTime? itemDeadline,  DateTime? sectionDeadline,  ItemResult? feedback,  bool awaitsNext)  running,required TResult Function( ActivityRunning snapshot,  Duration? itemRemaining,  Duration? sectionRemaining)  paused,required TResult Function( SessionResult result)  finished,}) {final _that = this;
switch (_that) {
case ActivityBriefing():
return briefing(_that.itemCount,_that.startIndex);case ActivityRunning():
return running(_that.itemIndex,_that.itemCount,_that.item,_that.phase,_that.itemStartedAt,_that.itemDeadline,_that.sectionDeadline,_that.feedback,_that.awaitsNext);case ActivityPaused():
return paused(_that.snapshot,_that.itemRemaining,_that.sectionRemaining);case ActivityFinished():
return finished(_that.result);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int itemCount,  int startIndex)?  briefing,TResult? Function( int itemIndex,  int itemCount,  Item item,  ItemPhase phase,  DateTime itemStartedAt,  DateTime? itemDeadline,  DateTime? sectionDeadline,  ItemResult? feedback,  bool awaitsNext)?  running,TResult? Function( ActivityRunning snapshot,  Duration? itemRemaining,  Duration? sectionRemaining)?  paused,TResult? Function( SessionResult result)?  finished,}) {final _that = this;
switch (_that) {
case ActivityBriefing() when briefing != null:
return briefing(_that.itemCount,_that.startIndex);case ActivityRunning() when running != null:
return running(_that.itemIndex,_that.itemCount,_that.item,_that.phase,_that.itemStartedAt,_that.itemDeadline,_that.sectionDeadline,_that.feedback,_that.awaitsNext);case ActivityPaused() when paused != null:
return paused(_that.snapshot,_that.itemRemaining,_that.sectionRemaining);case ActivityFinished() when finished != null:
return finished(_that.result);case _:
  return null;

}
}

}

/// @nodoc


class ActivityBriefing extends ActivitySessionState {
  const ActivityBriefing({required this.itemCount, this.startIndex = 0}): super._();
  

 final  int itemCount;
@JsonKey() final  int startIndex;

/// Create a copy of ActivitySessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityBriefingCopyWith<ActivityBriefing> get copyWith => _$ActivityBriefingCopyWithImpl<ActivityBriefing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityBriefing&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.startIndex, startIndex) || other.startIndex == startIndex));
}


@override
int get hashCode => Object.hash(runtimeType,itemCount,startIndex);

@override
String toString() {
  return 'ActivitySessionState.briefing(itemCount: $itemCount, startIndex: $startIndex)';
}


}

/// @nodoc
abstract mixin class $ActivityBriefingCopyWith<$Res> implements $ActivitySessionStateCopyWith<$Res> {
  factory $ActivityBriefingCopyWith(ActivityBriefing value, $Res Function(ActivityBriefing) _then) = _$ActivityBriefingCopyWithImpl;
@useResult
$Res call({
 int itemCount, int startIndex
});




}
/// @nodoc
class _$ActivityBriefingCopyWithImpl<$Res>
    implements $ActivityBriefingCopyWith<$Res> {
  _$ActivityBriefingCopyWithImpl(this._self, this._then);

  final ActivityBriefing _self;
  final $Res Function(ActivityBriefing) _then;

/// Create a copy of ActivitySessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemCount = null,Object? startIndex = null,}) {
  return _then(ActivityBriefing(
itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,startIndex: null == startIndex ? _self.startIndex : startIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ActivityRunning extends ActivitySessionState {
  const ActivityRunning({required this.itemIndex, required this.itemCount, required this.item, required this.phase, required this.itemStartedAt, this.itemDeadline, this.sectionDeadline, this.feedback, this.awaitsNext = false}): super._();
  

 final  int itemIndex;
 final  int itemCount;
 final  Item item;
 final  ItemPhase phase;
 final  DateTime itemStartedAt;
 final  DateTime? itemDeadline;
 final  DateTime? sectionDeadline;
 final  ItemResult? feedback;
@JsonKey() final  bool awaitsNext;

/// Create a copy of ActivitySessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityRunningCopyWith<ActivityRunning> get copyWith => _$ActivityRunningCopyWithImpl<ActivityRunning>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityRunning&&(identical(other.itemIndex, itemIndex) || other.itemIndex == itemIndex)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.item, item) || other.item == item)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.itemStartedAt, itemStartedAt) || other.itemStartedAt == itemStartedAt)&&(identical(other.itemDeadline, itemDeadline) || other.itemDeadline == itemDeadline)&&(identical(other.sectionDeadline, sectionDeadline) || other.sectionDeadline == sectionDeadline)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.awaitsNext, awaitsNext) || other.awaitsNext == awaitsNext));
}


@override
int get hashCode => Object.hash(runtimeType,itemIndex,itemCount,item,phase,itemStartedAt,itemDeadline,sectionDeadline,feedback,awaitsNext);

@override
String toString() {
  return 'ActivitySessionState.running(itemIndex: $itemIndex, itemCount: $itemCount, item: $item, phase: $phase, itemStartedAt: $itemStartedAt, itemDeadline: $itemDeadline, sectionDeadline: $sectionDeadline, feedback: $feedback, awaitsNext: $awaitsNext)';
}


}

/// @nodoc
abstract mixin class $ActivityRunningCopyWith<$Res> implements $ActivitySessionStateCopyWith<$Res> {
  factory $ActivityRunningCopyWith(ActivityRunning value, $Res Function(ActivityRunning) _then) = _$ActivityRunningCopyWithImpl;
@useResult
$Res call({
 int itemIndex, int itemCount, Item item, ItemPhase phase, DateTime itemStartedAt, DateTime? itemDeadline, DateTime? sectionDeadline, ItemResult? feedback, bool awaitsNext
});


$ItemCopyWith<$Res> get item;$ItemResultCopyWith<$Res>? get feedback;

}
/// @nodoc
class _$ActivityRunningCopyWithImpl<$Res>
    implements $ActivityRunningCopyWith<$Res> {
  _$ActivityRunningCopyWithImpl(this._self, this._then);

  final ActivityRunning _self;
  final $Res Function(ActivityRunning) _then;

/// Create a copy of ActivitySessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? itemIndex = null,Object? itemCount = null,Object? item = null,Object? phase = null,Object? itemStartedAt = null,Object? itemDeadline = freezed,Object? sectionDeadline = freezed,Object? feedback = freezed,Object? awaitsNext = null,}) {
  return _then(ActivityRunning(
itemIndex: null == itemIndex ? _self.itemIndex : itemIndex // ignore: cast_nullable_to_non_nullable
as int,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as Item,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ItemPhase,itemStartedAt: null == itemStartedAt ? _self.itemStartedAt : itemStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime,itemDeadline: freezed == itemDeadline ? _self.itemDeadline : itemDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,sectionDeadline: freezed == sectionDeadline ? _self.sectionDeadline : sectionDeadline // ignore: cast_nullable_to_non_nullable
as DateTime?,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as ItemResult?,awaitsNext: null == awaitsNext ? _self.awaitsNext : awaitsNext // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ActivitySessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res> get item {
  
  return $ItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}/// Create a copy of ActivitySessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemResultCopyWith<$Res>? get feedback {
    if (_self.feedback == null) {
    return null;
  }

  return $ItemResultCopyWith<$Res>(_self.feedback!, (value) {
    return _then(_self.copyWith(feedback: value));
  });
}
}

/// @nodoc


class ActivityPaused extends ActivitySessionState {
  const ActivityPaused({required this.snapshot, this.itemRemaining, this.sectionRemaining}): super._();
  

 final  ActivityRunning snapshot;
 final  Duration? itemRemaining;
 final  Duration? sectionRemaining;

/// Create a copy of ActivitySessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityPausedCopyWith<ActivityPaused> get copyWith => _$ActivityPausedCopyWithImpl<ActivityPaused>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityPaused&&const DeepCollectionEquality().equals(other.snapshot, snapshot)&&(identical(other.itemRemaining, itemRemaining) || other.itemRemaining == itemRemaining)&&(identical(other.sectionRemaining, sectionRemaining) || other.sectionRemaining == sectionRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(snapshot),itemRemaining,sectionRemaining);

@override
String toString() {
  return 'ActivitySessionState.paused(snapshot: $snapshot, itemRemaining: $itemRemaining, sectionRemaining: $sectionRemaining)';
}


}

/// @nodoc
abstract mixin class $ActivityPausedCopyWith<$Res> implements $ActivitySessionStateCopyWith<$Res> {
  factory $ActivityPausedCopyWith(ActivityPaused value, $Res Function(ActivityPaused) _then) = _$ActivityPausedCopyWithImpl;
@useResult
$Res call({
 ActivityRunning snapshot, Duration? itemRemaining, Duration? sectionRemaining
});




}
/// @nodoc
class _$ActivityPausedCopyWithImpl<$Res>
    implements $ActivityPausedCopyWith<$Res> {
  _$ActivityPausedCopyWithImpl(this._self, this._then);

  final ActivityPaused _self;
  final $Res Function(ActivityPaused) _then;

/// Create a copy of ActivitySessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? snapshot = freezed,Object? itemRemaining = freezed,Object? sectionRemaining = freezed,}) {
  return _then(ActivityPaused(
snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as ActivityRunning,itemRemaining: freezed == itemRemaining ? _self.itemRemaining : itemRemaining // ignore: cast_nullable_to_non_nullable
as Duration?,sectionRemaining: freezed == sectionRemaining ? _self.sectionRemaining : sectionRemaining // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

/// @nodoc


class ActivityFinished extends ActivitySessionState {
  const ActivityFinished({required this.result}): super._();
  

 final  SessionResult result;

/// Create a copy of ActivitySessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityFinishedCopyWith<ActivityFinished> get copyWith => _$ActivityFinishedCopyWithImpl<ActivityFinished>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityFinished&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,result);

@override
String toString() {
  return 'ActivitySessionState.finished(result: $result)';
}


}

/// @nodoc
abstract mixin class $ActivityFinishedCopyWith<$Res> implements $ActivitySessionStateCopyWith<$Res> {
  factory $ActivityFinishedCopyWith(ActivityFinished value, $Res Function(ActivityFinished) _then) = _$ActivityFinishedCopyWithImpl;
@useResult
$Res call({
 SessionResult result
});


$SessionResultCopyWith<$Res> get result;

}
/// @nodoc
class _$ActivityFinishedCopyWithImpl<$Res>
    implements $ActivityFinishedCopyWith<$Res> {
  _$ActivityFinishedCopyWithImpl(this._self, this._then);

  final ActivityFinished _self;
  final $Res Function(ActivityFinished) _then;

/// Create a copy of ActivitySessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? result = null,}) {
  return _then(ActivityFinished(
result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as SessionResult,
  ));
}

/// Create a copy of ActivitySessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionResultCopyWith<$Res> get result {
  
  return $SessionResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

// dart format on
