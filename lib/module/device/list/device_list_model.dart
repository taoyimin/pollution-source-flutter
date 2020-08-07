import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_list_model.g.dart';

/// 废水监测设备列表
@JsonSerializable()
class Device extends Equatable {
  @JsonKey(name: 'onlineDeviceId')
  final int deviceId; // 设备ID
  @JsonKey(defaultValue: '')
  final String deviceName; // 设备名称
  @JsonKey(defaultValue: '')
  final String deviceNo; // 设备编号
  @JsonKey(defaultValue: '')
  final String deviceTypeName; // 设备类型
  @JsonKey(defaultValue: '')
  final String markerName; // 制造商

  const Device({
    this.deviceId,
    this.deviceName,
    this.deviceNo,
    this.deviceTypeName,
    this.markerName,
  });

  @override
  List<Object> get props => [
        deviceId,
        deviceName,
        deviceNo,
        deviceTypeName,
        markerName,
      ];

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
