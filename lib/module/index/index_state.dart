import 'package:meta/meta.dart';

//不继承equatable，确保每次刷新都会触发状态改变的监听
abstract class IndexState{
}

//首页首次进入的加载状态
class IndexLoading extends IndexState {
  @override
  String toString() => 'IndexLoading';
}

//首页加载完成状态
class IndexLoaded extends IndexState {
  final aqiStatistics;
  final aqiExamineList;
  final waterStatisticsList;
  final pollutionEnterStatisticsList;
  final onlineMonitorStatisticsList;
  final todoTaskStatisticsList;
  final comprehensiveStatisticsList;
  final rainEnterStatisticsList;

  IndexLoaded({
    @required this.aqiStatistics,
    @required this.aqiExamineList,
    @required this.waterStatisticsList,
    @required this.pollutionEnterStatisticsList,
    @required this.onlineMonitorStatisticsList,
    @required this.todoTaskStatisticsList,
    @required this.comprehensiveStatisticsList,
    @required this.rainEnterStatisticsList,
  });

  @override
  String toString() => 'IndexLoaded';
}

//首页刷新完成状态
/*class IndexRefreshed extends IndexState {
  final aqiStatistics;

  IndexRefreshed({
    @required this.aqiStatistics,
  }) : super([aqiStatistics]);

  @override
  String toString() => 'IndexRefreshed';
}*/

//首页发生错误的状态
class IndexError extends IndexState {
  final errorMessage;

  IndexError({@required this.errorMessage});

  @override
  String toString() => 'IndexError';
}
