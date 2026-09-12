// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
Answer _$AnswerFromJson(
  Map<String, dynamic> json
) {
        switch (json['kind']) {
                  case 'choice':
          return ChoiceAnswer.fromJson(
            json
          );
                case 'numeric':
          return NumericAnswer.fromJson(
            json
          );
                case 'multiSelect':
          return MultiSelectAnswer.fromJson(
            json
          );
                case 'key':
          return KeyAnswer.fromJson(
            json
          );
                case 'sequence':
          return SequenceAnswer.fromJson(
            json
          );
                case 'skip':
          return SkipAnswer.fromJson(
            json
          );
                case 'timeout':
          return TimeoutAnswer.fromJson(
            json
          );
                case 'raw':
          return RawAnswer.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'kind',
  'Answer',
  'Invalid union type "${json['kind']}"!'
);
        }
      
}

/// @nodoc
mixin _$Answer {



  /// Serializes this Answer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Answer);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Answer()';
}


}

/// @nodoc
class $AnswerCopyWith<$Res>  {
$AnswerCopyWith(Answer _, $Res Function(Answer) __);
}


/// Adds pattern-matching-related methods to [Answer].
extension AnswerPatterns on Answer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChoiceAnswer value)?  choice,TResult Function( NumericAnswer value)?  numeric,TResult Function( MultiSelectAnswer value)?  multiSelect,TResult Function( KeyAnswer value)?  key,TResult Function( SequenceAnswer value)?  sequence,TResult Function( SkipAnswer value)?  skip,TResult Function( TimeoutAnswer value)?  timeout,TResult Function( RawAnswer value)?  raw,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChoiceAnswer() when choice != null:
return choice(_that);case NumericAnswer() when numeric != null:
return numeric(_that);case MultiSelectAnswer() when multiSelect != null:
return multiSelect(_that);case KeyAnswer() when key != null:
return key(_that);case SequenceAnswer() when sequence != null:
return sequence(_that);case SkipAnswer() when skip != null:
return skip(_that);case TimeoutAnswer() when timeout != null:
return timeout(_that);case RawAnswer() when raw != null:
return raw(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChoiceAnswer value)  choice,required TResult Function( NumericAnswer value)  numeric,required TResult Function( MultiSelectAnswer value)  multiSelect,required TResult Function( KeyAnswer value)  key,required TResult Function( SequenceAnswer value)  sequence,required TResult Function( SkipAnswer value)  skip,required TResult Function( TimeoutAnswer value)  timeout,required TResult Function( RawAnswer value)  raw,}){
final _that = this;
switch (_that) {
case ChoiceAnswer():
return choice(_that);case NumericAnswer():
return numeric(_that);case MultiSelectAnswer():
return multiSelect(_that);case KeyAnswer():
return key(_that);case SequenceAnswer():
return sequence(_that);case SkipAnswer():
return skip(_that);case TimeoutAnswer():
return timeout(_that);case RawAnswer():
return raw(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChoiceAnswer value)?  choice,TResult? Function( NumericAnswer value)?  numeric,TResult? Function( MultiSelectAnswer value)?  multiSelect,TResult? Function( KeyAnswer value)?  key,TResult? Function( SequenceAnswer value)?  sequence,TResult? Function( SkipAnswer value)?  skip,TResult? Function( TimeoutAnswer value)?  timeout,TResult? Function( RawAnswer value)?  raw,}){
final _that = this;
switch (_that) {
case ChoiceAnswer() when choice != null:
return choice(_that);case NumericAnswer() when numeric != null:
return numeric(_that);case MultiSelectAnswer() when multiSelect != null:
return multiSelect(_that);case KeyAnswer() when key != null:
return key(_that);case SequenceAnswer() when sequence != null:
return sequence(_that);case SkipAnswer() when skip != null:
return skip(_that);case TimeoutAnswer() when timeout != null:
return timeout(_that);case RawAnswer() when raw != null:
return raw(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int index)?  choice,TResult Function( num value)?  numeric,TResult Function( List<int> indices)?  multiSelect,TResult Function( String key)?  key,TResult Function( List<String> values)?  sequence,TResult Function()?  skip,TResult Function()?  timeout,TResult Function( Map<String, Object?> payload)?  raw,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChoiceAnswer() when choice != null:
return choice(_that.index);case NumericAnswer() when numeric != null:
return numeric(_that.value);case MultiSelectAnswer() when multiSelect != null:
return multiSelect(_that.indices);case KeyAnswer() when key != null:
return key(_that.key);case SequenceAnswer() when sequence != null:
return sequence(_that.values);case SkipAnswer() when skip != null:
return skip();case TimeoutAnswer() when timeout != null:
return timeout();case RawAnswer() when raw != null:
return raw(_that.payload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int index)  choice,required TResult Function( num value)  numeric,required TResult Function( List<int> indices)  multiSelect,required TResult Function( String key)  key,required TResult Function( List<String> values)  sequence,required TResult Function()  skip,required TResult Function()  timeout,required TResult Function( Map<String, Object?> payload)  raw,}) {final _that = this;
switch (_that) {
case ChoiceAnswer():
return choice(_that.index);case NumericAnswer():
return numeric(_that.value);case MultiSelectAnswer():
return multiSelect(_that.indices);case KeyAnswer():
return key(_that.key);case SequenceAnswer():
return sequence(_that.values);case SkipAnswer():
return skip();case TimeoutAnswer():
return timeout();case RawAnswer():
return raw(_that.payload);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int index)?  choice,TResult? Function( num value)?  numeric,TResult? Function( List<int> indices)?  multiSelect,TResult? Function( String key)?  key,TResult? Function( List<String> values)?  sequence,TResult? Function()?  skip,TResult? Function()?  timeout,TResult? Function( Map<String, Object?> payload)?  raw,}) {final _that = this;
switch (_that) {
case ChoiceAnswer() when choice != null:
return choice(_that.index);case NumericAnswer() when numeric != null:
return numeric(_that.value);case MultiSelectAnswer() when multiSelect != null:
return multiSelect(_that.indices);case KeyAnswer() when key != null:
return key(_that.key);case SequenceAnswer() when sequence != null:
return sequence(_that.values);case SkipAnswer() when skip != null:
return skip();case TimeoutAnswer() when timeout != null:
return timeout();case RawAnswer() when raw != null:
return raw(_that.payload);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class ChoiceAnswer extends Answer {
  const ChoiceAnswer(this.index, {final  String? $type}): $type = $type ?? 'choice',super._();
  factory ChoiceAnswer.fromJson(Map<String, dynamic> json) => _$ChoiceAnswerFromJson(json);

 final  int index;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChoiceAnswerCopyWith<ChoiceAnswer> get copyWith => _$ChoiceAnswerCopyWithImpl<ChoiceAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChoiceAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChoiceAnswer&&(identical(other.index, index) || other.index == index));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'Answer.choice(index: $index)';
}


}

