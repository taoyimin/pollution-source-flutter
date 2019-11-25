// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discharge_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DischargeDetail _$DischargeDetailFromJson(Map<String, dynamic> json) {
  return DischargeDetail(
      dischargeId: json['dischargeId'] as String,
      enterId: json['enterId'] as String,
      enterName: json['enterName'] as String,
      enterAddress: json['enterAddress'] as String,
      dischargeName: json['dischargeName'] as String,
      dischargeShortName: json['dischargeShortName'] as String,
      dischargeAddress: json['dischargeAddress'] as String,
      dischargeNumber: json['dischargeNumber'] as String,
      dischargeTypeStr: json['dischargeTypeStr'] as String,
      dischargeCategoryStr: json['dischargeCategoryStr'] as String,
      dischargeRuleStr: json['dischargeRuleStr'] as String,
      outTypeStr: json['outTypeStr'] as String,
      denoterInstallTypeStr: json['denoterInstallTypeStr'] as String,
      longitude: json['longitude'] as String,
      latitude: json['latitude'] as String,
      dischargeReportTotalCount: json['dischargeReportTotalCount'] as String,
      factorReportTotalCount: json['factorReportTotalCount'] as String);
}

Map<String, dynamic> _$DischargeDetailToJson(DischargeDetail instance) =>
    <String, dynamic>{
      'dischargeId': instance.dischargeId,
      'enterId': instance.enterId,
      'enterName': instance.enterName,
      'enterAddress': instance.enterAddress,
      'dischargeName': instance.dischargeName,
      'dischargeShortName': instance.dischargeShortName,
      'dischargeAddress': instance.dischargeAddress,
      'dischargeNumber': instance.dischargeNumber,
      'dischargeRuleStr': instance.dischargeRuleStr,
      'denoterInstallTypeStr': instance.denoterInstallTypeStr,
      'dischargeTypeStr': instance.dischargeTypeStr,
      'dischargeCategoryStr': instance.dischargeCategoryStr,
      'outTypeStr': instance.outTypeStr,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'dischargeReportTotalCount': instance.dischargeReportTotalCount,
      'factorReportTotalCount': instance.factorReportTotalCount
    };
