import 'package:bdmap_location_flutter_plugin/flutter_baidu_location.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_factor_model.dart';
import 'package:pollution_source/util/common_utils.dart';

/// 废气监测设备校验上报
class AirDeviceCheckUpload {
  /// 任务id
  String inspectionTaskId;

  /// 任务类型
  String itemType;

  /// 位置信息
  BaiduLocation baiduLocation;

  /// 校验因子
  RoutineInspectionUploadFactor factor;

  /// 校验记录
  List<AirDeviceCheckRecord> airDeviceCheckRecordList;

  /// 如校验合格前对系统进行过处理、调整、参数修改，请说明
  final TextEditingController paramRemark = TextEditingController();

  /// 如校验后，颗粒物测量仪、流速仪的原校正系统改动，请说明
  final TextEditingController changeRemark = TextEditingController();

  /// 总体校验是否合格
  final TextEditingController checkResult = TextEditingController();

  /// 获取参比方法测量值平均值
  String get compareAvgVal {
    try {
      if (airDeviceCheckRecordList == null) {
        return '';
      }
      var tempList = airDeviceCheckRecordList
          .where((item) => CommonUtils.isNumeric(item.currentCheckResult.text));
      if (tempList.length == 0) {
        return '';
      }
      return (tempList
                  .map((item) => double.tryParse(item.currentCheckResult.text))
                  .reduce((a, b) => a + b) /
              tempList.length)
          .toStringAsFixed(4);
    } catch (e) {
      return '';
    }
  }

  /// 获取CEMS 测量值平均值
  String get cemsAvgVal {
    try {
      if (airDeviceCheckRecordList == null) {
        return '';
      }
      var tempList = airDeviceCheckRecordList
          .where((item) => CommonUtils.isNumeric(item.currentCheckIsPass.text));
      if (tempList.length == 0) {
        return '';
      }
      return (tempList
                  .map((item) => double.tryParse(item.currentCheckIsPass.text))
                  .reduce((a, b) => a + b) /
              tempList.length)
          .toStringAsFixed(4);
    } catch (e) {
      return '';
    }
  }
}

/// 废气监测设备校验记录
class AirDeviceCheckRecord {
  /// 监测时间
  DateTime currentCheckTime;

  /// 参比方法测量值
  final TextEditingController currentCheckResult = TextEditingController();

  /// CEMS测量值
  final TextEditingController currentCheckIsPass = TextEditingController();
}
