// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discharge_report_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DischargeReport _$DischargeReportFromJson(Map<String, dynamic> json) {
  return DischargeReport(
      reportId: json['reportId'] as String,
      enterName: json['enterName'] as String,
      monitorName: json['monitorName'] as String,
      stopTypeStr: json['stopTypeStr'] as String,
      districtName: json['districtName'] as String,
      startTimeStr: json['startTimeStr'] as String,
      endTimeStr: json['endTimeStr'] as String,
      reportTimeStr: json['reportTimeStr'] as String);
}

Map<String, dynamic> _$DischargeReportToJson(DischargeReport instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'enterName': instance.enterName,
      'monitorName': instance.monitorName,
      'stopTypeStr': instance.stopTypeStr,
      'districtName': instance.districtName,
      'startTimeStr': instance.startTimeStr,
      'endTimeStr': instance.endTimeStr,
      'reportTimeStr': instance.reportTimeStr
    };
