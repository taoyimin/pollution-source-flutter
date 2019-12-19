import 'package:equatable/equatable.dart';

abstract class DataDictEvent extends Equatable {
  const DataDictEvent();

  @override
  List<Object> get props => [];
}

class DataDictLoad extends DataDictEvent {
  final Map<String, dynamic> params;

  const DataDictLoad({this.params});

  @override
  List<Object> get props => [params];
}
