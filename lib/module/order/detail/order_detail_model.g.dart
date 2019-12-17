// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) {
  return OrderDetail(
      orderId: json['orderId'].toString(),
      enterId: json['enterId'].toString(),
      monitorId: json['monitorId'].toString(),
      enterName: json['enterName'].toString(),
      enterAddress: json['enterAddress'].toString(),
      districtName: json['districtName'].toString(),
      monitorName: json['monitorName'].toString(),
      alarmDateStr: json['alarmDateStr'].toString(),
      orderStateStr: json['orderStateStr'].toString(),
      alarmTypeStr: json['alarmTypeStr'].toString(),
      alarmRemark: json['alarmRemark'].toString(),
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
      'alarmRemark': instance.alarmRemark,
      'processes': instance.processes
    };
