import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class CollectionState extends Equatable {
  const CollectionState();

  @override
  List<Object> get props => [];
}

/// 初始状态
class CollectionInitial extends CollectionState {}

/// 加载状态
class CollectionLoading extends CollectionState {
  final CancelToken cancelToken;

  const CollectionLoading({@required this.cancelToken});

  @override
  List<Object> get props => [cancelToken];
}

/// 加载完成状态
class CollectionLoaded extends CollectionState {
  final List collection;
  final Map<String, dynamic> params;

  const CollectionLoaded({@required this.collection, this.params});

  @override
  List<Object> get props => [collection, params];
}

/// 发生错误状态
class CollectionError extends CollectionState {
  final String message;

  const CollectionError({@required this.message});

  @override
  List<Object> get props => [message];
}
