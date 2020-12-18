import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/device/list/device_list_model.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';

/// 易耗品更换上报类
class ConsumableReplaceUpload {
  /// 位置信息
  BaiduLocation baiduLocation;

  /// 企业
  Enter enter;

  /// 监控点
  Monitor monitor;

  /// 设备
  Device device;

  /// 易耗品名称
  final TextEditingController consumableName = TextEditingController();

  /// 规格型号
  final TextEditingController specificationType = TextEditingController();

  /// 有效期
  DateTime validityTime;

  /// 更换时间
  DateTime replaceTime;

  /// 数量
  final TextEditingController amount = TextEditingController();

  /// 计量单位
  final TextEditingController unit = TextEditingController();

  /// 维护保养人/核查人
  final TextEditingController maintainPerson = TextEditingController();

  /// 维护保养时间/核查时间
  DateTime maintainTime;

  /// 更换原因说明
  final TextEditingController replaceRemark = TextEditingController();

  /// 证明材料
  List<Asset> attachments = [];
}
