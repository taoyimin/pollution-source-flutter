import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/util/constant.dart';

//传入时间戳，使得每次都触发状态改变
abstract class EnterListState extends Equatable{
  const EnterListState();

  @override
  List<Object> get props => [DateTime.now()];
}

//企业列表初始状态
class EnterListLoading extends EnterListState {}

//企业列表加载完成的状态
class EnterListLoaded extends EnterListState {
  //企业列表
  final enterList;

  //能否加载更多
  final bool hasNextPage;

  final int pageSize;

  final int currentPage;

  const EnterListLoaded({
    @required this.enterList,
    @required this.hasNextPage,
    this.currentPage = Constant.defaultCurrentPage,
    this.pageSize = Constant.defaultPageSize,
  });
}

//企业列表页没有数据的状态
class EnterListEmpty extends EnterListState {}

//企业列表页发生错误的状态
class EnterListError extends EnterListState {
  final String errorMessage;

  const EnterListError({@required this.errorMessage});
}
