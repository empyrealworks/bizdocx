// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_portfolio.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BusinessPortfolio {

 String get id; String get userId; String get name; String get description; String get mission; List<String> get brandColors; String get targetAudience; String? get logoStoragePath; String? get logoLocalPath; List<String> get documentIds; List<String> get uploadedAssetPaths; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of BusinessPortfolio
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessPortfolioCopyWith<BusinessPortfolio> get copyWith => _$BusinessPortfolioCopyWithImpl<BusinessPortfolio>(this as BusinessPortfolio, _$identity);

  /// Serializes this BusinessPortfolio to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessPortfolio&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.mission, mission) || other.mission == mission)&&const DeepCollectionEquality().equals(other.brandColors, brandColors)&&(identical(other.targetAudience, targetAudience) || other.targetAudience == targetAudience)&&(identical(other.logoStoragePath, logoStoragePath) || other.logoStoragePath == logoStoragePath)&&(identical(other.logoLocalPath, logoLocalPath) || other.logoLocalPath == logoLocalPath)&&const DeepCollectionEquality().equals(other.documentIds, documentIds)&&const DeepCollectionEquality().equals(other.uploadedAssetPaths, uploadedAssetPaths)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,description,mission,const DeepCollectionEquality().hash(brandColors),targetAudience,logoStoragePath,logoLocalPath,const DeepCollectionEquality().hash(documentIds),const DeepCollectionEquality().hash(uploadedAssetPaths),createdAt,updatedAt);

@override
String toString() {
  return 'BusinessPortfolio(id: $id, userId: $userId, name: $name, description: $description, mission: $mission, brandColors: $brandColors, targetAudience: $targetAudience, logoStoragePath: $logoStoragePath, logoLocalPath: $logoLocalPath, documentIds: $documentIds, uploadedAssetPaths: $uploadedAssetPaths, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $BusinessPortfolioCopyWith<$Res>  {
  factory $BusinessPortfolioCopyWith(BusinessPortfolio value, $Res Function(BusinessPortfolio) _then) = _$BusinessPortfolioCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, String description, String mission, List<String> brandColors, String targetAudience, String? logoStoragePath, String? logoLocalPath, List<String> documentIds, List<String> uploadedAssetPaths, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$BusinessPortfolioCopyWithImpl<$Res>
    implements $BusinessPortfolioCopyWith<$Res> {
  _$BusinessPortfolioCopyWithImpl(this._self, this._then);

  final BusinessPortfolio _self;
  final $Res Function(BusinessPortfolio) _then;

/// Create a copy of BusinessPortfolio
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? description = null,Object? mission = null,Object? brandColors = null,Object? targetAudience = null,Object? logoStoragePath = freezed,Object? logoLocalPath = freezed,Object? documentIds = null,Object? uploadedAssetPaths = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,mission: null == mission ? _self.mission : mission // ignore: cast_nullable_to_non_nullable
as String,brandColors: null == brandColors ? _self.brandColors : brandColors // ignore: cast_nullable_to_non_nullable
as List<String>,targetAudience: null == targetAudience ? _self.targetAudience : targetAudience // ignore: cast_nullable_to_non_nullable
as String,logoStoragePath: freezed == logoStoragePath ? _self.logoStoragePath : logoStoragePath // ignore: cast_nullable_to_non_nullable
as String?,logoLocalPath: freezed == logoLocalPath ? _self.logoLocalPath : logoLocalPath // ignore: cast_nullable_to_non_nullable
as String?,documentIds: null == documentIds ? _self.documentIds : documentIds // ignore: cast_nullable_to_non_nullable
as List<String>,uploadedAssetPaths: null == uploadedAssetPaths ? _self.uploadedAssetPaths : uploadedAssetPaths // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessPortfolio].
extension BusinessPortfolioPatterns on BusinessPortfolio {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessPortfolio value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessPortfolio() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessPortfolio value)  $default,){
final _that = this;
switch (_that) {
case _BusinessPortfolio():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessPortfolio value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessPortfolio() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  String description,  String mission,  List<String> brandColors,  String targetAudience,  String? logoStoragePath,  String? logoLocalPath,  List<String> documentIds,  List<String> uploadedAssetPaths,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessPortfolio() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.description,_that.mission,_that.brandColors,_that.targetAudience,_that.logoStoragePath,_that.logoLocalPath,_that.documentIds,_that.uploadedAssetPaths,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  String description,  String mission,  List<String> brandColors,  String targetAudience,  String? logoStoragePath,  String? logoLocalPath,  List<String> documentIds,  List<String> uploadedAssetPaths,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _BusinessPortfolio():
return $default(_that.id,_that.userId,_that.name,_that.description,_that.mission,_that.brandColors,_that.targetAudience,_that.logoStoragePath,_that.logoLocalPath,_that.documentIds,_that.uploadedAssetPaths,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  String description,  String mission,  List<String> brandColors,  String targetAudience,  String? logoStoragePath,  String? logoLocalPath,  List<String> documentIds,  List<String> uploadedAssetPaths,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BusinessPortfolio() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.description,_that.mission,_that.brandColors,_that.targetAudience,_that.logoStoragePath,_that.logoLocalPath,_that.documentIds,_that.uploadedAssetPaths,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusinessPortfolio extends BusinessPortfolio {
  const _BusinessPortfolio({required this.id, required this.userId, required this.name, this.description = '', this.mission = '', final  List<String> brandColors = const [], this.targetAudience = '', this.logoStoragePath, this.logoLocalPath, final  List<String> documentIds = const [], final  List<String> uploadedAssetPaths = const [], required this.createdAt, this.updatedAt}): _brandColors = brandColors,_documentIds = documentIds,_uploadedAssetPaths = uploadedAssetPaths,super._();
  factory _BusinessPortfolio.fromJson(Map<String, dynamic> json) => _$BusinessPortfolioFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  String mission;
 final  List<String> _brandColors;
@override@JsonKey() List<String> get brandColors {
  if (_brandColors is EqualUnmodifiableListView) return _brandColors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_brandColors);
}

@override@JsonKey() final  String targetAudience;
@override final  String? logoStoragePath;
@override final  String? logoLocalPath;
 final  List<String> _documentIds;
@override@JsonKey() List<String> get documentIds {
  if (_documentIds is EqualUnmodifiableListView) return _documentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_documentIds);
}

 final  List<String> _uploadedAssetPaths;
@override@JsonKey() List<String> get uploadedAssetPaths {
  if (_uploadedAssetPaths is EqualUnmodifiableListView) return _uploadedAssetPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uploadedAssetPaths);
}

@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of BusinessPortfolio
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessPortfolioCopyWith<_BusinessPortfolio> get copyWith => __$BusinessPortfolioCopyWithImpl<_BusinessPortfolio>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessPortfolioToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessPortfolio&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.mission, mission) || other.mission == mission)&&const DeepCollectionEquality().equals(other._brandColors, _brandColors)&&(identical(other.targetAudience, targetAudience) || other.targetAudience == targetAudience)&&(identical(other.logoStoragePath, logoStoragePath) || other.logoStoragePath == logoStoragePath)&&(identical(other.logoLocalPath, logoLocalPath) || other.logoLocalPath == logoLocalPath)&&const DeepCollectionEquality().equals(other._documentIds, _documentIds)&&const DeepCollectionEquality().equals(other._uploadedAssetPaths, _uploadedAssetPaths)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,description,mission,const DeepCollectionEquality().hash(_brandColors),targetAudience,logoStoragePath,logoLocalPath,const DeepCollectionEquality().hash(_documentIds),const DeepCollectionEquality().hash(_uploadedAssetPaths),createdAt,updatedAt);

