import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'routine_inspection_upload_list_model.g.dart';

// 常规巡检上报列表
@JsonSerializable()
class RoutineInspectionUploadList extends Equatable {
  final String inspectionTaskId;
  final String itemName;
  final String itemType;
  final String contentName;
  final String inspectionStartTime;
  final String inspectionEndTime;
  final String inspectionRemark;
  final String remark;
  final String deviceName;
  @JsonKey(name: 'enterpriseName')
  final String enterName;
  @JsonKey(name: 'disOutName')
  final String dischargeName;
  @JsonKey(name: 'disMonitorName')
  final String monitorName;

  const RoutineInspectionUploadList({
    this.inspectionTaskId,
    this.itemName,
    this.itemType,
    this.contentName,
    this.inspectionStartTime,
    this.inspectionEndTime,
    this.inspectionRemark,
    this.remark,
    this.deviceName,
    this.enterName,
    this.dischargeName,
    this.monitorName,
  });

  @override
  List<Object> get props => [
        inspectionTaskId,
        itemName,
        itemType,
        contentName,
        inspectionStartTime,
        inspectionEndTime,
        inspectionRemark,
        remark,
        deviceName,
        enterName,
        dischargeName,
        monitorName,
      ];

  factory RoutineInspectionUploadList.fromJson(Map<String, dynamic> json) =>
      _$RoutineInspectionUploadListFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineInspectionUploadListToJson(this);
}
