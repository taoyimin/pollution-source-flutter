import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PageEvent extends Equatable {
  const PageEvent();

  @override
  List<Object> get props => [];
}

class PageLoad extends PageEvent {
  /// 页面对应的实体类
  final model;

  const PageLoad({@required this.model});

  @override
  List<Object> get props => [model];
}
