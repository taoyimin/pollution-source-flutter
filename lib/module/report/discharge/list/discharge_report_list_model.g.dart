// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discharge_report_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DischargeReport _$DischargeReportFromJson(Map<String, dynamic> json) {
  return DischargeReport(
      reportId: json['stopApplyId'] as int,
      enterName: json['enterpriseName'] as String,
      monitorName: json['disMonitorName'] as String,
      stopTypeStr: json['stopTypeStr'] as String,
      cityName: json['cityName'] as String,
      areaName: json['areaName'] as String,
      startTimeStr: json['startTimeStr'] as String,
      endTimeStr: json['endTimeStr'] as String,
      reportTimeStr: json['applayTimeStr'] as String);
}

Map<String, dynamic> _$DischargeReportToJson(DischargeReport instance) =>
    <String, dynamic>{
      'stopApplyId': instance.reportId,
      'enterpriseName': instance.enterName,
      'disMonitorName': instance.monitorName,
      'stopTypeStr': instance.stopTypeStr,
      'cityName': instance.cityName,
      'areaName': instance.areaName,
      'startTimeStr': instance.startTimeStr,
      'endTimeStr': instance.endTimeStr,
      'applayTimeStr': instance.reportTimeStr
    };
