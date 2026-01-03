// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HearingAid _$HearingAidFromJson(Map<String, dynamic> json) => _HearingAid(
  id: _toString(json['id']),
  side: json['side'] as String,
  model: json['model'] as String,
  date: json['date'] as String?,
  customerId: json['customer_id'] as String?,
);

Map<String, dynamic> _$HearingAidToJson(_HearingAid instance) =>
    <String, dynamic>{
      'id': instance.id,
      'side': instance.side,
      'model': instance.model,
      'date': instance.date,
      'customer_id': instance.customerId,
    };

_Customer _$CustomerFromJson(Map<String, dynamic> json) => _Customer(
  id: json['id'] as String,
  name: json['name'] as String,
  age: json['age'] as String?,
  birthDate: json['birth_date'] as String?,
  sex: json['sex'] as String?,
  phoneNumber: json['phone_number'] as String?,
  mobilePhoneNumber: json['mobile_phone_number'] as String?,
  address: json['address'] as String?,
  cardAvailability: json['card_availability'] as String?,
  registrationDate: json['registration_date'] as String?,
  batteryOrderDate: json['battery_order_date'] as String?,
  cochlearImplant: json['cochlear_implant'] as String?,
  workersComp: json['workers_comp'] as String?,
  hearingAid: (json['hearing_aids'] as List<dynamic>?)
      ?.map((e) => HearingAid.fromJson(e as Map<String, dynamic>))
      .toList(),
  repairs: (json['repairs'] as List<dynamic>?)
      ?.map((e) => Repair.fromJson(e as Map<String, dynamic>))
      .toList(),
  note: json['note'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$CustomerToJson(_Customer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'age': instance.age,
  'birth_date': instance.birthDate,
  'sex': instance.sex,
  'phone_number': instance.phoneNumber,
  'mobile_phone_number': instance.mobilePhoneNumber,
  'address': instance.address,
  'card_availability': instance.cardAvailability,
  'registration_date': instance.registrationDate,
  'battery_order_date': instance.batteryOrderDate,
  'cochlear_implant': instance.cochlearImplant,
  'workers_comp': instance.workersComp,
  'hearing_aids': instance.hearingAid,
  'repairs': instance.repairs,
  'note': instance.note,
  'updated_at': instance.updatedAt,
};
