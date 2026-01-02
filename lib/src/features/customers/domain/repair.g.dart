// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Repair _$RepairFromJson(Map<String, dynamic> json) => _Repair(
  id: _toString(json['id']),
  date: json['date'] as String?,
  content: json['content'] as String,
  isCompleted: json['is_completed'] as bool? ?? false,
  cost: json['cost'] as String?,
  customerId: json['customer_id'] as String?,
);

Map<String, dynamic> _$RepairToJson(_Repair instance) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'content': instance.content,
  'is_completed': instance.isCompleted,
  'cost': instance.cost,
  'customer_id': instance.customerId,
};
