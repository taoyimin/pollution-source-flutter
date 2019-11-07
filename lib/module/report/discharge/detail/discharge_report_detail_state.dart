import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'discharge_report_detail_model.dart';

abstract class DischargeReportDetailState extends Equatable {
  const DischargeReportDetailState();

  @override
  List<Object> get props => [];
}

//异常申报单详情页初始的加载状态
class DischargeReportDetailLoading extends DischargeReportDetailState {}

//异常申报单详情加载完成的状态
class DischargeReportDetailLoaded extends DischargeReportDetailState {
  //异常申报单列表
  final DischargeReportDetail reportDetail;

  const DischargeReportDetailLoaded({@required this.reportDetail});

  @override
  List<Object> get props => [reportDetail];
}

//异常申报单详情页没有数据的状态
class DischargeReportDetailEmpty extends DischargeReportDetailState {}

//异常申报单详情页发生错误的状态
class DischargeReportDetailError extends DischargeReportDetailState {
  final String errorMessage;

  const DischargeReportDetailError({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
