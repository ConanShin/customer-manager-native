// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HearingAid _$HearingAidFromJson(Map<String, dynamic> json) => _HearingAid(
  side: json['side'] as String,
  model: json['model'] as String,
  date: json['date'] as String,
);

Map<String, dynamic> _$HearingAidToJson(_HearingAid instance) =>
    <String, dynamic>{
      'side': instance.side,
      'model': instance.model,
      'date': instance.date,
    };

_Customer _$CustomerFromJson(Map<String, dynamic> json) => _Customer(
  id: json['id'] as String,
  name: json['name'] as String,
  age: json['age'] as String?,
  birthDate: json['birthDate'] as String?,
  sex: json['sex'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  mobilePhoneNumber: json['mobilePhoneNumber'] as String?,
  address: json['address'] as String?,
  cardAvailability: json['cardAvailability'] as String?,
  registrationDate: json['registrationDate'] as String?,
  batteryOrderDate: json['batteryOrderDate'] as String?,
  hearingAid: (json['hearingAid'] as List<dynamic>?)
      ?.map((e) => HearingAid.fromJson(e as Map<String, dynamic>))
      .toList(),
  note: json['note'] as String?,
);

Map<String, dynamic> _$CustomerToJson(_Customer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'age': instance.age,
  'birthDate': instance.birthDate,
  'sex': instance.sex,
  'phoneNumber': instance.phoneNumber,
  'mobilePhoneNumber': instance.mobilePhoneNumber,
  'address': instance.address,
  'cardAvailability': instance.cardAvailability,
  'registrationDate': instance.registrationDate,
  'batteryOrderDate': instance.batteryOrderDate,
  'hearingAid': instance.hearingAid,
  'note': instance.note,
};
