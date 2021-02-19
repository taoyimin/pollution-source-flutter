// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) {
  return Device(
    deviceId: json['onlineDeviceId'] as int,
    deviceName: json['deviceName'] as String ?? '',
    deviceNo: json['deviceNo'] as String ?? '',
    markerName: json['markerName'] as String ?? '',
    markerHotLine: json['markerHotLine'] as String ?? '',
  );
}

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'onlineDeviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'deviceNo': instance.deviceNo,
      'markerName': instance.markerName,
      'markerHotLine': instance.markerHotLine,
    };
