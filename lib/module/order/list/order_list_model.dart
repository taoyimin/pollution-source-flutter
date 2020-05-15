import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/util/ui_utils.dart';

part 'order_list_model.g.dart';

/// 报警管理单列表
@JsonSerializable()
class Order extends Equatable {
  @JsonKey(name: 'id')
  final int orderId; // 报警管理单ID
  @JsonKey(name: 'enterpriseName', defaultValue: '')
  final String enterName; // 企业名称
  @JsonKey(name: 'disMonitorName', defaultValue: '')
  final String monitorName; // 监控点名称
  @JsonKey(name: 'alarmDate', defaultValue: '')
  final String alarmDateStr; // 报警时间
  @JsonKey(defaultValue: '')
  final String cityName; // 所属市
  @JsonKey(defaultValue: '')
  final String areaName; // 所属区
  @JsonKey(defaultValue: '')
  final String alarmStateStr; // 报警单状态
  @JsonKey(defaultValue: '')
  final String alarmDesc; // 报警描述
  @JsonKey(defaultValue: '')
  final String alarmTypeStr; // 报警类型
  @JsonKey(defaultValue: '')
  final String alarmCauseStr; // 报警类型
  @JsonKey(defaultValue: '')
  final String alarmLevel; // 报警级别
  @JsonKey(defaultValue: '')
  final String alarmLevelName; // 报警级别描述

  const Order({
    this.orderId,
    this.enterName,
    this.monitorName,
    this.alarmDateStr,
    this.cityName,
    this.areaName,
    this.alarmStateStr,
    this.alarmDesc,
    this.alarmTypeStr,
    this.alarmCauseStr,
    this.alarmLevel,
    this.alarmLevelName,
  });

  @override
  List<Object> get props => [
        orderId,
        enterName,
        monitorName,
        alarmDateStr,
        cityName,
        areaName,
        alarmStateStr,
        alarmDesc,
        alarmTypeStr,
        alarmCauseStr,
        alarmLevel,
        alarmLevelName,
      ];

  List<Label> get labelList {
    final String labelStr =
        '${alarmTypeStr.trim()} ${alarmCauseStr.trim()}'.trim();
    if (TextUtil.isEmpty(labelStr)) {
      return [];
    } else {
      return labelStr.split(' ').map((string) {
        return UIUtils.getOrderAlarmIcon(string);
      }).toList();
    }
  }

  /// 所属区域
  String get districtName {
    return '${cityName ?? ''}${areaName ?? ''}';
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
