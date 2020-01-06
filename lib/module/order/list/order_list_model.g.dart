// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
      orderId: json['id'] as int,
      enterName: json['enterpriseName'] as String,
      monitorName: json['disMonitorName'] as String,
      alarmDateStr: json['alarmDate'] as String,
      districtName: json['areaName'] as String,
      orderStateStr: json['orderStateStr'] as String,
      alarmRemark: json['alarmDesc'] as String,
      alarmTypeStr: json['alarmTypeStr'] as String);
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.orderId,
      'enterpriseName': instance.enterName,
      'disMonitorName': instance.monitorName,
      'alarmDate': instance.alarmDateStr,
      'areaName': instance.districtName,
      'orderStateStr': instance.orderStateStr,
      'alarmDesc': instance.alarmRemark,
      'alarmTypeStr': instance.alarmTypeStr
    };
