// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HearingAid {

 String get side;// "left" or "right"
 String get model; String get date;
/// Create a copy of HearingAid
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HearingAidCopyWith<HearingAid> get copyWith => _$HearingAidCopyWithImpl<HearingAid>(this as HearingAid, _$identity);

  /// Serializes this HearingAid to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HearingAid&&(identical(other.side, side) || other.side == side)&&(identical(other.model, model) || other.model == model)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,side,model,date);

@override
String toString() {
  return 'HearingAid(side: $side, model: $model, date: $date)';
}


}

/// @nodoc
abstract mixin class $HearingAidCopyWith<$Res>  {
  factory $HearingAidCopyWith(HearingAid value, $Res Function(HearingAid) _then) = _$HearingAidCopyWithImpl;
@useResult
$Res call({
 String side, String model, String date
});




}
/// @nodoc
class _$HearingAidCopyWithImpl<$Res>
    implements $HearingAidCopyWith<$Res> {
  _$HearingAidCopyWithImpl(this._self, this._then);

  final HearingAid _self;
  final $Res Function(HearingAid) _then;

/// Create a copy of HearingAid
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? side = null,Object? model = null,Object? date = null,}) {
  return _then(_self.copyWith(
side: null == side ? _self.side : side // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HearingAid].
extension HearingAidPatterns on HearingAid {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HearingAid value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HearingAid() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HearingAid value)  $default,){
final _that = this;
switch (_that) {
case _HearingAid():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HearingAid value)?  $default,){
final _that = this;
switch (_that) {
case _HearingAid() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String side,  String model,  String date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HearingAid() when $default != null:
return $default(_that.side,_that.model,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String side,  String model,  String date)  $default,) {final _that = this;
switch (_that) {
case _HearingAid():
return $default(_that.side,_that.model,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String side,  String model,  String date)?  $default,) {final _that = this;
switch (_that) {
case _HearingAid() when $default != null:
return $default(_that.side,_that.model,_that.date);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HearingAid implements HearingAid {
  const _HearingAid({required this.side, required this.model, required this.date});
  factory _HearingAid.fromJson(Map<String, dynamic> json) => _$HearingAidFromJson(json);

@override final  String side;
// "left" or "right"
@override final  String model;
@override final  String date;

/// Create a copy of HearingAid
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HearingAidCopyWith<_HearingAid> get copyWith => __$HearingAidCopyWithImpl<_HearingAid>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HearingAidToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HearingAid&&(identical(other.side, side) || other.side == side)&&(identical(other.model, model) || other.model == model)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,side,model,date);

@override
String toString() {
  return 'HearingAid(side: $side, model: $model, date: $date)';
}


}

/// @nodoc
abstract mixin class _$HearingAidCopyWith<$Res> implements $HearingAidCopyWith<$Res> {
  factory _$HearingAidCopyWith(_HearingAid value, $Res Function(_HearingAid) _then) = __$HearingAidCopyWithImpl;
@override @useResult
$Res call({
 String side, String model, String date
});




}
/// @nodoc
class __$HearingAidCopyWithImpl<$Res>
    implements _$HearingAidCopyWith<$Res> {
  __$HearingAidCopyWithImpl(this._self, this._then);

  final _HearingAid _self;
  final $Res Function(_HearingAid) _then;

/// Create a copy of HearingAid
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? side = null,Object? model = null,Object? date = null,}) {
  return _then(_HearingAid(
side: null == side ? _self.side : side // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Customer {

 String get id; String get name; String? get age; String? get birthDate; String? get sex;// "Male" or "Female"
 String? get phoneNumber; String? get mobilePhoneNumber; String? get address; String? get cardAvailability;// "Yes" or "No"
 String? get registrationDate;// Format: YYYY-MM-DD
 String? get batteryOrderDate; List<HearingAid>? get hearingAid; String? get note;
/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerCopyWith<Customer> get copyWith => _$CustomerCopyWithImpl<Customer>(this as Customer, _$identity);

  /// Serializes this Customer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Customer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.mobilePhoneNumber, mobilePhoneNumber) || other.mobilePhoneNumber == mobilePhoneNumber)&&(identical(other.address, address) || other.address == address)&&(identical(other.cardAvailability, cardAvailability) || other.cardAvailability == cardAvailability)&&(identical(other.registrationDate, registrationDate) || other.registrationDate == registrationDate)&&(identical(other.batteryOrderDate, batteryOrderDate) || other.batteryOrderDate == batteryOrderDate)&&const DeepCollectionEquality().equals(other.hearingAid, hearingAid)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,age,birthDate,sex,phoneNumber,mobilePhoneNumber,address,cardAvailability,registrationDate,batteryOrderDate,const DeepCollectionEquality().hash(hearingAid),note);

@override
String toString() {
  return 'Customer(id: $id, name: $name, age: $age, birthDate: $birthDate, sex: $sex, phoneNumber: $phoneNumber, mobilePhoneNumber: $mobilePhoneNumber, address: $address, cardAvailability: $cardAvailability, registrationDate: $registrationDate, batteryOrderDate: $batteryOrderDate, hearingAid: $hearingAid, note: $note)';
}


}

/// @nodoc
abstract mixin class $CustomerCopyWith<$Res>  {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) _then) = _$CustomerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? age, String? birthDate, String? sex, String? phoneNumber, String? mobilePhoneNumber, String? address, String? cardAvailability, String? registrationDate, String? batteryOrderDate, List<HearingAid>? hearingAid, String? note
});




}
/// @nodoc
class _$CustomerCopyWithImpl<$Res>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._self, this._then);

  final Customer _self;
  final $Res Function(Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? age = freezed,Object? birthDate = freezed,Object? sex = freezed,Object? phoneNumber = freezed,Object? mobilePhoneNumber = freezed,Object? address = freezed,Object? cardAvailability = freezed,Object? registrationDate = freezed,Object? batteryOrderDate = freezed,Object? hearingAid = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,mobilePhoneNumber: freezed == mobilePhoneNumber ? _self.mobilePhoneNumber : mobilePhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,cardAvailability: freezed == cardAvailability ? _self.cardAvailability : cardAvailability // ignore: cast_nullable_to_non_nullable
as String?,registrationDate: freezed == registrationDate ? _self.registrationDate : registrationDate // ignore: cast_nullable_to_non_nullable
as String?,batteryOrderDate: freezed == batteryOrderDate ? _self.batteryOrderDate : batteryOrderDate // ignore: cast_nullable_to_non_nullable
as String?,hearingAid: freezed == hearingAid ? _self.hearingAid : hearingAid // ignore: cast_nullable_to_non_nullable
as List<HearingAid>?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Customer].
extension CustomerPatterns on Customer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Customer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Customer value)  $default,){
final _that = this;
switch (_that) {
case _Customer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Customer value)?  $default,){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? age,  String? birthDate,  String? sex,  String? phoneNumber,  String? mobilePhoneNumber,  String? address,  String? cardAvailability,  String? registrationDate,  String? batteryOrderDate,  List<HearingAid>? hearingAid,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.name,_that.age,_that.birthDate,_that.sex,_that.phoneNumber,_that.mobilePhoneNumber,_that.address,_that.cardAvailability,_that.registrationDate,_that.batteryOrderDate,_that.hearingAid,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? age,  String? birthDate,  String? sex,  String? phoneNumber,  String? mobilePhoneNumber,  String? address,  String? cardAvailability,  String? registrationDate,  String? batteryOrderDate,  List<HearingAid>? hearingAid,  String? note)  $default,) {final _that = this;
switch (_that) {
case _Customer():
return $default(_that.id,_that.name,_that.age,_that.birthDate,_that.sex,_that.phoneNumber,_that.mobilePhoneNumber,_that.address,_that.cardAvailability,_that.registrationDate,_that.batteryOrderDate,_that.hearingAid,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? age,  String? birthDate,  String? sex,  String? phoneNumber,  String? mobilePhoneNumber,  String? address,  String? cardAvailability,  String? registrationDate,  String? batteryOrderDate,  List<HearingAid>? hearingAid,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.name,_that.age,_that.birthDate,_that.sex,_that.phoneNumber,_that.mobilePhoneNumber,_that.address,_that.cardAvailability,_that.registrationDate,_that.batteryOrderDate,_that.hearingAid,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Customer implements Customer {
  const _Customer({required this.id, required this.name, this.age, this.birthDate, this.sex, this.phoneNumber, this.mobilePhoneNumber, this.address, this.cardAvailability, this.registrationDate, this.batteryOrderDate, final  List<HearingAid>? hearingAid, this.note}): _hearingAid = hearingAid;
  factory _Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? age;
@override final  String? birthDate;
@override final  String? sex;
// "Male" or "Female"
@override final  String? phoneNumber;
@override final  String? mobilePhoneNumber;
@override final  String? address;
@override final  String? cardAvailability;
// "Yes" or "No"
@override final  String? registrationDate;
// Format: YYYY-MM-DD
@override final  String? batteryOrderDate;
 final  List<HearingAid>? _hearingAid;
@override List<HearingAid>? get hearingAid {
  final value = _hearingAid;
  if (value == null) return null;
  if (_hearingAid is EqualUnmodifiableListView) return _hearingAid;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? note;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerCopyWith<_Customer> get copyWith => __$CustomerCopyWithImpl<_Customer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Customer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.mobilePhoneNumber, mobilePhoneNumber) || other.mobilePhoneNumber == mobilePhoneNumber)&&(identical(other.address, address) || other.address == address)&&(identical(other.cardAvailability, cardAvailability) || other.cardAvailability == cardAvailability)&&(identical(other.registrationDate, registrationDate) || other.registrationDate == registrationDate)&&(identical(other.batteryOrderDate, batteryOrderDate) || other.batteryOrderDate == batteryOrderDate)&&const DeepCollectionEquality().equals(other._hearingAid, _hearingAid)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,age,birthDate,sex,phoneNumber,mobilePhoneNumber,address,cardAvailability,registrationDate,batteryOrderDate,const DeepCollectionEquality().hash(_hearingAid),note);

@override
String toString() {
  return 'Customer(id: $id, name: $name, age: $age, birthDate: $birthDate, sex: $sex, phoneNumber: $phoneNumber, mobilePhoneNumber: $mobilePhoneNumber, address: $address, cardAvailability: $cardAvailability, registrationDate: $registrationDate, batteryOrderDate: $batteryOrderDate, hearingAid: $hearingAid, note: $note)';
}


}

/// @nodoc
abstract mixin class _$CustomerCopyWith<$Res> implements $CustomerCopyWith<$Res> {
  factory _$CustomerCopyWith(_Customer value, $Res Function(_Customer) _then) = __$CustomerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? age, String? birthDate, String? sex, String? phoneNumber, String? mobilePhoneNumber, String? address, String? cardAvailability, String? registrationDate, String? batteryOrderDate, List<HearingAid>? hearingAid, String? note
});




}
/// @nodoc
class __$CustomerCopyWithImpl<$Res>
    implements _$CustomerCopyWith<$Res> {
  __$CustomerCopyWithImpl(this._self, this._then);

  final _Customer _self;
  final $Res Function(_Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? age = freezed,Object? birthDate = freezed,Object? sex = freezed,Object? phoneNumber = freezed,Object? mobilePhoneNumber = freezed,Object? address = freezed,Object? cardAvailability = freezed,Object? registrationDate = freezed,Object? batteryOrderDate = freezed,Object? hearingAid = freezed,Object? note = freezed,}) {
  return _then(_Customer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,mobilePhoneNumber: freezed == mobilePhoneNumber ? _self.mobilePhoneNumber : mobilePhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,cardAvailability: freezed == cardAvailability ? _self.cardAvailability : cardAvailability // ignore: cast_nullable_to_non_nullable
as String?,registrationDate: freezed == registrationDate ? _self.registrationDate : registrationDate // ignore: cast_nullable_to_non_nullable
as String?,batteryOrderDate: freezed == batteryOrderDate ? _self.batteryOrderDate : batteryOrderDate // ignore: cast_nullable_to_non_nullable
as String?,hearingAid: freezed == hearingAid ? _self._hearingAid : hearingAid // ignore: cast_nullable_to_non_nullable
as List<HearingAid>?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
