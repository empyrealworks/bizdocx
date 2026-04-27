// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get uid; String get email; String? get displayName; UserTier get tier; int get credits; DateTime? get lastCreditReset;// Limits tracking for Free Tier
 int get dailyDocGens; DateTime? get lastDocGenDate; int get weeklyImageGens; DateTime? get lastImageGenDate;// Metadata
 DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.lastCreditReset, lastCreditReset) || other.lastCreditReset == lastCreditReset)&&(identical(other.dailyDocGens, dailyDocGens) || other.dailyDocGens == dailyDocGens)&&(identical(other.lastDocGenDate, lastDocGenDate) || other.lastDocGenDate == lastDocGenDate)&&(identical(other.weeklyImageGens, weeklyImageGens) || other.weeklyImageGens == weeklyImageGens)&&(identical(other.lastImageGenDate, lastImageGenDate) || other.lastImageGenDate == lastImageGenDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,tier,credits,lastCreditReset,dailyDocGens,lastDocGenDate,weeklyImageGens,lastImageGenDate,createdAt,updatedAt);

@override
String toString() {
  return 'UserProfile(uid: $uid, email: $email, displayName: $displayName, tier: $tier, credits: $credits, lastCreditReset: $lastCreditReset, dailyDocGens: $dailyDocGens, lastDocGenDate: $lastDocGenDate, weeklyImageGens: $weeklyImageGens, lastImageGenDate: $lastImageGenDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String uid, String email, String? displayName, UserTier tier, int credits, DateTime? lastCreditReset, int dailyDocGens, DateTime? lastDocGenDate, int weeklyImageGens, DateTime? lastImageGenDate, DateTime createdAt, DateTime? updatedAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? displayName = freezed,Object? tier = null,Object? credits = null,Object? lastCreditReset = freezed,Object? dailyDocGens = null,Object? lastDocGenDate = freezed,Object? weeklyImageGens = null,Object? lastImageGenDate = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as UserTier,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,lastCreditReset: freezed == lastCreditReset ? _self.lastCreditReset : lastCreditReset // ignore: cast_nullable_to_non_nullable
as DateTime?,dailyDocGens: null == dailyDocGens ? _self.dailyDocGens : dailyDocGens // ignore: cast_nullable_to_non_nullable
as int,lastDocGenDate: freezed == lastDocGenDate ? _self.lastDocGenDate : lastDocGenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,weeklyImageGens: null == weeklyImageGens ? _self.weeklyImageGens : weeklyImageGens // ignore: cast_nullable_to_non_nullable
as int,lastImageGenDate: freezed == lastImageGenDate ? _self.lastImageGenDate : lastImageGenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String email,  String? displayName,  UserTier tier,  int credits,  DateTime? lastCreditReset,  int dailyDocGens,  DateTime? lastDocGenDate,  int weeklyImageGens,  DateTime? lastImageGenDate,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.tier,_that.credits,_that.lastCreditReset,_that.dailyDocGens,_that.lastDocGenDate,_that.weeklyImageGens,_that.lastImageGenDate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String email,  String? displayName,  UserTier tier,  int credits,  DateTime? lastCreditReset,  int dailyDocGens,  DateTime? lastDocGenDate,  int weeklyImageGens,  DateTime? lastImageGenDate,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.uid,_that.email,_that.displayName,_that.tier,_that.credits,_that.lastCreditReset,_that.dailyDocGens,_that.lastDocGenDate,_that.weeklyImageGens,_that.lastImageGenDate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String email,  String? displayName,  UserTier tier,  int credits,  DateTime? lastCreditReset,  int dailyDocGens,  DateTime? lastDocGenDate,  int weeklyImageGens,  DateTime? lastImageGenDate,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.tier,_that.credits,_that.lastCreditReset,_that.dailyDocGens,_that.lastDocGenDate,_that.weeklyImageGens,_that.lastImageGenDate,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile extends UserProfile {
  const _UserProfile({required this.uid, required this.email, this.displayName, this.tier = UserTier.free, this.credits = 0, this.lastCreditReset, this.dailyDocGens = 0, this.lastDocGenDate, this.weeklyImageGens = 0, this.lastImageGenDate, required this.createdAt, this.updatedAt}): super._();
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String uid;
@override final  String email;
@override final  String? displayName;
@override@JsonKey() final  UserTier tier;
@override@JsonKey() final  int credits;
@override final  DateTime? lastCreditReset;
// Limits tracking for Free Tier
@override@JsonKey() final  int dailyDocGens;
@override final  DateTime? lastDocGenDate;
@override@JsonKey() final  int weeklyImageGens;
@override final  DateTime? lastImageGenDate;
// Metadata
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.lastCreditReset, lastCreditReset) || other.lastCreditReset == lastCreditReset)&&(identical(other.dailyDocGens, dailyDocGens) || other.dailyDocGens == dailyDocGens)&&(identical(other.lastDocGenDate, lastDocGenDate) || other.lastDocGenDate == lastDocGenDate)&&(identical(other.weeklyImageGens, weeklyImageGens) || other.weeklyImageGens == weeklyImageGens)&&(identical(other.lastImageGenDate, lastImageGenDate) || other.lastImageGenDate == lastImageGenDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,tier,credits,lastCreditReset,dailyDocGens,lastDocGenDate,weeklyImageGens,lastImageGenDate,createdAt,updatedAt);

@override
String toString() {
  return 'UserProfile(uid: $uid, email: $email, displayName: $displayName, tier: $tier, credits: $credits, lastCreditReset: $lastCreditReset, dailyDocGens: $dailyDocGens, lastDocGenDate: $lastDocGenDate, weeklyImageGens: $weeklyImageGens, lastImageGenDate: $lastImageGenDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email, String? displayName, UserTier tier, int credits, DateTime? lastCreditReset, int dailyDocGens, DateTime? lastDocGenDate, int weeklyImageGens, DateTime? lastImageGenDate, DateTime createdAt, DateTime? updatedAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? displayName = freezed,Object? tier = null,Object? credits = null,Object? lastCreditReset = freezed,Object? dailyDocGens = null,Object? lastDocGenDate = freezed,Object? weeklyImageGens = null,Object? lastImageGenDate = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_UserProfile(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as UserTier,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,lastCreditReset: freezed == lastCreditReset ? _self.lastCreditReset : lastCreditReset // ignore: cast_nullable_to_non_nullable
as DateTime?,dailyDocGens: null == dailyDocGens ? _self.dailyDocGens : dailyDocGens // ignore: cast_nullable_to_non_nullable
as int,lastDocGenDate: freezed == lastDocGenDate ? _self.lastDocGenDate : lastDocGenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,weeklyImageGens: null == weeklyImageGens ? _self.weeklyImageGens : weeklyImageGens // ignore: cast_nullable_to_non_nullable
as int,lastImageGenDate: freezed == lastImageGenDate ? _self.lastImageGenDate : lastImageGenDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
