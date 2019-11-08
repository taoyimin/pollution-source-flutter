import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DischargeDetailEvent extends Equatable {
  const DischargeDetailEvent();

  @override
  List<Object> get props => [];
}

//加载排口详情事件
class DischargeDetailLoad extends DischargeDetailEvent {
  //排口ID
  final String dischargeId;

  const DischargeDetailLoad({@required this.dischargeId});

  @override
  List<Object> get props => [dischargeId];
}
