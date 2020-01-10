import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

//加载状态
class DetailLoading extends DetailState {
  final CancelToken cancelToken;

  const DetailLoading({@required this.cancelToken});

  @override
  List<Object> get props => [cancelToken];
}

//加载完成状态
class DetailLoaded extends DetailState {
  final detail;

  const DetailLoaded({@required this.detail});

  @override
  List<Object> get props => [detail];
}

//发生错误状态
class DetailError extends DetailState {
  final String message;

  const DetailError({@required this.message});

  @override
  List<Object> get props => [message];
}
