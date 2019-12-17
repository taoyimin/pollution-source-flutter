// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enter_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnterDetail _$EnterDetailFromJson(Map<String, dynamic> json) {
  return EnterDetail(
      enterId: json['enterId'].toString(),
      enterName: json['enterName'].toString(),
      enterAddress: json['enterAddress'].toString(),
      enterTel: json['enterTel'].toString(),
      contactPerson: json['contactPerson'].toString(),
      contactPersonTel: json['contactPersonTel'].toString(),
      legalPerson: json['legalPerson'].toString(),
      legalPersonTel: json['legalPersonTel'].toString(),
      attentionLevelStr: json['attentionLevelStr'].toString(),
      districtName: json['districtName'].toString(),
      industryTypeStr: json['industryTypeStr'].toString(),
      creditCode: json['creditCode'].toString(),
      orderCompleteCount: json['orderCompleteCount'].toString(),
      orderTotalCount: json['orderTotalCount'].toString(),
      longStopReportTotalCount: json['longStopReportTotalCount'].toString(),
      dischargeReportTotalCount: json['dischargeReportTotalCount'].toString(),
      factorReportTotalCount: json['factorReportTotalCount'].toString(),
      monitorTotalCount: json['monitorTotalCount'].toString(),
      monitorOnlineCount: json['monitorOnlineCount'].toString(),
      monitorAlarmCount: json['monitorAlarmCount'].toString(),
      monitorOverCount: json['monitorOverCount'].toString(),
      monitorOfflineCount: json['monitorOfflineCount'].toString(),
      monitorStopCount: json['monitorStopCount'].toString(),
      licenseNumber: json['licenseNumber'].toString(),
      buildProjectCount: json['buildProjectCount'].toString(),
      sceneLawCount: json['sceneLawCount'].toString(),
      environmentVisitCount: json['environmentVisitCount'].toString());
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
