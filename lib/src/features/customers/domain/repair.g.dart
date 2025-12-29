// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Repair _$RepairFromJson(Map<String, dynamic> json) => _Repair(
  id: json['id'] as String,
  date: json['date'] as String,
  content: json['content'] as String,
  isCompleted: json['isCompleted'] as bool? ?? false,
  cost: json['cost'] as String?,
);

Map<String, dynamic> _$RepairToJson(_Repair instance) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'content': instance.content,
  'isCompleted': instance.isCompleted,
  'cost': instance.cost,
};
