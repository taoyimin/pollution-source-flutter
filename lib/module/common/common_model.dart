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