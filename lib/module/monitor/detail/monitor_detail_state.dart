import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'monitor_detail_model.dart';

abstract class MonitorDetailState extends Equatable {
  const MonitorDetailState();

  @override
  List<Object> get props => [];
}

//监控点详情页初始的加载状态
class MonitorDetailLoading extends MonitorDetailState {}

//监控点详情加载完成的状态
class MonitorDetailLoaded extends MonitorDetailState {
  //监控点列表
  final MonitorDetail monitorDetail;

  const MonitorDetailLoaded({@required this.monitorDetail});

  @override
  List<Object> get props => [monitorDetail];
}

//监控点详情页没有数据的状态
class MonitorDetailEmpty extends MonitorDetailState {}

//监控点详情页发生错误的状态
class MonitorDetailError extends MonitorDetailState {
  final String errorMessage;

  const MonitorDetailError({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
