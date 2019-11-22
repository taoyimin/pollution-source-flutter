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
  final String orderId; //报警管理单ID
  final String enterName; //企业名称
  final String monitorName; //监控点名称
  final String alarmDateStr; //报警时间
  final String districtName; //区域
  final String orderStateStr; //状态
  final String alarmRemark; //报警描述
  final String alarmTypeStr; //报警类型

  const Order({
    this.orderId,
    this.enterName,
    this.monitorName,
    this.alarmDateStr,
    this.districtName,
    this.orderStateStr,
    this.alarmRemark,
    this.alarmTypeStr,
    //this.labelList,
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
        alarmTypeStr,
        //labelList,
      ];

  List<Label> get labelList {
    return TextUtil.isEmpty(alarmTypeStr)
        ? const []
        : _getLabelList(alarmTypeStr);
  }

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);

/*  static Order fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return Order(
        orderId: json['id'],
        enterName: json['enterpriseName'],
        monitorName: json['disOutName'],
        alarmDateStr: '-',
        districtName: json['areaName'],
        orderStateStr: json['orderstate'],
        alarmRemark: json['alarmdesc'],
        alarmTypeStr: json['alarmTypeStr'],
        labelList: TextUtil.isEmpty(json['alarmType'])
            ? const []
            : _getLabelList(json['alarmType']),
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
        alarmTypeStr: json['alarmTypeStr'],
        labelList: TextUtil.isEmpty(json['alarmTypeStr'])
            ? const []
            : _getLabelList(json['alarmTypeStr']),
      );
    }
  }*/

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
        case '联网异常':
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
