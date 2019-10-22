import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/util/constant.dart';

//传入时间戳，使得每次都触发状态改变
abstract class MonitorListState extends Equatable {
  const MonitorListState();

  @override
  List<Object> get props => [DateTime.now()];
}

class MonitorListLoading extends MonitorListState {}

class MonitorListLoaded extends MonitorListState {
  //监控点列表
  final monitorList;

  //能否加载更多
  final bool hasNextPage;

  final int pageSize;

  final int currentPage;

  const MonitorListLoaded({
    @required this.monitorList,
    @required this.hasNextPage,
    this.currentPage = Constant.defaultCurrentPage,
    this.pageSize = Constant.defaultPageSize,
  });
}

//监控点列表页没有数据的状态
class MonitorListEmpty extends MonitorListState {}

//监控点列表页发生错误的状态
class MonitorListError extends MonitorListState {
  final String errorMessage;

  const MonitorListError({@required this.errorMessage});
}
