import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

//传入时间戳，使得每次都触发状态改变
abstract class IndexState extends Equatable{
  const IndexState();

  @override
  List<Object> get props => [DateTime.now()];
}

//首页首次进入的加载状态
class IndexLoading extends IndexState {}

//首页加载完成状态
class IndexLoaded extends IndexState {
  final aqiStatistics;
  final aqiExamineList;
  final waterStatisticsList;
  final pollutionEnterStatisticsList;
  final onlineMonitorStatisticsList;
  final todoTaskStatisticsList;
  final reportStatisticsList;
  final comprehensiveStatisticsList;
  final rainEnterStatisticsList;

  const IndexLoaded({
    @required this.aqiStatistics,
    @required this.aqiExamineList,
    @required this.waterStatisticsList,
    @required this.pollutionEnterStatisticsList,
    @required this.onlineMonitorStatisticsList,
    @required this.todoTaskStatisticsList,
    @required this.reportStatisticsList,
    @required this.comprehensiveStatisticsList,
    @required this.rainEnterStatisticsList,
  });
}

//首页发生错误的状态
class IndexError extends IndexState {
  final String errorMessage;

  const IndexError({@required this.errorMessage});
}
