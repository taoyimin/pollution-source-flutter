// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitor_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Monitor _$MonitorFromJson(Map<String, dynamic> json) {
  return Monitor(
      monitorId: json['monitorId'].toString(),
      enterName: json['enterName'].toString(),
      monitorName: json['monitorName'].toString(),
      monitorAddress: json['monitorAddress'].toString(),
      monitorType: json['monitorType'].toString(),
      monitorCategoryStr: json['monitorCategoryStr'].toString());
}

Map<String, dynamic> _$MonitorToJson(Monitor instance) => <String, dynamic>{
      'monitorId': instance.monitorId,
      'enterName': instance.enterName,
      'monitorName': instance.monitorName,
      'monitorAddress': instance.monitorAddress,
      'monitorType': instance.monitorType,
      'monitorCategoryStr': instance.monitorCategoryStr
    };
