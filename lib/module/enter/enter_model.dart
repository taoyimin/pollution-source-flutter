import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pollution_source/module/common/common_model.dart';

//报警管理单
class Enter extends Equatable {
  //企业名
  final String name;
  //企业地址
  final String address;
  //是否是重点企业
  final bool isImportant;
  //企业logo
  final String imagePath;
  //行业类别
  final String industryType;
  //企业标签
  final List<Label> labelList;

  Enter({
    this.name,
    this.address,
    this.isImportant,
    this.imagePath,
    this.industryType,
    this.labelList,
  }) : super([
          name,
          address,
          isImportant,
          imagePath,
          industryType,
    labelList,
        ]);

  static Enter fromJson(dynamic json) {
    return Enter(
      name: json['enterprisename'],
      address: json['address'],
      isImportant: json['isImportant'],
      imagePath: json['imagePath'],
      industryType: json['industryType'],
      labelList: _getLabelList(json['enterLabel']),
    );
  }

  //将报警类型string转化成List
  static List<Label> _getLabelList(String string) {
    return string.trimLeft().trimRight().split(' ').map((string) {
      switch (string) {
        case '废水排口':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_pollution_water_outlet.png',
              color: Colors.blue);
        case '废气排口':
          return Label(
              name: string,
              imagePath: 'assets/images/icon_pollution_air_outlet.png',
              color: Colors.orange);
        case '雨水':
          return Label(
              name: string,
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
