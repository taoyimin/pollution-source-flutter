import 'package:meta/meta.dart';
import 'package:pollution_source/util/constant.dart';

//不继承equatable，确保每次刷新都会触发状态改变的监听
abstract class OrderListState{
}

class OrderListLoading extends OrderListState {
  @override
  String toString() => 'OrderListLoading';
}

class OrderListLoaded extends OrderListState {
  //报警管理单列表
  final orderList;

  //能否加载更多
  final bool hasNextPage;

  final int pageSize;

  final int currentPage;

  OrderListLoaded({
    @required this.orderList,
    @required this.hasNextPage,
    this.currentPage = Constant.defaultCurrentPage,
    this.pageSize = Constant.defaultPageSize,
  });
}

//报警管理单列表页没有数据的状态
class OrderListEmpty extends OrderListState {
  @override
  String toString() => 'OrderListEmpty';
}

//报警管理单列表页发生错误的状态
class OrderListError extends OrderListState {
  final errorMessage;

  OrderListError({@required this.errorMessage});

  @override
  String toString() => 'OrderListError';
}
