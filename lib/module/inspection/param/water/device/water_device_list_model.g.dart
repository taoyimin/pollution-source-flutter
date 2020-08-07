// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_device_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterDevice _$WaterDeviceFromJson(Map<String, dynamic> json) {
  return WaterDevice(
    deviceId: json['Device_Id'] as int,
    deviceName: json['deviceName'] as String ?? '',
    deviceNo: json['deviceNo'] as String ?? '',
    deviceType: json['deviceType'] as String ?? '',
    markerName: json['markerName'] as String ?? '',
    measureMethod: json['measure_method'] as String ?? '',
    measurePrinciple: json['measure_principle'] as String ?? '',
    measurePrincipleStr: json['measurePrincipleStr'] as String ?? '',
    analysisMethod: json['analysis_method'] as String ?? '',
    analysisMethodStr: json['analysisMethodStr'] as String ?? '',
  );
}

Map<String, dynamic> _$WaterDeviceToJson(WaterDevice instance) => <String, dynamic>{
      'Device_Id': instance.deviceId,
      'deviceName': instance.deviceName,
      'deviceNo': instance.deviceNo,
      'deviceType': instance.deviceType,
      'markerName': instance.markerName,
      'measure_method': instance.measureMethod,
      'measure_principle': instance.measurePrinciple,
      'measurePrincipleStr': instance.measurePrincipleStr,
      'analysis_method': instance.analysisMethod,
      'analysisMethodStr': instance.analysisMethodStr,
    };
