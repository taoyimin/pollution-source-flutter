// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) {
  return OrderDetail(
      orderId: json['orderId'] as int,
      enterId: json['enterId'] as int,
      monitorId: json['monitorId'] as int,
      enterName: json['enterName'] as String,
      enterAddress: json['enterAddress'] as String,
      districtName: json['districtName'] as String,
      monitorName: json['monitorName'] as String,
      alarmDateStr: json['alarmDateStr'] as String,
      orderStateStr: json['orderStateStr'] as String,
      alarmTypeStr: json['alarmTypeStr'] as String,
      alarmRemark: json['alarmDesc'] as String,
      processes: (json['processes'] as List)
          ?.map((e) =>
              e == null ? null : Process.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$OrderDetailToJson(OrderDetail instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'enterId': instance.enterId,
      'monitorId': instance.monitorId,
      'enterName': instance.enterName,
      'enterAddress': instance.enterAddress,
      'districtName': instance.districtName,
      'monitorName': instance.monitorName,
      'alarmDateStr': instance.alarmDateStr,
      'orderStateStr': instance.orderStateStr,
      'alarmTypeStr': instance.alarmTypeStr,
      'alarmDesc': instance.alarmRemark,
      'processes': instance.processes
    };
