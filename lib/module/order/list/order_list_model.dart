import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/common_model.dart';

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
    return '${alarmTypeStr.trim()} ${alarmCauseStr.trim()}'
        .trim()
        .split(' ')
        .map((string) {
      switch (string) {
        case '连续恒值':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_constant_value.png',
              color: Colors.green);
        case '超标异常':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_outrange_error.png',
              color: Colors.red);
        case '超大值':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_large_value.png',
              color: Colors.pink);
        case '联网异常':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_connect_error.png',
              color: Colors.orange);
        case '零值':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_zero_value.png',
              color: Colors.blue);
        case '负值':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_negative_value.png',
              color: Colors.purpleAccent);
        case '设备故障':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_cause_device_error.png',
              color: Colors.red);
        case '设备校准':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_cause_correct.png',
              color: Colors.lightGreen);
        case '接口松动':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_cause_device_offline.png',
              color: Colors.deepOrangeAccent);
        case '超低排放':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_pollution_water_outlet.png',
              color: Colors.purpleAccent);
        case '低于检出限':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_cause_lower_limit.png',
              color: Colors.lightBlueAccent);
        case '停产':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_cause_stopline.png',
              color: Colors.pinkAccent);
        case '停电':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_cause_power_failure.png',
              color: Colors.amber);
        case '网络故障':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_cause_net_error.png',
              color: Colors.grey);
        default:
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_unknow.png',
              color: Colors.grey);
      }
    }).toList();
  }

  /// 所属区域
  String get districtName {
    return '${cityName ?? ''}${areaName ?? ''}';
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
