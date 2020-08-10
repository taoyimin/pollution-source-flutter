import 'package:bdmap_location_flutter_plugin/flutter_baidu_location.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/device/list/device_list_model.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';

/// 设备检修上报类
class DeviceRepairUpload {
  /// 位置信息
  BaiduLocation baiduLocation;

  /// 企业
  Enter enter;

  /// 监控点
  Monitor monitor;

  /// 设备
  Device device;

  /// 故障设备名称
  final TextEditingController faultEquipmentName = TextEditingController();

  /// 故障发生时间
  DateTime faultTime;

  /// 恢复正常时间
  DateTime workTime;

  /// 故障情况描述
  final TextEditingController faultRemark = TextEditingController();

  /// 更换部件
  final TextEditingController replacePart = TextEditingController();

  /// 检修情况总结
  final TextEditingController overhaulRemark = TextEditingController();

  /// 证明材料
  List<Asset> attachments = [];
}
