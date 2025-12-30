import 'package:freezed_annotation/freezed_annotation.dart';
import 'repair.dart';

// ignore: invalid_annotation_target

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
abstract class HearingAid with _$HearingAid {
  const factory HearingAid({
    required String side, // "left" or "right"
    required String model,
    required String date,
    @JsonKey(name: 'customer_id') String? customerId,
  }) = _HearingAid;

  factory HearingAid.fromJson(Map<String, dynamic> json) =>
      _$HearingAidFromJson(json);
}

@freezed
abstract class Customer with _$Customer {
  const factory Customer({
    required String id,
    required String name,
    String? age,
    @JsonKey(name: 'birth_date') String? birthDate, // Format: YYYY-MM-DD
    String? sex, // "Male" or "Female"
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'mobile_phone_number') String? mobilePhoneNumber,
    String? address,
    @JsonKey(name: 'card_availability')
    String? cardAvailability, // "Yes" or "No"
    @JsonKey(name: 'registration_date')
    String? registrationDate, // Format: YYYY-MM-DD
    @JsonKey(name: 'battery_order_date') String? batteryOrderDate,
    @JsonKey(name: 'hearing_aids') List<HearingAid>? hearingAid,
    List<Repair>? repairs,
    String? note,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  factory Customer.empty() => const Customer(
    id: '',
    name: '',
    age: '',
    sex: 'Male',
    phoneNumber: '',
    mobilePhoneNumber: '',
    address: '',
    cardAvailability: 'No',
    registrationDate: '',
  );
}
