// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_inspection_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutineInspection _$RoutineInspectionFromJson(Map<String, dynamic> json) {
  return RoutineInspection(
    monitorId: json['monitorId'] as int,
    enterName: json['enterName'] as String,
    dischargeName: json['outName'] as String,
    monitorName: json['monitorName'] as String,
    taskCount: json['cnt'] as int,
    monitorType: json['disMonitorType'] as String,
  );
}

Map<String, dynamic> _$RoutineInspectionToJson(RoutineInspection instance) =>
    <String, dynamic>{
      'monitorId': instance.monitorId,
      'enterName': instance.enterName,
      'outName': instance.dischargeName,
      'monitorName': instance.monitorName,
      'cnt': instance.taskCount,
      'disMonitorType': instance.monitorType,
    };
