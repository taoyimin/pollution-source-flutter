// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factor_data_dict_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FactorDataDict _$FactorDataDictFromJson(Map<String, dynamic> json) {
  return FactorDataDict(
      code: json['Factor_Code'] as String, name: json['Factor_Name'] as String);
}

Map<String, dynamic> _$FactorDataDictToJson(FactorDataDict instance) =>
    <String, dynamic>{
      'Factor_Code': instance.code,
      'Factor_Name': instance.name
    };
