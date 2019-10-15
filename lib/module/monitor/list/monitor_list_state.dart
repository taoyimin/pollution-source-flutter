import 'package:meta/meta.dart';
import 'package:pollution_source/util/constant.dart';

//不继承equatable，确保每次刷新都会触发状态改变的监听
abstract class MonitorListState{
}

class MonitorListLoading extends MonitorListState {
  @override
  String toString() => 'MonitorListLoading';
}

class MonitorListLoaded extends MonitorListState {
  //监控点列表
  final monitorList;

  //能否加载更多
  final bool hasNextPage;

  final int pageSize;

  final int currentPage;

  MonitorListLoaded({
    @required this.monitorList,
    @required this.hasNextPage,
    this.currentPage = Constant.defaultCurrentPage,
    this.pageSize = Constant.defaultPageSize,
  });
}

//监控点列表页没有数据的状态
class MonitorListEmpty extends MonitorListState {
  @override
  String toString() => 'MonitorListEmpty';
}

//监控点列表页发生错误的状态
class MonitorListError extends MonitorListState {
  final errorMessage;

  MonitorListError({@required this.errorMessage});

  @override
  String toString() => 'MonitorListError';
}
