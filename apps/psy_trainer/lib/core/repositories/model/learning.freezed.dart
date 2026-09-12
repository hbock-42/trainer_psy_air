// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FlashcardReview {

 String get flashcardId; String get deckId; int get box; int get reviews; int get lapses; DateTime get nextReviewAt; DateTime? get lastReviewedAt;
/// Create a copy of FlashcardReview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlashcardReviewCopyWith<FlashcardReview> get copyWith => _$FlashcardReviewCopyWithImpl<FlashcardReview>(this as FlashcardReview, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlashcardReview&&(identical(other.flashcardId, flashcardId) || other.flashcardId == flashcardId)&&(identical(other.deckId, deckId) || other.deckId == deckId)&&(identical(other.box, box) || other.box == box)&&(identical(other.reviews, reviews) || other.reviews == reviews)&&(identical(other.lapses, lapses) || other.lapses == lapses)&&(identical(other.nextReviewAt, nextReviewAt) || other.nextReviewAt == nextReviewAt)&&(identical(other.lastReviewedAt, lastReviewedAt) || other.lastReviewedAt == lastReviewedAt));
}


@override
int get hashCode => Object.hash(runtimeType,flashcardId,deckId,box,reviews,lapses,nextReviewAt,lastReviewedAt);

@override
String toString() {
  return 'FlashcardReview(flashcardId: $flashcardId, deckId: $deckId, box: $box, reviews: $reviews, lapses: $lapses, nextReviewAt: $nextReviewAt, lastReviewedAt: $lastReviewedAt)';
}


}

/// @nodoc
abstract mixin class $FlashcardReviewCopyWith<$Res>  {
  factory $FlashcardReviewCopyWith(FlashcardReview value, $Res Function(FlashcardReview) _then) = _$FlashcardReviewCopyWithImpl;
@useResult
$Res call({
 String flashcardId, String deckId, int box, int reviews, int lapses, DateTime nextReviewAt, DateTime? lastReviewedAt
});




}
/// @nodoc
class _$FlashcardReviewCopyWithImpl<$Res>
    implements $FlashcardReviewCopyWith<$Res> {
  _$FlashcardReviewCopyWithImpl(this._self, this._then);

  final FlashcardReview _self;
  final $Res Function(FlashcardReview) _then;

/// Create a copy of FlashcardReview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flashcardId = null,Object? deckId = null,Object? box = null,Object? reviews = null,Object? lapses = null,Object? nextReviewAt = null,Object? lastReviewedAt = freezed,}) {
  return _then(_self.copyWith(
flashcardId: null == flashcardId ? _self.flashcardId : flashcardId // ignore: cast_nullable_to_non_nullable
as String,deckId: null == deckId ? _self.deckId : deckId // ignore: cast_nullable_to_non_nullable
as String,box: null == box ? _self.box : box // ignore: cast_nullable_to_non_nullable
as int,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as int,lapses: null == lapses ? _self.lapses : lapses // ignore: cast_nullable_to_non_nullable
as int,nextReviewAt: null == nextReviewAt ? _self.nextReviewAt : nextReviewAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastReviewedAt: freezed == lastReviewedAt ? _self.lastReviewedAt : lastReviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FlashcardReview].
extension FlashcardReviewPatterns on FlashcardReview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlashcardReview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlashcardReview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlashcardReview value)  $default,){
final _that = this;
switch (_that) {
case _FlashcardReview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlashcardReview value)?  $default,){
final _that = this;
switch (_that) {
case _FlashcardReview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String flashcardId,  String deckId,  int box,  int reviews,  int lapses,  DateTime nextReviewAt,  DateTime? lastReviewedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlashcardReview() when $default != null:
return $default(_that.flashcardId,_that.deckId,_that.box,_that.reviews,_that.lapses,_that.nextReviewAt,_that.lastReviewedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String flashcardId,  String deckId,  int box,  int reviews,  int lapses,  DateTime nextReviewAt,  DateTime? lastReviewedAt)  $default,) {final _that = this;
switch (_that) {
case _FlashcardReview():
return $default(_that.flashcardId,_that.deckId,_that.box,_that.reviews,_that.lapses,_that.nextReviewAt,_that.lastReviewedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String flashcardId,  String deckId,  int box,  int reviews,  int lapses,  DateTime nextReviewAt,  DateTime? lastReviewedAt)?  $default,) {final _that = this;
switch (_that) {
case _FlashcardReview() when $default != null:
return $default(_that.flashcardId,_that.deckId,_that.box,_that.reviews,_that.lapses,_that.nextReviewAt,_that.lastReviewedAt);case _:
  return null;

}
}

}

/// @nodoc


class _FlashcardReview implements FlashcardReview {
  const _FlashcardReview({required this.flashcardId, required this.deckId, required this.box, required this.reviews, required this.lapses, required this.nextReviewAt, this.lastReviewedAt});
  

@override final  String flashcardId;
@override final  String deckId;
@override final  int box;
@override final  int reviews;
@override final  int lapses;
@override final  DateTime nextReviewAt;
@override final  DateTime? lastReviewedAt;

/// Create a copy of FlashcardReview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlashcardReviewCopyWith<_FlashcardReview> get copyWith => __$FlashcardReviewCopyWithImpl<_FlashcardReview>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlashcardReview&&(identical(other.flashcardId, flashcardId) || other.flashcardId == flashcardId)&&(identical(other.deckId, deckId) || other.deckId == deckId)&&(identical(other.box, box) || other.box == box)&&(identical(other.reviews, reviews) || other.reviews == reviews)&&(identical(other.lapses, lapses) || other.lapses == lapses)&&(identical(other.nextReviewAt, nextReviewAt) || other.nextReviewAt == nextReviewAt)&&(identical(other.lastReviewedAt, lastReviewedAt) || other.lastReviewedAt == lastReviewedAt));
}


@override
int get hashCode => Object.hash(runtimeType,flashcardId,deckId,box,reviews,lapses,nextReviewAt,lastReviewedAt);

@override
String toString() {
  return 'FlashcardReview(flashcardId: $flashcardId, deckId: $deckId, box: $box, reviews: $reviews, lapses: $lapses, nextReviewAt: $nextReviewAt, lastReviewedAt: $lastReviewedAt)';
}


}

