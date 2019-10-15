import 'package:equatable/equatable.dart';

abstract class ReportListEvent extends Equatable {
  ReportListEvent([List props = const []]) : super(props);
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

  ReportListLoad({
    this.isRefresh = false,
    this.enterName = '',
    this.areaCode = '',
    this.state = '',
  }) : super([
          isRefresh,
          enterName,
          areaCode,
          state,
        ]);

  @override
  String toString() => 'ReportListLoad';
}
