import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'report_detail_model.dart';

abstract class ReportDetailState extends Equatable {
  const ReportDetailState();

  @override
  List<Object> get props => [];
}

//异常申报单详情页初始的加载状态
class ReportDetailLoading extends ReportDetailState {}

//异常申报单详情加载完成的状态
class ReportDetailLoaded extends ReportDetailState {
  //异常申报单列表
  final ReportDetail reportDetail;

  const ReportDetailLoaded({@required this.reportDetail});

  @override
  List<Object> get props => [reportDetail];
}

//异常申报单详情页没有数据的状态
class ReportDetailEmpty extends ReportDetailState {}

//异常申报单详情页发生错误的状态
class ReportDetailError extends ReportDetailState {
  final String errorMessage;

  const ReportDetailError({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
