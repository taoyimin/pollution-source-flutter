import 'package:bdmap_location_flutter_plugin/flutter_baidu_location.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/module/device/list/device_list_model.dart';
import 'package:pollution_source/module/discharge/list/discharge_list_model.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';

/// 废水监测设备参数巡检上报
class WaterDeviceParamUpload {
  /// 位置信息
  BaiduLocation baiduLocation;

  /// 选中企业
  Enter enter;

  /// 选中排口
  Discharge discharge;

  /// 选中监控点
  Monitor monitor;

  /// 选中设备
  Device device;

  /// 测量原理
  String measurePrincipleStr;

  /// 分析方法
  String analysisMethodStr;

  /// 巡检参数类型集合
  List<WaterDeviceParamType> waterDeviceParamTypeList = [];
}

/// 巡检参数类型
class WaterDeviceParamType {
  ///参数类型（有可能是String，也有可能是TextEditingController）
  dynamic parameterType;

  ///参数类型ID
  int parameterTypeId;

  ////// 巡检参数名集合
  final List<WaterDeviceParamName> waterDeviceParamNameList;

  WaterDeviceParamType(
      {this.parameterType,
      this.parameterTypeId,
      this.waterDeviceParamNameList});
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
