import 'package:freezed_annotation/freezed_annotation.dart';
import 'repair.dart';

// ignore: invalid_annotation_target

part 'customer.freezed.dart';
part 'customer.g.dart';

// Helper for JSON serialization
String _toString(dynamic value) => value.toString();

@freezed
abstract class HearingAid with _$HearingAid {
  const factory HearingAid({
    @JsonKey(fromJson: _toString) required String id,
    required String side, // "left" or "right"
    required String model,
    String? date,
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
    @JsonKey(name: 'cochlear_implant') String? cochlearImplant, // "Yes" or "No"
    @JsonKey(name: 'workers_comp') String? workersComp, // "Yes" or "No"
    @JsonKey(name: 'fitting_test_1') String? fittingTest1,
    @JsonKey(name: 'fitting_test_2') String? fittingTest2,
    @JsonKey(name: 'fitting_test_3') String? fittingTest3,
    @JsonKey(name: 'fitting_test_4') String? fittingTest4,
    @JsonKey(name: 'fitting_test_5') String? fittingTest5,
    @JsonKey(name: 'hearing_aids') List<HearingAid>? hearingAid,
    List<Repair>? repairs,
    String? note,
    @JsonKey(name: 'updated_at') String? updatedAt,
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
    cochlearImplant: 'No',
    workersComp: 'No',
    registrationDate: '',
    fittingTest1: '',
    fittingTest2: '',
    fittingTest3: '',
    fittingTest4: '',
    fittingTest5: '',
  );
}
