import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/module/common/common_model.dart';

abstract class DataDictState extends Equatable {
  const DataDictState();

  @override
  List<Object> get props => [];
}

/// 初始状态
class DataDictInitial extends DataDictState {}

/// 加载状态
class DataDictLoading extends DataDictState {}

/// 加载完成状态
class DataDictLoaded extends DataDictState {
  final List<DataDict> dataDictList;

  const DataDictLoaded({@required this.dataDictList});

  @override
  List<Object> get props => [dataDictList];
}

/// 发生错误状态
class DataDictError extends DataDictState {
  final String message;

  const DataDictError({@required this.message});

  @override
  List<Object> get props => [message];
}
