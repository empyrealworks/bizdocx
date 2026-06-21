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

 String get uid; String get email; String? get displayName; UserTier get tier;// Wallets
 int get subscriptionCredits; int get topUpCredits;// Limits tracking
 DateTime? get lastCreditReset; DateTime? get subscriptionEndDate; bool get autoRenew;// Metadata
 DateTime get createdAt; DateTime? get updatedAt;// Settings
 Map<String, dynamic> get settings;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.subscriptionCredits, subscriptionCredits) || other.subscriptionCredits == subscriptionCredits)&&(identical(other.topUpCredits, topUpCredits) || other.topUpCredits == topUpCredits)&&(identical(other.lastCreditReset, lastCreditReset) || other.lastCreditReset == lastCreditReset)&&(identical(other.subscriptionEndDate, subscriptionEndDate) || other.subscriptionEndDate == subscriptionEndDate)&&(identical(other.autoRenew, autoRenew) || other.autoRenew == autoRenew)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.settings, settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,tier,subscriptionCredits,topUpCredits,lastCreditReset,subscriptionEndDate,autoRenew,createdAt,updatedAt,const DeepCollectionEquality().hash(settings));

@override
String toString() {
  return 'UserProfile(uid: $uid, email: $email, displayName: $displayName, tier: $tier, subscriptionCredits: $subscriptionCredits, topUpCredits: $topUpCredits, lastCreditReset: $lastCreditReset, subscriptionEndDate: $subscriptionEndDate, autoRenew: $autoRenew, createdAt: $createdAt, updatedAt: $updatedAt, settings: $settings)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String uid, String email, String? displayName, UserTier tier, int subscriptionCredits, int topUpCredits, DateTime? lastCreditReset, DateTime? subscriptionEndDate, bool autoRenew, DateTime createdAt, DateTime? updatedAt, Map<String, dynamic> settings
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
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? displayName = freezed,Object? tier = null,Object? subscriptionCredits = null,Object? topUpCredits = null,Object? lastCreditReset = freezed,Object? subscriptionEndDate = freezed,Object? autoRenew = null,Object? createdAt = null,Object? updatedAt = freezed,Object? settings = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as UserTier,subscriptionCredits: null == subscriptionCredits ? _self.subscriptionCredits : subscriptionCredits // ignore: cast_nullable_to_non_nullable
as int,topUpCredits: null == topUpCredits ? _self.topUpCredits : topUpCredits // ignore: cast_nullable_to_non_nullable
as int,lastCreditReset: freezed == lastCreditReset ? _self.lastCreditReset : lastCreditReset // ignore: cast_nullable_to_non_nullable
as DateTime?,subscriptionEndDate: freezed == subscriptionEndDate ? _self.subscriptionEndDate : subscriptionEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,autoRenew: null == autoRenew ? _self.autoRenew : autoRenew // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String email,  String? displayName,  UserTier tier,  int subscriptionCredits,  int topUpCredits,  DateTime? lastCreditReset,  DateTime? subscriptionEndDate,  bool autoRenew,  DateTime createdAt,  DateTime? updatedAt,  Map<String, dynamic> settings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.tier,_that.subscriptionCredits,_that.topUpCredits,_that.lastCreditReset,_that.subscriptionEndDate,_that.autoRenew,_that.createdAt,_that.updatedAt,_that.settings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String email,  String? displayName,  UserTier tier,  int subscriptionCredits,  int topUpCredits,  DateTime? lastCreditReset,  DateTime? subscriptionEndDate,  bool autoRenew,  DateTime createdAt,  DateTime? updatedAt,  Map<String, dynamic> settings)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.uid,_that.email,_that.displayName,_that.tier,_that.subscriptionCredits,_that.topUpCredits,_that.lastCreditReset,_that.subscriptionEndDate,_that.autoRenew,_that.createdAt,_that.updatedAt,_that.settings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String email,  String? displayName,  UserTier tier,  int subscriptionCredits,  int topUpCredits,  DateTime? lastCreditReset,  DateTime? subscriptionEndDate,  bool autoRenew,  DateTime createdAt,  DateTime? updatedAt,  Map<String, dynamic> settings)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.tier,_that.subscriptionCredits,_that.topUpCredits,_that.lastCreditReset,_that.subscriptionEndDate,_that.autoRenew,_that.createdAt,_that.updatedAt,_that.settings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile extends UserProfile {
  const _UserProfile({required this.uid, required this.email, this.displayName, this.tier = UserTier.free, this.subscriptionCredits = 50, this.topUpCredits = 0, this.lastCreditReset, this.subscriptionEndDate, this.autoRenew = false, required this.createdAt, this.updatedAt, final  Map<String, dynamic> settings = const {}}): _settings = settings,super._();
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String uid;
@override final  String email;
@override final  String? displayName;
@override@JsonKey() final  UserTier tier;
// Wallets
@override@JsonKey() final  int subscriptionCredits;
@override@JsonKey() final  int topUpCredits;
// Limits tracking
@override final  DateTime? lastCreditReset;
@override final  DateTime? subscriptionEndDate;
@override@JsonKey() final  bool autoRenew;
// Metadata
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;
// Settings
 final  Map<String, dynamic> _settings;
// Settings
@override@JsonKey() Map<String, dynamic> get settings {
  if (_settings is EqualUnmodifiableMapView) return _settings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_settings);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.subscriptionCredits, subscriptionCredits) || other.subscriptionCredits == subscriptionCredits)&&(identical(other.topUpCredits, topUpCredits) || other.topUpCredits == topUpCredits)&&(identical(other.lastCreditReset, lastCreditReset) || other.lastCreditReset == lastCreditReset)&&(identical(other.subscriptionEndDate, subscriptionEndDate) || other.subscriptionEndDate == subscriptionEndDate)&&(identical(other.autoRenew, autoRenew) || other.autoRenew == autoRenew)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._settings, _settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,tier,subscriptionCredits,topUpCredits,lastCreditReset,subscriptionEndDate,autoRenew,createdAt,updatedAt,const DeepCollectionEquality().hash(_settings));

