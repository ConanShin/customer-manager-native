// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repair.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Repair {

// Supabase ID which might be int, converted to String
@JsonKey(fromJson: _toString) String get id; String? get date; String get content;@JsonKey(name: 'is_completed') bool get isCompleted; String? get cost;@JsonKey(name: 'customer_id') String? get customerId;
/// Create a copy of Repair
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RepairCopyWith<Repair> get copyWith => _$RepairCopyWithImpl<Repair>(this as Repair, _$identity);

  /// Serializes this Repair to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Repair&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.content, content) || other.content == content)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.customerId, customerId) || other.customerId == customerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,content,isCompleted,cost,customerId);

@override
String toString() {
  return 'Repair(id: $id, date: $date, content: $content, isCompleted: $isCompleted, cost: $cost, customerId: $customerId)';
}


}

/// @nodoc
abstract mixin class $RepairCopyWith<$Res>  {
  factory $RepairCopyWith(Repair value, $Res Function(Repair) _then) = _$RepairCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _toString) String id, String? date, String content,@JsonKey(name: 'is_completed') bool isCompleted, String? cost,@JsonKey(name: 'customer_id') String? customerId
});




}
/// @nodoc
class _$RepairCopyWithImpl<$Res>
    implements $RepairCopyWith<$Res> {
  _$RepairCopyWithImpl(this._self, this._then);

  final Repair _self;
  final $Res Function(Repair) _then;

/// Create a copy of Repair
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = freezed,Object? content = null,Object? isCompleted = null,Object? cost = freezed,Object? customerId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Repair].
extension RepairPatterns on Repair {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Repair value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Repair() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Repair value)  $default,){
final _that = this;
switch (_that) {
case _Repair():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Repair value)?  $default,){
final _that = this;
switch (_that) {
case _Repair() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _toString)  String id,  String? date,  String content, @JsonKey(name: 'is_completed')  bool isCompleted,  String? cost, @JsonKey(name: 'customer_id')  String? customerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Repair() when $default != null:
return $default(_that.id,_that.date,_that.content,_that.isCompleted,_that.cost,_that.customerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _toString)  String id,  String? date,  String content, @JsonKey(name: 'is_completed')  bool isCompleted,  String? cost, @JsonKey(name: 'customer_id')  String? customerId)  $default,) {final _that = this;
switch (_that) {
case _Repair():
return $default(_that.id,_that.date,_that.content,_that.isCompleted,_that.cost,_that.customerId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _toString)  String id,  String? date,  String content, @JsonKey(name: 'is_completed')  bool isCompleted,  String? cost, @JsonKey(name: 'customer_id')  String? customerId)?  $default,) {final _that = this;
switch (_that) {
case _Repair() when $default != null:
return $default(_that.id,_that.date,_that.content,_that.isCompleted,_that.cost,_that.customerId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Repair implements Repair {
  const _Repair({@JsonKey(fromJson: _toString) required this.id, this.date, required this.content, @JsonKey(name: 'is_completed') this.isCompleted = false, this.cost, @JsonKey(name: 'customer_id') this.customerId});
  factory _Repair.fromJson(Map<String, dynamic> json) => _$RepairFromJson(json);

// Supabase ID which might be int, converted to String
@override@JsonKey(fromJson: _toString) final  String id;
@override final  String? date;
@override final  String content;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;
@override final  String? cost;
@override@JsonKey(name: 'customer_id') final  String? customerId;

/// Create a copy of Repair
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RepairCopyWith<_Repair> get copyWith => __$RepairCopyWithImpl<_Repair>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RepairToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Repair&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.content, content) || other.content == content)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.customerId, customerId) || other.customerId == customerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,content,isCompleted,cost,customerId);

@override
String toString() {
  return 'Repair(id: $id, date: $date, content: $content, isCompleted: $isCompleted, cost: $cost, customerId: $customerId)';
}


}

/// @nodoc
abstract mixin class _$RepairCopyWith<$Res> implements $RepairCopyWith<$Res> {
  factory _$RepairCopyWith(_Repair value, $Res Function(_Repair) _then) = __$RepairCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _toString) String id, String? date, String content,@JsonKey(name: 'is_completed') bool isCompleted, String? cost,@JsonKey(name: 'customer_id') String? customerId
});




}
/// @nodoc
class __$RepairCopyWithImpl<$Res>
    implements _$RepairCopyWith<$Res> {
  __$RepairCopyWithImpl(this._self, this._then);

  final _Repair _self;
  final $Res Function(_Repair) _then;

/// Create a copy of Repair
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = freezed,Object? content = null,Object? isCompleted = null,Object? cost = freezed,Object? customerId = freezed,}) {
  return _then(_Repair(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
