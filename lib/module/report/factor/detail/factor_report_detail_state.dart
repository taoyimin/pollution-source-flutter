import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'factor_report_detail_model.dart';

abstract class FactorReportDetailState extends Equatable {
  const FactorReportDetailState();

  @override
  List<Object> get props => [];
}

//异常申报单详情页初始的加载状态
class FactorReportDetailLoading extends FactorReportDetailState {}

//异常申报单详情加载完成的状态
class FactorReportDetailLoaded extends FactorReportDetailState {
  //异常申报单列表
  final FactorReportDetail reportDetail;

  const FactorReportDetailLoaded({@required this.reportDetail});

  @override
  List<Object> get props => [reportDetail];
}

//异常申报单详情页没有数据的状态
class FactorReportDetailEmpty extends FactorReportDetailState {}

//异常申报单详情页发生错误的状态
class FactorReportDetailError extends FactorReportDetailState {
  final String errorMessage;

  const FactorReportDetailError({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
