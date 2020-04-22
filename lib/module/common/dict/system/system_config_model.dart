import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';

part 'system_config_model.g.dart';

/// 系统配置类
@JsonSerializable()
class SystemConfig extends DataDict {
  @JsonKey(name: 'dicDesc')
  final String name;
  @JsonKey(name: 'dicValue')
  final String code;

  const SystemConfig({
    @required this.name,
    @required this.code,
  });

  @override
  List<Object> get props => [name, code];

  factory SystemConfig.fromJson(Map<String, dynamic> json) =>
      _$SystemConfigFromJson(json);

  Map<String, dynamic> toJson() => _$SystemConfigToJson(this);
}
