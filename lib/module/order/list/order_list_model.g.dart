// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
      orderId: json['orderId'] as String,
      enterName: json['enterName'] as String,
      monitorName: json['monitorName'] as String,
      alarmDateStr: json['alarmDateStr'] as String,
      districtName: json['districtName'] as String,
      orderStateStr: json['orderStateStr'] as String,
      alarmRemark: json['alarmRemark'] as String,
      alarmTypeStr: json['alarmTypeStr'] as String);
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'orderId': instance.orderId,
      'enterName': instance.enterName,
      'monitorName': instance.monitorName,
      'alarmDateStr': instance.alarmDateStr,
      'districtName': instance.districtName,
      'orderStateStr': instance.orderStateStr,
      'alarmRemark': instance.alarmRemark,
      'alarmTypeStr': instance.alarmTypeStr
    };
