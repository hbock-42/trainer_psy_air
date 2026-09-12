// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_session_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivitySessionConfig {

 String get familyId; SessionMode get mode; ItemSource get source; TimingPolicy get timing; ScoringPolicy get scoringPolicy;/// Keep the engine's live right/wrong feedback in exam mode (rules S-R,
/// parity restart): `TestFamily.liveFeedback` /
/// `ExamSection.liveFeedback`. Practice always shows feedback.
 bool get liveFeedback;/// Shown on the briefing screen (blueprint section briefing or family
/// description).
 LocalizedText? get briefing; LocalizedText? get title;/// Exam runner: the blueprint and the section this run belongs to.
 String? get blueprintId; int? get sectionIndex;/// Attach attempts to this already-started session instead of starting
/// one: set by the exam runner (which also finishes it, see
/// [ownsSession]) and by `ActivitySession.resume`. Null for a fresh
/// practice session.
 String? get sessionId;/// Whether this run finishes the `TrainingSession` when it ends
/// (practice, including a resumed one). The exam runner sets it to
/// false: it finishes the session after its last section.
 bool get ownsSession;/// Exam runner: position of this section's first item within the whole
/// session, so `NewAttempt.position` stays unique across sections.
 int get positionOffset;
/// Create a copy of ActivitySessionConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivitySessionConfigCopyWith<ActivitySessionConfig> get copyWith => _$ActivitySessionConfigCopyWithImpl<ActivitySessionConfig>(this as ActivitySessionConfig, _$identity);

  /// Serializes this ActivitySessionConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivitySessionConfig&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.source, source) || other.source == source)&&(identical(other.timing, timing) || other.timing == timing)&&(identical(other.scoringPolicy, scoringPolicy) || other.scoringPolicy == scoringPolicy)&&(identical(other.liveFeedback, liveFeedback) || other.liveFeedback == liveFeedback)&&(identical(other.briefing, briefing) || other.briefing == briefing)&&(identical(other.title, title) || other.title == title)&&(identical(other.blueprintId, blueprintId) || other.blueprintId == blueprintId)&&(identical(other.sectionIndex, sectionIndex) || other.sectionIndex == sectionIndex)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.ownsSession, ownsSession) || other.ownsSession == ownsSession)&&(identical(other.positionOffset, positionOffset) || other.positionOffset == positionOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,mode,source,timing,scoringPolicy,liveFeedback,briefing,title,blueprintId,sectionIndex,sessionId,ownsSession,positionOffset);

@override
String toString() {
  return 'ActivitySessionConfig(familyId: $familyId, mode: $mode, source: $source, timing: $timing, scoringPolicy: $scoringPolicy, liveFeedback: $liveFeedback, briefing: $briefing, title: $title, blueprintId: $blueprintId, sectionIndex: $sectionIndex, sessionId: $sessionId, ownsSession: $ownsSession, positionOffset: $positionOffset)';
}


}

