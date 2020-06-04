// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discharge_report_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DischargeReportDetail _$DischargeReportDetailFromJson(
    Map<String, dynamic> json) {
  return DischargeReportDetail(
    reportId: json['stopApplyId'] as int,
    enterId: json['enterId'] as int,
    dischargeId: json['outId'] as int,
    monitorId: json['monitorId'] as int,
    enterName: json['enterpriseName'] as String ?? '',
    enterAddress: json['entAddress'] as String ?? '',
    dischargeName: json['disOutName'] as String ?? '',
    monitorName: json['disMonitorName'] as String ?? '',
    cityName: json['cityName'] as String ?? '',
    areaName: json['areaName'] as String ?? '',
    reportTimeStr: json['applayTimeStr'] as String ?? '',
    startTimeStr: json['startTimeStr'] as String ?? '',
    endTimeStr: json['endTimeStr'] as String ?? '',
    stopTypeStr: json['stopTypeStr'] as String ?? '',
    isShutdownStr: json['hasShutdown'] as String ?? '',
    stopReason: json['stopReason'] as String ?? '',
    attachments: (json['attachmentList'] as List)
            ?.map((e) => e == null
                ? null
                : Attachment.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$DischargeReportDetailToJson(
        DischargeReportDetail instance) =>
    <String, dynamic>{
      'stopApplyId': instance.reportId,
      'enterId': instance.enterId,
      'outId': instance.dischargeId,
      'monitorId': instance.monitorId,
      'enterpriseName': instance.enterName,
      'entAddress': instance.enterAddress,
      'disOutName': instance.dischargeName,
      'disMonitorName': instance.monitorName,
      'cityName': instance.cityName,
      'areaName': instance.areaName,
      'applayTimeStr': instance.reportTimeStr,
      'startTimeStr': instance.startTimeStr,
      'endTimeStr': instance.endTimeStr,
      'stopTypeStr': instance.stopTypeStr,
      'hasShutdown': instance.isShutdownStr,
      'stopReason': instance.stopReason,
      'attachmentList': instance.attachments,
    };
