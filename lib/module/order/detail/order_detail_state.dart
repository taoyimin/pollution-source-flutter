import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'order_detail_model.dart';

abstract class OrderDetailState extends Equatable {
  const OrderDetailState();

  @override
  List<Object> get props => [];
}

class OrderDetailLoading extends OrderDetailState {}

class OrderDetailLoaded extends OrderDetailState {
  //报警管理单详情
  final OrderDetail orderDetail;

  const OrderDetailLoaded({@required this.orderDetail});

  @override
  List<Object> get props => [orderDetail];
}

//报警管理单详情页没有数据的状态
class OrderDetailEmpty extends OrderDetailState {}

//报警管理单详情页发生错误的状态
class OrderDetailError extends OrderDetailState {
  final String errorMessage;

  const OrderDetailError({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
