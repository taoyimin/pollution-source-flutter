import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class DetailLoad extends DetailEvent {
  final String detailId;
  final Map<String, dynamic> params;

  const DetailLoad({@required this.detailId, this.params});

  @override
  List<Object> get props => [detailId, params];
}
