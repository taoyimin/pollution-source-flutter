import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PageState extends Equatable {
  const PageState();

  @override
  List<Object> get props => [];
}

class PageLoaded extends PageState {
  final model;

  const PageLoaded({@required this.model});

  /// 默认每次都触发状态改变
  @override
  List<Object> get props => [DateTime.now()];
}
