import 'package:meta/meta.dart';

import 'order_detail_model.dart';

//不继承equatable，确保每次刷新都会触发状态改变的监听
abstract class OrderDetailState{
}

class OrderDetailLoading extends OrderDetailState {
  @override
  String toString() => 'OrderDetailLoading';
}

class OrderDetailLoaded extends OrderDetailState {
  //报警管理单详情
  final OrderDetail orderDetail;

  OrderDetailLoaded({
    @required this.orderDetail,
  });
}

//报警管理单详情页没有数据的状态
class OrderDetailEmpty extends OrderDetailState {
  @override
  String toString() => 'OrderDetailEmpty';
}

//报警管理单详情页发生错误的状态
class OrderDetailError extends OrderDetailState {
  final errorMessage;

  OrderDetailError({@required this.errorMessage});

  @override
  String toString() => 'OrderDetailError';
}
