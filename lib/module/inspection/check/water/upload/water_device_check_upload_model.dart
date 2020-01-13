import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'water_device_check_upload_model.g.dart';

// 废水监测设备校验上报
@JsonSerializable()
class WaterDeviceCheckUpload extends Equatable {
  final String inspectionTaskId;
  final String itemType;
  final DateTime currentCheckTime;
  final String currentCheckResult;
  final bool currentCheckIsPass;
  final DateTime currentCorrectTime;
  final bool currentCorrectIsPass;

  const WaterDeviceCheckUpload({
    this.inspectionTaskId,
    this.itemType,
    this.currentCheckTime,
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
        currentCheckResult,
        currentCheckIsPass,
        currentCorrectTime,
        currentCorrectIsPass,
      ];

  WaterDeviceCheckUpload copyWith({
    DateTime currentCheckTime,
    String currentCheckResult,
    bool currentCheckIsPass,
    DateTime currentCorrectTime,
    bool currentCorrectIsPass,
    bool isExpanded,
  }) {
    return WaterDeviceCheckUpload(
      inspectionTaskId: this.inspectionTaskId,
      itemType: this.itemType,
      currentCheckTime: currentCheckTime ?? this.currentCheckTime,
      currentCheckResult: currentCheckResult ?? this.currentCheckResult,
      currentCheckIsPass: currentCheckIsPass ?? this.currentCheckIsPass,
      currentCorrectTime: currentCorrectTime ?? this.currentCorrectTime,
      currentCorrectIsPass: currentCorrectIsPass ?? this.currentCorrectIsPass,
    );
  }
}
