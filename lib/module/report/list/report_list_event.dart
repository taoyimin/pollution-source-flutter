import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ReportListEvent extends Equatable {
  const ReportListEvent();

  @override
  List<Object> get props => [];
}

class ReportListLoad extends ReportListEvent {
  //是否刷新
  final bool isRefresh;

  //按企业名称搜索
  final String enterName;

  //按区域搜索
  final String areaCode;

  //企业ID
  final String enterId;

  //异常类型 0：排口异常 1：因子异常
  final String type;

  //异常申报单状态 0：未审核 1：已审核 2：审核不通过
  final String state;

  const ReportListLoad({
    this.isRefresh = false,
    this.enterName = '',
    this.areaCode = '',
    this.enterId = '',
    @required this.type,
    this.state = '',
  });

  @override
  List<Object> get props => [
        isRefresh,
        enterName,
        areaCode,
        enterId,
        type,
        state,
      ];
}