@override
String toString() {
  return 'UserProfile(uid: $uid, email: $email, displayName: $displayName, tier: $tier, subscriptionCredits: $subscriptionCredits, topUpCredits: $topUpCredits, lastCreditReset: $lastCreditReset, subscriptionEndDate: $subscriptionEndDate, autoRenew: $autoRenew, createdAt: $createdAt, updatedAt: $updatedAt, settings: $settings)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email, String? displayName, UserTier tier, int subscriptionCredits, int topUpCredits, DateTime? lastCreditReset, DateTime? subscriptionEndDate, bool autoRenew, DateTime createdAt, DateTime? updatedAt, Map<String, dynamic> settings
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
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? displayName = freezed,Object? tier = null,Object? subscriptionCredits = null,Object? topUpCredits = null,Object? lastCreditReset = freezed,Object? subscriptionEndDate = freezed,Object? autoRenew = null,Object? createdAt = null,Object? updatedAt = freezed,Object? settings = null,}) {
  return _then(_UserProfile(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as UserTier,subscriptionCredits: null == subscriptionCredits ? _self.subscriptionCredits : subscriptionCredits // ignore: cast_nullable_to_non_nullable
as int,topUpCredits: null == topUpCredits ? _self.topUpCredits : topUpCredits // ignore: cast_nullable_to_non_nullable
as int,lastCreditReset: freezed == lastCreditReset ? _self.lastCreditReset : lastCreditReset // ignore: cast_nullable_to_non_nullable
as DateTime?,subscriptionEndDate: freezed == subscriptionEndDate ? _self.subscriptionEndDate : subscriptionEndDate // ignore: cast_nullable_to_non_nullable
as DateTime?,autoRenew: null == autoRenew ? _self.autoRenew : autoRenew // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,settings: null == settings ? _self._settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
