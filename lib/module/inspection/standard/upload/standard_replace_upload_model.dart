import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/device/list/device_list_model.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';

/// 标准样品更换上报类
class StandardReplaceUpload {
  /// 位置信息
  BaiduLocation baiduLocation;

  /// 企业
  Enter enter;

  /// 监控点
  Monitor monitor;

  /// 设备
  Device device;

  /// 数量
  final TextEditingController amount = TextEditingController();

  /// 标准样品名称
  final TextEditingController standardSampleName = TextEditingController();

  /// 标准样品浓度
  final TextEditingController standardSamplePotency = TextEditingController();

  /// 配置时间（废水独有）
  DateTime mixTime;

  /// 配置人员（废水独有）
  final TextEditingController mixPerson = TextEditingController();

  /// 更换时间
  DateTime replaceTime;

  /// 更换人员
  final TextEditingController replacePerson = TextEditingController();

  /// 有效期
  DateTime validityTime;

  /// 维护保养/核查时间
  DateTime maintainTime;

  /// 维护保养/核查人
  final TextEditingController maintainPerson = TextEditingController();

  /// 计量单位（废气独有）
  final TextEditingController unit = TextEditingController();

  /// 供应商（废气独有）
  final TextEditingController supplier = TextEditingController();

  /// 证明材料
  List<Asset> attachments = [];
}
