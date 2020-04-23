import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// 传入时间戳，使得每次都触发状态改变
abstract class IndexState extends Equatable{
  const IndexState();

  @override
  List<Object> get props => [DateTime.now()];
}

/// 首页首次进入的加载状态
class IndexLoading extends IndexState {}

/// 首页加载完成状态
class IndexLoaded extends IndexState {
  final pollutionEnterStatisticsList;
  final orderStatisticsList;
  final inspectionStatisticsList;

  const IndexLoaded({
    @required this.pollutionEnterStatisticsList,
    @required this.orderStatisticsList,
    @required this.inspectionStatisticsList,
  });
}

/// 首页发生错误的状态
class IndexError extends IndexState {
  final String errorMessage;

  const IndexError({@required this.errorMessage});
}
