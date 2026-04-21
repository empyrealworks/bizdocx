// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_context.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserContext {

 String get userId; String get portfolioId; String get companyName; String get mission; List<String> get brandColors; String get targetAudience; String? get logoStorageUrl;// Injected from recent doc metadata for stylistic continuity
 List<String> get recentDocumentTitles;// Client snippets for invoice/proposal auto-fill
 Map<String, String> get savedClientDetails;// Paths to user-uploaded assets in Storage
 List<String> get uploadedAssetStoragePaths; DateTime? get lastUpdated;
/// Create a copy of UserContext
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserContextCopyWith<UserContext> get copyWith => _$UserContextCopyWithImpl<UserContext>(this as UserContext, _$identity);

  /// Serializes this UserContext to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserContext&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.portfolioId, portfolioId) || other.portfolioId == portfolioId)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.mission, mission) || other.mission == mission)&&const DeepCollectionEquality().equals(other.brandColors, brandColors)&&(identical(other.targetAudience, targetAudience) || other.targetAudience == targetAudience)&&(identical(other.logoStorageUrl, logoStorageUrl) || other.logoStorageUrl == logoStorageUrl)&&const DeepCollectionEquality().equals(other.recentDocumentTitles, recentDocumentTitles)&&const DeepCollectionEquality().equals(other.savedClientDetails, savedClientDetails)&&const DeepCollectionEquality().equals(other.uploadedAssetStoragePaths, uploadedAssetStoragePaths)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,portfolioId,companyName,mission,const DeepCollectionEquality().hash(brandColors),targetAudience,logoStorageUrl,const DeepCollectionEquality().hash(recentDocumentTitles),const DeepCollectionEquality().hash(savedClientDetails),const DeepCollectionEquality().hash(uploadedAssetStoragePaths),lastUpdated);

