import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/res/colors.dart';

//标签
class Label extends Equatable {
  final Color color;
  final String name;
  final String imagePath;

  Label({
    this.color,
    this.name,
    this.imagePath,
  }) : super([
    color,
    name,
    imagePath,
  ]);
}

//元数据
class Meta extends Equatable {
  final String title; //标题
  final String content; //内容
  final Color color; //颜色
  final String imagePath; //图标路径
  final String backgroundPath; //背景图片路径

  Meta({
    this.title ='标题',
    this.content= '内容',
    this.color = Colours.primary_color,
    this.imagePath = '',
    this.backgroundPath = '',
  }) : super([
    title,
    content,
    color,
    imagePath,
    backgroundPath,
  ]);
}

//附件类
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

//处理流程
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