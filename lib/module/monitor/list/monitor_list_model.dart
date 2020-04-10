import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'monitor_list_model.g.dart';

/// 监控点列表
@JsonSerializable()
class Monitor extends Equatable {
  @JsonKey(name: 'outId')
  final int dischargeId; // 排口ID
  final int monitorId; // 监控点ID
  @JsonKey(name: 'enterpriseName')
  final String enterName; // 企业名称
  @JsonKey(name: 'disMonitorName')
  final String monitorName; // 监控点名称
  @JsonKey(name: 'disMonitorType')
  final String monitorType; // 监控点类型
  @JsonKey(name: 'outletTypeStr')
  final String monitorCategoryStr; // 监控点类别

  const Monitor({
    this.dischargeId,
    this.monitorId,
    this.enterName,
    this.monitorName,
    this.monitorType,
    this.monitorCategoryStr,
  });

  @override
  List<Object> get props => [
        dischargeId,
        monitorId,
        enterName,
        monitorName,
        monitorType,
        monitorCategoryStr,
      ];

  String get imagePath {
    return _getMonitorTypeImage(monitorType);
  }

  factory Monitor.fromJson(Map<String, dynamic> json) =>
      _$MonitorFromJson(json);

  Map<String, dynamic> toJson() => _$MonitorToJson(this);

  //根据监控点类型获取图片
  static String _getMonitorTypeImage(String monitorType) {
    switch (monitorType) {
      case 'outletType1':
        // 雨水
        return 'assets/images/icon_unknown_monitor.png';
      case 'outletType2':
        // 废水
        return 'assets/images/icon_water_monitor.png';
      case 'outletType3':
        // 废气
        return 'assets/images/icon_air_monitor.png';
      default:
        // 未知
        return 'assets/images/icon_unknown_monitor.png';
    }
  }
}
