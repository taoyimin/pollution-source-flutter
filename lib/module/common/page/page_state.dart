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

  @override
  List<Object> get props => [model];
}
