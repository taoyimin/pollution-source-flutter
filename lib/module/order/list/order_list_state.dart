import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/res/constant.dart';

//传入时间戳，使得每次都触发状态改变
abstract class OrderListState extends Equatable{
  const OrderListState();

  @override
  List<Object> get props => [DateTime.now()];
}

class OrderListLoading extends OrderListState {}

class OrderListLoaded extends OrderListState {
  //报警管理单列表
  final orderList;

  //能否加载更多
  final bool hasNextPage;

  final int pageSize;

  final int currentPage;

  const OrderListLoaded({
    @required this.orderList,
    @required this.hasNextPage,
    this.currentPage = Constant.defaultCurrentPage,
    this.pageSize = Constant.defaultPageSize,
  });
}

//报警管理单列表页没有数据的状态
class OrderListEmpty extends OrderListState {}

//报警管理单列表页发生错误的状态
class OrderListError extends OrderListState {
  final String errorMessage;

  const OrderListError({@required this.errorMessage});
}
