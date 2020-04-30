import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'data_dict_model.g.dart';

/// 数据字典类
///
/// [checked]默认为false，只有多选时才会用到
@JsonSerializable()
class DataDict extends Equatable {
  @JsonKey(name: 'dicSubCode')
  final String code;
  @JsonKey(name: 'dicSubName')
  final String name;
  @JsonKey(ignore: true)
  final bool checked;

  const DataDict({
    @required this.code,
    @required this.name,
    this.checked = false,
  });

  @override
  List<Object> get props => [
        // 不去比较name，只要code相同就视为同一对象
        code,
        checked,
      ];

  DataDict copyWith({
    String code,
    String name,
    bool checked,
  }) {
    return DataDict(
      code: code ?? this.code,
      name: name ?? this.name,
      checked: checked ?? this.checked,
    );
  }

  factory DataDict.fromJson(Map<String, dynamic> json) =>
      _$DataDictFromJson(json);

  Map<String, dynamic> toJson() => _$DataDictToJson(this);
}
