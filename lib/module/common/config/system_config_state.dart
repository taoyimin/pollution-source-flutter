import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/module/common/common_model.dart';

abstract class SystemConfigState extends Equatable {
  const SystemConfigState();

  @override
  List<Object> get props => [];
}

/// 初始状态
class SystemConfigInitial extends SystemConfigState {}

/// 加载状态
class SystemConfigLoading extends SystemConfigState {
  final CancelToken cancelToken;

  const SystemConfigLoading({@required this.cancelToken});

  @override
  List<Object> get props => [cancelToken];
}

/// 加载完成状态
class SystemConfigLoaded extends SystemConfigState {
  final SystemConfig systemConfig;

  const SystemConfigLoaded({@required this.systemConfig});

  @override
  List<Object> get props => [systemConfig];
}

/// 发生错误状态
class SystemConfigError extends SystemConfigState {
  final String message;

  const SystemConfigError({@required this.message});

  @override
  List<Object> get props => [message];
}
