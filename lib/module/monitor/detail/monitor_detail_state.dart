import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'monitor_detail_model.dart';

abstract class MonitorDetailState extends Equatable {
  const MonitorDetailState();

  @override
  List<Object> get props => [];
}

//监控点详情页初始的加载状态
class MonitorDetailLoading extends MonitorDetailState {
  final CancelToken cancelToken;

  const MonitorDetailLoading({@required this.cancelToken});

  @override
  List<Object> get props => [cancelToken];
}

//监控点详情加载完成的状态
class MonitorDetailLoaded extends MonitorDetailState {
  //监控点详情
  final MonitorDetail monitorDetail;

  final bool isCurved;

  final bool showDotData;

  const MonitorDetailLoaded({
    @required this.monitorDetail,
    @required this.isCurved,
    @required this.showDotData,
  });

  @override
  List<Object> get props => [
        monitorDetail,
        isCurved,
        showDotData,
      ];
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
