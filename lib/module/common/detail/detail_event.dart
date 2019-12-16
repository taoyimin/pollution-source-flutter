import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class DetailLoad extends DetailEvent {
  final String detailId;

  const DetailLoad({this.detailId});

  @override
  List<Object> get props => [detailId];
}
