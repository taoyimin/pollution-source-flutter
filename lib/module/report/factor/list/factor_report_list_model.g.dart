// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factor_report_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FactorReport _$FactorReportFromJson(Map<String, dynamic> json) {
  return FactorReport(
      reportId: json['id'] as int,
      enterName: json['enterpriseName'] as String,
      monitorName: json['disMonitorName'] as String,
      alarmTypeStr: json['alarmTypeStr'] as String,
      cityName: json['cityName'] as String,
      areaName: json['areaName'] as String,
      startTimeStr: json['startTime'] as String,
      endTimeStr: json['endTime'] as String,
      reportTimeStr: json['updateTime'] as String,
      factorCodeStr: json['factorCode'] as String);
}

Map<String, dynamic> _$FactorReportToJson(FactorReport instance) =>
    <String, dynamic>{
      'id': instance.reportId,
      'enterpriseName': instance.enterName,
      'disMonitorName': instance.monitorName,
      'alarmTypeStr': instance.alarmTypeStr,
      'cityName': instance.cityName,
      'areaName': instance.areaName,
      'startTime': instance.startTimeStr,
      'endTime': instance.endTimeStr,
      'updateTime': instance.reportTimeStr,
      'factorCode': instance.factorCodeStr
    };
