import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

//报警管理单
class Order extends Equatable {
  final String name;
  final String outletName;
  final String alarmTime;
  final String area;
  final String statue;
  final List<AlarmType> alarmTypeList;
  final String alarmRemark;

  Order({
    this.name,
    this.outletName,
    this.alarmTime,
    this.area,
    this.statue,
    this.alarmTypeList,
    this.alarmRemark,
  }) : super([
          name,
          outletName,
          alarmTime,
          area,
          statue,
          alarmTypeList,
          alarmRemark
        ]);

  static Order fromJson(dynamic json) {
    return Order(
      name: json['enterprisename'],
      outletName: json['disOutName'],
      alarmTime: json['createtime'],
      area: json['areaName'],
      statue: json['orderstate'],
      alarmRemark: json['alarmdesc'],
      alarmTypeList: _getAlarmTypeList(json['alarmtype']),
    );
  }

  //将报警类型string转化成List
  static List<AlarmType> _getAlarmTypeList(String string) {
    return string.trimLeft().trimRight().split(' ').map((string) {
      switch (string) {
        case '连续恒值':
          return AlarmType(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_constant_value.png',
              color: Colors.green);
        case '超标异常':
          return AlarmType(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_factor_outrange.png',
              color: Colors.blue);
        case '排放流量异常':
          return AlarmType(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_discharge_abnormal.png',
              color: Colors.red);
        case '数采仪掉线':
          return AlarmType(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_device_offline.png',
              color: Colors.teal);
        case '无数据上传':
          return AlarmType(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_no_upload.png',
              color: Colors.orange);
        default:
          return AlarmType(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_unknow.png',
              color: Colors.grey);
      }
    }).toList();
  }
}

//报警类型
class AlarmType extends Equatable {
  final Color color;
  final String name;
  final String imagePath;

  AlarmType({
    this.color,
    this.name,
    this.imagePath,
  }) : super([
          color,
          name,
          imagePath,
        ]);
}
