// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discharge_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Discharge _$DischargeFromJson(Map<String, dynamic> json) {
  return Discharge(
      dischargeId: json['outId'] as int,
      enterName: json['enterpriseName'] as String,
      dischargeName: json['disOutName'] as String,
      dischargeAddress: json['disOutAddress'] as String,
      dischargeType: json['disOutType'] as String,
      dischargeTypeStr: json['disOutTypeStr'] as String,
      dischargeCategoryStr: json['outletTypeStr'] as String,
      dischargeRuleStr: json['disOutRuleStr'] as String);
}

Map<String, dynamic> _$DischargeToJson(Discharge instance) => <String, dynamic>{
      'outId': instance.dischargeId,
      'enterpriseName': instance.enterName,
      'disOutName': instance.dischargeName,
      'disOutAddress': instance.dischargeAddress,
      'disOutType': instance.dischargeType,
      'disOutTypeStr': instance.dischargeTypeStr,
      'outletTypeStr': instance.dischargeCategoryStr,
      'disOutRuleStr': instance.dischargeRuleStr
    };
