// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Module {

 ModuleId get id; int get version; int get order; LocalizedText get name; LocalizedText get description; List<String> get familyIds; String? get defaultBlueprintId; ContentStatus get status;
/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModuleCopyWith<Module> get copyWith => _$ModuleCopyWithImpl<Module>(this as Module, _$identity);

  /// Serializes this Module to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Module&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.order, order) || other.order == order)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.familyIds, familyIds)&&(identical(other.defaultBlueprintId, defaultBlueprintId) || other.defaultBlueprintId == defaultBlueprintId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,order,name,description,const DeepCollectionEquality().hash(familyIds),defaultBlueprintId,status);

@override
String toString() {
  return 'Module(id: $id, version: $version, order: $order, name: $name, description: $description, familyIds: $familyIds, defaultBlueprintId: $defaultBlueprintId, status: $status)';
}


}

/// @nodoc
abstract mixin class $ModuleCopyWith<$Res>  {
  factory $ModuleCopyWith(Module value, $Res Function(Module) _then) = _$ModuleCopyWithImpl;
@useResult
$Res call({
 ModuleId id, int version, int order, LocalizedText name, LocalizedText description, List<String> familyIds, String? defaultBlueprintId, ContentStatus status
});


$LocalizedTextCopyWith<$Res> get name;$LocalizedTextCopyWith<$Res> get description;

}
/// @nodoc
class _$ModuleCopyWithImpl<$Res>
    implements $ModuleCopyWith<$Res> {
  _$ModuleCopyWithImpl(this._self, this._then);

  final Module _self;
  final $Res Function(Module) _then;

/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? version = null,Object? order = null,Object? name = null,Object? description = null,Object? familyIds = null,Object? defaultBlueprintId = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as ModuleId,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as LocalizedText,familyIds: null == familyIds ? _self.familyIds : familyIds // ignore: cast_nullable_to_non_nullable
as List<String>,defaultBlueprintId: freezed == defaultBlueprintId ? _self.defaultBlueprintId : defaultBlueprintId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,
  ));
}
/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get name {
  
  return $LocalizedTextCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get description {
  
  return $LocalizedTextCopyWith<$Res>(_self.description, (value) {
    return _then(_self.copyWith(description: value));
  });
}
}


/// Adds pattern-matching-related methods to [Module].
extension ModulePatterns on Module {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Module value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Module() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Module value)  $default,){
final _that = this;
switch (_that) {
case _Module():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Module value)?  $default,){
final _that = this;
switch (_that) {
case _Module() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ModuleId id,  int version,  int order,  LocalizedText name,  LocalizedText description,  List<String> familyIds,  String? defaultBlueprintId,  ContentStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Module() when $default != null:
return $default(_that.id,_that.version,_that.order,_that.name,_that.description,_that.familyIds,_that.defaultBlueprintId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ModuleId id,  int version,  int order,  LocalizedText name,  LocalizedText description,  List<String> familyIds,  String? defaultBlueprintId,  ContentStatus status)  $default,) {final _that = this;
switch (_that) {
case _Module():
return $default(_that.id,_that.version,_that.order,_that.name,_that.description,_that.familyIds,_that.defaultBlueprintId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ModuleId id,  int version,  int order,  LocalizedText name,  LocalizedText description,  List<String> familyIds,  String? defaultBlueprintId,  ContentStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Module() when $default != null:
return $default(_that.id,_that.version,_that.order,_that.name,_that.description,_that.familyIds,_that.defaultBlueprintId,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Module implements Module {
  const _Module({required this.id, required this.version, required this.order, required this.name, required this.description, required final  List<String> familyIds, this.defaultBlueprintId, this.status = ContentStatus.published}): _familyIds = familyIds;
  factory _Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);

@override final  ModuleId id;
@override final  int version;
@override final  int order;
@override final  LocalizedText name;
@override final  LocalizedText description;
 final  List<String> _familyIds;
@override List<String> get familyIds {
  if (_familyIds is EqualUnmodifiableListView) return _familyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_familyIds);
}

@override final  String? defaultBlueprintId;
@override@JsonKey() final  ContentStatus status;

/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModuleCopyWith<_Module> get copyWith => __$ModuleCopyWithImpl<_Module>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Module&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.order, order) || other.order == order)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._familyIds, _familyIds)&&(identical(other.defaultBlueprintId, defaultBlueprintId) || other.defaultBlueprintId == defaultBlueprintId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,order,name,description,const DeepCollectionEquality().hash(_familyIds),defaultBlueprintId,status);

@override
String toString() {
  return 'Module(id: $id, version: $version, order: $order, name: $name, description: $description, familyIds: $familyIds, defaultBlueprintId: $defaultBlueprintId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ModuleCopyWith<$Res> implements $ModuleCopyWith<$Res> {
  factory _$ModuleCopyWith(_Module value, $Res Function(_Module) _then) = __$ModuleCopyWithImpl;
@override @useResult
$Res call({
 ModuleId id, int version, int order, LocalizedText name, LocalizedText description, List<String> familyIds, String? defaultBlueprintId, ContentStatus status
});


@override $LocalizedTextCopyWith<$Res> get name;@override $LocalizedTextCopyWith<$Res> get description;

}
/// @nodoc
class __$ModuleCopyWithImpl<$Res>
    implements _$ModuleCopyWith<$Res> {
  __$ModuleCopyWithImpl(this._self, this._then);

  final _Module _self;
  final $Res Function(_Module) _then;

/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? version = null,Object? order = null,Object? name = null,Object? description = null,Object? familyIds = null,Object? defaultBlueprintId = freezed,Object? status = null,}) {
  return _then(_Module(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as ModuleId,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as LocalizedText,familyIds: null == familyIds ? _self._familyIds : familyIds // ignore: cast_nullable_to_non_nullable
as List<String>,defaultBlueprintId: freezed == defaultBlueprintId ? _self.defaultBlueprintId : defaultBlueprintId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,
  ));
}

/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get name {
  
  return $LocalizedTextCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get description {
  
  return $LocalizedTextCopyWith<$Res>(_self.description, (value) {
    return _then(_self.copyWith(description: value));
  });
}
}

// dart format on
