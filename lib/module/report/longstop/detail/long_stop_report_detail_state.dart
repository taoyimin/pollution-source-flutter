import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'long_stop_report_detail_model.dart';

abstract class LongStopReportDetailState extends Equatable {
  const LongStopReportDetailState();

  @override
  List<Object> get props => [];
}

//异常申报单详情页初始的加载状态
class LongStopReportDetailLoading extends LongStopReportDetailState {}

//异常申报单详情加载完成的状态
class LongStopReportDetailLoaded extends LongStopReportDetailState {
  //异常申报单列表
  final LongStopReportDetail reportDetail;

  const LongStopReportDetailLoaded({@required this.reportDetail});

  @override
  List<Object> get props => [reportDetail];
}

//异常申报单详情页没有数据的状态
class LongStopReportDetailEmpty extends LongStopReportDetailState {}

//异常申报单详情页发生错误的状态
class LongStopReportDetailError extends LongStopReportDetailState {
  final String errorMessage;

  const LongStopReportDetailError({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
