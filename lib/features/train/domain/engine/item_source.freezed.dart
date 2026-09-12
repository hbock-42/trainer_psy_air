// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
ItemSource _$ItemSourceFromJson(
  Map<String, dynamic> json
) {
        switch (json['kind']) {
                  case 'bank':
          return BankSource.fromJson(
            json
          );
                case 'generator':
          return GeneratorSource.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'kind',
  'ItemSource',
  'Invalid union type "${json['kind']}"!'
);
        }
      
}

/// @nodoc
mixin _$ItemSource {



  /// Serializes this ItemSource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemSource);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ItemSource()';
}


}

/// @nodoc
class $ItemSourceCopyWith<$Res>  {
$ItemSourceCopyWith(ItemSource _, $Res Function(ItemSource) __);
}


/// Adds pattern-matching-related methods to [ItemSource].
extension ItemSourcePatterns on ItemSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BankSource value)?  bank,TResult Function( GeneratorSource value)?  generator,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BankSource() when bank != null:
return bank(_that);case GeneratorSource() when generator != null:
return generator(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BankSource value)  bank,required TResult Function( GeneratorSource value)  generator,}){
final _that = this;
switch (_that) {
case BankSource():
return bank(_that);case GeneratorSource():
return generator(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BankSource value)?  bank,TResult? Function( GeneratorSource value)?  generator,}){
final _that = this;
switch (_that) {
case BankSource() when bank != null:
return bank(_that);case GeneratorSource() when generator != null:
return generator(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<Item> items)?  bank,TResult Function( GeneratorId generatorId,  int seed, @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson)  GeneratorParams params,  int count,  DifficultyRange difficulty)?  generator,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BankSource() when bank != null:
return bank(_that.items);case GeneratorSource() when generator != null:
return generator(_that.generatorId,_that.seed,_that.params,_that.count,_that.difficulty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<Item> items)  bank,required TResult Function( GeneratorId generatorId,  int seed, @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson)  GeneratorParams params,  int count,  DifficultyRange difficulty)  generator,}) {final _that = this;
switch (_that) {
case BankSource():
return bank(_that.items);case GeneratorSource():
return generator(_that.generatorId,_that.seed,_that.params,_that.count,_that.difficulty);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<Item> items)?  bank,TResult? Function( GeneratorId generatorId,  int seed, @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson)  GeneratorParams params,  int count,  DifficultyRange difficulty)?  generator,}) {final _that = this;
switch (_that) {
case BankSource() when bank != null:
return bank(_that.items);case GeneratorSource() when generator != null:
return generator(_that.generatorId,_that.seed,_that.params,_that.count,_that.difficulty);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class BankSource extends ItemSource {
  const BankSource(final  List<Item> items, {final  String? $type}): _items = items,$type = $type ?? 'bank',super._();
  factory BankSource.fromJson(Map<String, dynamic> json) => _$BankSourceFromJson(json);

 final  List<Item> _items;
 List<Item> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


@JsonKey(name: 'kind')
final String $type;


/// Create a copy of ItemSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankSourceCopyWith<BankSource> get copyWith => _$BankSourceCopyWithImpl<BankSource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BankSourceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankSource&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ItemSource.bank(items: $items)';
}


}

/// @nodoc
abstract mixin class $BankSourceCopyWith<$Res> implements $ItemSourceCopyWith<$Res> {
  factory $BankSourceCopyWith(BankSource value, $Res Function(BankSource) _then) = _$BankSourceCopyWithImpl;
@useResult
$Res call({
 List<Item> items
});




}
/// @nodoc
class _$BankSourceCopyWithImpl<$Res>
    implements $BankSourceCopyWith<$Res> {
  _$BankSourceCopyWithImpl(this._self, this._then);

  final BankSource _self;
  final $Res Function(BankSource) _then;

/// Create a copy of ItemSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(BankSource(
null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Item>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class GeneratorSource extends ItemSource {
  const GeneratorSource({required this.generatorId, required this.seed, @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson) required this.params, required this.count, this.difficulty = const DifficultyRange(min: 3, max: 3), final  String? $type}): $type = $type ?? 'generator',super._();
  factory GeneratorSource.fromJson(Map<String, dynamic> json) => _$GeneratorSourceFromJson(json);

 final  GeneratorId generatorId;
 final  int seed;
@JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson) final  GeneratorParams params;
 final  int count;
@JsonKey() final  DifficultyRange difficulty;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of ItemSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneratorSourceCopyWith<GeneratorSource> get copyWith => _$GeneratorSourceCopyWithImpl<GeneratorSource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeneratorSourceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneratorSource&&(identical(other.generatorId, generatorId) || other.generatorId == generatorId)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.params, params) || other.params == params)&&(identical(other.count, count) || other.count == count)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatorId,seed,params,count,difficulty);

@override
String toString() {
  return 'ItemSource.generator(generatorId: $generatorId, seed: $seed, params: $params, count: $count, difficulty: $difficulty)';
}


}

/// @nodoc
abstract mixin class $GeneratorSourceCopyWith<$Res> implements $ItemSourceCopyWith<$Res> {
  factory $GeneratorSourceCopyWith(GeneratorSource value, $Res Function(GeneratorSource) _then) = _$GeneratorSourceCopyWithImpl;
@useResult
$Res call({
 GeneratorId generatorId, int seed,@JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson) GeneratorParams params, int count, DifficultyRange difficulty
});


$GeneratorParamsCopyWith<$Res> get params;$DifficultyRangeCopyWith<$Res> get difficulty;

}
/// @nodoc
class _$GeneratorSourceCopyWithImpl<$Res>
    implements $GeneratorSourceCopyWith<$Res> {
  _$GeneratorSourceCopyWithImpl(this._self, this._then);

  final GeneratorSource _self;
  final $Res Function(GeneratorSource) _then;

/// Create a copy of ItemSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? generatorId = null,Object? seed = null,Object? params = null,Object? count = null,Object? difficulty = null,}) {
  return _then(GeneratorSource(
generatorId: null == generatorId ? _self.generatorId : generatorId // ignore: cast_nullable_to_non_nullable
as GeneratorId,seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,params: null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as GeneratorParams,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyRange,
  ));
}

/// Create a copy of ItemSource
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeneratorParamsCopyWith<$Res> get params {
  
  return $GeneratorParamsCopyWith<$Res>(_self.params, (value) {
    return _then(_self.copyWith(params: value));
  });
}/// Create a copy of ItemSource
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DifficultyRangeCopyWith<$Res> get difficulty {
  
  return $DifficultyRangeCopyWith<$Res>(_self.difficulty, (value) {
    return _then(_self.copyWith(difficulty: value));
  });
}
}

// dart format on
