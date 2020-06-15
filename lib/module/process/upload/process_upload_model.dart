import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pollution_source/module/common/collection/law/mobile_law_model.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';

/// 报警管理单流程上报
class ProcessUpload {
  int orderId; // 报警管理单单Id
  String alarmState; // 报警管理单状态
  String operateType; // 操作类型 -1:处理 0:审核通过 1:审核不通过
  List<DataDict> alarmCauseList = []; // 报警原因
  List<MobileLaw> mobileLawList = []; // 移动执法
  final TextEditingController mobileLawNumber =
      TextEditingController(); // 手工录入移动执法任务编号
  final TextEditingController operateDesc = TextEditingController(); // 操作描述
  List<Asset> attachments = []; // 附件
}
