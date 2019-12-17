// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discharge_report_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DischargeReport _$DischargeReportFromJson(Map<String, dynamic> json) {
  return DischargeReport(
      reportId: json['reportId'].toString(),
      enterName: json['enterName'].toString(),
      monitorName: json['monitorName'].toString(),
      stopTypeStr: json['stopTypeStr'].toString(),
      districtName: json['districtName'].toString(),
      startTimeStr: json['startTimeStr'].toString(),
      endTimeStr: json['endTimeStr'].toString(),
      reportTimeStr: json['reportTimeStr'].toString());
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
