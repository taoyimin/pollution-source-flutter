import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pollution_source/module/common/common_model.dart';

abstract class MonitorDetailEvent extends Equatable {
  const MonitorDetailEvent();

  @override
  List<Object> get props => [];
}

//加载监控点详情事件
class MonitorDetailLoad extends MonitorDetailEvent {
  //监控点ID
  final int monitorId;

  const MonitorDetailLoad({@required this.monitorId});

  @override
  List<Object> get props => [monitorId];
}

//更新监控点图表数据
class UpdateChartData extends MonitorDetailEvent {
  //要更新的ChartData
  final ChartData chartData;

  const UpdateChartData({@required this.chartData});

  @override
  List<Object> get props => [chartData];
}

//更新监控点图表设置
class UpdateChartConfig extends MonitorDetailEvent {
  //是否曲线
  final bool isCurved;

  //是否显示点
  final bool showDotData;

  const UpdateChartConfig(
      {@required this.isCurved, @required this.showDotData});

  @override
  List<Object> get props => [isCurved, showDotData];
}