/// @nodoc
abstract mixin class $ChoiceAnswerCopyWith<$Res> implements $AnswerCopyWith<$Res> {
  factory $ChoiceAnswerCopyWith(ChoiceAnswer value, $Res Function(ChoiceAnswer) _then) = _$ChoiceAnswerCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class _$ChoiceAnswerCopyWithImpl<$Res>
    implements $ChoiceAnswerCopyWith<$Res> {
  _$ChoiceAnswerCopyWithImpl(this._self, this._then);

  final ChoiceAnswer _self;
  final $Res Function(ChoiceAnswer) _then;

/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(ChoiceAnswer(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class NumericAnswer extends Answer {
  const NumericAnswer(this.value, {final  String? $type}): $type = $type ?? 'numeric',super._();
  factory NumericAnswer.fromJson(Map<String, dynamic> json) => _$NumericAnswerFromJson(json);

 final  num value;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NumericAnswerCopyWith<NumericAnswer> get copyWith => _$NumericAnswerCopyWithImpl<NumericAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NumericAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NumericAnswer&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'Answer.numeric(value: $value)';
}


}

/// @nodoc
abstract mixin class $NumericAnswerCopyWith<$Res> implements $AnswerCopyWith<$Res> {
  factory $NumericAnswerCopyWith(NumericAnswer value, $Res Function(NumericAnswer) _then) = _$NumericAnswerCopyWithImpl;
@useResult
$Res call({
 num value
});




}
/// @nodoc
class _$NumericAnswerCopyWithImpl<$Res>
    implements $NumericAnswerCopyWith<$Res> {
  _$NumericAnswerCopyWithImpl(this._self, this._then);

  final NumericAnswer _self;
  final $Res Function(NumericAnswer) _then;

/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(NumericAnswer(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

/// @nodoc
@JsonSerializable()

class MultiSelectAnswer extends Answer {
  const MultiSelectAnswer(final  List<int> indices, {final  String? $type}): _indices = indices,$type = $type ?? 'multiSelect',super._();
  factory MultiSelectAnswer.fromJson(Map<String, dynamic> json) => _$MultiSelectAnswerFromJson(json);

 final  List<int> _indices;
 List<int> get indices {
  if (_indices is EqualUnmodifiableListView) return _indices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_indices);
}


@JsonKey(name: 'kind')
final String $type;


/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MultiSelectAnswerCopyWith<MultiSelectAnswer> get copyWith => _$MultiSelectAnswerCopyWithImpl<MultiSelectAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MultiSelectAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MultiSelectAnswer&&const DeepCollectionEquality().equals(other._indices, _indices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_indices));

@override
String toString() {
  return 'Answer.multiSelect(indices: $indices)';
}


}

/// @nodoc
abstract mixin class $MultiSelectAnswerCopyWith<$Res> implements $AnswerCopyWith<$Res> {
  factory $MultiSelectAnswerCopyWith(MultiSelectAnswer value, $Res Function(MultiSelectAnswer) _then) = _$MultiSelectAnswerCopyWithImpl;
@useResult
$Res call({
 List<int> indices
});




}
/// @nodoc
class _$MultiSelectAnswerCopyWithImpl<$Res>
    implements $MultiSelectAnswerCopyWith<$Res> {
  _$MultiSelectAnswerCopyWithImpl(this._self, this._then);

  final MultiSelectAnswer _self;
  final $Res Function(MultiSelectAnswer) _then;

/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? indices = null,}) {
  return _then(MultiSelectAnswer(
null == indices ? _self._indices : indices // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class KeyAnswer extends Answer {
  const KeyAnswer(this.key, {final  String? $type}): $type = $type ?? 'key',super._();
  factory KeyAnswer.fromJson(Map<String, dynamic> json) => _$KeyAnswerFromJson(json);

 final  String key;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KeyAnswerCopyWith<KeyAnswer> get copyWith => _$KeyAnswerCopyWithImpl<KeyAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KeyAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KeyAnswer&&(identical(other.key, key) || other.key == key));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key);

@override
String toString() {
  return 'Answer.key(key: $key)';
}


}

/// @nodoc
abstract mixin class $KeyAnswerCopyWith<$Res> implements $AnswerCopyWith<$Res> {
  factory $KeyAnswerCopyWith(KeyAnswer value, $Res Function(KeyAnswer) _then) = _$KeyAnswerCopyWithImpl;
@useResult
$Res call({
 String key
});




}
/// @nodoc
class _$KeyAnswerCopyWithImpl<$Res>
    implements $KeyAnswerCopyWith<$Res> {
  _$KeyAnswerCopyWithImpl(this._self, this._then);

  final KeyAnswer _self;
  final $Res Function(KeyAnswer) _then;

/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? key = null,}) {
  return _then(KeyAnswer(
null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class SequenceAnswer extends Answer {
  const SequenceAnswer(final  List<String> values, {final  String? $type}): _values = values,$type = $type ?? 'sequence',super._();
  factory SequenceAnswer.fromJson(Map<String, dynamic> json) => _$SequenceAnswerFromJson(json);

 final  List<String> _values;
 List<String> get values {
  if (_values is EqualUnmodifiableListView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_values);
}


@JsonKey(name: 'kind')
final String $type;


/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SequenceAnswerCopyWith<SequenceAnswer> get copyWith => _$SequenceAnswerCopyWithImpl<SequenceAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SequenceAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SequenceAnswer&&const DeepCollectionEquality().equals(other._values, _values));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_values));

@override
String toString() {
  return 'Answer.sequence(values: $values)';
}


}

/// @nodoc
abstract mixin class $SequenceAnswerCopyWith<$Res> implements $AnswerCopyWith<$Res> {
  factory $SequenceAnswerCopyWith(SequenceAnswer value, $Res Function(SequenceAnswer) _then) = _$SequenceAnswerCopyWithImpl;
@useResult
$Res call({
 List<String> values
});




}
/// @nodoc
class _$SequenceAnswerCopyWithImpl<$Res>
    implements $SequenceAnswerCopyWith<$Res> {
  _$SequenceAnswerCopyWithImpl(this._self, this._then);

  final SequenceAnswer _self;
  final $Res Function(SequenceAnswer) _then;

/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? values = null,}) {
  return _then(SequenceAnswer(
null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class SkipAnswer extends Answer {
  const SkipAnswer({final  String? $type}): $type = $type ?? 'skip',super._();
  factory SkipAnswer.fromJson(Map<String, dynamic> json) => _$SkipAnswerFromJson(json);



@JsonKey(name: 'kind')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$SkipAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkipAnswer);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Answer.skip()';
}


}




/// @nodoc
@JsonSerializable()

class TimeoutAnswer extends Answer {
  const TimeoutAnswer({final  String? $type}): $type = $type ?? 'timeout',super._();
  factory TimeoutAnswer.fromJson(Map<String, dynamic> json) => _$TimeoutAnswerFromJson(json);



@JsonKey(name: 'kind')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$TimeoutAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeoutAnswer);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Answer.timeout()';
}


}




