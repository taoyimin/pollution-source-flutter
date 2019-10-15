import 'package:equatable/equatable.dart';

abstract class MonitorListEvent extends Equatable {
  MonitorListEvent([List props = const []]) : super(props);
}

class MonitorListLoad extends MonitorListEvent {
  //是否刷新
  final bool isRefresh;

  //按企业名称搜索
  final String enterName;

  //按区域搜索
  final String areaCode;

  //监控点类型 outletType1:雨水 outletType2:废水 outletType3:废气
  final String monitorType;

  MonitorListLoad({
    this.isRefresh = false,
    this.enterName = '',
    this.areaCode = '',
    this.monitorType = '',
  }) : super([
          isRefresh,
          enterName,
          areaCode,
          monitorType,
        ]);

  @override
  String toString() => 'MonitorListLoad';
}
