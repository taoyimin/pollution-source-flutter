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
  final String enterId; //企业id
  final String enterName; //企业名
  final String enterAddress; //企业地址
  final String attentionLevel; //是否是重点企业 0:非重点 1:重点
  final String industryTypeStr; //行业类别
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

  factory Enter.fromJson(Map<String, dynamic> json) =>
      _$EnterFromJson(json);

  Map<String, dynamic> toJson() => _$EnterToJson(this);

  /*static Enter fromJson(dynamic json) {
    if(SpUtil.getBool(Constant.spJavaApi, defValue: true)){
      return Enter(
        enterId: '${json['enter_id']}',
        enterName: json['enterprise_name'],
        enterAddress: json['ent_address'],
        isImportant: json['attention_level'] == '1' ? true : false,
        imagePath: _getEnterTypeImage(json['enterprise_type']),
        industryTypeStr: json['industryTypeStr'],
        labelList: TextUtil.isEmpty(json['enterprise_type_str'])
            ? const []
            : _getLabelList(json['enterprise_type_str']),
      );
    }else{
      return Enter(
        enterId: json['enterId'],
        enterName: json['enterName'],
        enterAddress: json['enterAddress'],
        isImportant: json['attentionLevel'] == '1' ? true : false,
        imagePath: _getEnterTypeImage(json['enterType']),
        industryTypeStr: json['industryTypeStr'],
        labelList: TextUtil.isEmpty(json['enterType'])
            ? const []
            : _getLabelList2(json['enterType']),
      );
    }
  }*/

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
  /*static List<Label> _getLabelList(String string) {
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
  }*/

  //将企业类型string转化成List
  static List<Label> _getLabelList(String string) {
    return string.split(',').map((string) {
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
