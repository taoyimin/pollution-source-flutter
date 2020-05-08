// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enter_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Enter _$EnterFromJson(Map<String, dynamic> json) {
  return Enter(
    enterId: json['enterId'] as int,
    enterName: json['enterpriseName'] as String ?? '',
    enterAddress: json['entAddress'] as String ?? '',
    attentionLevel: json['attentionLevel'] as String ?? '',
    industryTypeStr: json['industryTypeStr'] as String ?? '',
    enterType: json['enterpriseType'] as String ?? '',
  );
}

Map<String, dynamic> _$EnterToJson(Enter instance) => <String, dynamic>{
      'enterId': instance.enterId,
      'enterpriseName': instance.enterName,
      'entAddress': instance.enterAddress,
      'attentionLevel': instance.attentionLevel,
      'industryTypeStr': instance.industryTypeStr,
      'enterpriseType': instance.enterType,
    };
