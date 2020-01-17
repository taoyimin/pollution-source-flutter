import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'air_device_last_value_model.g.dart';

@JsonSerializable()
class AirDeviceLastValue extends Equatable{
  final String zeroCorrectVal; //零点漂移上次校准后测试值
  final String rangeCorrectVal; //量程漂移上次校准后测试值

  const AirDeviceLastValue({
    this.zeroCorrectVal,
    this.rangeCorrectVal,
  });

  @override
  List<Object> get props => [
    zeroCorrectVal,
    rangeCorrectVal,
  ];

  factory AirDeviceLastValue.fromJson(Map<String, dynamic> json) =>
      _$AirDeviceLastValueFromJson(json);

  Map<String, dynamic> toJson() => _$AirDeviceLastValueToJson(this);
}