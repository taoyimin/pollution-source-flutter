// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discharge_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Discharge _$DischargeFromJson(Map<String, dynamic> json) {
  return Discharge(
      dischargeId: json['dischargeId'].toString(),
      enterName: json['enterName'].toString(),
      dischargeName: json['dischargeName'].toString(),
      dischargeAddress: json['dischargeAddress'].toString(),
      dischargeType: json['dischargeType'].toString(),
      dischargeTypeStr: json['dischargeTypeStr'].toString(),
      dischargeCategoryStr: json['dischargeCategoryStr'].toString(),
      dischargeRuleStr: json['dischargeRuleStr'].toString());
}

Map<String, dynamic> _$DischargeToJson(Discharge instance) => <String, dynamic>{
      'dischargeId': instance.dischargeId,
      'enterName': instance.enterName,
      'dischargeName': instance.dischargeName,
      'dischargeAddress': instance.dischargeAddress,
      'dischargeType': instance.dischargeType,
      'dischargeTypeStr': instance.dischargeTypeStr,
      'dischargeCategoryStr': instance.dischargeCategoryStr,
      'dischargeRuleStr': instance.dischargeRuleStr
    };
