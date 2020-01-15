import 'package:equatable/equatable.dart';
import 'package:pollution_source/module/inspection/common/routine_inspection_upload_factor_model.dart';

// 废气监测设备校准上报
class AirDeviceCorrectUpload extends Equatable {
  final String inspectionTaskId;
  final RoutineInspectionUploadFactor factor;
  final DateTime correctStartTime;
  final DateTime correctEndTime;
  final String zeroVal;
  final String beforeZeroVal;
  final String correctZeroVal;
  final String zeroPercent;
  final bool zeroIsNormal;
  final String zeroCorrectVal;
  final String rangeVal;
  final String beforeRangeVal;
  final String correctRangeVal;
  final String rangePercent;
  final bool rangeIsNormal;
  final String rangeCorrectVal;

  const AirDeviceCorrectUpload({
    this.inspectionTaskId,
    this.factor,
    this.correctStartTime,
    this.correctEndTime,
    this.zeroVal,
    this.beforeZeroVal,
    this.correctZeroVal,
    this.zeroPercent,
    this.zeroIsNormal = true,
    this.zeroCorrectVal,
    this.rangeVal,
    this.beforeRangeVal,
    this.correctRangeVal,
    this.rangePercent,
    this.rangeIsNormal = true,
    this.rangeCorrectVal,
  });

  @override
  List<Object> get props => [
        inspectionTaskId,
        factor,
        correctStartTime,
        correctEndTime,
        zeroVal,
        beforeZeroVal,
        correctZeroVal,
        zeroPercent,
        zeroIsNormal,
        zeroCorrectVal,
        rangeVal,
        beforeRangeVal,
        correctRangeVal,
        rangePercent,
        rangeIsNormal,
        rangeCorrectVal,
      ];

  AirDeviceCorrectUpload copyWith({
    RoutineInspectionUploadFactor factor,
    DateTime correctStartTime,
    DateTime correctEndTime,
    String zeroVal,
    String beforeZeroVal,
    String correctZeroVal,
    String zeroPercent,
    bool zeroIsNormal,
    String zeroCorrectVal,
    String rangeVal,
    String beforeRangeVal,
    String correctRangeVal,
    String rangePercent,
    bool rangeIsNormal,
    String rangeCorrectVal,
  }) {
    return AirDeviceCorrectUpload(
      inspectionTaskId: this.inspectionTaskId,
      factor: factor ?? this.factor,
      correctStartTime: correctStartTime ?? this.correctStartTime,
      correctEndTime: correctEndTime ?? this.correctEndTime,
      zeroVal: zeroVal ?? this.zeroVal,
      beforeZeroVal: beforeZeroVal ?? this.beforeZeroVal,
      correctZeroVal: correctZeroVal ?? this.correctZeroVal,
      zeroPercent: zeroPercent ?? this.zeroPercent,
      zeroIsNormal: zeroIsNormal ?? this.zeroIsNormal,
      zeroCorrectVal: zeroCorrectVal ?? this.zeroCorrectVal,
      rangeVal: rangeVal ?? this.rangeVal,
      beforeRangeVal: beforeRangeVal ?? this.beforeRangeVal,
      correctRangeVal: correctRangeVal ?? this.correctRangeVal,
      rangePercent: rangePercent ?? this.rangePercent,
      rangeIsNormal: rangeIsNormal ?? this.rangeIsNormal,
      rangeCorrectVal: rangeCorrectVal ?? this.rangeCorrectVal,
    );
  }
}
