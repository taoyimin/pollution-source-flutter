import 'package:equatable/equatable.dart';
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

class DataDictReset extends DataDictEvent{}

class DataDictUpdate extends DataDictEvent{
  final List<DataDict> dataDictList;
  final int timeStamp;

  const DataDictUpdate({this.dataDictList, this.timeStamp});

  @override
  List<Object> get props => [dataDictList, timeStamp];
}
