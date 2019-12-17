import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/res/constant.dart';

abstract class ListState extends Equatable {
  const ListState();

  //传入时间戳，防止加载的数据相同时不触发状态改变
  @override
  List<Object> get props => [DateTime.now()];
}

//初始状态
class ListInitial extends ListState {}

//加载状态
class ListLoading extends ListState {
  final CancelToken cancelToken;

  const ListLoading({@required this.cancelToken});

  @override
  List<Object> get props => [cancelToken];
}

//加载完成状态
class ListLoaded extends ListState {
  final list;
  final bool hasNextPage;
  final int total;
  final int currentPage;

  const ListLoaded({
    @required this.list,
    @required this.hasNextPage,
    this.total,
    this.currentPage = Constant.defaultCurrentPage,
  });

  @override
  List<Object> get props => [list, hasNextPage, total, currentPage];
}

//没有数据状态
class ListEmpty extends ListState {}

//发生错误状态
class ListError extends ListState {
  final String message;

  const ListError({@required this.message});

  @override
  List<Object> get props => [message];
}
