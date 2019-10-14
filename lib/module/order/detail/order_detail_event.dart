import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OrderDetailEvent extends Equatable {
  OrderDetailEvent([List props = const []]) : super(props);
}

class OrderDetailLoad extends OrderDetailEvent {
  //督办单ID
  final String orderId;

  OrderDetailLoad({
    @required this.orderId,
  }) : super([
          orderId,
        ]);

  @override
  String toString() => 'OrderDetailLoad';
}
