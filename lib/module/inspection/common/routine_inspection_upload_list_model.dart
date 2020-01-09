import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'routine_inspection_upload_list_model.g.dart';

// 常规巡检上报列表
@JsonSerializable()
class RoutineInspectionUploadList extends Equatable {
  final String inspectionTaskId;
  final String itemName;
  final String contentName;
  final String inspectionStartTime;
  final String inspectionEndTime;
  final String inspectionRemark;
  final String remark;

  const RoutineInspectionUploadList({
    this.inspectionTaskId,
    this.itemName,
    this.contentName,
    this.inspectionStartTime,
    this.inspectionEndTime,
    this.inspectionRemark,
    this.remark,
  });

  @override
  List<Object> get props => [
        inspectionTaskId,
        itemName,
        contentName,
        inspectionStartTime,
        inspectionEndTime,
        inspectionRemark,
        remark,
      ];

  factory RoutineInspectionUploadList.fromJson(Map<String, dynamic> json) =>
      _$RoutineInspectionUploadListFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineInspectionUploadListToJson(this);
}
