import 'package:freezed_annotation/freezed_annotation.dart';
import 'repair.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
abstract class HearingAid with _$HearingAid {
  const factory HearingAid({
    required String side, // "left" or "right"
    required String model,
    required String date,
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
    String? birthDate, // Format: YYYY-MM-DD
    String? sex, // "Male" or "Female"
    String? phoneNumber,
    String? mobilePhoneNumber,
    String? address,
    String? cardAvailability, // "Yes" or "No"
    String? registrationDate, // Format: YYYY-MM-DD
    String? batteryOrderDate,
    List<HearingAid>? hearingAid,
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
