import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/res/colors.dart';
import 'package:pollution_source/util/common_utils.dart';
import 'package:pollution_source/util/ui_utils.dart';

part 'common_model.g.dart';

/// 标签
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

/// 元数据
class Meta extends Equatable {
  final String title; // 标题
  final String content; // 内容
  final Color color; // 颜色
  final String imagePath; // 图标路径
  final String backgroundPath; // 背景图片路径
  final String router; // 路由

  const Meta({
    this.title,
    this.content,
    this.color = Colours.primary_color,
    this.imagePath,
    this.backgroundPath,
    this.router,
  });

  @override
  List<Object> get props => [
        title,
        content,
        color,
        imagePath,
        backgroundPath,
        router,
      ];
}

/// 附件类
@JsonSerializable()
class Attachment extends Equatable {
  final String fileName; //文件名
  @JsonKey(name: 'showUrl')
  final String url; //完整路径
  final String size; //附件大小

  const Attachment({
    @required this.fileName,
    @required this.url,
    @required this.size,
  });

  @override
  List<Object> get props => [
        fileName,
        url,
        size,
      ];

  String get imagePath {
    if (fileName == null) return "assets/images/icon_attachment_other.png";
    if (fileName.toLowerCase().endsWith('.jpg') ||
        fileName.toLowerCase().endsWith('.png') ||
        fileName.toLowerCase().endsWith('.jpeg')) {
      return "assets/images/icon_attachment_image.png";
    } else if (fileName.toLowerCase().endsWith('.doc') ||
        fileName.toLowerCase().endsWith('.docx')) {
      return "assets/images/icon_attachment_doc.png";
    } else if (fileName.toLowerCase().endsWith('.xls') ||
        fileName.toLowerCase().endsWith('.xlsx')) {
      return "assets/images/icon_attachment_xls.png";
    } else if (fileName.toLowerCase().endsWith('.pdf')) {
      return "assets/images/icon_attachment_pdf.png";
    } else {
      return "assets/images/icon_attachment_other.png";
    }
  }

  String get fileSize {
    return CommonUtils.formatSize(double.parse(size));
  }

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}

/// 坐标点信息 用于记录因子在某个时间的监测值
@JsonSerializable()
class PointData extends Equatable {
  final double x; //时间戳
  final double y; //监测值

  const PointData({
    @required this.x,
    @required this.y,
  });

  @override
  List<Object> get props => [x, y];

  factory PointData.fromJson(Map<String, dynamic> json) =>
      _$PointDataFromJson(json);

  Map<String, dynamic> toJson() => _$PointDataToJson(this);
}

/// 因子监测数据 记录了一个因子在一段时间内的监测数据
class ChartData extends Equatable {
  final String factorName; // 因子名称
  final bool checked; // 是否选中
  final String value; // 最新的监测值
  final int time; // 最新的监测时间
  final String alarmFlag; // 报警类型
  final String unit; // 单位
  final double maxX; // 最大X值
  final double minX; // 最小X值
  final double maxY; // 最大Y值
  final double minY; // 最小Y值
  final Color color; // 颜色
  final List<PointData> points; // 坐标点集合

  const ChartData({
    @required this.factorName,
    @required this.checked,
    @required this.value,
    @required this.time,
    @required this.alarmFlag,
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
        value,
        time,
        alarmFlag,
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
      value: this.value,
      time: this.time,
      alarmFlag: this.alarmFlag,
      unit: this.unit,
      color: this.color,
      maxX: this.maxX,
      maxY: this.maxY,
      minX: this.minX,
      minY: this.minY,
      points: this.points,
    );
  }

  factory ChartData.fromJson(Map<String, dynamic> json) =>
      _$ChartDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChartDataToJson(this);
}

ChartData _$ChartDataFromJson(Map<String, dynamic> json) {
  List<PointData> points = (json['points'] as List)
      ?.map((e) =>
          e == null ? null : PointData.fromJson(e as Map<String, dynamic>))
      ?.toList();
  return ChartData(
      factorName: json['factorName'] as String,
      unit: json['unit'] as String,
      value: json['value'].toString(),
      time: json['time'] as int,
      alarmFlag: json['alarmFlag'] as String,
      checked: points.length != 0,
      color: UIUtils.getRandomColor(),
      maxX: CommonUtils.getMax(points.map((point) {
        return point.x;
      }).toList()),
      minX: CommonUtils.getMin(points.map((point) {
        return point.x;
      }).toList()),
      maxY: CommonUtils.getMax(points.map((point) {
        return point.y;
      }).toList()),
      minY: CommonUtils.getMin(points.map((point) {
        return point.y;
      }).toList()),
      points: points);
}

Map<String, dynamic> _$ChartDataToJson(ChartData instance) => <String, dynamic>{
      'factorName': instance.factorName,
      'unit': instance.unit,
      'value': instance.value,
      'time': instance.time,
      'points': instance.points
    };

/// 系统配置类
@JsonSerializable()
class SystemConfig extends Equatable {
  @JsonKey(name: 'dicDesc')
  final String desc;
  @JsonKey(name: 'dicValue')
  final String value;

  const SystemConfig({
    @required this.desc,
    @required this.value,
  });

  @override
  List<Object> get props => [
        desc,
        value,
      ];

  factory SystemConfig.fromJson(Map<String, dynamic> json) =>
      _$SystemConfigFromJson(json);

  Map<String, dynamic> toJson() => _$SystemConfigToJson(this);
}
