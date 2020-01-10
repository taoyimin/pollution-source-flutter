import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class DetailLoad extends DetailEvent {
  final String detailId;
  final Map<String, dynamic> params;

  const DetailLoad({this.detailId, this.params});

  @override
  List<Object> get props => [detailId, params];
}
