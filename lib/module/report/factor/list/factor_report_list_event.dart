import 'package:equatable/equatable.dart';

abstract class FactorReportListEvent extends Equatable {
  const FactorReportListEvent();

  @override
  List<Object> get props => [];
}

class FactorReportListLoad extends FactorReportListEvent {
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

  //监控点ID
  final String monitorId;

  //异常申报单状态 0：未审核 1：已审核 2：审核不通过
  final String state;

  const FactorReportListLoad({
    this.isRefresh = false,
    this.enterName = '',
    this.areaCode = '',
    this.enterId = '',
    this.dischargeId = '',
    this.monitorId = '',
    this.state = '',
  });

  @override
  List<Object> get props => [
    isRefresh,
    enterName,
    areaCode,
    enterId,
    dischargeId,
    monitorId,
    state,
  ];
}
