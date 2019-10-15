import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'order_detail_model.dart';

abstract class OrderDetailState extends Equatable {
  OrderDetailState([List props = const []]) : super(props);
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
  }) : super([
          orderDetail,
        ]);
}

//报警管理单详情页没有数据的状态
class OrderDetailEmpty extends OrderDetailState {
  @override
  String toString() => 'OrderDetailEmpty';
}

//报警管理单详情页发生错误的状态
class OrderDetailError extends OrderDetailState {
  final errorMessage;

  OrderDetailError({
    @required this.errorMessage,
  }) : super([
          errorMessage,
        ]);

  @override
  String toString() => 'OrderDetailError';
}
