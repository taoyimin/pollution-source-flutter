// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_device_check_upload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterDeviceCheckUpload _$WaterDeviceCheckUploadFromJson(
    Map<String, dynamic> json) {
  return WaterDeviceCheckUpload(
      inspectionTaskId: json['inspectionTaskId'] as String,
      itemType: json['itemType'] as String,
      currentCheckTime: json['currentCheckTime'] == null
          ? null
          : DateTime.parse(json['currentCheckTime'] as String),
      currentCheckResult: json['currentCheckResult'] as String,
      currentCheckIsPass: json['currentCheckIsPass'] as bool,
      currentCorrectTime: json['currentCorrectTime'] == null
          ? null
          : DateTime.parse(json['currentCorrectTime'] as String),
      currentCorrectIsPass: json['currentCorrectIsPass'] as bool);
}

Map<String, dynamic> _$WaterDeviceCheckUploadToJson(
        WaterDeviceCheckUpload instance) =>
    <String, dynamic>{
      'inspectionTaskId': instance.inspectionTaskId,
      'itemType': instance.itemType,
      'currentCheckTime': instance.currentCheckTime?.toIso8601String(),
      'currentCheckResult': instance.currentCheckResult,
      'currentCheckIsPass': instance.currentCheckIsPass,
      'currentCorrectTime': instance.currentCorrectTime?.toIso8601String(),
      'currentCorrectIsPass': instance.currentCorrectIsPass
    };
