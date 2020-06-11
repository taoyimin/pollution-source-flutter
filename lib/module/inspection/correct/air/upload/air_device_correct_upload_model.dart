import 'package:flutter/material.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_factor_model.dart';

/// 废气监测设备校准上报
class AirDeviceCorrectUpload {
  /// 任务id
  String inspectionTaskId;

  /// 校准因子
  RoutineInspectionUploadFactor factor;

  /// 校准开始时间
  DateTime correctStartTime;

  /// 校准结束时间
  DateTime correctEndTime;

  /// 零气浓度值
  final TextEditingController zeroVal = TextEditingController();

  /// 上次校准后测试值
  final TextEditingController beforeZeroVal = TextEditingController();

  /// 校前测试值
  final TextEditingController correctZeroVal = TextEditingController();

  /// 零点漂移 %F.S.
  final TextEditingController zeroPercent = TextEditingController();

  /// 仪器校准是否正常
  bool zeroIsNormal = true;

  /// 校准后测试值
  final TextEditingController zeroCorrectVal = TextEditingController();

  /// 标气浓度值
  final TextEditingController rangeVal = TextEditingController();

  /// 上次校准后测试值
  final TextEditingController beforeRangeVal = TextEditingController();

  /// 校前测试值
  final TextEditingController correctRangeVal = TextEditingController();

  /// 量程漂移 %F.S.
  final TextEditingController rangePercent = TextEditingController();

  /// 仪器校准是否正常
  bool rangeIsNormal = true;

  /// 校准后测试值
  final TextEditingController rangeCorrectVal = TextEditingController();

  AirDeviceCorrectUpload({this.inspectionTaskId});
}
