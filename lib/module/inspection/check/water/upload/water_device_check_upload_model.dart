import 'package:flutter/material.dart';

/// 废水监测设备校验上报
class WaterDeviceCheckUpload {
  /// 任务id
  String inspectionTaskId;

  /// 任务类型
  String itemType;

  /// 核查时间
  DateTime currentCheckTime;

  /// 标液浓度
  final TextEditingController standardSolution = TextEditingController();

  /// 实测浓度
  final TextEditingController realitySolution = TextEditingController();

  /// 核查结果
  final TextEditingController currentCheckResult = TextEditingController();

  /// 是否合格
  bool currentCheckIsPass = true;

  /// 校准时间
  DateTime currentCorrectTime;

  /// 是否通过
  bool currentCorrectIsPass = true;

  WaterDeviceCheckUpload({this.inspectionTaskId, this.itemType});
}
