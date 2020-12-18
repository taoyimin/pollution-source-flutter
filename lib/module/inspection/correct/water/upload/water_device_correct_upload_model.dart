import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';

/// 废水监测设备校准上报
class WaterDeviceCorrectUpload {
  /// 位置信息
  BaiduLocation baiduLocation;

  /// 测量单位
  final TextEditingController factorUnit = TextEditingController();

  /// 废水监测设备校准记录集合
  final List<WaterDeviceCorrectRecord> waterDeviceCorrectRecordList = [];
}

/// 废水监测设备校准记录
class WaterDeviceCorrectRecord{
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

  WaterDeviceCorrectRecord({this.inspectionTaskId, this.itemType});
}