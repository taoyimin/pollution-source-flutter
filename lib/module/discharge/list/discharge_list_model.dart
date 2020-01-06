import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discharge_list_model.g.dart';

//排口列表
@JsonSerializable()
class Discharge extends Equatable {
  @JsonKey(name: 'outId')
  final int dischargeId; //排口ID
  @JsonKey(name: 'enterpriseName')
  final String enterName; //企业名称
  @JsonKey(name: 'disOutName')
  final String dischargeName; //排口名称
  @JsonKey(name: 'disOutAddress')
  final String dischargeAddress; //排口地址
  @JsonKey(name: 'disOutType')
  final String dischargeType; //排口类型
  @JsonKey(name: 'disOutTypeStr')
  final String dischargeTypeStr; //排口类型
  @JsonKey(name: 'outletTypeStr')
  final String dischargeCategoryStr; //排口类别
  @JsonKey(name: 'disOutRuleStr')
  final String dischargeRuleStr; //排放规律

  const Discharge({
    this.dischargeId,
    this.enterName,
    this.dischargeName,
    this.dischargeAddress,
    this.dischargeType,
    this.dischargeTypeStr,
    this.dischargeCategoryStr,
    this.dischargeRuleStr,
  });

  @override
  List<Object> get props => [
        dischargeId,
        enterName,
        dischargeName,
        dischargeAddress,
        dischargeType,
        dischargeTypeStr,
        dischargeCategoryStr,
        dischargeRuleStr,
      ];

  String get imagePath {
    return _getMonitorTypeImage(dischargeType);
  }

  factory Discharge.fromJson(Map<String, dynamic> json) =>
      _$DischargeFromJson(json);

  Map<String, dynamic> toJson() => _$DischargeToJson(this);

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
