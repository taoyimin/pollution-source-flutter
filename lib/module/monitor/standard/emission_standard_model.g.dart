// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emission_standard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmissionStandard _$EmissionStandardFromJson(Map<String, dynamic> json) {
  return EmissionStandard(
    factorCode: json['Factor_Code'] as String ?? '',
    factorName: json['Factor_Name'] as String ?? '',
    disStandardName: json['disStandardName'] as String ?? '',
    alarmUpper: (json['Alarm_Upper'] as num)?.toDouble(),
    alarmLower: (json['Alarm_Lower'] as num)?.toDouble(),
    overproofUpper: (json['Overproof_Upper'] as num)?.toDouble(),
    overproofLower: (json['Overproof_Lower'] as num)?.toDouble(),
    rangeUpper: (json['Range_Upper'] as num)?.toDouble(),
    rangeLower: (json['Range_Lower'] as num)?.toDouble(),
    measureUpper: (json['measure_Upper'] as num)?.toDouble(),
    measureLower: (json['measure_Lower'] as num)?.toDouble(),
    compareTypeStr: json['compareTypeStr'] as String ?? '',
    dataTypeStr: json['dataTypeStr'] as String ?? '',
  );
}

Map<String, dynamic> _$EmissionStandardToJson(EmissionStandard instance) =>
    <String, dynamic>{
      'Factor_Code': instance.factorCode,
      'Factor_Name': instance.factorName,
      'disStandardName': instance.disStandardName,
      'Alarm_Upper': instance.alarmUpper,
      'Alarm_Lower': instance.alarmLower,
      'Overproof_Upper': instance.overproofUpper,
      'Overproof_Lower': instance.overproofLower,
      'Range_Upper': instance.rangeUpper,
      'Range_Lower': instance.rangeLower,
      'measure_Upper': instance.measureUpper,
      'measure_Lower': instance.measureLower,
      'compareTypeStr': instance.compareTypeStr,
      'dataTypeStr': instance.dataTypeStr,
    };
