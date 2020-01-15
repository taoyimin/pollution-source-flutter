import 'package:equatable/equatable.dart';

// 废水监测设备参数巡检上报
class WaterDeviceParamUpload extends Equatable {
  final String inspectionTaskId;
  final List<WaterDeviceParamType> waterDeviceParamTypeList;

  const WaterDeviceParamUpload({
    this.inspectionTaskId,
    this.waterDeviceParamTypeList,
  });

  @override
  List<Object> get props => [
        inspectionTaskId,
        waterDeviceParamTypeList,
      ];

  WaterDeviceParamUpload copyWith({
    List<WaterDeviceParamType> waterDeviceParamTypeList,
  }) {
    return WaterDeviceParamUpload(
      inspectionTaskId: this.inspectionTaskId,
      waterDeviceParamTypeList:
          waterDeviceParamTypeList ?? this.waterDeviceParamTypeList,
    );
  }
}

/// 巡检参数类型
class WaterDeviceParamType extends Equatable {
  final String parameterType;
  final List<WaterDeviceParamName> waterDeviceParamNameList;

  const WaterDeviceParamType({
    this.parameterType,
    this.waterDeviceParamNameList,
  });

  @override
  List<Object> get props => [
        parameterType,
        waterDeviceParamNameList,
      ];

  WaterDeviceParamType copyWith({
    String originalVal,
    List<WaterDeviceParamName> waterDeviceParamNameList,
  }) {
    return WaterDeviceParamType(
      parameterType: this.parameterType,
      waterDeviceParamNameList:
          waterDeviceParamNameList ?? this.waterDeviceParamNameList,
    );
  }
}

/// 巡检参数名
class WaterDeviceParamName extends Equatable {
  final String parameterName;
  final String originalVal;
  final String updateVal;
  final String modifyReason;

  const WaterDeviceParamName({
    this.parameterName,
    this.originalVal = '',
    this.updateVal = '',
    this.modifyReason = '',
  });

  @override
  List<Object> get props => [
        parameterName,
        originalVal,
        updateVal,
        modifyReason,
      ];

  WaterDeviceParamName copyWith({
    String originalVal,
    String updateVal,
    String modifyReason,
  }) {
    return WaterDeviceParamName(
      parameterName: this.parameterName,
      originalVal: originalVal ?? this.originalVal,
      updateVal: updateVal ?? this.updateVal,
      modifyReason: modifyReason ?? this.modifyReason,
    );
  }
}
