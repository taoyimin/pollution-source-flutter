// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_inspection_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutineInspectionDetail _$RoutineInspectionDetailFromJson(
    Map<String, dynamic> json) {
  return RoutineInspectionDetail(
      itemInspectTypeName: json['itemInspectTypeName'] as String,
      itemInspectType: json['itemInspectType'] as String,
      taskCount: json['cnt'] as int);
}

Map<String, dynamic> _$RoutineInspectionDetailToJson(
        RoutineInspectionDetail instance) =>
    <String, dynamic>{
      'itemInspectTypeName': instance.itemInspectTypeName,
      'itemInspectType': instance.itemInspectType,
      'cnt': instance.taskCount
    };
