import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/module/common/common_model.dart';

abstract class MonitorDetailEvent extends Equatable {
  const MonitorDetailEvent();

  @override
  List<Object> get props => [];
}

class MonitorDetailLoad extends MonitorDetailEvent {
  //监控点ID
  final String monitorId;

  const MonitorDetailLoad({@required this.monitorId});

  @override
  List<Object> get props => [monitorId];
}

class UpdateChartData extends MonitorDetailEvent {
  //要更新的ChartData
  final ChartData chartData;

  const UpdateChartData({@required this.chartData});

  @override
  List<Object> get props => [chartData];
}
