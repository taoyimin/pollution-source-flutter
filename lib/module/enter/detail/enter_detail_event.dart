import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class EnterDetailEvent extends Equatable {
  const EnterDetailEvent();

  @override
  List<Object> get props => [];
}

class EnterDetailLoad extends EnterDetailEvent {
  //企业ID
  final int enterId;

  const EnterDetailLoad({@required this.enterId});

  @override
  List<Object> get props => [enterId];
}
