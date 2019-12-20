import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/module/common/common_model.dart';

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

class DataDictUpdate extends DataDictEvent {
  final int index;
  final DataDict dataDict;

  const DataDictUpdate({@required this.index, @required this.dataDict});

  @override
  List<Object> get props => [index, dataDict];
}
