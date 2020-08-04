// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_inspection_upload_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutineInspectionUploadList _$RoutineInspectionUploadListFromJson(
    Map<String, dynamic> json) {
  return RoutineInspectionUploadList(
    inspectionTaskId: json['inspectionTaskId'] as String ?? '',
    itemName: json['itemName'] as String ?? '',
    itemType: json['itemType'] as String ?? '',
    contentName: json['contentName'] as String ?? '',
    inspectionStartTime: json['inspectionStartTime'] as String ?? '',
    inspectionEndTime: json['inspectionEndTime'] as String ?? '',
    inspectionRemark: json['inspectionRemark'] as String ?? '',
    remark: json['remark'] as String ?? '',
    deviceName: json['deviceName'] as String ?? '',
    enterName: json['enterpriseName'] as String ?? '',
    dischargeName: json['disOutName'] as String ?? '',
    monitorName: json['disMonitorName'] as String ?? '',
    factorCode: json['factorCode'] as String ?? '',
    monitorId: json['monitorId'] as String ?? '',
    deviceId: json['deviceId'] as String ?? '',
    factorName: json['factorName'] as String ?? '',
    factorUnit: json['factorUnit'] as String ?? '',
    measurePrinciple: json['measurePrinciple'] as String ?? '',
    analysisMethod: json['analysisMethod'] as String ?? '',
    measureUpper: json['measureUpper'] as String ?? '',
    measureLower: json['measureLower'] as String ?? '',
  );
}

Map<String, dynamic> _$RoutineInspectionUploadListToJson(
        RoutineInspectionUploadList instance) =>
    <String, dynamic>{
      'inspectionTaskId': instance.inspectionTaskId,
      'itemName': instance.itemName,
      'itemType': instance.itemType,
      'contentName': instance.contentName,
      'inspectionStartTime': instance.inspectionStartTime,
      'inspectionEndTime': instance.inspectionEndTime,
      'inspectionRemark': instance.inspectionRemark,
      'remark': instance.remark,
      'deviceName': instance.deviceName,
      'enterpriseName': instance.enterName,
      'disOutName': instance.dischargeName,
      'disMonitorName': instance.monitorName,
      'factorCode': instance.factorCode,
      'monitorId': instance.monitorId,
      'deviceId': instance.deviceId,
      'factorName': instance.factorName,
      'factorUnit': instance.factorUnit,
      'measurePrinciple': instance.measurePrinciple,
      'analysisMethod': instance.analysisMethod,
      'measureUpper': instance.measureUpper,
      'measureLower': instance.measureLower,
    };
