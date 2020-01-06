// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factor_report_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FactorReportDetail _$FactorReportDetailFromJson(Map<String, dynamic> json) {
  return FactorReportDetail(
      reportId: json['id'] as int,
      enterId: json['enterId'] as int,
      dischargeId: json['outId'] as int,
      monitorId: json['monitorId'] as int,
      enterName: json['enterpriseName'] as String,
      enterAddress: json['entAddress'] as String,
      dischargeName: json['disOutName'] as String,
      monitorName: json['disMonitorName'] as String,
      cityName: json['cityName'] as String,
      areaName: json['areaName'] as String,
      reportTimeStr: json['updateTime'] as String,
      startTimeStr: json['startTime'] as String,
      endTimeStr: json['endTime'] as String,
      alarmTypeStr: json['alarmTypeStr'] as String,
      exceptionReason: json['exceptionReason'] as String,
      attachments: (json['attachmentList'] as List)
          ?.map((e) =>
              e == null ? null : Attachment.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$FactorReportDetailToJson(FactorReportDetail instance) =>
    <String, dynamic>{
      'id': instance.reportId,
      'enterId': instance.enterId,
      'outId': instance.dischargeId,
      'monitorId': instance.monitorId,
      'enterpriseName': instance.enterName,
      'entAddress': instance.enterAddress,
      'disOutName': instance.dischargeName,
      'disMonitorName': instance.monitorName,
      'cityName': instance.cityName,
      'areaName': instance.areaName,
      'updateTime': instance.reportTimeStr,
      'startTime': instance.startTimeStr,
      'endTime': instance.endTimeStr,
      'alarmTypeStr': instance.alarmTypeStr,
      'exceptionReason': instance.exceptionReason,
      'attachmentList': instance.attachments
    };
