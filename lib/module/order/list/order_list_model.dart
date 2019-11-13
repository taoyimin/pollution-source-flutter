import 'package:common_utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/res/constant.dart';

//报警管理单列表
class Order extends Equatable {
  final String orderId; //报警管理单ID
  final String enterName; //企业名称
  final String monitorName; //监控点名称
  final String alarmDateStr; //报警时间
  final String districtName; //区域
  final String orderStateStr; //状态
  final String alarmRemark; //报警描述
  final List<Label> labelList; //标签集合

  const Order({
    this.orderId,
    this.enterName,
    this.monitorName,
    this.alarmDateStr,
    this.districtName,
    this.orderStateStr,
    this.alarmRemark,
    this.labelList,
  });

  @override
  List<Object> get props => [
    orderId,
        enterName,
        monitorName,
        alarmDateStr,
        districtName,
        orderStateStr,
        alarmRemark,
        labelList,
      ];

  static Order fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return Order(
        orderId: json['id'],
        enterName: json['enterprisename'],
        monitorName: json['disOutName'],
        alarmDateStr: '-',
        districtName: json['areaName'],
        orderStateStr: json['orderstate'],
        alarmRemark: json['alarmdesc'],
        labelList: TextUtil.isEmpty(json['alarmtype'])
            ? const []
            : _getLabelList(json['alarmtype']),
      );
    } else {
      return Order(
        orderId: json['orderId'],
        enterName: json['enterName'],
        monitorName: json['monitorName'],
        alarmDateStr: json['alarmDateStr'],
        districtName: json['districtName'],
        orderStateStr: json['orderStateStr'],
        alarmRemark: json['alarmRemark'],
        labelList: TextUtil.isEmpty(json['alarmTypeStr'])
            ? const []
            : _getLabelList(json['alarmTypeStr']),
      );
    }
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
