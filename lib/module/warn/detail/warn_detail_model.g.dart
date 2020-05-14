// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warn_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WarnDetail _$WarnDetailFromJson(Map<String, dynamic> json) {
  return WarnDetail(
    enterId: json['enterId'] as int,
    monitorId: json['monitorId'] as int,
    enterName: json['enterName'] as String ?? '',
    monitorName: json['monitorName'] as String ?? '',
    createTimeStr: json['createDate'] as String ?? '',
    startTimeStr: json['startTime'] as String ?? '',
    endTimeStr: json['endTime'] as String ?? '',
    title: json['title'] as String ?? '',
    text: json['text'] as String ?? '',
    cityName: json['cityName'] as String ?? '',
    areaName: json['areaName'] as String ?? '',
    attentionLevelStr: json['attentionLevelStr'] as String ?? '',
    alarmTypeStr: json['alarmTypeName'] as String ?? '',
  );
}

Map<String, dynamic> _$WarnDetailToJson(WarnDetail instance) =>
    <String, dynamic>{
      'enterId': instance.enterId,
      'monitorId': instance.monitorId,
      'enterName': instance.enterName,
      'monitorName': instance.monitorName,
      'createDate': instance.createTimeStr,
      'startTime': instance.startTimeStr,
      'endTime': instance.endTimeStr,
      'title': instance.title,
      'text': instance.text,
      'cityName': instance.cityName,
      'areaName': instance.areaName,
      'attentionLevelStr': instance.attentionLevelStr,
      'alarmTypeName': instance.alarmTypeStr,
    };
