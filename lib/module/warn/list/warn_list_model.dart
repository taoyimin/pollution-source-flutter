import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/util/ui_utils.dart';

part 'warn_list_model.g.dart';

/// 实时预警单列表
@JsonSerializable()
class Warn extends Equatable {
  @JsonKey(name: 'id')
  final int warnId; // 实时预警单ID
  @JsonKey(defaultValue: '')
  final String enterName; // 企业名
  @JsonKey(defaultValue: '')
  final String monitorName; // 监控点名
  @JsonKey(name: 'createDate', defaultValue: '')
  final String createTimeStr; // 生成时间
  @JsonKey(defaultValue: '')
  final String title; // 预警标题
  @JsonKey(defaultValue: '')
  final String text; // 预警详情
  @JsonKey(defaultValue: '')
  final String cityName; // 市名称
  @JsonKey(defaultValue: '')
  final String areaName; // 区名称
  @JsonKey(name: 'alarmTypeName', defaultValue: '')
  final String alarmTypeStr; // 报警原因

  const Warn({
    this.warnId,
    this.enterName,
    this.monitorName,
    this.createTimeStr,
    this.title,
    this.text,
    this.cityName,
    this.areaName,
    this.alarmTypeStr,
  });

  @override
  List<Object> get props => [
        warnId,
        enterName,
        monitorName,
        createTimeStr,
        title,
        text,
        cityName,
        areaName,
        alarmTypeStr,
      ];

  /// 所属区域
  String get districtName {
    return '${cityName ?? ''}${areaName ?? ''}';
  }

  List<Label> get labelList {
    final String labelStr = alarmTypeStr.trim();
    if (TextUtil.isEmpty(labelStr)) {
      return [];
    } else {
      return labelStr.split(' ').map((string) {
        return UIUtils.getOrderAlarmIcon(string);
      }).toList();
    }
  }

  factory Warn.fromJson(Map<String, dynamic> json) => _$WarnFromJson(json);

  Map<String, dynamic> toJson() => _$WarnToJson(this);
}
