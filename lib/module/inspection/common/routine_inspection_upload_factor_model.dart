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
  final String measureRange;  // 分析仪量程
  @JsonKey(name: 'measure_Upper')
  final dynamic measureUpper;  // 分析仪量程上限
  @JsonKey(name: 'measure_Lower')
  final dynamic measureLower;  // 分析仪量程下限

  const RoutineInspectionUploadFactor({
    this.factorId,
    this.factorCode,
    this.factorName,
    this.unit,
    this.measureRange,
    this.measureUpper,
    this.measureLower,
  });

  @override
  List<Object> get props => [
    factorId,
    factorCode,
    factorName,
    unit,
    measureRange,
    measureUpper,
    measureLower,
  ];

  factory RoutineInspectionUploadFactor.fromJson(Map<String, dynamic> json) =>
      _$RoutineInspectionUploadFactorFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineInspectionUploadFactorToJson(this);

  RoutineInspectionUploadFactor copyWith({
    unit,
    measureUpper,
    measureLower,
  }) {
    return RoutineInspectionUploadFactor(
      factorId: this.factorId,
      factorCode: this.factorCode,
      factorName: this.factorName,
      unit: unit ?? this.unit,
      measureRange: this.measureRange,
      measureUpper: measureUpper ?? this.measureUpper,
      measureLower: measureLower ?? this.measureLower,
    );
  }
}