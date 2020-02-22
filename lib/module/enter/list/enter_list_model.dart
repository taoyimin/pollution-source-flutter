import 'package:common_utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pollution_source/module/common/common_model.dart';

part 'enter_list_model.g.dart';

//企业列表
@JsonSerializable()
class Enter extends Equatable {
  final int enterId; //企业id
  @JsonKey(name: 'enterpriseName')
  final String enterName; //企业名
  @JsonKey(name: 'entAddress')
  final String enterAddress; //企业地址
  final String attentionLevel; //是否是重点企业 0:非重点 1:重点
  final String industryTypeStr; //行业类别
  @JsonKey(name: 'enterpriseType')
  final String enterType; //企业类型

  const Enter({
    this.enterId,
    this.enterName,
    this.enterAddress,
    this.attentionLevel,
    this.industryTypeStr,
    this.enterType,
  });

  @override
  List<Object> get props => [
    enterId,
    enterName,
    enterAddress,
    attentionLevel,
    industryTypeStr,
    enterType,
  ];

  factory Enter.fromJson(Map<String, dynamic> json) =>
      _$EnterFromJson(json);

  Map<String, dynamic> toJson() => _$EnterToJson(this);

  //企业图标
  String get imagePath{
    return _getEnterTypeImage(enterType);
  }

  //是否是重点企业
  bool get isImportant{
    return attentionLevel == '1' ? true : false;
  }

  List<Label> get labelList{
    return TextUtil.isEmpty(enterType)
        ? const []
        : _getLabelList(enterType);
  }

  //根据企业类型获取图片
  static String _getEnterTypeImage(String enterType) {
    switch (enterType) {
      case 'EnterType1':
        //废水
        return 'assets/images/icon_water_monitor.png';
      case 'EnterType2':
        //废气
        return 'assets/images/icon_air_monitor.png';
      default:
        //雨水、水气、未知
        return 'assets/images/icon_unknown_monitor.png';
    }
  }

  //将企业类型string转化成List
  static List<Label> _getLabelList(String enterType) {
    return enterType.split(',').map((string) {
      switch (string) {
        case 'EnterType1':
          return Label(
              name: '废水企业',
              imagePath: 'assets/images/icon_pollution_water_outlet.png',
              color: Colors.blue);
        case 'EnterType2':
          return Label(
              name: '废气企业',
              imagePath: 'assets/images/icon_pollution_air_outlet.png',
              color: Colors.orange);
        case 'EnterType3':
          return Label(
              name: '雨水企业',
              imagePath: 'assets/images/icon_pollution_water_enter.png',
              color: Colors.green);
        default:
          return Label(
              name: '未知',
              imagePath: 'assets/images/icon_alarm_type_unknow.png',
              color: Colors.grey);
      }
    }).toList();
  }
}
