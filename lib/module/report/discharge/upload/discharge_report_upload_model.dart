import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';
import 'package:pollution_source/res/constant.dart';

/// 异常申报单详情
class DischargeReportUpload {
  Enter enter; // 企业
  Monitor monitor; // 监控点
  DateTime startTime; // 开始时间
  DateTime endTime; // 结束时间
  DateTime minStartTime = DateTime.now().add(
    Duration(hours: -Constant.defaultStopAdvanceTime),
  );  // 最小开始时间
  DataDict stopType; // 异常类型
  bool isShutdown = true; // 是否关停设备
  final TextEditingController stopReason = TextEditingController(); // 停产原因
  List<Asset> attachments = []; // 证明材料

  DischargeReportUpload({this.enter});
}
