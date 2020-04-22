import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'data_dict_model.dart';

abstract class DataDictState extends Equatable {
  const DataDictState();

  @override
  List<Object> get props => [];
}

/// 初始状态
class DataDictInitial extends DataDictState {}

/// 加载状态
class DataDictLoading extends DataDictState {
  final CancelToken cancelToken;

  const DataDictLoading({@required this.cancelToken});

  @override
  List<Object> get props => [cancelToken];
}

/// 加载完成状态
class DataDictLoaded extends DataDictState {
  final List<DataDict> dataDictList;
  final int timeStamp;

  const DataDictLoaded({@required this.dataDictList, this.timeStamp});

  @override
  List<Object> get props => [dataDictList, timeStamp];
}

/// 发生错误状态
class DataDictError extends DataDictState {
  final String message;

  const DataDictError({@required this.message});

  @override
  List<Object> get props => [message];
}
