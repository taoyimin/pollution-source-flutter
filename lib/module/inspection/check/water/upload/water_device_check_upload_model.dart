import 'package:equatable/equatable.dart';

/// 废水监测设备校验上报
class WaterDeviceCheckUpload extends Equatable {
  final String inspectionTaskId;
  final String itemType;
  final DateTime currentCheckTime;
  final String standardSolution;
  final String realitySolution;
  final String currentCheckResult;
  final bool currentCheckIsPass;
  final DateTime currentCorrectTime;
  final bool currentCorrectIsPass;

  const WaterDeviceCheckUpload({
    this.inspectionTaskId,
    this.itemType,
    this.currentCheckTime,
    this.standardSolution,
    this.realitySolution,
    this.currentCheckResult,
    this.currentCheckIsPass = true,
    this.currentCorrectTime,
    this.currentCorrectIsPass = true,
  });

  @override
  List<Object> get props => [
        inspectionTaskId,
        itemType,
        currentCheckTime,
        standardSolution,
        realitySolution,
        currentCheckResult,
        currentCheckIsPass,
        currentCorrectTime,
        currentCorrectIsPass,
      ];

  WaterDeviceCheckUpload copyWith({
    DateTime currentCheckTime,
    String standardSolution,
    String realitySolution,
    String currentCheckResult,
    bool currentCheckIsPass,
    DateTime currentCorrectTime,
    bool currentCorrectIsPass,
  }) {
    return WaterDeviceCheckUpload(
      inspectionTaskId: this.inspectionTaskId,
      itemType: this.itemType,
      currentCheckTime: currentCheckTime ?? this.currentCheckTime,
      standardSolution: standardSolution ?? this.standardSolution,
      realitySolution: realitySolution ?? this.realitySolution,
      currentCheckResult: currentCheckResult ?? this.currentCheckResult,
      currentCheckIsPass: currentCheckIsPass ?? this.currentCheckIsPass,
      currentCorrectTime: currentCorrectTime ?? this.currentCorrectTime,
      currentCorrectIsPass: currentCorrectIsPass ?? this.currentCorrectIsPass,
    );
  }
}
