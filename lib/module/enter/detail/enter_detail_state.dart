import 'package:meta/meta.dart';

import 'enter_detail_model.dart';

//不继承equatable，确保每次刷新都会触发状态改变的监听
abstract class EnterDetailState{
}

//企业详情页初始的加载状态
class EnterDetailLoading extends EnterDetailState {
  @override
  String toString() => 'EnterDetailLoading';
}

//企业详情加载完成的状态
class EnterDetailLoaded extends EnterDetailState {
  //企业列表
  final EnterDetail enterDetail;

  EnterDetailLoaded({
    @required this.enterDetail,
  });
}

//企业详情页没有数据的状态
class EnterDetailEmpty extends EnterDetailState {
  @override
  String toString() => 'EnterDetailEmpty';
}

//企业详情页发生错误的状态
class EnterDetailError extends EnterDetailState {
  final errorMessage;

  EnterDetailError({@required this.errorMessage});

  @override
  String toString() => 'EnterDetailError';
}
