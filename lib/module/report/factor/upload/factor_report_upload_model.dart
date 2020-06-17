import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/module/monitor/list/monitor_list_model.dart';
import 'package:pollution_source/res/constant.dart';

/// 异常申报单详情
class FactorReportUpload {
  Enter enter; // 企业
  Monitor monitor; // 监控点
  List<DataDict> factorCodeList = []; // 异常因子
  DateTime startTime; // 开始时间
  DateTime endTime; // 结束时间
  DateTime minStartTime = DateTime.now().add(
    Duration(hours: -Constant.defaultStopAdvanceTime),
  );  // 最小开始时间
  List<DataDict> alarmTypeList = []; // 异常类型
  int limitDay = 5; // 因子异常申报异常类型为设备故障时限制时间，默认5天
  final TextEditingController exceptionReason = TextEditingController(); // 异常原因
  List<Asset> attachments = []; // 证明材料

  FactorReportUpload({this.enter});
}
