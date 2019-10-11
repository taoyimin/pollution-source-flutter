import 'package:equatable/equatable.dart';

//报警管理单
class Monitor extends Equatable {
  final String enterName;
  final String monitorName;
  final String address;
  final String number;  //数采编码
  final int monitorType;
  final String monitorTypeName;
  final String imagePath;
  final String area;

  Monitor({
    this.enterName,
    this.monitorName,
    this.address,
    this.number,
    this.monitorType,
    this.monitorTypeName,
    this.imagePath,
    this.area,
  }) : super([
          enterName,
          monitorName,
          address,
          number,
          monitorType,
          monitorTypeName,
          imagePath,
          area,
        ]);

  static Monitor fromJson(dynamic json) {
    return Monitor(
      enterName: json['enterName'],
      monitorName: json['monitorName'],
      address: json['address'],
      number: json['number'],
      monitorType: json['monitorType'],
      monitorTypeName: json['monitorTypeName'],
      area: json['areaName'],
      imagePath: _getMonitorTypeImage(json['monitorType']),
    );
  }

  //根据监控点类型获取图片
  static String _getMonitorTypeImage(int monitorType) {
    switch (monitorType) {
      case 0:
        //废水
        return 'assets/images/icon_water_monitor.png';
      case 1:
        //废气
        return 'assets/images/icon_air_monitor.png';
      default:
        //未知
        return 'assets/images/icon_unknown_monitor.png';
    }
  }
}
