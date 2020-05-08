// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warn_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Warn _$WarnFromJson(Map<String, dynamic> json) {
  return Warn(
    warnId: json['id'] as int,
    enterName: json['enterName'] as String ?? '',
    monitorName: json['monitorName'] as String ?? '',
    createTimeStr: json['createDate'] as String ?? '',
    title: json['title'] as String ?? '',
    text: json['text'] as String ?? '',
    cityName: json['cityName'] as String ?? '',
    areaName: json['areaName'] as String ?? '',
  );
}

Map<String, dynamic> _$WarnToJson(Warn instance) => <String, dynamic>{
      'id': instance.warnId,
      'enterName': instance.enterName,
      'monitorName': instance.monitorName,
      'createDate': instance.createTimeStr,
      'title': instance.title,
      'text': instance.text,
      'cityName': instance.cityName,
      'areaName': instance.areaName,
    };
