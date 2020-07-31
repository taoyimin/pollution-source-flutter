// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) {
  return Device(
    deviceId: json['Device_Id'] as int,
    deviceName: json['deviceName'] as String ?? '',
    deviceNo: json['deviceNo'] as String ?? '',
    deviceType: json['deviceType'] as String ?? '',
    markerName: json['markerName'] as String ?? '',
    measureMethod: json['measure_method'] as String ?? '',
    measurePrincipleStr: json['measurePrincipleStr'] as String ?? '',
    analysisMethodStr: json['analysisMethodStr'] as String ?? '',
  );
}

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'Device_Id': instance.deviceId,
      'deviceName': instance.deviceName,
      'deviceNo': instance.deviceNo,
      'deviceType': instance.deviceType,
      'markerName': instance.markerName,
      'measure_method': instance.measureMethod,
      'measurePrincipleStr': instance.measurePrincipleStr,
      'analysisMethodStr': instance.analysisMethodStr,
    };
