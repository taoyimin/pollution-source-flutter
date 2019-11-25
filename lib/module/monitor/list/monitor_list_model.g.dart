// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitor_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Monitor _$MonitorFromJson(Map<String, dynamic> json) {
  return Monitor(
      monitorId: json['monitorId'] as String,
      enterName: json['enterName'] as String,
      monitorName: json['monitorName'] as String,
      monitorAddress: json['monitorAddress'] as String,
      monitorType: json['monitorType'] as String,
      monitorCategoryStr: json['monitorCategoryStr'] as String);
}

Map<String, dynamic> _$MonitorToJson(Monitor instance) => <String, dynamic>{
      'monitorId': instance.monitorId,
      'enterName': instance.enterName,
      'monitorName': instance.monitorName,
      'monitorAddress': instance.monitorAddress,
      'monitorType': instance.monitorType,
      'monitorCategoryStr': instance.monitorCategoryStr
    };
