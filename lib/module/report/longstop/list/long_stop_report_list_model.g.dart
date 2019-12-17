// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'long_stop_report_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LongStopReport _$LongStopReportFromJson(Map<String, dynamic> json) {
  return LongStopReport(
      reportId: json['reportId'].toString(),
      enterName: json['enterName'].toString(),
      districtName: json['districtName'].toString(),
      startTimeStr: json['startTimeStr'].toString(),
      endTimeStr: json['endTimeStr'].toString(),
      reportTimeStr: json['reportTimeStr'].toString());
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
