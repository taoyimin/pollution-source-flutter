import 'package:meta/meta.dart';
import 'package:pollution_source/util/constant.dart';

//不继承equatable，确保每次刷新都会触发状态改变的监听
abstract class EnterListState{
}

//企业列表初始状态
class EnterListLoading extends EnterListState {
  @override
  String toString() => 'EnterListLoading';
}

//企业列表加载完成的状态
class EnterListLoaded extends EnterListState {
  //企业列表
  final enterList;

  //能否加载更多
  final bool hasNextPage;

  final int pageSize;

  final int currentPage;

  EnterListLoaded({
    @required this.enterList,
    @required this.hasNextPage,
    this.currentPage = Constant.defaultCurrentPage,
    this.pageSize = Constant.defaultPageSize,
  });
}

//企业列表页没有数据的状态
class EnterListEmpty extends EnterListState {
  @override
  String toString() => 'EnterListEmpty';
}

//企业列表页发生错误的状态
class EnterListError extends EnterListState {
  final errorMessage;

  EnterListError({@required this.errorMessage});

  @override
  String toString() => 'EnterListError';
}