/// @nodoc
abstract mixin class $ActivitySessionConfigCopyWith<$Res>  {
  factory $ActivitySessionConfigCopyWith(ActivitySessionConfig value, $Res Function(ActivitySessionConfig) _then) = _$ActivitySessionConfigCopyWithImpl;
@useResult
$Res call({
 String familyId, SessionMode mode, ItemSource source, TimingPolicy timing, ScoringPolicy scoringPolicy, bool liveFeedback, LocalizedText? briefing, LocalizedText? title, String? blueprintId, int? sectionIndex, String? sessionId, bool ownsSession, int positionOffset
});


$ItemSourceCopyWith<$Res> get source;$TimingPolicyCopyWith<$Res> get timing;$ScoringPolicyCopyWith<$Res> get scoringPolicy;$LocalizedTextCopyWith<$Res>? get briefing;$LocalizedTextCopyWith<$Res>? get title;

}
/// @nodoc
class _$ActivitySessionConfigCopyWithImpl<$Res>
    implements $ActivitySessionConfigCopyWith<$Res> {
  _$ActivitySessionConfigCopyWithImpl(this._self, this._then);

  final ActivitySessionConfig _self;
  final $Res Function(ActivitySessionConfig) _then;

/// Create a copy of ActivitySessionConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? familyId = null,Object? mode = null,Object? source = null,Object? timing = null,Object? scoringPolicy = null,Object? liveFeedback = null,Object? briefing = freezed,Object? title = freezed,Object? blueprintId = freezed,Object? sectionIndex = freezed,Object? sessionId = freezed,Object? ownsSession = null,Object? positionOffset = null,}) {
  return _then(_self.copyWith(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionMode,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ItemSource,timing: null == timing ? _self.timing : timing // ignore: cast_nullable_to_non_nullable
as TimingPolicy,scoringPolicy: null == scoringPolicy ? _self.scoringPolicy : scoringPolicy // ignore: cast_nullable_to_non_nullable
as ScoringPolicy,liveFeedback: null == liveFeedback ? _self.liveFeedback : liveFeedback // ignore: cast_nullable_to_non_nullable
as bool,briefing: freezed == briefing ? _self.briefing : briefing // ignore: cast_nullable_to_non_nullable
as LocalizedText?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as LocalizedText?,blueprintId: freezed == blueprintId ? _self.blueprintId : blueprintId // ignore: cast_nullable_to_non_nullable
as String?,sectionIndex: freezed == sectionIndex ? _self.sectionIndex : sectionIndex // ignore: cast_nullable_to_non_nullable
as int?,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,ownsSession: null == ownsSession ? _self.ownsSession : ownsSession // ignore: cast_nullable_to_non_nullable
as bool,positionOffset: null == positionOffset ? _self.positionOffset : positionOffset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ActivitySessionConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemSourceCopyWith<$Res> get source {
  
  return $ItemSourceCopyWith<$Res>(_self.source, (value) {
    return _then(_self.copyWith(source: value));
  });
}/// Create a copy of ActivitySessionConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimingPolicyCopyWith<$Res> get timing {
  
  return $TimingPolicyCopyWith<$Res>(_self.timing, (value) {
    return _then(_self.copyWith(timing: value));
  });
}/// Create a copy of ActivitySessionConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringPolicyCopyWith<$Res> get scoringPolicy {
  
  return $ScoringPolicyCopyWith<$Res>(_self.scoringPolicy, (value) {
    return _then(_self.copyWith(scoringPolicy: value));
  });
}/// Create a copy of ActivitySessionConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get briefing {
    if (_self.briefing == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.briefing!, (value) {
    return _then(_self.copyWith(briefing: value));
  });
}/// Create a copy of ActivitySessionConfig
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
}
}


