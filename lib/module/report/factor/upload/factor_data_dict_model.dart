import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/dict/data_dict_model.dart';

part 'factor_data_dict_model.g.dart';

/// 异常因子类
@JsonSerializable()
class FactorDataDict extends DataDict {
  @JsonKey(name: 'Factor_Code')
  final String code;
  @JsonKey(name: 'Factor_Name')
  final String name;

  const FactorDataDict({this.code, this.name}) : super(code: code, name: name);

  factory FactorDataDict.fromJson(Map<String, dynamic> json) =>
      _$FactorDataDictFromJson(json);

  Map<String, dynamic> toJson() => _$FactorDataDictToJson(this);
}