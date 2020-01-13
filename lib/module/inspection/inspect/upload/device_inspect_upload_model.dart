import 'package:equatable/equatable.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';

// 辅助/监测设备巡检上报类
class DeviceInspectUpload extends Equatable {
  final List<RoutineInspectionUploadList> selectedList; // 已选中任务
  final bool isNormal; // 是否正常
  final String remark; // 备注

  const DeviceInspectUpload({
    this.selectedList,
    this.isNormal = true,
    this.remark,
  });

  @override
  List<Object> get props => [
        selectedList,
        isNormal,
        remark,
      ];

  DeviceInspectUpload copyWith({
    List<RoutineInspectionUploadList> selectedList,
    bool isNormal,
    String remark,
  }) {
    return DeviceInspectUpload(
      selectedList: selectedList ?? this.selectedList,
      isNormal: isNormal ?? this.isNormal,
      remark: remark ?? this.remark,
    );
  }
}