/// @nodoc
abstract mixin class _$FlashcardReviewCopyWith<$Res> implements $FlashcardReviewCopyWith<$Res> {
  factory _$FlashcardReviewCopyWith(_FlashcardReview value, $Res Function(_FlashcardReview) _then) = __$FlashcardReviewCopyWithImpl;
@override @useResult
$Res call({
 String flashcardId, String deckId, int box, int reviews, int lapses, DateTime nextReviewAt, DateTime? lastReviewedAt
});




}
/// @nodoc
class __$FlashcardReviewCopyWithImpl<$Res>
    implements _$FlashcardReviewCopyWith<$Res> {
  __$FlashcardReviewCopyWithImpl(this._self, this._then);

  final _FlashcardReview _self;
  final $Res Function(_FlashcardReview) _then;

/// Create a copy of FlashcardReview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flashcardId = null,Object? deckId = null,Object? box = null,Object? reviews = null,Object? lapses = null,Object? nextReviewAt = null,Object? lastReviewedAt = freezed,}) {
  return _then(_FlashcardReview(
flashcardId: null == flashcardId ? _self.flashcardId : flashcardId // ignore: cast_nullable_to_non_nullable
as String,deckId: null == deckId ? _self.deckId : deckId // ignore: cast_nullable_to_non_nullable
as String,box: null == box ? _self.box : box // ignore: cast_nullable_to_non_nullable
as int,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as int,lapses: null == lapses ? _self.lapses : lapses // ignore: cast_nullable_to_non_nullable
as int,nextReviewAt: null == nextReviewAt ? _self.nextReviewAt : nextReviewAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastReviewedAt: freezed == lastReviewedAt ? _self.lastReviewedAt : lastReviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$LessonRead {

 String get lessonId; DateTime get readAt;
/// Create a copy of LessonRead
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonReadCopyWith<LessonRead> get copyWith => _$LessonReadCopyWithImpl<LessonRead>(this as LessonRead, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonRead&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}


@override
int get hashCode => Object.hash(runtimeType,lessonId,readAt);

@override
String toString() {
  return 'LessonRead(lessonId: $lessonId, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class $LessonReadCopyWith<$Res>  {
  factory $LessonReadCopyWith(LessonRead value, $Res Function(LessonRead) _then) = _$LessonReadCopyWithImpl;
@useResult
$Res call({
 String lessonId, DateTime readAt
});




}
/// @nodoc
class _$LessonReadCopyWithImpl<$Res>
    implements $LessonReadCopyWith<$Res> {
  _$LessonReadCopyWithImpl(this._self, this._then);

  final LessonRead _self;
  final $Res Function(LessonRead) _then;

/// Create a copy of LessonRead
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lessonId = null,Object? readAt = null,}) {
  return _then(_self.copyWith(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,readAt: null == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonRead].
extension LessonReadPatterns on LessonRead {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonRead value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonRead() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonRead value)  $default,){
final _that = this;
switch (_that) {
case _LessonRead():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonRead value)?  $default,){
final _that = this;
switch (_that) {
case _LessonRead() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String lessonId,  DateTime readAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonRead() when $default != null:
return $default(_that.lessonId,_that.readAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String lessonId,  DateTime readAt)  $default,) {final _that = this;
switch (_that) {
case _LessonRead():
return $default(_that.lessonId,_that.readAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String lessonId,  DateTime readAt)?  $default,) {final _that = this;
switch (_that) {
case _LessonRead() when $default != null:
return $default(_that.lessonId,_that.readAt);case _:
  return null;

}
}

}

/// @nodoc


class _LessonRead implements LessonRead {
  const _LessonRead({required this.lessonId, required this.readAt});
  

@override final  String lessonId;
@override final  DateTime readAt;

/// Create a copy of LessonRead
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonReadCopyWith<_LessonRead> get copyWith => __$LessonReadCopyWithImpl<_LessonRead>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonRead&&(identical(other.lessonId, lessonId) || other.lessonId == lessonId)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}


@override
int get hashCode => Object.hash(runtimeType,lessonId,readAt);

@override
String toString() {
  return 'LessonRead(lessonId: $lessonId, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class _$LessonReadCopyWith<$Res> implements $LessonReadCopyWith<$Res> {
  factory _$LessonReadCopyWith(_LessonRead value, $Res Function(_LessonRead) _then) = __$LessonReadCopyWithImpl;
@override @useResult
$Res call({
 String lessonId, DateTime readAt
});




}
/// @nodoc
class __$LessonReadCopyWithImpl<$Res>
    implements _$LessonReadCopyWith<$Res> {
  __$LessonReadCopyWithImpl(this._self, this._then);

  final _LessonRead _self;
  final $Res Function(_LessonRead) _then;

/// Create a copy of LessonRead
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lessonId = null,Object? readAt = null,}) {
  return _then(_LessonRead(
lessonId: null == lessonId ? _self.lessonId : lessonId // ignore: cast_nullable_to_non_nullable
as String,readAt: null == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$UserProfile {

 String get locale; Map<String, Object?> get settings; DateTime? get examDate;/// `psy0` | `psy1` | `psy2`; null until onboarding (US-090).
 String? get targetStage;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.locale, locale) || other.locale == locale)&&const DeepCollectionEquality().equals(other.settings, settings)&&(identical(other.examDate, examDate) || other.examDate == examDate)&&(identical(other.targetStage, targetStage) || other.targetStage == targetStage));
}


@override
int get hashCode => Object.hash(runtimeType,locale,const DeepCollectionEquality().hash(settings),examDate,targetStage);

@override
String toString() {
  return 'UserProfile(locale: $locale, settings: $settings, examDate: $examDate, targetStage: $targetStage)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String locale, Map<String, Object?> settings, DateTime? examDate, String? targetStage
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? locale = null,Object? settings = null,Object? examDate = freezed,Object? targetStage = freezed,}) {
  return _then(_self.copyWith(
locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,examDate: freezed == examDate ? _self.examDate : examDate // ignore: cast_nullable_to_non_nullable
as DateTime?,targetStage: freezed == targetStage ? _self.targetStage : targetStage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String locale,  Map<String, Object?> settings,  DateTime? examDate,  String? targetStage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.locale,_that.settings,_that.examDate,_that.targetStage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String locale,  Map<String, Object?> settings,  DateTime? examDate,  String? targetStage)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.locale,_that.settings,_that.examDate,_that.targetStage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String locale,  Map<String, Object?> settings,  DateTime? examDate,  String? targetStage)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.locale,_that.settings,_that.examDate,_that.targetStage);case _:
  return null;

}
}

}

