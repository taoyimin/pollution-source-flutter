import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/res/colors.dart';

part 'common_model.g.dart';

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
@JsonSerializable()
class Attachment extends Equatable {
  final String fileName; //文件名
  final String url; //完整路径
  final int size; //附件大小

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
    if (url.endsWith('.jpg') || url.endsWith('.png')) {
      return "assets/images/icon_attachment_image.png";
    } else if (url.endsWith('.doc') || url.endsWith('.docx')) {
      return "assets/images/icon_attachment_doc.png";
    } else if (url.endsWith('.xls') || url.endsWith('.xlsx')) {
      return "assets/images/icon_attachment_xls.png";
    } else if (url.endsWith('.pdf')) {
      return "assets/images/icon_attachment_pdf.png";
    } else {
      return "assets/images/icon_attachment_other.png";
    }
  }

  String get fileSize {
    if (size < 1024 * 1024) {
      //小于1M
      return '${(size.toDouble() / (1024)).toStringAsFixed(2)}KB';
    } else {
      return '${(size.toDouble() / (1024 * 1024)).toStringAsFixed(2)}M';
    }
  }

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);

/*static Attachment fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spUseJavaApi, defValue: Constant.defaultUseJavaApi)) {
      return Attachment(
        fileName: json['File_Name'],
        url: json['Url'],
        size: int.parse(json['Size']),
      );
    }else{
      return Attachment(
        fileName: json['fileName'],
        url: json['url'],
        size: json['size'],
      );
    }
  }

  static List<Attachment> fromJsonArray(dynamic jsonArray) {
    return jsonArray.map<Attachment>((json) {
      return Attachment.fromJson(json);
    }).toList();
  }*/
}

//处理流程
@JsonSerializable()
class Process extends Equatable {
  final String operateTypeStr; //操作类型
  final String operatePerson; //操作人
  final String operateTimeStr; //操作时间
  final String operateDesc; //操作描述
  final List<Attachment> attachments; //附件

  const Process({
    @required this.operateTypeStr,
    @required this.operatePerson,
    @required this.operateTimeStr,
    @required this.operateDesc,
    @required this.attachments,
  });

  @override
  List<Object> get props => [
        operateTypeStr,
        operatePerson,
        operateTimeStr,
        operateDesc,
        attachments,
      ];

  factory Process.fromJson(Map<String, dynamic> json) =>
      _$ProcessFromJson(json);

  Map<String, dynamic> toJson() => _$ProcessToJson(this);

/*  static Process fromJson(dynamic json) {
    return Process(
      operateTypeStr: json['operateTypeStr'],
      operatePerson: json['operatePerson'],
      operateTimeStr: json['operateTimeStr'],
      operateDesc: json['operateDesc'],
      attachmentList: Attachment.fromJsonArray(json['attachments']),
    );
  }

  static List<Process> fromJsonArray(dynamic jsonArray) {
    return jsonArray.map<Process>((json) {
      return Process.fromJson(json);
    }).toList();
  }*/
}

//坐标点信息 用于记录因子在某个时间的监测值
class PointData extends Equatable {
  final double x; //时间戳
  final double y; //监测值

  const PointData({
    @required this.x,
    @required this.y,
  });

  @override
  List<Object> get props => [x, y];
}

//因子监测数据 记录了一个因子在一段时间内的监测数据
class ChartData extends Equatable {
  final String factorName; //因子名称
  final bool checked; //是否选中
  final String lastValue; //最新的监测值
  final String unit; //单位
  final double maxX; //最大X值
  final double minX; //最小X值
  final double maxY; //最大Y值
  final double minY; //最小Y值
  final Color color; //颜色
  final List<PointData> points; //坐标点集合

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

/// 数据字典类
///
/// [checked]默认为false，只有多选时才会用到
@JsonSerializable()
class DataDict extends Equatable {
  final String code;
  final String name;
  final bool checked;

  const DataDict({
    @required this.code,
    @required this.name,
    this.checked = false,
  });

  @override
  List<Object> get props => [
        code,
        name,
        checked,
      ];

  DataDict copyWith({
    String code,
    String name,
    bool checked,
  }) {
    return DataDict(
      code: code ?? this.code,
      name: name ?? this.name,
      checked: checked ?? this.checked,
    );
  }

  factory DataDict.fromJson(Map<String, dynamic> json) =>
      _$DataDictFromJson(json);

  Map<String, dynamic> toJson() => _$DataDictToJson(this);
}
