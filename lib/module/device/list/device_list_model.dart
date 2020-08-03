import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_list_model.g.dart';

/// 设备列表
@JsonSerializable()
class Device extends Equatable {
  @JsonKey(name: 'Device_Id')
  final int deviceId; // 设备ID
  @JsonKey(defaultValue: '')
  final String deviceName; // 设备名称
  @JsonKey(defaultValue: '')
  final String deviceNo; // 设备编号
  @JsonKey(defaultValue: '')
  final String deviceType; // 设备类型
  @JsonKey(defaultValue: '')
  final String markerName; // 制造商
  @JsonKey(name: 'measure_method', defaultValue: '')
  final String measureMethod; // 测量方法
  @JsonKey(name: 'measure_principle', defaultValue: '')
  final String measurePrinciple; // 测量原理
  @JsonKey(defaultValue: '')
  final String measurePrincipleStr; // 测量原理中文
  @JsonKey(name: 'analysis_method', defaultValue: '')
  final String analysisMethod; // 分析方法
  @JsonKey(defaultValue: '')
  final String analysisMethodStr; // 分析方法中文

  const Device({
    this.deviceId,
    this.deviceName,
    this.deviceNo,
    this.deviceType,
    this.markerName,
    this.measureMethod,
    this.measurePrinciple,
    this.measurePrincipleStr,
    this.analysisMethod,
    this.analysisMethodStr,
  });

  @override
  List<Object> get props => [
        deviceId,
        deviceName,
        deviceNo,
        deviceType,
        markerName,
        measureMethod,
        measurePrinciple,
        measurePrincipleStr,
        analysisMethod,
        analysisMethodStr,
      ];

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
