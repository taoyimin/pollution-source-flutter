import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class EnterDetailEvent extends Equatable {
  EnterDetailEvent([List props = const []]) : super(props);
}

class EnterDetailLoad extends EnterDetailEvent {
  //企业ID
  final String enterId;

  EnterDetailLoad({
    @required this.enterId,
  }) : super([
          enterId,
        ]);

  @override
  String toString() => 'EnterDetailLoad';
}
