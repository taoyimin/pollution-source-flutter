import 'package:common_utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/module/common/common_model.dart';

//企业
class Enter extends Equatable {
  //企业名
  final String enterName;

  //企业地址
  final String enterAddress;

  //是否是重点企业
  final bool isImportant;

  //企业logo
  final String imagePath;

  //行业类别
  final String industryType;

  //企业标签
  final List<Label> labelList;

  Enter({
    this.enterName,
    this.enterAddress,
    this.isImportant,
    this.imagePath,
    this.industryType,
    this.labelList,
  }) : super([
          enterName,
          enterAddress,
          isImportant,
          imagePath,
          industryType,
          labelList,
        ]);

  static Enter fromJson(dynamic json) {
    return Enter(
      enterName: json['enterprise_name'],
      enterAddress: json['ent_address'],
      isImportant: json['attention_level'] == '1' ? true : false,
      imagePath: _getEnterTypeImage(json['enterprise_type']),
      industryType: json['industryTypeStr'],
      labelList: TextUtil.isEmpty(json['enterprise_type_str'])
          ? []
          : _getLabelList(json['enterprise_type_str']),
    );
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
        //未知
        return 'assets/images/icon_unknown_monitor.png';
    }
  }

  //将企业类型string转化成List
  static List<Label> _getLabelList(String string) {
    return string.trimLeft().trimRight().split(' ').map((string) {
      switch (string) {
        case '废水':
          return Label(
              name: '$string企业',
              imagePath: 'assets/images/icon_pollution_water_outlet.png',
              color: Colors.blue);
        case '废气':
          return Label(
              name: '$string企业',
              imagePath: 'assets/images/icon_pollution_air_outlet.png',
              color: Colors.orange);
        case '雨水':
          return Label(
              name: '$string企业',
              imagePath: 'assets/images/icon_pollution_water_enter.png',
              color: Colors.green);
        default:
          return Label(
              name: string,
              imagePath: 'assets/images/icon_alarm_type_unknow.png',
              color: Colors.grey);
      }
    }).toList();
  }
}
