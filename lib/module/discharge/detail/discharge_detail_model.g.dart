// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discharge_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DischargeDetail _$DischargeDetailFromJson(Map<String, dynamic> json) {
  return DischargeDetail(
      dischargeId: json['dischargeId'].toString(),
      enterId: json['enterId'].toString(),
      enterName: json['enterName'].toString(),
      enterAddress: json['enterAddress'].toString(),
      dischargeName: json['dischargeName'].toString(),
      dischargeShortName: json['dischargeShortName'].toString(),
      dischargeAddress: json['dischargeAddress'].toString(),
      dischargeNumber: json['dischargeNumber'].toString(),
      dischargeTypeStr: json['dischargeTypeStr'].toString(),
      dischargeCategoryStr: json['dischargeCategoryStr'].toString(),
      dischargeRuleStr: json['dischargeRuleStr'].toString(),
      outTypeStr: json['outTypeStr'].toString(),
      denoterInstallTypeStr: json['denoterInstallTypeStr'].toString(),
      longitude: json['longitude'].toString(),
      latitude: json['latitude'].toString(),
      dischargeReportTotalCount: json['dischargeReportTotalCount'].toString(),
      factorReportTotalCount: json['factorReportTotalCount'].toString());
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