/// @nodoc


class _UserProfile implements UserProfile {
  const _UserProfile({required this.locale, final  Map<String, Object?> settings = const <String, Object?>{}, this.examDate, this.targetStage}): _settings = settings;
  

@override final  String locale;
 final  Map<String, Object?> _settings;
@override@JsonKey() Map<String, Object?> get settings {
  if (_settings is EqualUnmodifiableMapView) return _settings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_settings);
}

@override final  DateTime? examDate;
/// `psy0` | `psy1` | `psy2`; null until onboarding (US-090).
@override final  String? targetStage;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.locale, locale) || other.locale == locale)&&const DeepCollectionEquality().equals(other._settings, _settings)&&(identical(other.examDate, examDate) || other.examDate == examDate)&&(identical(other.targetStage, targetStage) || other.targetStage == targetStage));
}


@override
int get hashCode => Object.hash(runtimeType,locale,const DeepCollectionEquality().hash(_settings),examDate,targetStage);

@override
String toString() {
  return 'UserProfile(locale: $locale, settings: $settings, examDate: $examDate, targetStage: $targetStage)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String locale, Map<String, Object?> settings, DateTime? examDate, String? targetStage
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? locale = null,Object? settings = null,Object? examDate = freezed,Object? targetStage = freezed,}) {
  return _then(_UserProfile(
locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,settings: null == settings ? _self._settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,examDate: freezed == examDate ? _self.examDate : examDate // ignore: cast_nullable_to_non_nullable
as DateTime?,targetStage: freezed == targetStage ? _self.targetStage : targetStage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ContentInfo {

 int get schemaVersion; int get contentVersion; DateTime get seededAt;
/// Create a copy of ContentInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentInfoCopyWith<ContentInfo> get copyWith => _$ContentInfoCopyWithImpl<ContentInfo>(this as ContentInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentInfo&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.contentVersion, contentVersion) || other.contentVersion == contentVersion)&&(identical(other.seededAt, seededAt) || other.seededAt == seededAt));
}


@override
int get hashCode => Object.hash(runtimeType,schemaVersion,contentVersion,seededAt);

@override
String toString() {
  return 'ContentInfo(schemaVersion: $schemaVersion, contentVersion: $contentVersion, seededAt: $seededAt)';
}


}

/// @nodoc
abstract mixin class $ContentInfoCopyWith<$Res>  {
  factory $ContentInfoCopyWith(ContentInfo value, $Res Function(ContentInfo) _then) = _$ContentInfoCopyWithImpl;
@useResult
$Res call({
 int schemaVersion, int contentVersion, DateTime seededAt
});




}
/// @nodoc
class _$ContentInfoCopyWithImpl<$Res>
    implements $ContentInfoCopyWith<$Res> {
  _$ContentInfoCopyWithImpl(this._self, this._then);

  final ContentInfo _self;
  final $Res Function(ContentInfo) _then;

/// Create a copy of ContentInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = null,Object? contentVersion = null,Object? seededAt = null,}) {
  return _then(_self.copyWith(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,contentVersion: null == contentVersion ? _self.contentVersion : contentVersion // ignore: cast_nullable_to_non_nullable
as int,seededAt: null == seededAt ? _self.seededAt : seededAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ContentInfo].
extension ContentInfoPatterns on ContentInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContentInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContentInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContentInfo value)  $default,){
final _that = this;
switch (_that) {
case _ContentInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContentInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ContentInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int schemaVersion,  int contentVersion,  DateTime seededAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContentInfo() when $default != null:
return $default(_that.schemaVersion,_that.contentVersion,_that.seededAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int schemaVersion,  int contentVersion,  DateTime seededAt)  $default,) {final _that = this;
switch (_that) {
case _ContentInfo():
return $default(_that.schemaVersion,_that.contentVersion,_that.seededAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int schemaVersion,  int contentVersion,  DateTime seededAt)?  $default,) {final _that = this;
switch (_that) {
case _ContentInfo() when $default != null:
return $default(_that.schemaVersion,_that.contentVersion,_that.seededAt);case _:
  return null;

}
}

}

/// @nodoc


class _ContentInfo implements ContentInfo {
  const _ContentInfo({required this.schemaVersion, required this.contentVersion, required this.seededAt});
  

@override final  int schemaVersion;
@override final  int contentVersion;
@override final  DateTime seededAt;

/// Create a copy of ContentInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentInfoCopyWith<_ContentInfo> get copyWith => __$ContentInfoCopyWithImpl<_ContentInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentInfo&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.contentVersion, contentVersion) || other.contentVersion == contentVersion)&&(identical(other.seededAt, seededAt) || other.seededAt == seededAt));
}


@override
int get hashCode => Object.hash(runtimeType,schemaVersion,contentVersion,seededAt);

@override
String toString() {
  return 'ContentInfo(schemaVersion: $schemaVersion, contentVersion: $contentVersion, seededAt: $seededAt)';
}


}

/// @nodoc
abstract mixin class _$ContentInfoCopyWith<$Res> implements $ContentInfoCopyWith<$Res> {
  factory _$ContentInfoCopyWith(_ContentInfo value, $Res Function(_ContentInfo) _then) = __$ContentInfoCopyWithImpl;
@override @useResult
$Res call({
 int schemaVersion, int contentVersion, DateTime seededAt
});




}
/// @nodoc
class __$ContentInfoCopyWithImpl<$Res>
    implements _$ContentInfoCopyWith<$Res> {
  __$ContentInfoCopyWithImpl(this._self, this._then);

  final _ContentInfo _self;
  final $Res Function(_ContentInfo) _then;

/// Create a copy of ContentInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = null,Object? contentVersion = null,Object? seededAt = null,}) {
  return _then(_ContentInfo(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,contentVersion: null == contentVersion ? _self.contentVersion : contentVersion // ignore: cast_nullable_to_non_nullable
as int,seededAt: null == seededAt ? _self.seededAt : seededAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
