// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discharge_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Discharge _$DischargeFromJson(Map<String, dynamic> json) {
  return Discharge(
      dischargeId: json['dischargeId'] as String,
      enterName: json['enterName'] as String,
      dischargeName: json['dischargeName'] as String,
      dischargeAddress: json['dischargeAddress'] as String,
      dischargeType: json['dischargeType'] as String,
      dischargeTypeStr: json['dischargeTypeStr'] as String,
      dischargeCategoryStr: json['dischargeCategoryStr'] as String,
      dischargeRuleStr: json['dischargeRuleStr'] as String);
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
