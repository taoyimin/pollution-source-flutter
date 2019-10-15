import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'enter_detail_model.dart';

abstract class EnterDetailState extends Equatable {
  EnterDetailState([List props = const []]) : super(props);
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
  }) : super([
          enterDetail,
        ]);
}

//企业详情页没有数据的状态
class EnterDetailEmpty extends EnterDetailState {
  @override
  String toString() => 'EnterDetailEmpty';
}

//企业详情页发生错误的状态
class EnterDetailError extends EnterDetailState {
  final errorMessage;

  EnterDetailError({
    @required this.errorMessage,
  }) : super([
          errorMessage,
        ]);

  @override
  String toString() => 'EnterDetailError';
}
