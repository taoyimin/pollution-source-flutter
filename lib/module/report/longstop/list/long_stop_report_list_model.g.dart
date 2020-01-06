// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'long_stop_report_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LongStopReport _$LongStopReportFromJson(Map<String, dynamic> json) {
  return LongStopReport(
      reportId: json['reportId'] as String,
      enterName: json['enterName'] as String,
      districtName: json['districtName'] as String,
      startTimeStr: json['startTimeStr'] as String,
      endTimeStr: json['endTimeStr'] as String,
      reportTimeStr: json['reportTimeStr'] as String);
}

Map<String, dynamic> _$LongStopReportToJson(LongStopReport instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'enterName': instance.enterName,
      'districtName': instance.districtName,
      'startTimeStr': instance.startTimeStr,
      'endTimeStr': instance.endTimeStr,
      'reportTimeStr': instance.reportTimeStr
    };
