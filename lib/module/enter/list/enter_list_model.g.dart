// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enter_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Enter _$EnterFromJson(Map<String, dynamic> json) {
  return Enter(
      enterId: json['enterId'] as String,
      enterName: json['enterName'] as String,
      enterAddress: json['enterAddress'] as String,
      attentionLevel: json['attentionLevel'] as String,
      industryTypeStr: json['industryTypeStr'] as String,
      enterType: json['enterType'] as String);
}

Map<String, dynamic> _$EnterToJson(Enter instance) => <String, dynamic>{
      'enterId': instance.enterId,
      'enterName': instance.enterName,
      'enterAddress': instance.enterAddress,
      'attentionLevel': instance.attentionLevel,
      'industryTypeStr': instance.industryTypeStr,
      'enterType': instance.enterType
    };
