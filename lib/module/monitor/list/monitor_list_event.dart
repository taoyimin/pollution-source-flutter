import 'package:equatable/equatable.dart';

abstract class MonitorListEvent extends Equatable {
  const MonitorListEvent();

  @override
  List<Object> get props => [];
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

  //监控点状态 online:在线 warn:预警 outrange:超标 offline:脱机 stopline:停产
  final String state;

  const MonitorListLoad({
    this.isRefresh = false,
    this.enterName = '',
    this.areaCode = '',
    this.monitorType = '',
    this.state = '',
  });

  @override
  List<Object> get props => [
        isRefresh,
        enterName,
        areaCode,
        monitorType,
        state,
      ];
}
