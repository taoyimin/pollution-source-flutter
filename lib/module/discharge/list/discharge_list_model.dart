import 'package:equatable/equatable.dart';
import 'package:flustars/flustars.dart';
import 'package:pollution_source/res/constant.dart';

//排口列表
class Discharge extends Equatable {
  final String dischargeId; //排口ID
  final String enterName; //企业名称
  final String dischargeName; //排口名称
  final String dischargeAddress; //排口地址
  final String dischargeTypeStr; //排口类型
  final String dischargeCategoryStr; //排口类别
  final String dischargeRuleStr; //排放规律
  final String imagePath; //排口logo

  const Discharge({
    this.dischargeId,
    this.enterName,
    this.dischargeName,
    this.dischargeAddress,
    this.dischargeTypeStr,
    this.dischargeCategoryStr,
    this.dischargeRuleStr,
    this.imagePath,
  });

  @override
  List<Object> get props => [
        dischargeId,
        enterName,
        dischargeName,
        dischargeAddress,
        dischargeTypeStr,
        dischargeCategoryStr,
        dischargeRuleStr,
        imagePath,
      ];

  static Discharge fromJson(dynamic json) {
    if (SpUtil.getBool(Constant.spJavaApi, defValue: true)) {
      return Discharge(
        dischargeId: '0*',
        enterName: '-',
        dischargeName: '-',
        dischargeAddress: '-',
        dischargeTypeStr: '-',
        dischargeCategoryStr: '-',
        dischargeRuleStr: '-',
        imagePath: _getMonitorTypeImage('-'),
      );
    } else {
      return Discharge(
        dischargeId: json['dischargeId'],
        enterName: json['enterName'],
        dischargeName: json['dischargeName'],
        dischargeAddress: json['dischargeAddress'],
        dischargeTypeStr: json['dischargeTypeStr'],
        dischargeCategoryStr: json['dischargeCategoryStr'],
        dischargeRuleStr: json['dischargeRuleStr'],
        imagePath: _getMonitorTypeImage(json['dischargeType']),
      );
    }
  }

  //根据排口类型获取图片
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
