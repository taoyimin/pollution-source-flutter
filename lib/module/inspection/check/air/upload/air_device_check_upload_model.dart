import 'package:common_utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_factor_model.dart';

// 废气监测设备校验上报
class AirDeviceCheckUpload extends Equatable {
  final String inspectionTaskId;
  final String itemType;
  final RoutineInspectionUploadFactor factor;
  final List<AirDeviceCheckRecord> airDeviceCheckRecordList;
  final String paramRemark;
  final String changeRemark;
  final String checkResult;

  const AirDeviceCheckUpload({
    this.inspectionTaskId,
    this.itemType,
    this.factor,
    this.airDeviceCheckRecordList,
    this.paramRemark,
    this.changeRemark,
    this.checkResult,
  });

  @override
  List<Object> get props => [
        inspectionTaskId,
        itemType,
        factor,
        airDeviceCheckRecordList,
        paramRemark,
        changeRemark,
        checkResult,
      ];

  /// 获取参比方法测量值平均值
  String get compareAvgVal {
    try {
      if (airDeviceCheckRecordList == null) {
        return '';
      }
      var tempList = airDeviceCheckRecordList
          .where((item) => !TextUtil.isEmpty(item.currentCheckResult));
      if (tempList.length == 0) {
        return '';
      }
      return (tempList
                  .map((item) => double.parse(item.currentCheckResult))
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
          .where((item) => !TextUtil.isEmpty(item.currentCheckIsPass));
      if (tempList.length == 0) {
        return '';
      }
      return (tempList
                  .map((item) => double.parse(item.currentCheckIsPass))
                  .reduce((a, b) => a + b) /
              tempList.length)
          .toStringAsFixed(4);
    } catch (e) {
      return '';
    }
  }

  AirDeviceCheckUpload copyWith({
    RoutineInspectionUploadFactor factor,
    List<AirDeviceCheckRecord> airDeviceCheckRecordList,
    String paramRemark,
    String changeRemark,
    String checkResult,
  }) {
    return AirDeviceCheckUpload(
      inspectionTaskId: this.inspectionTaskId,
      itemType: this.itemType,
      factor: factor ?? this.factor,
      airDeviceCheckRecordList:
          airDeviceCheckRecordList ?? this.airDeviceCheckRecordList,
      paramRemark: paramRemark ?? this.paramRemark,
      changeRemark: changeRemark ?? this.changeRemark,
      checkResult: checkResult ?? this.checkResult,
    );
  }
}

class AirDeviceCheckRecord extends Equatable {
  final DateTime currentCheckTime;
  final String currentCheckResult;
  final String currentCheckIsPass;

  AirDeviceCheckRecord({
    this.currentCheckTime,
    this.currentCheckResult,
    this.currentCheckIsPass,
  });

  @override
  List<Object> get props => [
        currentCheckTime,
        currentCheckResult,
        currentCheckIsPass,
      ];

  AirDeviceCheckRecord copyWith({
    DateTime currentCheckTime,
    String currentCheckResult,
    String currentCheckIsPass,
  }) {
    return AirDeviceCheckRecord(
      currentCheckTime: currentCheckTime ?? this.currentCheckTime,
      currentCheckResult: currentCheckResult ?? this.currentCheckResult,
      currentCheckIsPass: currentCheckIsPass ?? this.currentCheckIsPass,
    );
  }
}
