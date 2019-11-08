import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/res/constant.dart';

//传入时间戳，使得每次都触发状态改变
abstract class DischargeListState extends Equatable {
  const DischargeListState();

  @override
  List<Object> get props => [DateTime.now()];
}

class DischargeListLoading extends DischargeListState {}

class DischargeListLoaded extends DischargeListState {
  //排口列表
  final dischargeList;

  //能否加载更多
  final bool hasNextPage;

  final int pageSize;

  final int currentPage;

  const DischargeListLoaded({
    @required this.dischargeList,
    @required this.hasNextPage,
    this.currentPage = Constant.defaultCurrentPage,
    this.pageSize = Constant.defaultPageSize,
  });
}

//排口列表页没有数据的状态
class DischargeListEmpty extends DischargeListState {}

//排口列表页发生错误的状态
class DischargeListError extends DischargeListState {
  final String errorMessage;

  const DischargeListError({@required this.errorMessage});
}