@override
String toString() {
  return 'UserContext(userId: $userId, portfolioId: $portfolioId, companyName: $companyName, mission: $mission, brandColors: $brandColors, targetAudience: $targetAudience, logoStorageUrl: $logoStorageUrl, recentDocumentTitles: $recentDocumentTitles, savedClientDetails: $savedClientDetails, uploadedAssetStoragePaths: $uploadedAssetStoragePaths, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $UserContextCopyWith<$Res>  {
  factory $UserContextCopyWith(UserContext value, $Res Function(UserContext) _then) = _$UserContextCopyWithImpl;
@useResult
$Res call({
 String userId, String portfolioId, String companyName, String mission, List<String> brandColors, String targetAudience, String? logoStorageUrl, List<String> recentDocumentTitles, Map<String, String> savedClientDetails, List<String> uploadedAssetStoragePaths, DateTime? lastUpdated
});




}
/// @nodoc
class _$UserContextCopyWithImpl<$Res>
    implements $UserContextCopyWith<$Res> {
  _$UserContextCopyWithImpl(this._self, this._then);

  final UserContext _self;
  final $Res Function(UserContext) _then;

/// Create a copy of UserContext
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? portfolioId = null,Object? companyName = null,Object? mission = null,Object? brandColors = null,Object? targetAudience = null,Object? logoStorageUrl = freezed,Object? recentDocumentTitles = null,Object? savedClientDetails = null,Object? uploadedAssetStoragePaths = null,Object? lastUpdated = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,portfolioId: null == portfolioId ? _self.portfolioId : portfolioId // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,mission: null == mission ? _self.mission : mission // ignore: cast_nullable_to_non_nullable
as String,brandColors: null == brandColors ? _self.brandColors : brandColors // ignore: cast_nullable_to_non_nullable
as List<String>,targetAudience: null == targetAudience ? _self.targetAudience : targetAudience // ignore: cast_nullable_to_non_nullable
as String,logoStorageUrl: freezed == logoStorageUrl ? _self.logoStorageUrl : logoStorageUrl // ignore: cast_nullable_to_non_nullable
as String?,recentDocumentTitles: null == recentDocumentTitles ? _self.recentDocumentTitles : recentDocumentTitles // ignore: cast_nullable_to_non_nullable
as List<String>,savedClientDetails: null == savedClientDetails ? _self.savedClientDetails : savedClientDetails // ignore: cast_nullable_to_non_nullable
as Map<String, String>,uploadedAssetStoragePaths: null == uploadedAssetStoragePaths ? _self.uploadedAssetStoragePaths : uploadedAssetStoragePaths // ignore: cast_nullable_to_non_nullable
as List<String>,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserContext].
extension UserContextPatterns on UserContext {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserContext value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserContext() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserContext value)  $default,){
final _that = this;
switch (_that) {
case _UserContext():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserContext value)?  $default,){
final _that = this;
switch (_that) {
case _UserContext() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String portfolioId,  String companyName,  String mission,  List<String> brandColors,  String targetAudience,  String? logoStorageUrl,  List<String> recentDocumentTitles,  Map<String, String> savedClientDetails,  List<String> uploadedAssetStoragePaths,  DateTime? lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserContext() when $default != null:
return $default(_that.userId,_that.portfolioId,_that.companyName,_that.mission,_that.brandColors,_that.targetAudience,_that.logoStorageUrl,_that.recentDocumentTitles,_that.savedClientDetails,_that.uploadedAssetStoragePaths,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String portfolioId,  String companyName,  String mission,  List<String> brandColors,  String targetAudience,  String? logoStorageUrl,  List<String> recentDocumentTitles,  Map<String, String> savedClientDetails,  List<String> uploadedAssetStoragePaths,  DateTime? lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _UserContext():
return $default(_that.userId,_that.portfolioId,_that.companyName,_that.mission,_that.brandColors,_that.targetAudience,_that.logoStorageUrl,_that.recentDocumentTitles,_that.savedClientDetails,_that.uploadedAssetStoragePaths,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String portfolioId,  String companyName,  String mission,  List<String> brandColors,  String targetAudience,  String? logoStorageUrl,  List<String> recentDocumentTitles,  Map<String, String> savedClientDetails,  List<String> uploadedAssetStoragePaths,  DateTime? lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _UserContext() when $default != null:
return $default(_that.userId,_that.portfolioId,_that.companyName,_that.mission,_that.brandColors,_that.targetAudience,_that.logoStorageUrl,_that.recentDocumentTitles,_that.savedClientDetails,_that.uploadedAssetStoragePaths,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserContext extends UserContext {
  const _UserContext({required this.userId, required this.portfolioId, this.companyName = '', this.mission = '', final  List<String> brandColors = const [], this.targetAudience = '', this.logoStorageUrl, final  List<String> recentDocumentTitles = const [], final  Map<String, String> savedClientDetails = const {}, final  List<String> uploadedAssetStoragePaths = const [], this.lastUpdated}): _brandColors = brandColors,_recentDocumentTitles = recentDocumentTitles,_savedClientDetails = savedClientDetails,_uploadedAssetStoragePaths = uploadedAssetStoragePaths,super._();
  factory _UserContext.fromJson(Map<String, dynamic> json) => _$UserContextFromJson(json);

@override final  String userId;
@override final  String portfolioId;
@override@JsonKey() final  String companyName;
@override@JsonKey() final  String mission;
 final  List<String> _brandColors;
@override@JsonKey() List<String> get brandColors {
  if (_brandColors is EqualUnmodifiableListView) return _brandColors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_brandColors);
}

@override@JsonKey() final  String targetAudience;
@override final  String? logoStorageUrl;
// Injected from recent doc metadata for stylistic continuity
 final  List<String> _recentDocumentTitles;
// Injected from recent doc metadata for stylistic continuity
@override@JsonKey() List<String> get recentDocumentTitles {
  if (_recentDocumentTitles is EqualUnmodifiableListView) return _recentDocumentTitles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentDocumentTitles);
}

// Client snippets for invoice/proposal auto-fill
 final  Map<String, String> _savedClientDetails;
// Client snippets for invoice/proposal auto-fill
@override@JsonKey() Map<String, String> get savedClientDetails {
  if (_savedClientDetails is EqualUnmodifiableMapView) return _savedClientDetails;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_savedClientDetails);
}

// Paths to user-uploaded assets in Storage
 final  List<String> _uploadedAssetStoragePaths;
// Paths to user-uploaded assets in Storage
@override@JsonKey() List<String> get uploadedAssetStoragePaths {
  if (_uploadedAssetStoragePaths is EqualUnmodifiableListView) return _uploadedAssetStoragePaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_uploadedAssetStoragePaths);
}

@override final  DateTime? lastUpdated;

/// Create a copy of UserContext
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserContextCopyWith<_UserContext> get copyWith => __$UserContextCopyWithImpl<_UserContext>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserContextToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserContext&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.portfolioId, portfolioId) || other.portfolioId == portfolioId)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.mission, mission) || other.mission == mission)&&const DeepCollectionEquality().equals(other._brandColors, _brandColors)&&(identical(other.targetAudience, targetAudience) || other.targetAudience == targetAudience)&&(identical(other.logoStorageUrl, logoStorageUrl) || other.logoStorageUrl == logoStorageUrl)&&const DeepCollectionEquality().equals(other._recentDocumentTitles, _recentDocumentTitles)&&const DeepCollectionEquality().equals(other._savedClientDetails, _savedClientDetails)&&const DeepCollectionEquality().equals(other._uploadedAssetStoragePaths, _uploadedAssetStoragePaths)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,portfolioId,companyName,mission,const DeepCollectionEquality().hash(_brandColors),targetAudience,logoStorageUrl,const DeepCollectionEquality().hash(_recentDocumentTitles),const DeepCollectionEquality().hash(_savedClientDetails),const DeepCollectionEquality().hash(_uploadedAssetStoragePaths),lastUpdated);

