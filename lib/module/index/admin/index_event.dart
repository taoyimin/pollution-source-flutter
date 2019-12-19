import 'package:equatable/equatable.dart';

abstract class IndexEvent extends Equatable {
  const IndexEvent();

  @override
  List<Object> get props => [];
}

class Load extends IndexEvent {}
