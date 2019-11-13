import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/res/constant.dart';

//传入时间戳，使得每次都触发状态改变
abstract class LongStopReportListState extends Equatable{
  const LongStopReportListState();

  @override
  List<Object> get props => [DateTime.now()];
}

class LongStopReportListLoading extends LongStopReportListState {}

class LongStopReportListLoaded extends LongStopReportListState {
  //异常申报单列表
  final reportList;

  //能否加载更多
  final bool hasNextPage;

  final int pageSize;

  final int currentPage;

  const LongStopReportListLoaded({
    @required this.reportList,
    @required this.hasNextPage,
    this.currentPage = Constant.defaultCurrentPage,
    this.pageSize = Constant.defaultPageSize,
  });
}

//异常申报单列表页没有数据的状态
class LongStopReportListEmpty extends LongStopReportListState {}

//异常申报单列表页发生错误的状态
class LongStopReportListError extends LongStopReportListState {
  final String errorMessage;

  const LongStopReportListError({@required this.errorMessage});
}
