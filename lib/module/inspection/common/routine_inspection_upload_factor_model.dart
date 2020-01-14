import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'routine_inspection_upload_factor_model.g.dart';

@JsonSerializable()
class RoutineInspectionUploadFactor extends Equatable{
  @JsonKey(name: 'Factor_Id')
  final int factorId;
  @JsonKey(name: 'Factor_Code')
  final String factorCode;
  @JsonKey(name: 'Factor_Name')
  final String factorName;
  @JsonKey(name: 'Unit')
  final String unit;

  const RoutineInspectionUploadFactor({
    this.factorId,
    this.factorCode,
    this.factorName,
    this.unit,
  });

  @override
  List<Object> get props => [
    factorId,
    factorCode,
    factorName,
    unit,
  ];

  factory RoutineInspectionUploadFactor.fromJson(Map<String, dynamic> json) =>
      _$RoutineInspectionUploadFactorFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineInspectionUploadFactorToJson(this);
}