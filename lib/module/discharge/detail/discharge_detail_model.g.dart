// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discharge_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DischargeDetail _$DischargeDetailFromJson(Map<String, dynamic> json) {
  return DischargeDetail(
      dischargeId: json['outId'] as int,
      enterId: json['enterId'] as int,
      enterName: json['enterpriseName'] as String,
      enterAddress: json['entAddress'] as String,
      dischargeName: json['disOutName'] as String,
      dischargeNumber: json['disOutId'] as String,
      dischargeTypeStr: json['disOutTypeStr'] as String,
      dischargeCategoryStr: json['outletTypeStr'] as String,
      dischargeRuleStr: json['disOutRuleStr'] as String,
      outTypeStr: json['outTypeStr'] as String,
      denoterInstallTypeStr: json['denoterInstallTypeStr'] as String,
      dischargeReportTotalCount: json['dischargeReportTotalCount'] as int,
      factorReportTotalCount: json['factorReportTotalCount'] as int);
}

Map<String, dynamic> _$DischargeDetailToJson(DischargeDetail instance) =>
    <String, dynamic>{
      'outId': instance.dischargeId,
      'enterId': instance.enterId,
      'enterpriseName': instance.enterName,
      'entAddress': instance.enterAddress,
      'disOutName': instance.dischargeName,
      'disOutId': instance.dischargeNumber,
      'disOutRuleStr': instance.dischargeRuleStr,
      'denoterInstallTypeStr': instance.denoterInstallTypeStr,
      'disOutTypeStr': instance.dischargeTypeStr,
      'outletTypeStr': instance.dischargeCategoryStr,
      'outTypeStr': instance.outTypeStr,
      'dischargeReportTotalCount': instance.dischargeReportTotalCount,
      'factorReportTotalCount': instance.factorReportTotalCount
    };