@override
String toString() {
  return 'UserContext(userId: $userId, portfolioId: $portfolioId, companyName: $companyName, mission: $mission, brandColors: $brandColors, targetAudience: $targetAudience, logoStorageUrl: $logoStorageUrl, recentDocumentTitles: $recentDocumentTitles, savedClientDetails: $savedClientDetails, uploadedAssetStoragePaths: $uploadedAssetStoragePaths, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$UserContextCopyWith<$Res> implements $UserContextCopyWith<$Res> {
  factory _$UserContextCopyWith(_UserContext value, $Res Function(_UserContext) _then) = __$UserContextCopyWithImpl;
@override @useResult
$Res call({
 String userId, String portfolioId, String companyName, String mission, List<String> brandColors, String targetAudience, String? logoStorageUrl, List<String> recentDocumentTitles, Map<String, String> savedClientDetails, List<String> uploadedAssetStoragePaths, DateTime? lastUpdated
});




}
/// @nodoc
class __$UserContextCopyWithImpl<$Res>
    implements _$UserContextCopyWith<$Res> {
  __$UserContextCopyWithImpl(this._self, this._then);

  final _UserContext _self;
  final $Res Function(_UserContext) _then;

/// Create a copy of UserContext
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? portfolioId = null,Object? companyName = null,Object? mission = null,Object? brandColors = null,Object? targetAudience = null,Object? logoStorageUrl = freezed,Object? recentDocumentTitles = null,Object? savedClientDetails = null,Object? uploadedAssetStoragePaths = null,Object? lastUpdated = freezed,}) {
  return _then(_UserContext(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,portfolioId: null == portfolioId ? _self.portfolioId : portfolioId // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,mission: null == mission ? _self.mission : mission // ignore: cast_nullable_to_non_nullable
as String,brandColors: null == brandColors ? _self._brandColors : brandColors // ignore: cast_nullable_to_non_nullable
as List<String>,targetAudience: null == targetAudience ? _self.targetAudience : targetAudience // ignore: cast_nullable_to_non_nullable
as String,logoStorageUrl: freezed == logoStorageUrl ? _self.logoStorageUrl : logoStorageUrl // ignore: cast_nullable_to_non_nullable
as String?,recentDocumentTitles: null == recentDocumentTitles ? _self._recentDocumentTitles : recentDocumentTitles // ignore: cast_nullable_to_non_nullable
as List<String>,savedClientDetails: null == savedClientDetails ? _self._savedClientDetails : savedClientDetails // ignore: cast_nullable_to_non_nullable
as Map<String, String>,uploadedAssetStoragePaths: null == uploadedAssetStoragePaths ? _self._uploadedAssetStoragePaths : uploadedAssetStoragePaths // ignore: cast_nullable_to_non_nullable
as List<String>,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
