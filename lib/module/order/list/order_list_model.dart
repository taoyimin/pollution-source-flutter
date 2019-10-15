import 'package:common_utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/module/common/common_model.dart';

//报警管理单
class Order extends Equatable {
  final String enterName;
  final String monitorName;
  final String alarmTime;
  final String areaName;
  final String state;
  final String alarmRemark;
  final List<Label> labelList;

  Order({
    this.enterName = '',
    this.monitorName = '',
    this.alarmTime = '',
    this.areaName = '',
    this.state = '',
    this.alarmRemark = '',
    this.labelList,
  }) : super([
          enterName,
          monitorName,
          alarmTime,
          areaName,
          state,
          alarmRemark,
          labelList,
        ]);

  static Order fromJson(dynamic json) {
    return Order(
      enterName: json['enterprisename'],
      monitorName: json['disOutName'],
      alarmTime: json['createtime'],
      areaName: json['areaName'],
      state: json['orderstate'],
      alarmRemark: json['alarmdesc'],
      labelList: TextUtil.isEmpty(json['alarmtype'])
          ? []
          : _getLabelList(json['alarmtype']),
    );
  }

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
        default:
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_unknow.png',
              color: Colors.grey);
      }
    }).toList();
  }
}
