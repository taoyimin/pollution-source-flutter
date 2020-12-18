import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_list_model.dart';

/// 辅助/监测设备巡检上报类
class DeviceInspectUpload {
  /// 位置信息
  BaiduLocation baiduLocation;

  /// 已选中任务
  final List<RoutineInspectionUploadList> selectedList = [];

  /// 是否正常
  bool isNormal = true;

  /// 备注
  final TextEditingController remark = TextEditingController();
}
