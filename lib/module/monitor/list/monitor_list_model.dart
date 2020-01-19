import 'package:common_utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/common_model.dart';

part 'monitor_list_model.g.dart';

//监控点列表
@JsonSerializable()
class Monitor extends Equatable {
  final int monitorId; //监控点ID
  @JsonKey(name: 'enterpriseName')
  final String enterName; //企业名称
  @JsonKey(name: 'disMonitorName')
  final String monitorName; //监控点名称
  @JsonKey(name: 'disMonitorAddress')
  final String monitorAddress; //监控点地址
  @JsonKey(name: 'disMonitorType')
  final String monitorType; //监控点类型
  @JsonKey(name: 'outletTypeStr')
  final String monitorCategoryStr; //监控点类别

  const Monitor({
    this.monitorId,
    this.enterName,
    this.monitorName,
    this.monitorAddress,
    this.monitorType,
    this.monitorCategoryStr,
  });

  @override
  List<Object> get props => [
        monitorId,
        enterName,
        monitorName,
        monitorAddress,
        monitorType,
        monitorCategoryStr,
      ];

  String get imagePath {
    return _getMonitorTypeImage(monitorType);
  }

  List<Label> get labelList {
    return TextUtil.isEmpty('')
        ? const []
        : _getLabelList('流量* PH* 化学需氧量* 氨氮* 总磷* 总氮*');
  }

  factory Monitor.fromJson(Map<String, dynamic> json) =>
      _$MonitorFromJson(json);

  Map<String, dynamic> toJson() => _$MonitorToJson(this);

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
