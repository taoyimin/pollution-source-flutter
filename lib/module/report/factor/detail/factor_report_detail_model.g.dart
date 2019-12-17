// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factor_report_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FactorReportDetail _$FactorReportDetailFromJson(Map<String, dynamic> json) {
  return FactorReportDetail(
      reportId: json['reportId'].toString(),
      enterId: json['enterId'].toString(),
      dischargeId: json['dischargeId'].toString(),
      monitorId: json['monitorId'].toString(),
      enterName: json['enterName'].toString(),
      enterAddress: json['enterAddress'].toString(),
      dischargeName: json['dischargeName'].toString(),
      monitorName: json['monitorName'].toString(),
      districtName: json['districtName'].toString(),
      reportTimeStr: json['reportTimeStr'].toString(),
      startTimeStr: json['startTimeStr'].toString(),
      endTimeStr: json['endTimeStr'].toString(),
      alarmTypeStr: json['alarmTypeStr'].toString(),
      exceptionReason: json['exceptionReason'].toString(),
      reviewOpinion: json['reviewOpinion'].toString(),
      attachments: (json['attachments'] as List)
          ?.map((e) =>
              e == null ? null : Attachment.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$FactorReportDetailToJson(FactorReportDetail instance) =>
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
      'alarmTypeStr': instance.alarmTypeStr,
      'exceptionReason': instance.exceptionReason,
      'reviewOpinion': instance.reviewOpinion,
      'attachments': instance.attachments
    };