@override
String toString() {
  return 'BusinessPortfolio(id: $id, userId: $userId, name: $name, description: $description, mission: $mission, brandColors: $brandColors, targetAudience: $targetAudience, logoStoragePath: $logoStoragePath, logoLocalPath: $logoLocalPath, documentIds: $documentIds, uploadedAssetPaths: $uploadedAssetPaths, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BusinessPortfolioCopyWith<$Res> implements $BusinessPortfolioCopyWith<$Res> {
  factory _$BusinessPortfolioCopyWith(_BusinessPortfolio value, $Res Function(_BusinessPortfolio) _then) = __$BusinessPortfolioCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, String description, String mission, List<String> brandColors, String targetAudience, String? logoStoragePath, String? logoLocalPath, List<String> documentIds, List<String> uploadedAssetPaths, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$BusinessPortfolioCopyWithImpl<$Res>
    implements _$BusinessPortfolioCopyWith<$Res> {
  __$BusinessPortfolioCopyWithImpl(this._self, this._then);

  final _BusinessPortfolio _self;
  final $Res Function(_BusinessPortfolio) _then;

/// Create a copy of BusinessPortfolio
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? description = null,Object? mission = null,Object? brandColors = null,Object? targetAudience = null,Object? logoStoragePath = freezed,Object? logoLocalPath = freezed,Object? documentIds = null,Object? uploadedAssetPaths = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_BusinessPortfolio(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,mission: null == mission ? _self.mission : mission // ignore: cast_nullable_to_non_nullable
as String,brandColors: null == brandColors ? _self._brandColors : brandColors // ignore: cast_nullable_to_non_nullable
as List<String>,targetAudience: null == targetAudience ? _self.targetAudience : targetAudience // ignore: cast_nullable_to_non_nullable
as String,logoStoragePath: freezed == logoStoragePath ? _self.logoStoragePath : logoStoragePath // ignore: cast_nullable_to_non_nullable
as String?,logoLocalPath: freezed == logoLocalPath ? _self.logoLocalPath : logoLocalPath // ignore: cast_nullable_to_non_nullable
as String?,documentIds: null == documentIds ? _self._documentIds : documentIds // ignore: cast_nullable_to_non_nullable
as List<String>,uploadedAssetPaths: null == uploadedAssetPaths ? _self._uploadedAssetPaths : uploadedAssetPaths // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
