// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_inspection_upload_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutineInspectionUploadList _$RoutineInspectionUploadListFromJson(
    Map<String, dynamic> json) {
  return RoutineInspectionUploadList(
      inspectionTaskId: json['inspectionTaskId'] as String,
      itemName: json['itemName'] as String,
      contentName: json['contentName'] as String,
      inspectionStartTime: json['inspectionStartTime'] as String,
      inspectionEndTime: json['inspectionEndTime'] as String,
      inspectionRemark: json['inspectionRemark'] as String,
      remark: json['remark'] as String);
}

Map<String, dynamic> _$RoutineInspectionUploadListToJson(
        RoutineInspectionUploadList instance) =>
    <String, dynamic>{
      'inspectionTaskId': instance.inspectionTaskId,
      'itemName': instance.itemName,
      'contentName': instance.contentName,
      'inspectionStartTime': instance.inspectionStartTime,
      'inspectionEndTime': instance.inspectionEndTime,
      'inspectionRemark': instance.inspectionRemark,
      'remark': instance.remark
    };
