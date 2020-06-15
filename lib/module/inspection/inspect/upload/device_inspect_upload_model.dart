import 'package:flutter/material.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';

// 辅助/监测设备巡检上报类
class DeviceInspectUpload{
  final List<RoutineInspectionUploadList> selectedList = []; // 已选中任务
  bool isNormal = true; // 是否正常
  final TextEditingController remark = TextEditingController(); // 备注
}
