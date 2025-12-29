import 'package:freezed_annotation/freezed_annotation.dart';

part 'repair.freezed.dart';
part 'repair.g.dart';

@freezed
abstract class Repair with _$Repair {
  const factory Repair({
    required String id,
    required String date,
    required String content,
    @Default(false) bool isCompleted,
    String? cost,
  }) = _Repair;

  factory Repair.fromJson(Map<String, dynamic> json) => _$RepairFromJson(json);
}
