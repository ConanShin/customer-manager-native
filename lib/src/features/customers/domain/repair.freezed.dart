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

 String get id; String get date; String get content; bool get isCompleted; String? get cost;
/// Create a copy of Repair
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RepairCopyWith<Repair> get copyWith => _$RepairCopyWithImpl<Repair>(this as Repair, _$identity);

  /// Serializes this Repair to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Repair&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.content, content) || other.content == content)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.cost, cost) || other.cost == cost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,content,isCompleted,cost);

@override
String toString() {
  return 'Repair(id: $id, date: $date, content: $content, isCompleted: $isCompleted, cost: $cost)';
}


}

/// @nodoc
abstract mixin class $RepairCopyWith<$Res>  {
  factory $RepairCopyWith(Repair value, $Res Function(Repair) _then) = _$RepairCopyWithImpl;
@useResult
$Res call({
 String id, String date, String content, bool isCompleted, String? cost
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? content = null,Object? isCompleted = null,Object? cost = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String date,  String content,  bool isCompleted,  String? cost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Repair() when $default != null:
return $default(_that.id,_that.date,_that.content,_that.isCompleted,_that.cost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String date,  String content,  bool isCompleted,  String? cost)  $default,) {final _that = this;
switch (_that) {
case _Repair():
return $default(_that.id,_that.date,_that.content,_that.isCompleted,_that.cost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String date,  String content,  bool isCompleted,  String? cost)?  $default,) {final _that = this;
switch (_that) {
case _Repair() when $default != null:
return $default(_that.id,_that.date,_that.content,_that.isCompleted,_that.cost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Repair implements Repair {
  const _Repair({required this.id, required this.date, required this.content, this.isCompleted = false, this.cost});
  factory _Repair.fromJson(Map<String, dynamic> json) => _$RepairFromJson(json);

@override final  String id;
@override final  String date;
@override final  String content;
@override@JsonKey() final  bool isCompleted;
@override final  String? cost;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Repair&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.content, content) || other.content == content)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.cost, cost) || other.cost == cost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,content,isCompleted,cost);

@override
String toString() {
  return 'Repair(id: $id, date: $date, content: $content, isCompleted: $isCompleted, cost: $cost)';
}


}

/// @nodoc
abstract mixin class _$RepairCopyWith<$Res> implements $RepairCopyWith<$Res> {
  factory _$RepairCopyWith(_Repair value, $Res Function(_Repair) _then) = __$RepairCopyWithImpl;
@override @useResult
$Res call({
 String id, String date, String content, bool isCompleted, String? cost
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? content = null,Object? isCompleted = null,Object? cost = freezed,}) {
  return _then(_Repair(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
