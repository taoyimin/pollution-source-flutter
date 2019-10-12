import 'package:equatable/equatable.dart';

//报警管理单
class Monitor extends Equatable {
  final String enterMonitorName;
  final String monitorName;
  final String address;
  final String monitorType;
  final String imagePath;
  final String area;

  Monitor({
    this.enterMonitorName,
    this.monitorName,
    this.address,
    this.monitorType,
    this.imagePath,
    this.area,
  }) : super([
    enterMonitorName,
          monitorName,
          address,
          monitorType,
          imagePath,
          area,
        ]);

  static Monitor fromJson(dynamic json) {
    return Monitor(
      enterMonitorName: json['disoutshortname'],
      monitorName: json['disoutname'],
      address: json['disoutaddress'],
      monitorType: json['disouttype'],
      area: '没有该字段',
      imagePath: _getMonitorTypeImage(json['disouttype']),
    );
  }

  //根据监控点类型获取图片
  static String _getMonitorTypeImage(String monitorType) {
    switch (monitorType) {
      case 'outletType1':
        //雨水
        return 'assets/images/icon_unknown_monitor.png';
      case 'outletType2':
      //废水
        return 'assets/images/icon_water_monitor.png';
      case 'outletType3':
        //废气
        return 'assets/images/icon_air_monitor.png';
      default:
        //未知
        return 'assets/images/icon_unknown_monitor.png';
    }
  }
}
