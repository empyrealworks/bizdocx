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

 String get id; String get userId; String get name; String get description; String get mission; List<String> get brandColors; String get targetAudience;// New context fields
 String get businessAddress; String get businessEmail; String get businessPhone; String get website; String get country; String get defaultCurrency; DateTime get createdAt; DateTime? get updatedAt; List<String> get documentIds;
/// Create a copy of BusinessPortfolio
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessPortfolioCopyWith<BusinessPortfolio> get copyWith => _$BusinessPortfolioCopyWithImpl<BusinessPortfolio>(this as BusinessPortfolio, _$identity);

  /// Serializes this BusinessPortfolio to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessPortfolio&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.mission, mission) || other.mission == mission)&&const DeepCollectionEquality().equals(other.brandColors, brandColors)&&(identical(other.targetAudience, targetAudience) || other.targetAudience == targetAudience)&&(identical(other.businessAddress, businessAddress) || other.businessAddress == businessAddress)&&(identical(other.businessEmail, businessEmail) || other.businessEmail == businessEmail)&&(identical(other.businessPhone, businessPhone) || other.businessPhone == businessPhone)&&(identical(other.website, website) || other.website == website)&&(identical(other.country, country) || other.country == country)&&(identical(other.defaultCurrency, defaultCurrency) || other.defaultCurrency == defaultCurrency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.documentIds, documentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,description,mission,const DeepCollectionEquality().hash(brandColors),targetAudience,businessAddress,businessEmail,businessPhone,website,country,defaultCurrency,createdAt,updatedAt,const DeepCollectionEquality().hash(documentIds));

@override
String toString() {
  return 'BusinessPortfolio(id: $id, userId: $userId, name: $name, description: $description, mission: $mission, brandColors: $brandColors, targetAudience: $targetAudience, businessAddress: $businessAddress, businessEmail: $businessEmail, businessPhone: $businessPhone, website: $website, country: $country, defaultCurrency: $defaultCurrency, createdAt: $createdAt, updatedAt: $updatedAt, documentIds: $documentIds)';
}


}

