// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_dict_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataDict _$DataDictFromJson(Map<String, dynamic> json) {
  return DataDict(
      code: json['dicSubCode'] as String, name: json['dicSubName'] as String);
}

Map<String, dynamic> _$DataDictToJson(DataDict instance) =>
    <String, dynamic>{'dicSubCode': instance.code, 'dicSubName': instance.name};
