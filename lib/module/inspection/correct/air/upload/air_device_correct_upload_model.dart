import 'package:bdmap_location_flutter_plugin/flutter_baidu_location.dart';
import 'package:flutter/material.dart';

/// 废气监测设备校准上报
class AirDeviceCorrectUpload {
  /// 任务id
  String inspectionTaskId;

  /// 位置信息
  BaiduLocation baiduLocation;

  /// 校准因子名称
  String factorName;

  /// 校准因子代码
  String factorCode;

  /// 校准因子单位
  String unit;

  /// 分析仪量程下限
  String measureLower;

  /// 分析仪量程上限
  String measureUpper;

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
