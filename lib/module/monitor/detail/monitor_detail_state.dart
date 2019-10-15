import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'monitor_detail_model.dart';

abstract class MonitorDetailState extends Equatable {
  MonitorDetailState([List props = const []]) : super(props);
}

//监控点详情页初始的加载状态
class MonitorDetailLoading extends MonitorDetailState {
  @override
  String toString() => 'MonitorDetailLoading';
}

//监控点详情加载完成的状态
class MonitorDetailLoaded extends MonitorDetailState {
  //监控点列表
  final MonitorDetail monitorDetail;

  MonitorDetailLoaded({
    @required this.monitorDetail,
  }) : super([
          monitorDetail,
        ]);
}

//监控点详情页没有数据的状态
class MonitorDetailEmpty extends MonitorDetailState {
  @override
  String toString() => 'MonitorDetailEmpty';
}

//监控点详情页发生错误的状态
class MonitorDetailError extends MonitorDetailState {
  final errorMessage;

  MonitorDetailError({
    @required this.errorMessage,
  }) : super([
          errorMessage,
        ]);

  @override
  String toString() => 'MonitorDetailError';
}
