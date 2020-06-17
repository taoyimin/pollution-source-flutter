import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/enter/list/enter_list_model.dart';
import 'package:pollution_source/res/constant.dart';

/// 长期停产上报
class LongStopReportUpload {
  Enter enter; // 企业
  DateTime startTime; // 开始时间
  DateTime endTime; // 结束时间
  DateTime minStartTime = DateTime.now().add(
    Duration(hours: -Constant.defaultStopAdvanceTime),
  );  // 最小开始时间
  final TextEditingController remark = TextEditingController(); // 备注
  List<Asset> attachments = []; // 证明材料

  LongStopReportUpload({this.enter});
}
