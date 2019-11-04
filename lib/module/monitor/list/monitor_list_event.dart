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

  //企业ID
  final String enterId;

  //排口ID
  final String dischargeId;

  //监控点类型 outletType1:雨水 outletType2:废水 outletType3:废气
  final String monitorType;

  //监控点状态 0:全部 1:在线 2:预警 3:超标 4:脱机 5:停产
  final String state;

  const MonitorListLoad({
    this.isRefresh = false,
    this.enterName = '',
    this.areaCode = '',
    this.enterId = '',
    this.dischargeId = '',
    this.monitorType = '',
    this.state = '',
  });

  @override
  List<Object> get props => [
        isRefresh,
        enterName,
        areaCode,
        enterId,
        dischargeId,
        monitorType,
        state,
      ];
}
