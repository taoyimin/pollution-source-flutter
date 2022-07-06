import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sampler_info_model.g.dart';

/// 采样器留样信息列表
@JsonSerializable()
class SamplerInfo extends Equatable {
  @JsonKey(name: 'monitor_time', defaultValue: '')
  final String monitorTime; //检测时间
  @JsonKey(name: 'i42001', defaultValue: '')
  final String status; //采样器状态
  @JsonKey(name: 'i42003', defaultValue: '')
  final String mode; //采样模式
  @JsonKey(name: 'i42103', defaultValue: '')
  final String password; //动态密码
  @JsonKey(name: 'i43001', defaultValue: '')
  final String number; //留样瓶号
  @JsonKey(name: 'i43002', defaultValue: '')
  final String time; //留样时间
  @JsonKey(name: 'i43003', defaultValue: '')
  final String capacity; //留样容量

  const SamplerInfo({
    this.monitorTime,
    this.status,
    this.mode,
    this.password,
    this.number,
    this.time,
    this.capacity,
  });

  @override
  List<Object> get props => [
        monitorTime,
        status,
        mode,
        password,
        number,
        time,
        capacity,
      ];

  factory SamplerInfo.fromJson(Map<String, dynamic> json) =>
      _$SamplerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SamplerInfoToJson(this);
}
