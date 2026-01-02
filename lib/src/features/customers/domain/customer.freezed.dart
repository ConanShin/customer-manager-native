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

@JsonKey(fromJson: _toString) String get id; String get side;// "left" or "right"
 String get model; String? get date;@JsonKey(name: 'customer_id') String? get customerId;
/// Create a copy of HearingAid
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HearingAidCopyWith<HearingAid> get copyWith => _$HearingAidCopyWithImpl<HearingAid>(this as HearingAid, _$identity);

  /// Serializes this HearingAid to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HearingAid&&(identical(other.id, id) || other.id == id)&&(identical(other.side, side) || other.side == side)&&(identical(other.model, model) || other.model == model)&&(identical(other.date, date) || other.date == date)&&(identical(other.customerId, customerId) || other.customerId == customerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,side,model,date,customerId);

@override
String toString() {
  return 'HearingAid(id: $id, side: $side, model: $model, date: $date, customerId: $customerId)';
}


}

/// @nodoc
abstract mixin class $HearingAidCopyWith<$Res>  {
  factory $HearingAidCopyWith(HearingAid value, $Res Function(HearingAid) _then) = _$HearingAidCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String id, String side, String model, String? date,@JsonKey(name: 'customer_id') String? customerId
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? side = null,Object? model = null,Object? date = freezed,Object? customerId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,side: null == side ? _self.side : side // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _toString)  String id,  String side,  String model,  String? date, @JsonKey(name: 'customer_id')  String? customerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HearingAid() when $default != null:
return $default(_that.id,_that.side,_that.model,_that.date,_that.customerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _toString)  String id,  String side,  String model,  String? date, @JsonKey(name: 'customer_id')  String? customerId)  $default,) {final _that = this;
switch (_that) {
case _HearingAid():
return $default(_that.id,_that.side,_that.model,_that.date,_that.customerId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _toString)  String id,  String side,  String model,  String? date, @JsonKey(name: 'customer_id')  String? customerId)?  $default,) {final _that = this;
switch (_that) {
case _HearingAid() when $default != null:
return $default(_that.id,_that.side,_that.model,_that.date,_that.customerId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HearingAid implements HearingAid {
  const _HearingAid({@JsonKey(fromJson: _toString) required this.id, required this.side, required this.model, this.date, @JsonKey(name: 'customer_id') this.customerId});
  factory _HearingAid.fromJson(Map<String, dynamic> json) => _$HearingAidFromJson(json);

@override@JsonKey(fromJson: _toString) final  String id;
@override final  String side;
// "left" or "right"
@override final  String model;
@override final  String? date;
@override@JsonKey(name: 'customer_id') final  String? customerId;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HearingAid&&(identical(other.id, id) || other.id == id)&&(identical(other.side, side) || other.side == side)&&(identical(other.model, model) || other.model == model)&&(identical(other.date, date) || other.date == date)&&(identical(other.customerId, customerId) || other.customerId == customerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,side,model,date,customerId);

@override
String toString() {
  return 'HearingAid(id: $id, side: $side, model: $model, date: $date, customerId: $customerId)';
}


}

/// @nodoc
abstract mixin class _$HearingAidCopyWith<$Res> implements $HearingAidCopyWith<$Res> {
  factory _$HearingAidCopyWith(_HearingAid value, $Res Function(_HearingAid) _then) = __$HearingAidCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String id, String side, String model, String? date,@JsonKey(name: 'customer_id') String? customerId
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? side = null,Object? model = null,Object? date = freezed,Object? customerId = freezed,}) {
  return _then(_HearingAid(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,side: null == side ? _self.side : side // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Customer {

 String get id; String get name; String? get age;@JsonKey(name: 'birth_date') String? get birthDate;// Format: YYYY-MM-DD
 String? get sex;// "Male" or "Female"
@JsonKey(name: 'phone_number') String? get phoneNumber;@JsonKey(name: 'mobile_phone_number') String? get mobilePhoneNumber; String? get address;@JsonKey(name: 'card_availability') String? get cardAvailability;// "Yes" or "No"
@JsonKey(name: 'registration_date') String? get registrationDate;// Format: YYYY-MM-DD
@JsonKey(name: 'battery_order_date') String? get batteryOrderDate;@JsonKey(name: 'hearing_aids') List<HearingAid>? get hearingAid; List<Repair>? get repairs; String? get note;@JsonKey(name: 'updated_at') String? get updatedAt;
/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerCopyWith<Customer> get copyWith => _$CustomerCopyWithImpl<Customer>(this as Customer, _$identity);

  /// Serializes this Customer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Customer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.mobilePhoneNumber, mobilePhoneNumber) || other.mobilePhoneNumber == mobilePhoneNumber)&&(identical(other.address, address) || other.address == address)&&(identical(other.cardAvailability, cardAvailability) || other.cardAvailability == cardAvailability)&&(identical(other.registrationDate, registrationDate) || other.registrationDate == registrationDate)&&(identical(other.batteryOrderDate, batteryOrderDate) || other.batteryOrderDate == batteryOrderDate)&&const DeepCollectionEquality().equals(other.hearingAid, hearingAid)&&const DeepCollectionEquality().equals(other.repairs, repairs)&&(identical(other.note, note) || other.note == note)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,age,birthDate,sex,phoneNumber,mobilePhoneNumber,address,cardAvailability,registrationDate,batteryOrderDate,const DeepCollectionEquality().hash(hearingAid),const DeepCollectionEquality().hash(repairs),note,updatedAt);

@override
String toString() {
  return 'Customer(id: $id, name: $name, age: $age, birthDate: $birthDate, sex: $sex, phoneNumber: $phoneNumber, mobilePhoneNumber: $mobilePhoneNumber, address: $address, cardAvailability: $cardAvailability, registrationDate: $registrationDate, batteryOrderDate: $batteryOrderDate, hearingAid: $hearingAid, repairs: $repairs, note: $note, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CustomerCopyWith<$Res>  {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) _then) = _$CustomerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? age,@JsonKey(name: 'birth_date') String? birthDate, String? sex,@JsonKey(name: 'phone_number') String? phoneNumber,@JsonKey(name: 'mobile_phone_number') String? mobilePhoneNumber, String? address,@JsonKey(name: 'card_availability') String? cardAvailability,@JsonKey(name: 'registration_date') String? registrationDate,@JsonKey(name: 'battery_order_date') String? batteryOrderDate,@JsonKey(name: 'hearing_aids') List<HearingAid>? hearingAid, List<Repair>? repairs, String? note,@JsonKey(name: 'updated_at') String? updatedAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? age = freezed,Object? birthDate = freezed,Object? sex = freezed,Object? phoneNumber = freezed,Object? mobilePhoneNumber = freezed,Object? address = freezed,Object? cardAvailability = freezed,Object? registrationDate = freezed,Object? batteryOrderDate = freezed,Object? hearingAid = freezed,Object? repairs = freezed,Object? note = freezed,Object? updatedAt = freezed,}) {
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
as List<HearingAid>?,repairs: freezed == repairs ? _self.repairs : repairs // ignore: cast_nullable_to_non_nullable
as List<Repair>?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? age, @JsonKey(name: 'birth_date')  String? birthDate,  String? sex, @JsonKey(name: 'phone_number')  String? phoneNumber, @JsonKey(name: 'mobile_phone_number')  String? mobilePhoneNumber,  String? address, @JsonKey(name: 'card_availability')  String? cardAvailability, @JsonKey(name: 'registration_date')  String? registrationDate, @JsonKey(name: 'battery_order_date')  String? batteryOrderDate, @JsonKey(name: 'hearing_aids')  List<HearingAid>? hearingAid,  List<Repair>? repairs,  String? note, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.name,_that.age,_that.birthDate,_that.sex,_that.phoneNumber,_that.mobilePhoneNumber,_that.address,_that.cardAvailability,_that.registrationDate,_that.batteryOrderDate,_that.hearingAid,_that.repairs,_that.note,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? age, @JsonKey(name: 'birth_date')  String? birthDate,  String? sex, @JsonKey(name: 'phone_number')  String? phoneNumber, @JsonKey(name: 'mobile_phone_number')  String? mobilePhoneNumber,  String? address, @JsonKey(name: 'card_availability')  String? cardAvailability, @JsonKey(name: 'registration_date')  String? registrationDate, @JsonKey(name: 'battery_order_date')  String? batteryOrderDate, @JsonKey(name: 'hearing_aids')  List<HearingAid>? hearingAid,  List<Repair>? repairs,  String? note, @JsonKey(name: 'updated_at')  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Customer():
return $default(_that.id,_that.name,_that.age,_that.birthDate,_that.sex,_that.phoneNumber,_that.mobilePhoneNumber,_that.address,_that.cardAvailability,_that.registrationDate,_that.batteryOrderDate,_that.hearingAid,_that.repairs,_that.note,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? age, @JsonKey(name: 'birth_date')  String? birthDate,  String? sex, @JsonKey(name: 'phone_number')  String? phoneNumber, @JsonKey(name: 'mobile_phone_number')  String? mobilePhoneNumber,  String? address, @JsonKey(name: 'card_availability')  String? cardAvailability, @JsonKey(name: 'registration_date')  String? registrationDate, @JsonKey(name: 'battery_order_date')  String? batteryOrderDate, @JsonKey(name: 'hearing_aids')  List<HearingAid>? hearingAid,  List<Repair>? repairs,  String? note, @JsonKey(name: 'updated_at')  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.name,_that.age,_that.birthDate,_that.sex,_that.phoneNumber,_that.mobilePhoneNumber,_that.address,_that.cardAvailability,_that.registrationDate,_that.batteryOrderDate,_that.hearingAid,_that.repairs,_that.note,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Customer implements Customer {
  const _Customer({required this.id, required this.name, this.age, @JsonKey(name: 'birth_date') this.birthDate, this.sex, @JsonKey(name: 'phone_number') this.phoneNumber, @JsonKey(name: 'mobile_phone_number') this.mobilePhoneNumber, this.address, @JsonKey(name: 'card_availability') this.cardAvailability, @JsonKey(name: 'registration_date') this.registrationDate, @JsonKey(name: 'battery_order_date') this.batteryOrderDate, @JsonKey(name: 'hearing_aids') final  List<HearingAid>? hearingAid, final  List<Repair>? repairs, this.note, @JsonKey(name: 'updated_at') this.updatedAt}): _hearingAid = hearingAid,_repairs = repairs;
  factory _Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? age;
@override@JsonKey(name: 'birth_date') final  String? birthDate;
// Format: YYYY-MM-DD
@override final  String? sex;
// "Male" or "Female"
@override@JsonKey(name: 'phone_number') final  String? phoneNumber;
@override@JsonKey(name: 'mobile_phone_number') final  String? mobilePhoneNumber;
@override final  String? address;
@override@JsonKey(name: 'card_availability') final  String? cardAvailability;
// "Yes" or "No"
@override@JsonKey(name: 'registration_date') final  String? registrationDate;
// Format: YYYY-MM-DD
@override@JsonKey(name: 'battery_order_date') final  String? batteryOrderDate;
 final  List<HearingAid>? _hearingAid;
@override@JsonKey(name: 'hearing_aids') List<HearingAid>? get hearingAid {
  final value = _hearingAid;
  if (value == null) return null;
  if (_hearingAid is EqualUnmodifiableListView) return _hearingAid;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Repair>? _repairs;
@override List<Repair>? get repairs {
  final value = _repairs;
  if (value == null) return null;
  if (_repairs is EqualUnmodifiableListView) return _repairs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? note;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Customer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.mobilePhoneNumber, mobilePhoneNumber) || other.mobilePhoneNumber == mobilePhoneNumber)&&(identical(other.address, address) || other.address == address)&&(identical(other.cardAvailability, cardAvailability) || other.cardAvailability == cardAvailability)&&(identical(other.registrationDate, registrationDate) || other.registrationDate == registrationDate)&&(identical(other.batteryOrderDate, batteryOrderDate) || other.batteryOrderDate == batteryOrderDate)&&const DeepCollectionEquality().equals(other._hearingAid, _hearingAid)&&const DeepCollectionEquality().equals(other._repairs, _repairs)&&(identical(other.note, note) || other.note == note)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,age,birthDate,sex,phoneNumber,mobilePhoneNumber,address,cardAvailability,registrationDate,batteryOrderDate,const DeepCollectionEquality().hash(_hearingAid),const DeepCollectionEquality().hash(_repairs),note,updatedAt);

@override
String toString() {
  return 'Customer(id: $id, name: $name, age: $age, birthDate: $birthDate, sex: $sex, phoneNumber: $phoneNumber, mobilePhoneNumber: $mobilePhoneNumber, address: $address, cardAvailability: $cardAvailability, registrationDate: $registrationDate, batteryOrderDate: $batteryOrderDate, hearingAid: $hearingAid, repairs: $repairs, note: $note, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CustomerCopyWith<$Res> implements $CustomerCopyWith<$Res> {
  factory _$CustomerCopyWith(_Customer value, $Res Function(_Customer) _then) = __$CustomerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? age,@JsonKey(name: 'birth_date') String? birthDate, String? sex,@JsonKey(name: 'phone_number') String? phoneNumber,@JsonKey(name: 'mobile_phone_number') String? mobilePhoneNumber, String? address,@JsonKey(name: 'card_availability') String? cardAvailability,@JsonKey(name: 'registration_date') String? registrationDate,@JsonKey(name: 'battery_order_date') String? batteryOrderDate,@JsonKey(name: 'hearing_aids') List<HearingAid>? hearingAid, List<Repair>? repairs, String? note,@JsonKey(name: 'updated_at') String? updatedAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? age = freezed,Object? birthDate = freezed,Object? sex = freezed,Object? phoneNumber = freezed,Object? mobilePhoneNumber = freezed,Object? address = freezed,Object? cardAvailability = freezed,Object? registrationDate = freezed,Object? batteryOrderDate = freezed,Object? hearingAid = freezed,Object? repairs = freezed,Object? note = freezed,Object? updatedAt = freezed,}) {
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
as List<HearingAid>?,repairs: freezed == repairs ? _self._repairs : repairs // ignore: cast_nullable_to_non_nullable
as List<Repair>?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
