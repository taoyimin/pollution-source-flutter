import 'dart:ui';

import 'package:equatable/equatable.dart';

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

//统计
class Statistics extends Equatable {
  final String title; //标题
  final String count; //个数
  final Color color; //图标颜色
  final String imagePath; //图标路径

  Statistics({
    this.title,
    this.count,
    this.color,
    this.imagePath,
  }) : super([
    title,
    count,
    color,
    imagePath,
  ]);
}