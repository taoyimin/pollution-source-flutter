import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'discharge_detail_model.dart';

abstract class DischargeDetailState extends Equatable {
  const DischargeDetailState();

  @override
  List<Object> get props => [];
}

//排口详情页初始的加载状态
class DischargeDetailLoading extends DischargeDetailState {}

//排口详情加载完成的状态
class DischargeDetailLoaded extends DischargeDetailState {
  //排口列表
  final DischargeDetail dischargeDetail;

  const DischargeDetailLoaded({@required this.dischargeDetail});

  @override
  List<Object> get props => [dischargeDetail];
}

//排口详情页没有数据的状态
class DischargeDetailEmpty extends DischargeDetailState {}

//排口详情页发生错误的状态
class DischargeDetailError extends DischargeDetailState {
  final String errorMessage;

  const DischargeDetailError({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
