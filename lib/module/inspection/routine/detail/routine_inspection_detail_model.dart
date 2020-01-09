import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'routine_inspection_detail_model.g.dart';

@JsonSerializable()
class RoutineInspectionDetail extends Equatable{
  final String itemInspectTypeName; //巡检任务名称
  final String itemInspectType; //巡检任务类型
  @JsonKey(name: 'cnt')
  final int taskCount;  //任务个数

  const RoutineInspectionDetail({
    this.itemInspectTypeName,
    this.itemInspectType,
    this.taskCount,
  });

  @override
  List<Object> get props => [
    itemInspectTypeName,
    itemInspectType,
    taskCount,
  ];

  factory RoutineInspectionDetail.fromJson(Map<String, dynamic> json) =>
      _$RoutineInspectionDetailFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineInspectionDetailToJson(this);
}