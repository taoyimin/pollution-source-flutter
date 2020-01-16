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
  @JsonKey(name: 'Standar_Value')
  final String measureRange;  //分析仪量程

  const RoutineInspectionUploadFactor({
    this.factorId,
    this.factorCode,
    this.factorName,
    this.unit,
    this.measureRange,
  });

  @override
  List<Object> get props => [
    factorId,
    factorCode,
    factorName,
    unit,
    measureRange,
  ];

  factory RoutineInspectionUploadFactor.fromJson(Map<String, dynamic> json) =>
      _$RoutineInspectionUploadFactorFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineInspectionUploadFactorToJson(this);
}