// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enter_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnterDetail _$EnterDetailFromJson(Map<String, dynamic> json) {
  return EnterDetail(
      enterId: json['enterId'] as String,
      enterName: json['enterName'] as String,
      enterAddress: json['enterAddress'] as String,
      enterTel: json['enterTel'] as String,
      contactPerson: json['contactPerson'] as String,
      contactPersonTel: json['contactPersonTel'] as String,
      legalPerson: json['legalPerson'] as String,
      legalPersonTel: json['legalPersonTel'] as String,
      attentionLevelStr: json['attentionLevelStr'] as String,
      districtName: json['districtName'] as String,
      industryTypeStr: json['industryTypeStr'] as String,
      creditCode: json['creditCode'] as String,
      orderCompleteCount: json['orderCompleteCount'] as String,
      orderTotalCount: json['orderTotalCount'] as String,
      longStopReportTotalCount: json['longStopReportTotalCount'] as String,
      dischargeReportTotalCount: json['dischargeReportTotalCount'] as String,
      factorReportTotalCount: json['factorReportTotalCount'] as String,
      monitorTotalCount: json['monitorTotalCount'] as String,
      monitorOnlineCount: json['monitorOnlineCount'] as String,
      monitorAlarmCount: json['monitorAlarmCount'] as String,
      monitorOverCount: json['monitorOverCount'] as String,
      monitorOfflineCount: json['monitorOfflineCount'] as String,
      monitorStopCount: json['monitorStopCount'] as String,
      licenseNumber: json['licenseNumber'] as String,
      buildProjectCount: json['buildProjectCount'] as String,
      sceneLawCount: json['sceneLawCount'] as String,
      environmentVisitCount: json['environmentVisitCount'] as String);
}

Map<String, dynamic> _$EnterDetailToJson(EnterDetail instance) =>
    <String, dynamic>{
      'enterId': instance.enterId,
      'enterName': instance.enterName,
      'enterAddress': instance.enterAddress,
      'enterTel': instance.enterTel,
      'contactPerson': instance.contactPerson,
      'contactPersonTel': instance.contactPersonTel,
      'legalPerson': instance.legalPerson,
      'legalPersonTel': instance.legalPersonTel,
      'attentionLevelStr': instance.attentionLevelStr,
      'districtName': instance.districtName,
      'industryTypeStr': instance.industryTypeStr,
      'creditCode': instance.creditCode,
      'orderCompleteCount': instance.orderCompleteCount,
      'orderTotalCount': instance.orderTotalCount,
      'longStopReportTotalCount': instance.longStopReportTotalCount,
      'dischargeReportTotalCount': instance.dischargeReportTotalCount,
      'factorReportTotalCount': instance.factorReportTotalCount,
      'monitorTotalCount': instance.monitorTotalCount,
      'monitorOnlineCount': instance.monitorOnlineCount,
      'monitorAlarmCount': instance.monitorAlarmCount,
      'monitorOverCount': instance.monitorOverCount,
      'monitorOfflineCount': instance.monitorOfflineCount,
      'monitorStopCount': instance.monitorStopCount,
      'licenseNumber': instance.licenseNumber,
      'buildProjectCount': instance.buildProjectCount,
      'sceneLawCount': instance.sceneLawCount,
      'environmentVisitCount': instance.environmentVisitCount
    };
