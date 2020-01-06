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
      dischargeShortName: json['disOutShortName'] as String,
      dischargeAddress: json['disOutAddress'] as String,
      dischargeNumber: json['disOutId'] as String,
      dischargeTypeStr: json['disOutTypeStr'] as String,
      dischargeCategoryStr: json['outletTypeStr'] as String,
      dischargeRuleStr: json['disOutRuleStr'] as String,
      outTypeStr: json['outTypeStr'] as String,
      denoterInstallTypeStr: json['denoterInstallTypeStr'] as String,
      longitude: json['disOutLongitude'] as String,
      latitude: json['disOutLatitude'] as String,
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
      'disOutShortName': instance.dischargeShortName,
      'disOutAddress': instance.dischargeAddress,
      'disOutId': instance.dischargeNumber,
      'disOutRuleStr': instance.dischargeRuleStr,
      'denoterInstallTypeStr': instance.denoterInstallTypeStr,
      'disOutTypeStr': instance.dischargeTypeStr,
      'outletTypeStr': instance.dischargeCategoryStr,
      'outTypeStr': instance.outTypeStr,
      'disOutLongitude': instance.longitude,
      'disOutLatitude': instance.latitude,
      'dischargeReportTotalCount': instance.dischargeReportTotalCount,
      'factorReportTotalCount': instance.factorReportTotalCount
    };
