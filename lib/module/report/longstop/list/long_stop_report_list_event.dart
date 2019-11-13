import 'package:equatable/equatable.dart';

abstract class LongStopReportListEvent extends Equatable {
  const LongStopReportListEvent();

  @override
  List<Object> get props => [];
}

class LongStopReportListLoad extends LongStopReportListEvent {
  //是否刷新
  final bool isRefresh;

  //按企业名称搜索
  final String enterName;

  //按区域搜索
  final String areaCode;

  //企业ID
  final String enterId;

  const LongStopReportListLoad({
    this.isRefresh = false,
    this.enterName = '',
    this.areaCode = '',
    this.enterId = '',
  });

  @override
  List<Object> get props => [
    isRefresh,
    enterName,
    areaCode,
    enterId,
  ];
}
