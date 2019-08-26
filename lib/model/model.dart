import 'dart:ui';

class Water {
  Water(this.title, this.imagePath, this.count, this.achievementRate, this.monthOnMonth, this.yearOnYear);

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
  int count;  //个数
  Color color;  //图标颜色
  String imagePath; //图片路径
}
