// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'long_stop_report_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LongStopReportDetail _$LongStopReportDetailFromJson(Map<String, dynamic> json) {
  return LongStopReportDetail(
      reportId: json['reportId'] as String,
      enterId: json['enterId'] as String,
      enterName: json['enterName'] as String,
      enterAddress: json['enterAddress'] as String,
      districtName: json['districtName'] as String,
      reportTimeStr: json['reportTimeStr'] as String,
      startTimeStr: json['startTimeStr'] as String,
      endTimeStr: json['endTimeStr'] as String,
      remark: json['remark'] as String);
}

Map<String, dynamic> _$LongStopReportDetailToJson(
        LongStopReportDetail instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'enterId': instance.enterId,
      'enterName': instance.enterName,
      'enterAddress': instance.enterAddress,
      'districtName': instance.districtName,
      'reportTimeStr': instance.reportTimeStr,
      'startTimeStr': instance.startTimeStr,
      'endTimeStr': instance.endTimeStr,
      'remark': instance.remark
    };
