// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enter_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Enter _$EnterFromJson(Map<String, dynamic> json) {
  return Enter(
      enterId: json['enterId'].toString(),
      enterName: json['enterName'].toString(),
      enterAddress: json['enterAddress'].toString(),
      attentionLevel: json['attentionLevel'].toString(),
      industryTypeStr: json['industryTypeStr'].toString(),
      enterType: json['enterType'].toString());
}

Map<String, dynamic> _$EnterToJson(Enter instance) => <String, dynamic>{
      'enterId': instance.enterId,
      'enterName': instance.enterName,
      'enterAddress': instance.enterAddress,
      'attentionLevel': instance.attentionLevel,
      'industryTypeStr': instance.industryTypeStr,
      'enterType': instance.enterType
    };
