import 'dart:ui';

import 'package:flutter/material.dart';

class Water {
  Water(this.title, this.imagePath, this.count, this.achievementRate,
      this.monthOnMonth, this.yearOnYear);

  String title; //标题
  String imagePath; //图片路径
  int count; //数量
  double achievementRate; //达标率
  double monthOnMonth; //环比
  double yearOnYear; //同比
}

class Monitor {
  Monitor(this.title, this.count, this.imagePath, this.color);

  String title; //状态
  int count; //个数
  Color color; //图标颜色
  String imagePath; //图片路径
}

class AqiExamine {
  AqiExamine(this.title, this.imagePath, this.title1, this.value1, this.title2,
      this.value2, this.title3, this.value3);

  String title; //标题
  String imagePath; //图片路径
  String title1;
  String value1;
  String title2;
  String value2;
  String title3;
  String value3;
}

class PollutionEnter {
  PollutionEnter(this.title, this.count, this.imagePath, this.color);

  String title; //标题
  int count; //个数
  Color color; //图标颜色
  String imagePath; //图片路径
}

class SummaryStatistics {
  SummaryStatistics(
      this.title, this.count, this.color, this.imagePath, this.backgroundPath);

  String title; //标题
  int count; //个数
  Color color; //图标颜色
  String imagePath; //图片路径
  String backgroundPath; //背景路径
}

class Enter {
  Enter({
    @required this.name,
    @required this.address,
    @required this.isImportant, //是否重点
    @required this.imagePath,
    @required this.industryType, //行业类别
  });

  String name;
  String address;
  bool isImportant;
  String imagePath;
  String industryType;
}

class Task {
  Task({
    @required this.name,
    @required this.outletName,
    @required this.alarmTime,
    @required this.area,
    @required this.statue,
    @required this.alarmTypeList,
    @required this.alarmRemark,
  });

  String name;
  String outletName;
  String alarmTime;
  String area;
  String statue;
  List<AlarmType> alarmTypeList;
  String alarmRemark;
}

class AlarmType {
  AlarmType({
    @required this.color,
    @required this.name,
    @required this.imagePath,
  });

  Color color;
  String name;
  String imagePath;
}

class Attachment {
  Attachment({
    @required this.type,
    @required this.fileName,
    @required this.url,
    @required this.size,
  });

  String fileName;
  String url;
  int type;
  String size;

  String get imagePath{
    switch (type){
      case 0:
        return "assets/images/icon_attachment_image.png";
      case 1:
        return "assets/images/icon_attachment_doc.png";
      case 2:
        return "assets/images/icon_attachment_xls.png";
      case 3:
        return "assets/images/icon_attachment_pdf.png";
      default:
        return "assets/images/icon_attachment_other.png";
    }
  }
}

class DealStep {
  DealStep({
    @required this.dealType,
    @required this.dealPerson,
    @required this.dealTime,
    @required this.dealRemark,
    @required this.attachmentList,
  });

  String dealType;
  String dealPerson;
  String dealTime;
  String dealRemark;
  List<Attachment> attachmentList;
}