/// @nodoc
abstract mixin class $BusinessPortfolioCopyWith<$Res>  {
  factory $BusinessPortfolioCopyWith(BusinessPortfolio value, $Res Function(BusinessPortfolio) _then) = _$BusinessPortfolioCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, String description, String mission, List<String> brandColors, String targetAudience, String businessAddress, String businessEmail, String businessPhone, String website, String country, String defaultCurrency, DateTime createdAt, DateTime? updatedAt, List<String> documentIds
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? description = null,Object? mission = null,Object? brandColors = null,Object? targetAudience = null,Object? businessAddress = null,Object? businessEmail = null,Object? businessPhone = null,Object? website = null,Object? country = null,Object? defaultCurrency = null,Object? createdAt = null,Object? updatedAt = freezed,Object? documentIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,mission: null == mission ? _self.mission : mission // ignore: cast_nullable_to_non_nullable
as String,brandColors: null == brandColors ? _self.brandColors : brandColors // ignore: cast_nullable_to_non_nullable
as List<String>,targetAudience: null == targetAudience ? _self.targetAudience : targetAudience // ignore: cast_nullable_to_non_nullable
as String,businessAddress: null == businessAddress ? _self.businessAddress : businessAddress // ignore: cast_nullable_to_non_nullable
as String,businessEmail: null == businessEmail ? _self.businessEmail : businessEmail // ignore: cast_nullable_to_non_nullable
as String,businessPhone: null == businessPhone ? _self.businessPhone : businessPhone // ignore: cast_nullable_to_non_nullable
as String,website: null == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,defaultCurrency: null == defaultCurrency ? _self.defaultCurrency : defaultCurrency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,documentIds: null == documentIds ? _self.documentIds : documentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  String description,  String mission,  List<String> brandColors,  String targetAudience,  String businessAddress,  String businessEmail,  String businessPhone,  String website,  String country,  String defaultCurrency,  DateTime createdAt,  DateTime? updatedAt,  List<String> documentIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessPortfolio() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.description,_that.mission,_that.brandColors,_that.targetAudience,_that.businessAddress,_that.businessEmail,_that.businessPhone,_that.website,_that.country,_that.defaultCurrency,_that.createdAt,_that.updatedAt,_that.documentIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  String description,  String mission,  List<String> brandColors,  String targetAudience,  String businessAddress,  String businessEmail,  String businessPhone,  String website,  String country,  String defaultCurrency,  DateTime createdAt,  DateTime? updatedAt,  List<String> documentIds)  $default,) {final _that = this;
switch (_that) {
case _BusinessPortfolio():
return $default(_that.id,_that.userId,_that.name,_that.description,_that.mission,_that.brandColors,_that.targetAudience,_that.businessAddress,_that.businessEmail,_that.businessPhone,_that.website,_that.country,_that.defaultCurrency,_that.createdAt,_that.updatedAt,_that.documentIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  String description,  String mission,  List<String> brandColors,  String targetAudience,  String businessAddress,  String businessEmail,  String businessPhone,  String website,  String country,  String defaultCurrency,  DateTime createdAt,  DateTime? updatedAt,  List<String> documentIds)?  $default,) {final _that = this;
switch (_that) {
case _BusinessPortfolio() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.description,_that.mission,_that.brandColors,_that.targetAudience,_that.businessAddress,_that.businessEmail,_that.businessPhone,_that.website,_that.country,_that.defaultCurrency,_that.createdAt,_that.updatedAt,_that.documentIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BusinessPortfolio extends BusinessPortfolio {
  const _BusinessPortfolio({required this.id, required this.userId, required this.name, this.description = '', this.mission = '', final  List<String> brandColors = const [], this.targetAudience = '', this.businessAddress = '', this.businessEmail = '', this.businessPhone = '', this.website = '', this.country = 'Nigeria', this.defaultCurrency = 'NGN', required this.createdAt, this.updatedAt, final  List<String> documentIds = const []}): _brandColors = brandColors,_documentIds = documentIds,super._();
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
// New context fields
@override@JsonKey() final  String businessAddress;
@override@JsonKey() final  String businessEmail;
@override@JsonKey() final  String businessPhone;
@override@JsonKey() final  String website;
@override@JsonKey() final  String country;
@override@JsonKey() final  String defaultCurrency;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;
 final  List<String> _documentIds;
@override@JsonKey() List<String> get documentIds {
  if (_documentIds is EqualUnmodifiableListView) return _documentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_documentIds);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessPortfolio&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.mission, mission) || other.mission == mission)&&const DeepCollectionEquality().equals(other._brandColors, _brandColors)&&(identical(other.targetAudience, targetAudience) || other.targetAudience == targetAudience)&&(identical(other.businessAddress, businessAddress) || other.businessAddress == businessAddress)&&(identical(other.businessEmail, businessEmail) || other.businessEmail == businessEmail)&&(identical(other.businessPhone, businessPhone) || other.businessPhone == businessPhone)&&(identical(other.website, website) || other.website == website)&&(identical(other.country, country) || other.country == country)&&(identical(other.defaultCurrency, defaultCurrency) || other.defaultCurrency == defaultCurrency)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._documentIds, _documentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,name,description,mission,const DeepCollectionEquality().hash(_brandColors),targetAudience,businessAddress,businessEmail,businessPhone,website,country,defaultCurrency,createdAt,updatedAt,const DeepCollectionEquality().hash(_documentIds));

@override
String toString() {
  return 'BusinessPortfolio(id: $id, userId: $userId, name: $name, description: $description, mission: $mission, brandColors: $brandColors, targetAudience: $targetAudience, businessAddress: $businessAddress, businessEmail: $businessEmail, businessPhone: $businessPhone, website: $website, country: $country, defaultCurrency: $defaultCurrency, createdAt: $createdAt, updatedAt: $updatedAt, documentIds: $documentIds)';
}


}

/// @nodoc
abstract mixin class _$BusinessPortfolioCopyWith<$Res> implements $BusinessPortfolioCopyWith<$Res> {
  factory _$BusinessPortfolioCopyWith(_BusinessPortfolio value, $Res Function(_BusinessPortfolio) _then) = __$BusinessPortfolioCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, String description, String mission, List<String> brandColors, String targetAudience, String businessAddress, String businessEmail, String businessPhone, String website, String country, String defaultCurrency, DateTime createdAt, DateTime? updatedAt, List<String> documentIds
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? description = null,Object? mission = null,Object? brandColors = null,Object? targetAudience = null,Object? businessAddress = null,Object? businessEmail = null,Object? businessPhone = null,Object? website = null,Object? country = null,Object? defaultCurrency = null,Object? createdAt = null,Object? updatedAt = freezed,Object? documentIds = null,}) {
  return _then(_BusinessPortfolio(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,mission: null == mission ? _self.mission : mission // ignore: cast_nullable_to_non_nullable
as String,brandColors: null == brandColors ? _self._brandColors : brandColors // ignore: cast_nullable_to_non_nullable
as List<String>,targetAudience: null == targetAudience ? _self.targetAudience : targetAudience // ignore: cast_nullable_to_non_nullable
as String,businessAddress: null == businessAddress ? _self.businessAddress : businessAddress // ignore: cast_nullable_to_non_nullable
as String,businessEmail: null == businessEmail ? _self.businessEmail : businessEmail // ignore: cast_nullable_to_non_nullable
as String,businessPhone: null == businessPhone ? _self.businessPhone : businessPhone // ignore: cast_nullable_to_non_nullable
as String,website: null == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,defaultCurrency: null == defaultCurrency ? _self.defaultCurrency : defaultCurrency // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,documentIds: null == documentIds ? _self._documentIds : documentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
