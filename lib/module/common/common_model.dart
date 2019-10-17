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
    this.title = '标题',
    this.content = '内容',
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
class Attachment extends Equatable {
  final String fileName;
  final String url;
  final int type;
  final String size;

  Attachment({
    @required this.type,
    @required this.fileName,
    @required this.url,
    @required this.size,
  }) : super([
          type,
          fileName,
          url,
          size,
        ]);

  String get imagePath {
    switch (type) {
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
class DealStep extends Equatable {
  final String dealType;
  final String dealPerson;
  final String dealTime;
  final String dealRemark;
  final List<Attachment> attachmentList;

  DealStep({
    @required this.dealType,
    @required this.dealPerson,
    @required this.dealTime,
    @required this.dealRemark,
    @required this.attachmentList,
  }) : super([
          dealType,
          dealPerson,
          dealTime,
          dealRemark,
          attachmentList,
        ]);
}

class PointData extends Equatable {
  final double x;
  final double y;

  PointData({
    @required this.x,
    @required this.y,
  }) : super([
          x,
          y,
        ]);
}

class ChartData extends Equatable {
  final String factorName;
  final bool show;
  final double maxX;
  final double minX;
  final double maxY;
  final double minY;
  final Color color;
  final List<PointData> points;

  ChartData({
    @required this.factorName,
    @required this.show,
    @required this.color,
    @required this.maxX,
    @required this.maxY,
    @required this.minX,
    @required this.minY,
    @required this.points,
  }) : super([
          factorName,
          show,
          color,
          maxX,
          maxY,
          minX,
          minY,
          points,
        ]);
}
