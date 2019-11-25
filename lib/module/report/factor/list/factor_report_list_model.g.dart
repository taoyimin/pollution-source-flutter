// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factor_report_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FactorReport _$FactorReportFromJson(Map<String, dynamic> json) {
  return FactorReport(
      reportId: json['reportId'] as String,
      enterName: json['enterName'] as String,
      monitorName: json['monitorName'] as String,
      alarmTypeStr: json['alarmTypeStr'] as String,
      districtName: json['districtName'] as String,
      startTimeStr: json['startTimeStr'] as String,
      endTimeStr: json['endTimeStr'] as String,
      reportTimeStr: json['reportTimeStr'] as String,
      factorCodeStr: json['factorCodeStr'] as String);
}

Map<String, dynamic> _$FactorReportToJson(FactorReport instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'enterName': instance.enterName,
      'monitorName': instance.monitorName,
      'alarmTypeStr': instance.alarmTypeStr,
      'districtName': instance.districtName,
      'startTimeStr': instance.startTimeStr,
      'endTimeStr': instance.endTimeStr,
      'reportTimeStr': instance.reportTimeStr,
      'factorCodeStr': instance.factorCodeStr
    };
