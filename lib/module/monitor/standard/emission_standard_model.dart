import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'emission_standard_model.g.dart';

/// 排放标准列表
@JsonSerializable()
class EmissionStandard extends Equatable {
  @JsonKey(name: 'Factor_Code', defaultValue: '')
  final String factorCode; //因子代码
  @JsonKey(name: 'Factor_Name', defaultValue: '')
  final String factorName; //因子名称
  @JsonKey(defaultValue: '')
  final String disStandardName; //排放标准
  @JsonKey(name: 'Alarm_Upper')
  final double alarmUpper; //预警上限
  @JsonKey(name: 'Alarm_Lower')
  final double alarmLower; //预警下限
  @JsonKey(name: 'Overproof_Upper')
  final double overproofUpper; //超标上限
  @JsonKey(name: 'Overproof_Lower')
  final double overproofLower; //超标下限
  @JsonKey(name: 'Range_Upper')
  final double rangeUpper; //最大量程
  @JsonKey(name: 'Range_Lower')
  final double rangeLower; //最小量程
  @JsonKey(name: 'measure_Upper')
  final double measureUpper; //测量上限
  @JsonKey(name: 'measure_Lower')
  final double measureLower; //测量下限
  @JsonKey(defaultValue: '')
  final String compareTypeStr; //告警比较值
  @JsonKey(defaultValue: '')
  final String dataTypeStr; //数据类型

  const EmissionStandard({
    this.factorCode,
    this.factorName,
    this.disStandardName,
    this.alarmUpper,
    this.alarmLower,
    this.overproofUpper,
    this.overproofLower,
    this.rangeUpper,
    this.rangeLower,
    this.measureUpper,
    this.measureLower,
    this.compareTypeStr,
    this.dataTypeStr,
  });

  @override
  List<Object> get props => [
        factorCode,
        factorName,
        disStandardName,
        alarmUpper,
        alarmLower,
        overproofUpper,
        overproofLower,
        rangeUpper,
        rangeLower,
        measureUpper,
        measureLower,
        compareTypeStr,
        dataTypeStr,
      ];

  factory EmissionStandard.fromJson(Map<String, dynamic> json) =>
      _$EmissionStandardFromJson(json);

  Map<String, dynamic> toJson() => _$EmissionStandardToJson(this);
}
