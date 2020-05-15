// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'long_stop_report_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LongStopReportDetail _$LongStopReportDetailFromJson(Map<String, dynamic> json) {
  return LongStopReportDetail(
    reportId: json['id'] as int,
    enterId: json['enterId'] as int,
    enterName: json['enterpriseName'] as String,
    enterAddress: json['entAddress'] as String,
    cityName: json['cityName'] as String,
    areaName: json['areaName'] as String,
    reportTimeStr: json['reportTimeStr'] as String,
    startTimeStr: json['startTimeStr'] as String,
    endTimeStr: json['endTimeStr'] as String,
    remark: json['remark'] as String,
    attachments: (json['attachmentList'] as List)
            ?.map((e) => e == null
                ? null
                : Attachment.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$LongStopReportDetailToJson(
        LongStopReportDetail instance) =>
    <String, dynamic>{
      'id': instance.reportId,
      'enterId': instance.enterId,
      'enterpriseName': instance.enterName,
      'entAddress': instance.enterAddress,
      'cityName': instance.cityName,
      'areaName': instance.areaName,
      'reportTimeStr': instance.reportTimeStr,
      'startTimeStr': instance.startTimeStr,
      'endTimeStr': instance.endTimeStr,
      'remark': instance.remark,
      'attachmentList': instance.attachments,
    };
