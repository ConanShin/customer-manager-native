import 'package:freezed_annotation/freezed_annotation.dart';

part 'repair.freezed.dart';
part 'repair.g.dart';

// Helper for JSON serialization
String _toString(dynamic value) => value.toString();

@freezed
abstract class Repair with _$Repair {
  const factory Repair({
    // Supabase ID which might be int, converted to String
    @JsonKey(fromJson: _toString) required String id,
    required String date,
    required String content,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    String? cost,
    @JsonKey(name: 'customer_id') String? customerId,
  }) = _Repair;

  factory Repair.fromJson(Map<String, dynamic> json) => _$RepairFromJson(json);
}