/// @nodoc
@JsonSerializable()

class RawAnswer extends Answer {
  const RawAnswer(final  Map<String, Object?> payload, {final  String? $type}): _payload = payload,$type = $type ?? 'raw',super._();
  factory RawAnswer.fromJson(Map<String, dynamic> json) => _$RawAnswerFromJson(json);

 final  Map<String, Object?> _payload;
 Map<String, Object?> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}


@JsonKey(name: 'kind')
final String $type;


/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RawAnswerCopyWith<RawAnswer> get copyWith => _$RawAnswerCopyWithImpl<RawAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RawAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RawAnswer&&const DeepCollectionEquality().equals(other._payload, _payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_payload));

@override
String toString() {
  return 'Answer.raw(payload: $payload)';
}


}

/// @nodoc
abstract mixin class $RawAnswerCopyWith<$Res> implements $AnswerCopyWith<$Res> {
  factory $RawAnswerCopyWith(RawAnswer value, $Res Function(RawAnswer) _then) = _$RawAnswerCopyWithImpl;
@useResult
$Res call({
 Map<String, Object?> payload
});




}
/// @nodoc
class _$RawAnswerCopyWithImpl<$Res>
    implements $RawAnswerCopyWith<$Res> {
  _$RawAnswerCopyWithImpl(this._self, this._then);

  final RawAnswer _self;
  final $Res Function(RawAnswer) _then;

/// Create a copy of Answer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? payload = null,}) {
  return _then(RawAnswer(
null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

// dart format on
