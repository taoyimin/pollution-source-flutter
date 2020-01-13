import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'routine_inspection_list_model.g.dart';

@JsonSerializable()
class RoutineInspection extends Equatable{
  final int monitorId;
  final String enterName;
  @JsonKey(name: 'outName')
  final String dischargeName;
  final String monitorName;
  @JsonKey(name: 'cnt')
  final int taskCount;
  @JsonKey(name: 'disMonitorType')
  final String monitorType;

  const RoutineInspection({
    this.monitorId,
    this.enterName,
    this.dischargeName,
    this.monitorName,
    this.taskCount,
    this.monitorType,
  });

  @override
  List<Object> get props => [
    monitorId,
    enterName,
    dischargeName,
    monitorName,
    taskCount,
    monitorType,
  ];

  factory RoutineInspection.fromJson(Map<String, dynamic> json) =>
      _$RoutineInspectionFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineInspectionToJson(this);
}