import 'package:equatable/equatable.dart';

abstract class MonitorListEvent extends Equatable {
  const MonitorListEvent();

  @override
  List<Object> get props => [];
}

class MonitorListLoad extends MonitorListEvent {
  final bool isRefresh; //是否刷新
  final String enterName; //按企业名称搜索
  final String areaCode; //按区域搜索
  final String enterId; //企业ID
  final String monitorType; //监控点类型 outletType1:雨水 outletType2:废水 outletType3:废气
  final String
      state; //监控点状态 online:在线 warn:预警 outrange:超标 offline:脱机 stopline:停产

  const MonitorListLoad({
    this.isRefresh = false,
    this.enterName = '',
    this.areaCode = '',
    this.enterId = '',
    this.monitorType = '',
    this.state = '',
  });

  @override
  List<Object> get props => [
        isRefresh,
        enterName,
        areaCode,
        enterId,
        monitorType,
        state,
      ];
}
