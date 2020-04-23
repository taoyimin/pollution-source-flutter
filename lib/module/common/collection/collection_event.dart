import 'package:equatable/equatable.dart';

abstract class CollectionEvent extends Equatable {
  const CollectionEvent();

  @override
  List<Object> get props => [];
}

class CollectionLoad extends CollectionEvent {
  final Map<String, dynamic> params;

  const CollectionLoad({this.params});

  @override
  List<Object> get props => [params];
}
