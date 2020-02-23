import 'package:common_utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/common_model.dart';

part 'order_list_model.g.dart';

//报警管理单列表
@JsonSerializable()
class Order extends Equatable {
  @JsonKey(name: 'id')
  final int orderId; // 报警管理单ID
  @JsonKey(name: 'enterpriseName')
  final String enterName; // 企业名称
  @JsonKey(name: 'disMonitorName')
  final String monitorName; // 监控点名称
  @JsonKey(name: 'alarmDate')
  final String alarmDateStr; // 报警时间
  final String cityName; // 所属市
  final String areaName; // 所属区
  final String orderStateStr; // 状态
  @JsonKey(name: 'alarmDesc')
  final String alarmRemark; // 报警描述
  final String alarmTypeStr; // 报警类型
  final String alarmLevel; // 报警级别
  final String superviseStatus; // 报警级别描述

  const Order({
    this.orderId,
    this.enterName,
    this.monitorName,
    this.alarmDateStr,
    this.cityName,
    this.areaName,
    this.orderStateStr,
    this.alarmRemark,
    this.alarmTypeStr,
    this.alarmLevel,
    this.superviseStatus,
  });

  @override
  List<Object> get props => [
        orderId,
        enterName,
        monitorName,
        alarmDateStr,
        cityName,
        areaName,
        orderStateStr,
        alarmRemark,
        alarmTypeStr,
        alarmLevel,
        superviseStatus,
      ];

  List<Label> get labelList {
    return TextUtil.isEmpty(alarmTypeStr)
        ? const []
        : _getLabelList(alarmTypeStr);
  }

  // 所属区域
  String get districtName {
    return '${cityName ?? ''}${areaName ?? ''}';
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

  //将报警类型string转化成List
  static List<Label> _getLabelList(String string) {
    return string.trimLeft().trimRight().split(' ').map((string) {
      switch (string) {
        case '连续恒值':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_constant_value.png',
              color: Colors.green);
        case '超标异常':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_factor_outrange.png',
              color: Colors.blue);
        case '排放流量异常':
        case '超大值':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_discharge_abnormal.png',
              color: Colors.red);
        case '数采仪掉线':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_device_offline.png',
              color: Colors.teal);
        case '无数据上传':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_no_upload.png',
              color: Colors.orange);
        case '联网异常':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_no_upload.png',
              color: Colors.orange);
        case '零值':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_zero_value.png',
              color: Colors.blue);
        default:
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_unknow.png',
              color: Colors.grey);
      }
    }).toList();
  }
}
