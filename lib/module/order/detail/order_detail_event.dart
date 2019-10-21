import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OrderDetailEvent extends Equatable {
  const OrderDetailEvent();

  @override
  List<Object> get props => [];
}

class OrderDetailLoad extends OrderDetailEvent {
  //督办单ID
  final String orderId;

  const OrderDetailLoad({@required this.orderId});

  @override
  List<Object> get props => [orderId];
}
