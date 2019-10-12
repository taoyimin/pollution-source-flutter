import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class IndexData extends Equatable {
  IndexData([List props = const []]) : super(props);
}

//空气质量统计
class AqiStatistics extends IndexData {
  final String key;
  final bool show;
  final String areaName;
  final String updateTime;
  final String aqi;
  final String aqiLevel;
  final String pp;
  final String pm25;
  final String pm10;
  final String so2;
  final String no2;
  final String o3;
  final String co;

  AqiStatistics({
    @required this.key,
    @required this.show,
    this.areaName,
    this.updateTime,
    this.aqi,
    this.aqiLevel,
    this.pp,
    this.pm25,
    this.pm10,
    this.so2,
    this.no2,
    this.o3,
    this.co,
  }) : super([
          key,
          show,
          areaName,
          updateTime,
          aqi,
          aqiLevel,
          pp,
          pm25,
          pm10,
          so2,
          no2,
          o3,
          co,
        ]);

  @override
  String toString() {
    return 'AqiStatistics{key: $key, show: $show, areaName: $areaName, updateTime: $updateTime, aqi: $aqi, aqiLevel: $aqiLevel, pp: $pp, pm25: $pm25, pm10: $pm10, so2: $so2, no2: $no2, o3: $o3, co: $co}';
  }
}

//空气质量考核
class AqiExamine extends IndexData {
  final String key;
  final bool show;
  final String title; //标题
  final String imagePath; //图片路径
  final Color color; //颜色
  final String title1;
  final String value1;
  final String title2;
  final String value2;
  final String title3;
  final String value3;

  AqiExamine({
    @required this.key,
    @required this.show,
    this.title,
    this.imagePath,
    this.color,
    this.title1,
    this.value1,
    this.title2,
    this.value2,
    this.title3,
    this.value3,
  }) : super([
          key,
          show,
          title,
          imagePath,
          title1,
          value1,
          title2,
          value2,
          title3,
          value3,
        ]);

  @override
  String toString() {
    return 'AqiExamine{key: $key, show: $show, title: $title, imagePath: $imagePath, color: $color, title1: $title1, value1: $value1, title2: $title2, value2: $value2, title3: $title3, value3: $value3}';
  }
}

//地表水统计
class WaterStatistics extends IndexData {
  final String key;
  final bool show;
  final String title; //标题
  final String imagePath; //图片路径
  final Color color; //颜色
  final String count; //数量
  final String achievementRate; //达标率
  final String monthOnMonth; //环比
  final String yearOnYear; //同比

  WaterStatistics({
    this.key,
    this.show,
    this.title,
    this.imagePath,
    this.color,
    this.count,
    this.achievementRate,
    this.monthOnMonth,
    this.yearOnYear,
  }) : super([
          key,
          show,
          title,
          imagePath,
          color,
          count,
          achievementRate,
          monthOnMonth,
        ]);

  @override
  String toString() {
    return 'WaterStatistics{key: $key, show: $show, title: $title, imagePath: $imagePath, color: $color, count: $count, achievementRate: $achievementRate, monthOnMonth: $monthOnMonth, yearOnYear: $yearOnYear}';
  }
}

//代办任务统计
/*class TodoTaskStatistics extends IndexData {
  final String key;
  final bool show;
  final String title; //标题
  final String count; //个数
  final String imagePath; //图片路径

  TodoTaskStatistics({
    this.key,
    this.show,
    this.title,
    this.count,
    this.imagePath,
  }) : super([
          key,
          show,
          title,
          count,
          imagePath,
        ]);

  @override
  String toString() {
    return 'TodoTaskStatistics{key: $key, show: $show, title: $title, count: $count, imagePath: $imagePath}';
  }
}*/

//综合统计信息
/*class ComprehensiveStatistics extends IndexData {
  final String key;
  final bool show;
  final String title; //标题
  final String count; //个数
  final Color color; //图标颜色
  final String imagePath; //图片路径

  ComprehensiveStatistics({
    this.key,
    this.show,
    this.title,
    this.count,
    this.color,
    this.imagePath,
  }) : super([
          key,
          show,
          title,
          count,
          color,
          imagePath,
        ]);

  @override
  String toString() {
    return 'ComprehensiveStatistics{key: $key, show: $show, title: $title, count: $count, color: $color, imagePath: $imagePath}';
  }
}*/
