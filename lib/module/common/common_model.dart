import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/res/colors.dart';

//标签
class Label extends Equatable {
  final Color color;
  final String name;
  final String imagePath;

  const Label({
    this.color,
    this.name,
    this.imagePath,
  });

  @override
  List<Object> get props => [
        color,
        name,
        imagePath,
      ];
}

//元数据
class Meta extends Equatable {
  final String title; //标题
  final String content; //内容
  final Color color; //颜色
  final String imagePath; //图标路径
  final String backgroundPath; //背景图片路径

  const Meta({
    this.title = '标题',
    this.content = '内容',
    this.color = Colours.primary_color,
    this.imagePath = '',
    this.backgroundPath = '',
  });

  @override
  List<Object> get props => [
        title,
        content,
        color,
        imagePath,
        backgroundPath,
      ];
}

//附件类
class Attachment extends Equatable {
  final String fileName;
  final String url;
  final int type;
  final String size;

  const Attachment({
    @required this.type,
    @required this.fileName,
    @required this.url,
    @required this.size,
  });

  @override
  List<Object> get props => [
        type,
        fileName,
        url,
        size,
      ];

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

  const DealStep({
    @required this.dealType,
    @required this.dealPerson,
    @required this.dealTime,
    @required this.dealRemark,
    @required this.attachmentList,
  });

  @override
  List<Object> get props => [
        dealType,
        dealPerson,
        dealTime,
        dealRemark,
        attachmentList,
      ];
}

//坐标点信息 用于记录因子在某个时间的监测值
class PointData extends Equatable {
  final double x;
  final double y;

  const PointData({
    @required this.x,
    @required this.y,
  });

  @override
  List<Object> get props => [x, y];
}

//因子监测数据 记录了一个因子在一段时间内的监测数据
class ChartData extends Equatable {
  final String factorName;
  final bool checked;
  final String lastValue;
  final String unit;
  final double maxX;
  final double minX;
  final double maxY;
  final double minY;
  final Color color;
  final List<PointData> points;

  const ChartData({
    @required this.factorName,
    @required this.checked,
    @required this.lastValue,
    @required this.unit,
    @required this.color,
    @required this.maxX,
    @required this.maxY,
    @required this.minX,
    @required this.minY,
    @required this.points,
  });

  @override
  List<Object> get props => [
        factorName,
        checked,
        lastValue,
        unit,
        color,
        maxX,
        maxY,
        minX,
        minY,
        points,
      ];

  ChartData copyWith({bool checked}) {
    return ChartData(
      factorName: this.factorName,
      checked: checked ?? this.checked,
      lastValue: this.lastValue,
      unit: this.unit,
      color: this.color,
      maxX: this.maxX,
      maxY: this.maxY,
      minX: this.minX,
      minY: this.minY,
      points: this.points,
    );
  }
}
