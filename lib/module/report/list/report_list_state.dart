import 'package:meta/meta.dart';
import 'package:pollution_source/util/constant.dart';

//不继承equatable，确保每次刷新都会触发状态改变的监听
abstract class ReportListState{
}

class ReportListLoading extends ReportListState {
  @override
  String toString() => 'ReportListLoading';
}

class ReportListLoaded extends ReportListState {
  //异常申报单列表
  final reportList;

  //能否加载更多
  final bool hasNextPage;

  final int pageSize;

  final int currentPage;

  ReportListLoaded({
    @required this.reportList,
    @required this.hasNextPage,
    this.currentPage = Constant.defaultCurrentPage,
    this.pageSize = Constant.defaultPageSize,
  });
}

//异常申报单列表页没有数据的状态
class ReportListEmpty extends ReportListState {
  @override
  String toString() => 'ReportListEmpty';
}

//异常申报单列表页发生错误的状态
class ReportListError extends ReportListState {
  final errorMessage;

  ReportListError({@required this.errorMessage});

  @override
  String toString() => 'ReportListError';
}
