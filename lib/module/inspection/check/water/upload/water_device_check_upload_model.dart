import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:pollution_source/util/common_utils.dart';

/// 废水监测设备校验上报
class WaterDeviceCheckUpload {
  /// 任务id
  String inspectionTaskId;

  /// 任务类型
  String itemType;

  /// 位置信息
  BaiduLocation baiduLocation;

  /// 校验因子名称
  String factorName;

  /// 校验因子代码
  String factorCode;

  /// 测定结果单位
  TextEditingController factorUnit;

  /// 在线监测仪器测定结果
  final TextEditingController measuredResult = TextEditingController();

  /// 比对方法测定结果集合
  final List<TextEditingController> comparisonMeasuredResultList = [
    TextEditingController()
  ];

  /// 测定误差
  final TextEditingController measuredDisparity = TextEditingController();

  /// 校验时间
  DateTime currentCheckTime;

  /// 校验结果是否合格
  bool isQualified = true;

  WaterDeviceCheckUpload(
      {this.inspectionTaskId,
      this.itemType,
      this.factorName,
      this.factorCode,
      this.factorUnit});

  /// 获取比对方法测定结果平均值
  String get comparisonMeasuredAvg {
    try {
      if (comparisonMeasuredResultList == null) {
        return '0';
      }
      var tempList = comparisonMeasuredResultList
          .where((item) => CommonUtils.isNumeric(item.text));
      if (tempList.length == 0) {
        return '';
      }
      return (tempList
                  .map((item) => double.tryParse(item.text))
                  .reduce((a, b) => a + b) /
              tempList.length)
          .toStringAsFixed(4);
    } catch (e) {
      return '';
    }
  }
}
