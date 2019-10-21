import 'package:equatable/equatable.dart';

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

  //异常申报单状态
  final String state;

  const ReportListLoad({
    this.isRefresh = false,
    this.enterName = '',
    this.areaCode = '',
    this.state = '',
  });

  @override
  List<Object> get props => [
        isRefresh,
        enterName,
        areaCode,
        state,
      ];
}
