import 'package:equatable/equatable.dart';

// 废气监测设备校验上报
class AirDeviceCheckUpload extends Equatable {
  final String inspectionTaskId;
  final String itemType;
  final String factorId;
  final String factorCode;
  final String factorName;
  final String compareUnit;
  final String cemsUnit;
  final double compareAvgVal;
  final double cemsAvgVal;
  final List<AirDeviceCheckRecord> airDeviceCheckRecordList;
  final String paramRemark;
  final String changeRemark;
  final String checkResult;

  const AirDeviceCheckUpload({
    this.inspectionTaskId,
    this.itemType,
    this.factorId,
    this.factorCode,
    this.factorName,
    this.compareUnit,
    this.cemsUnit,
    this.compareAvgVal,
    this.cemsAvgVal,
    this.airDeviceCheckRecordList,
    this.paramRemark,
    this.changeRemark,
    this.checkResult,
  });

  @override
  List<Object> get props => [
        inspectionTaskId,
        itemType,
        factorId,
        factorCode,
        factorName,
        compareUnit,
        cemsUnit,
        compareAvgVal,
        cemsAvgVal,
        airDeviceCheckRecordList,
        paramRemark,
        changeRemark,
        checkResult,
      ];

  AirDeviceCheckUpload copyWith({
    List<AirDeviceCheckRecord> airDeviceCheckRecordList,
  }) {
    return AirDeviceCheckUpload(
      inspectionTaskId: this.inspectionTaskId,
      itemType: this.itemType,
      factorId: this.factorId,
      factorCode: this.factorCode,
      factorName: this.factorName,
      compareUnit: this.compareUnit,
      cemsUnit: this.cemsUnit,
      compareAvgVal: this.compareAvgVal,
      cemsAvgVal: this.cemsAvgVal,
      airDeviceCheckRecordList:
          airDeviceCheckRecordList ?? this.airDeviceCheckRecordList,
      paramRemark: this.paramRemark,
      changeRemark: this.changeRemark,
      checkResult: this.checkResult,
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
}
