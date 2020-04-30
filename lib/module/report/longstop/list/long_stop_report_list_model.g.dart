// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'long_stop_report_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LongStopReport _$LongStopReportFromJson(Map<String, dynamic> json) {
  return LongStopReport(
    reportId: json['id'] as int,
    enterName: json['enterpriseName'] as String,
    cityName: json['cityName'] as String,
    areaName: json['areaName'] as String,
    startTimeStr: json['startTimeStr'] as String,
    endTimeStr: json['endTimeStr'] as String,
    reportTimeStr: json['reportTimeStr'] as String,
  );
}

Map<String, dynamic> _$LongStopReportToJson(LongStopReport instance) =>
    <String, dynamic>{
      'id': instance.reportId,
      'enterpriseName': instance.enterName,
      'cityName': instance.cityName,
      'areaName': instance.areaName,
      'startTimeStr': instance.startTimeStr,
      'endTimeStr': instance.endTimeStr,
      'reportTimeStr': instance.reportTimeStr,
    };