/// Adds pattern-matching-related methods to [ActivitySessionConfig].
extension ActivitySessionConfigPatterns on ActivitySessionConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivitySessionConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivitySessionConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivitySessionConfig value)  $default,){
final _that = this;
switch (_that) {
case _ActivitySessionConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivitySessionConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ActivitySessionConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String familyId,  SessionMode mode,  ItemSource source,  TimingPolicy timing,  ScoringPolicy scoringPolicy,  bool liveFeedback,  LocalizedText? briefing,  LocalizedText? title,  String? blueprintId,  int? sectionIndex,  String? sessionId,  bool ownsSession,  int positionOffset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivitySessionConfig() when $default != null:
return $default(_that.familyId,_that.mode,_that.source,_that.timing,_that.scoringPolicy,_that.liveFeedback,_that.briefing,_that.title,_that.blueprintId,_that.sectionIndex,_that.sessionId,_that.ownsSession,_that.positionOffset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String familyId,  SessionMode mode,  ItemSource source,  TimingPolicy timing,  ScoringPolicy scoringPolicy,  bool liveFeedback,  LocalizedText? briefing,  LocalizedText? title,  String? blueprintId,  int? sectionIndex,  String? sessionId,  bool ownsSession,  int positionOffset)  $default,) {final _that = this;
switch (_that) {
case _ActivitySessionConfig():
return $default(_that.familyId,_that.mode,_that.source,_that.timing,_that.scoringPolicy,_that.liveFeedback,_that.briefing,_that.title,_that.blueprintId,_that.sectionIndex,_that.sessionId,_that.ownsSession,_that.positionOffset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String familyId,  SessionMode mode,  ItemSource source,  TimingPolicy timing,  ScoringPolicy scoringPolicy,  bool liveFeedback,  LocalizedText? briefing,  LocalizedText? title,  String? blueprintId,  int? sectionIndex,  String? sessionId,  bool ownsSession,  int positionOffset)?  $default,) {final _that = this;
switch (_that) {
case _ActivitySessionConfig() when $default != null:
return $default(_that.familyId,_that.mode,_that.source,_that.timing,_that.scoringPolicy,_that.liveFeedback,_that.briefing,_that.title,_that.blueprintId,_that.sectionIndex,_that.sessionId,_that.ownsSession,_that.positionOffset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivitySessionConfig extends ActivitySessionConfig {
  const _ActivitySessionConfig({required this.familyId, required this.mode, required this.source, this.timing = TimingPolicy.none, this.scoringPolicy = const ScoringPolicy(), this.liveFeedback = false, this.briefing, this.title, this.blueprintId, this.sectionIndex, this.sessionId, this.ownsSession = true, this.positionOffset = 0}): super._();
  factory _ActivitySessionConfig.fromJson(Map<String, dynamic> json) => _$ActivitySessionConfigFromJson(json);

@override final  String familyId;
@override final  SessionMode mode;
@override final  ItemSource source;
@override@JsonKey() final  TimingPolicy timing;
@override@JsonKey() final  ScoringPolicy scoringPolicy;
/// Keep the engine's live right/wrong feedback in exam mode (rules S-R,
/// parity restart): `TestFamily.liveFeedback` /
/// `ExamSection.liveFeedback`. Practice always shows feedback.
@override@JsonKey() final  bool liveFeedback;
/// Shown on the briefing screen (blueprint section briefing or family
/// description).
@override final  LocalizedText? briefing;
@override final  LocalizedText? title;
/// Exam runner: the blueprint and the section this run belongs to.
@override final  String? blueprintId;
@override final  int? sectionIndex;
/// Attach attempts to this already-started session instead of starting
/// one: set by the exam runner (which also finishes it, see
/// [ownsSession]) and by `ActivitySession.resume`. Null for a fresh
/// practice session.
@override final  String? sessionId;
/// Whether this run finishes the `TrainingSession` when it ends
/// (practice, including a resumed one). The exam runner sets it to
/// false: it finishes the session after its last section.
@override@JsonKey() final  bool ownsSession;
/// Exam runner: position of this section's first item within the whole
/// session, so `NewAttempt.position` stays unique across sections.
@override@JsonKey() final  int positionOffset;

/// Create a copy of ActivitySessionConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivitySessionConfigCopyWith<_ActivitySessionConfig> get copyWith => __$ActivitySessionConfigCopyWithImpl<_ActivitySessionConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivitySessionConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivitySessionConfig&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.source, source) || other.source == source)&&(identical(other.timing, timing) || other.timing == timing)&&(identical(other.scoringPolicy, scoringPolicy) || other.scoringPolicy == scoringPolicy)&&(identical(other.liveFeedback, liveFeedback) || other.liveFeedback == liveFeedback)&&(identical(other.briefing, briefing) || other.briefing == briefing)&&(identical(other.title, title) || other.title == title)&&(identical(other.blueprintId, blueprintId) || other.blueprintId == blueprintId)&&(identical(other.sectionIndex, sectionIndex) || other.sectionIndex == sectionIndex)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.ownsSession, ownsSession) || other.ownsSession == ownsSession)&&(identical(other.positionOffset, positionOffset) || other.positionOffset == positionOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,familyId,mode,source,timing,scoringPolicy,liveFeedback,briefing,title,blueprintId,sectionIndex,sessionId,ownsSession,positionOffset);

@override
String toString() {
  return 'ActivitySessionConfig(familyId: $familyId, mode: $mode, source: $source, timing: $timing, scoringPolicy: $scoringPolicy, liveFeedback: $liveFeedback, briefing: $briefing, title: $title, blueprintId: $blueprintId, sectionIndex: $sectionIndex, sessionId: $sessionId, ownsSession: $ownsSession, positionOffset: $positionOffset)';
}


}

/// @nodoc
abstract mixin class _$ActivitySessionConfigCopyWith<$Res> implements $ActivitySessionConfigCopyWith<$Res> {
  factory _$ActivitySessionConfigCopyWith(_ActivitySessionConfig value, $Res Function(_ActivitySessionConfig) _then) = __$ActivitySessionConfigCopyWithImpl;
@override @useResult
$Res call({
 String familyId, SessionMode mode, ItemSource source, TimingPolicy timing, ScoringPolicy scoringPolicy, bool liveFeedback, LocalizedText? briefing, LocalizedText? title, String? blueprintId, int? sectionIndex, String? sessionId, bool ownsSession, int positionOffset
});


@override $ItemSourceCopyWith<$Res> get source;@override $TimingPolicyCopyWith<$Res> get timing;@override $ScoringPolicyCopyWith<$Res> get scoringPolicy;@override $LocalizedTextCopyWith<$Res>? get briefing;@override $LocalizedTextCopyWith<$Res>? get title;

}
/// @nodoc
class __$ActivitySessionConfigCopyWithImpl<$Res>
    implements _$ActivitySessionConfigCopyWith<$Res> {
  __$ActivitySessionConfigCopyWithImpl(this._self, this._then);

  final _ActivitySessionConfig _self;
  final $Res Function(_ActivitySessionConfig) _then;

/// Create a copy of ActivitySessionConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? familyId = null,Object? mode = null,Object? source = null,Object? timing = null,Object? scoringPolicy = null,Object? liveFeedback = null,Object? briefing = freezed,Object? title = freezed,Object? blueprintId = freezed,Object? sectionIndex = freezed,Object? sessionId = freezed,Object? ownsSession = null,Object? positionOffset = null,}) {
  return _then(_ActivitySessionConfig(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionMode,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ItemSource,timing: null == timing ? _self.timing : timing // ignore: cast_nullable_to_non_nullable
as TimingPolicy,scoringPolicy: null == scoringPolicy ? _self.scoringPolicy : scoringPolicy // ignore: cast_nullable_to_non_nullable
as ScoringPolicy,liveFeedback: null == liveFeedback ? _self.liveFeedback : liveFeedback // ignore: cast_nullable_to_non_nullable
as bool,briefing: freezed == briefing ? _self.briefing : briefing // ignore: cast_nullable_to_non_nullable
as LocalizedText?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as LocalizedText?,blueprintId: freezed == blueprintId ? _self.blueprintId : blueprintId // ignore: cast_nullable_to_non_nullable
as String?,sectionIndex: freezed == sectionIndex ? _self.sectionIndex : sectionIndex // ignore: cast_nullable_to_non_nullable
as int?,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,ownsSession: null == ownsSession ? _self.ownsSession : ownsSession // ignore: cast_nullable_to_non_nullable
as bool,positionOffset: null == positionOffset ? _self.positionOffset : positionOffset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ActivitySessionConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemSourceCopyWith<$Res> get source {
  
  return $ItemSourceCopyWith<$Res>(_self.source, (value) {
    return _then(_self.copyWith(source: value));
  });
}/// Create a copy of ActivitySessionConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TimingPolicyCopyWith<$Res> get timing {
  
  return $TimingPolicyCopyWith<$Res>(_self.timing, (value) {
    return _then(_self.copyWith(timing: value));
  });
}/// Create a copy of ActivitySessionConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringPolicyCopyWith<$Res> get scoringPolicy {
  
  return $ScoringPolicyCopyWith<$Res>(_self.scoringPolicy, (value) {
    return _then(_self.copyWith(scoringPolicy: value));
  });
}/// Create a copy of ActivitySessionConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get briefing {
    if (_self.briefing == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.briefing!, (value) {
    return _then(_self.copyWith(briefing: value));
  });
}/// Create a copy of ActivitySessionConfig
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
}
}

// dart format on
