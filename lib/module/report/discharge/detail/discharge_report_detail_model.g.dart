// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discharge_report_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DischargeReportDetail _$DischargeReportDetailFromJson(
    Map<String, dynamic> json) {
  return DischargeReportDetail(
      reportId: json['reportId'] as String,
      enterId: json['enterId'] as String,
      dischargeId: json['dischargeId'] as String,
      monitorId: json['monitorId'] as String,
      enterName: json['enterName'] as String,
      enterAddress: json['enterAddress'] as String,
      dischargeName: json['dischargeName'] as String,
      monitorName: json['monitorName'] as String,
      districtName: json['districtName'] as String,
      reportTimeStr: json['reportTimeStr'] as String,
      startTimeStr: json['startTimeStr'] as String,
      endTimeStr: json['endTimeStr'] as String,
      stopTypeStr: json['stopTypeStr'] as String,
      stopReason: json['stopReason'] as String,
      reviewOpinion: json['reviewOpinion'] as String,
      attachments: (json['attachments'] as List)
          ?.map((e) =>
              e == null ? null : Attachment.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DischargeReportDetailToJson(
        DischargeReportDetail instance) =>
    <String, dynamic>{
      'reportId': instance.reportId,
      'enterId': instance.enterId,
      'dischargeId': instance.dischargeId,
      'monitorId': instance.monitorId,
      'enterName': instance.enterName,
      'enterAddress': instance.enterAddress,
      'dischargeName': instance.dischargeName,
      'monitorName': instance.monitorName,
      'districtName': instance.districtName,
      'reportTimeStr': instance.reportTimeStr,
      'startTimeStr': instance.startTimeStr,
      'endTimeStr': instance.endTimeStr,
      'stopTypeStr': instance.stopTypeStr,
      'stopReason': instance.stopReason,
      'reviewOpinion': instance.reviewOpinion,
      'attachments': instance.attachments
    };
