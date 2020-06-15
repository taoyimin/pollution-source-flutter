import 'package:flutter/material.dart';

// 废水监测设备参数巡检上报
class WaterDeviceParamUpload{
  String inspectionTaskId;
  List<WaterDeviceParamType> waterDeviceParamTypeList = [];
}

/// 巡检参数类型
class WaterDeviceParamType {
  String parameterType;
  final List<WaterDeviceParamName> waterDeviceParamNameList;

  WaterDeviceParamType({this.parameterType, this.waterDeviceParamNameList});
}

/// 巡检参数名
class WaterDeviceParamName{
  String parameterName;
  final TextEditingController originalVal = TextEditingController();
  final TextEditingController updateVal = TextEditingController();
  final TextEditingController modifyReason = TextEditingController();

  WaterDeviceParamName({this.parameterName});
}

