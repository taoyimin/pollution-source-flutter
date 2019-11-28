import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'enter_detail_model.dart';

//传入时间戳，使得每次都触发状态改变
abstract class EnterDetailState extends Equatable {
  const EnterDetailState();

  @override
  List<Object> get props => [DateTime.now()];
}

//企业详情页初始的加载状态
class EnterDetailLoading extends EnterDetailState {}

//企业详情加载完成的状态
class EnterDetailLoaded extends EnterDetailState {
  //企业列表
  final EnterDetail enterDetail;

  const EnterDetailLoaded({@required this.enterDetail});

  /*@override
  List<Object> get props => [enterDetail];*/
}

//企业详情页没有数据的状态
class EnterDetailEmpty extends EnterDetailState {}

//企业详情页发生错误的状态
class EnterDetailError extends EnterDetailState {
  final String errorMessage;

  const EnterDetailError({@required this.errorMessage});

  /*@override
  List<Object> get props => [errorMessage];*/
}
