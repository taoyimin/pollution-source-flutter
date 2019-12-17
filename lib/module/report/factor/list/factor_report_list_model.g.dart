// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factor_report_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FactorReport _$FactorReportFromJson(Map<String, dynamic> json) {
  return FactorReport(
      reportId: json['reportId'].toString(),
      enterName: json['enterName'].toString(),
      monitorName: json['monitorName'].toString(),
      alarmTypeStr: json['alarmTypeStr'].toString(),
      districtName: json['districtName'].toString(),
      startTimeStr: json['startTimeStr'].toString(),
      endTimeStr: json['endTimeStr'].toString(),
      reportTimeStr: json['reportTimeStr'].toString(),
      factorCodeStr: json['factorCodeStr'].toString());
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
