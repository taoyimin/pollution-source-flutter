import 'package:common_utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/module/common/common_model.dart';
import 'package:pollution_source/res/constant.dart';

//监控点列表
class Monitor extends Equatable {
  final String monitorId; //监控点ID
  final String enterName; //企业名称
  final String monitorName; //监控点名称
  final String monitorAddress; //监控点地址
  final String monitorType; //监控点类型
  final String imagePath; //监控点logo
  final String monitorCategoryStr; //监控点类别
  final List<Label> labelList; //标签集合

  const Monitor({
    this.monitorId,
    this.enterName,
    this.monitorName,
    this.monitorAddress,
    this.monitorType,
    this.imagePath,
    this.monitorCategoryStr,
    this.labelList,
  });

  @override
  List<Object> get props => [
        monitorId,
    enterName,
        monitorName,
        monitorAddress,
        monitorType,
        imagePath,
    monitorCategoryStr,
        labelList,
      ];

  static Monitor fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return Monitor(
        monitorId: json['monitorId'].toString(),
        enterName: json['enterpriseName'],
        monitorName: json['disMonitorName'],
        monitorAddress: json['disMonitorAddress'],
        monitorType: json['disMonitorType'],
        monitorCategoryStr: json['monitorCategoryStr'],
        imagePath: _getMonitorTypeImage(json['disMonitorType']),
        labelList: TextUtil.isEmpty('流量* PH* 化学需氧量* 氨氮* 总磷* 总氮*')
            ? const []
            : _getLabelList('流量* PH* 化学需氧量* 氨氮* 总磷* 总氮*'),
      );
    } else {
      return Monitor(
        monitorId: json['monitorId'],
        enterName: json['enterName'],
        monitorName: json['monitorName'],
        monitorAddress: json['monitorAddress'],
        monitorType: json['monitorType'],
        monitorCategoryStr: json['monitorCategoryStr'],
        imagePath: _getMonitorTypeImage(json['monitorType']),
        labelList: TextUtil.isEmpty('流量* PH* 化学需氧量* 氨氮* 总磷* 总氮*')
            ? const []
            : _getLabelList('流量* PH* 化学需氧量* 氨氮* 总磷* 总氮*'),
      );
    }
  }

  //根据监控点类型获取图片
  static String _getMonitorTypeImage(String monitorType) {
    switch (monitorType) {
      case 'outletType1':
        //雨水
        return 'assets/images/icon_unknown_monitor.png';
      case 'outletType2':
        //废水
        return 'assets/images/icon_water_monitor.png';
      case 'outletType3':
        //废气
        return 'assets/images/icon_air_monitor.png';
      default:
        //未知
        return 'assets/images/icon_unknown_monitor.png';
    }
  }

  //将因子string转化成List
  static List<Label> _getLabelList(String string) {
    return string.trimLeft().trimRight().split(' ').map((string) {
      return Label(
        name: string,
        color: Colors.green,
      );
    }).toList();
  }
}
