// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
      orderId: json['orderId'].toString(),
      enterName: json['enterName'].toString(),
      monitorName: json['monitorName'].toString(),
      alarmDateStr: json['alarmDateStr'].toString(),
      districtName: json['districtName'].toString(),
      orderStateStr: json['orderStateStr'].toString(),
      alarmRemark: json['alarmRemark'].toString(),
      alarmTypeStr: json['alarmTypeStr'].toString());
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
