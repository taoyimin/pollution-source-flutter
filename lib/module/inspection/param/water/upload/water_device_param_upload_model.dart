import 'package:bdmap_location_flutter_plugin/flutter_baidu_location.dart';
import 'package:flutter/material.dart';

/// 废水监测设备参数巡检上报
class WaterDeviceParamUpload {
  /// 任务id
  String inspectionTaskId;

  /// 位置信息
  BaiduLocation baiduLocation;

  /// 巡检参数类型集合
  List<WaterDeviceParamType> waterDeviceParamTypeList = [];
}

/// 巡检参数类型
class WaterDeviceParamType {
  ///参数类型
  String parameterType;

  ////// 巡检参数名集合
  final List<WaterDeviceParamName> waterDeviceParamNameList;

  WaterDeviceParamType({this.parameterType, this.waterDeviceParamNameList});
}

/// 巡检参数名
class WaterDeviceParamName {
  /// 参数名
  String parameterName;

  /// /// 原始值
  final TextEditingController originalVal = TextEditingController();

  /// 更新值
  final TextEditingController updateVal = TextEditingController();

  /// 修改原因
  final TextEditingController modifyReason = TextEditingController();

  WaterDeviceParamName({this.parameterName});
}
